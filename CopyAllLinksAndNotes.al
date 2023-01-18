pageextension 50101 ZYItemListExt extends "Item List"
{
    actions
    {
        addfirst(processing)
        {
            action(CopyLinksAndNotes)
            {
                Caption = 'Copy Links And Notes';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Copy;
                trigger OnAction()
                var
                    CopyLinksAndNotesDialog: Page "Copy Links and Notes Dialog";
                begin
                    CopyLinksAndNotesDialog.SetItemInfo(Rec."No.", Rec.Description);
                    if CopyLinksAndNotesDialog.RunModal() = Action::OK then
                        CopyLinksAndNotesDialog.CopyLinksAndNotes();
                end;
            }
        }
    }
}

page 50100 "Copy Links and Notes Dialog"
{
    PageType = StandardDialog;
    Caption = 'Copy Links and Notes Dialog';
    layout
    {
        area(content)
        {
            field(SourceItemNo; SourceItemNo)
            {
                ApplicationArea = All;
                Caption = 'Source Item No.';
                Editable = false;
            }
            field(SourceItemDesc; SourceItemDesc)
            {
                ApplicationArea = All;
                Caption = 'Source Item Description';
                Editable = false;
            }
            field(TargetItemNo; TargetItemNo)
            {
                ApplicationArea = All;
                Caption = 'Target Item No.';
                TableRelation = Item;

                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Item.Get(TargetItemNo) then
                        TargetItemDesc := Item.Description;
                end;
            }
            field(TargetItemDesc; TargetItemDesc)
            {
                ApplicationArea = All;
                Caption = 'Target Item Description';
                Editable = false;
            }
        }
    }
    var
        SourceItemNo: Code[20];
        TargetItemNo: Code[20];
        SourceItemDesc: Text[100];
        TargetItemDesc: Text[100];


    procedure SetItemInfo(NewItemNo: Code[20]; NewItemDesc: Text[100])
    begin
        SourceItemNo := NewItemNo;
        SourceItemDesc := NewItemDesc;
    end;

    procedure CopyLinksAndNotes()
    var
        RecordLink: Record "Record Link";
        RecordLinkMgt: Codeunit "Record Link Management";
        SourceItem: Record Item;
        TargetItem: Record Item;
    begin
        if SourceItem.Get(SourceItemNo) then
            if TargetItem.Get(TargetItemNo) then begin
                RecordLinkMgt.CopyLinks(SourceItem, TargetItem);
            end;
    end;
}
