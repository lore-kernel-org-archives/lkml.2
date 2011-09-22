Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1IVLgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:36:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40973 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1IVLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:36:44 -0400
From: Sanjeev Premi <premi@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Sanjeev Premi <premi@ti.com>
Subject: [PATCH] kconfig: fix warnings due to unused return values
Date: Thu, 22 Sep 2011 17:06:36 +0530
Message-ID: <1316691396-25447-1-git-send-email-premi@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of wattrset() is being ignored in the
code and newer compilers complain about this e.g.

HOSTCC  scripts/kconfig/lxdialog/checklist.o
scripts/kconfig/lxdialog/checklist.c: In function print_item:
scripts/kconfig/lxdialog/checklist.c:40: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:46: warning: value computed is not used

Let the compiler know that ignore is intentional.

Signed-off-by: Sanjeev Premi <premi@ti.com>
---

  The patch was created against the last pull from git.kernel.org
  The 'pull' from github is taking more than few hours...

  Based on the time stamps at this url, I believe the patch should
  apply cleanly:
   https://github.com/torvalds/linux/tree/master/scripts/kconfig/lxdialog

  Compiler version used:
   gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3


 scripts/kconfig/lxdialog/checklist.c |   22 +++++++++++-----------
 scripts/kconfig/lxdialog/inputbox.c  |   12 ++++++------
 scripts/kconfig/lxdialog/menubox.c   |   20 ++++++++++----------
 scripts/kconfig/lxdialog/textbox.c   |    8 ++++----
 scripts/kconfig/lxdialog/util.c      |   20 ++++++++++----------
 scripts/kconfig/lxdialog/yesno.c     |    6 +++---
 6 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
index a2eb80f..8407849 100644
--- a/scripts/kconfig/lxdialog/checklist.c
+++ b/scripts/kconfig/lxdialog/checklist.c
@@ -37,20 +37,20 @@ static void print_item(WINDOW * win, int choice, int selected)
 	list_item[list_width - item_x] = '\0';
 
 	/* Clear 'residue' of last item */
-	wattrset(win, dlg.menubox.atr);
+	(void)wattrset(win, dlg.menubox.atr);
 	wmove(win, choice, 0);
 	for (i = 0; i < list_width; i++)
 		waddch(win, ' ');
 
 	wmove(win, choice, check_x);
-	wattrset(win, selected ? dlg.check_selected.atr
+	(void)wattrset(win, selected ? dlg.check_selected.atr
 		 : dlg.check.atr);
 	if (!item_is_tag(':'))
 		wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
 
-	wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
+	(void)wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
 	mvwaddch(win, choice, item_x, list_item[0]);
-	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
+	(void)wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
 	waddstr(win, list_item + 1);
 	if (selected) {
 		wmove(win, choice, check_x + 1);
@@ -68,11 +68,11 @@ static void print_arrows(WINDOW * win, int choice, int item_no, int scroll,
 	wmove(win, y, x);
 
 	if (scroll > 0) {
-		wattrset(win, dlg.uarrow.atr);
+		(void)wattrset(win, dlg.uarrow.atr);
 		waddch(win, ACS_UARROW);
 		waddstr(win, "(-)");
 	} else {
-		wattrset(win, dlg.menubox.atr);
+		(void)wattrset(win, dlg.menubox.atr);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
@@ -83,11 +83,11 @@ static void print_arrows(WINDOW * win, int choice, int item_no, int scroll,
 	wmove(win, y, x);
 
 	if ((height < item_no) && (scroll + choice < item_no - 1)) {
-		wattrset(win, dlg.darrow.atr);
+		(void)wattrset(win, dlg.darrow.atr);
 		waddch(win, ACS_DARROW);
 		waddstr(win, "(+)");
 	} else {
-		wattrset(win, dlg.menubox_border.atr);
+		(void)wattrset(win, dlg.menubox_border.atr);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
@@ -150,16 +150,16 @@ do_resize:
 
 	draw_box(dialog, 0, 0, height, width,
 		 dlg.dialog.atr, dlg.border.atr);
-	wattrset(dialog, dlg.border.atr);
+	(void)wattrset(dialog, dlg.border.atr);
 	mvwaddch(dialog, height - 3, 0, ACS_LTEE);
 	for (i = 0; i < width - 2; i++)
 		waddch(dialog, ACS_HLINE);
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	waddch(dialog, ACS_RTEE);
 
 	print_title(dialog, title, width);
 
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	print_autowrap(dialog, prompt, width - 2, 1, 3);
 
 	list_width = width - 6;
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index dd8e587..a5402c5 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -71,16 +71,16 @@ do_resize:
 
 	draw_box(dialog, 0, 0, height, width,
 		 dlg.dialog.atr, dlg.border.atr);
-	wattrset(dialog, dlg.border.atr);
+	(void)wattrset(dialog, dlg.border.atr);
 	mvwaddch(dialog, height - 3, 0, ACS_LTEE);
 	for (i = 0; i < width - 2; i++)
 		waddch(dialog, ACS_HLINE);
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	waddch(dialog, ACS_RTEE);
 
 	print_title(dialog, title, width);
 
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	print_autowrap(dialog, prompt, width - 2, 1, 3);
 
 	/* Draw the input field box */
@@ -95,7 +95,7 @@ do_resize:
 
 	/* Set up the initial value */
 	wmove(dialog, box_y, box_x);
-	wattrset(dialog, dlg.inputbox.atr);
+	(void)wattrset(dialog, dlg.inputbox.atr);
 
 	input_x = strlen(instr);
 
@@ -128,7 +128,7 @@ do_resize:
 			case KEY_BACKSPACE:
 			case 127:
 				if (input_x || scroll) {
-					wattrset(dialog, dlg.inputbox.atr);
+					(void)wattrset(dialog, dlg.inputbox.atr);
 					if (!input_x) {
 						scroll = scroll < box_width - 1 ? 0 : scroll - (box_width - 1);
 						wmove(dialog, box_y, box_x);
@@ -148,7 +148,7 @@ do_resize:
 			default:
 				if (key < 0x100 && isprint(key)) {
 					if (scroll + input_x < MAX_LEN) {
-						wattrset(dialog, dlg.inputbox.atr);
+						(void)wattrset(dialog, dlg.inputbox.atr);
 						instr[scroll + input_x] = key;
 						instr[scroll + input_x + 1] = '\0';
 						if (input_x == box_width - 1) {
diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 1d60473..aa1e21b 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -74,7 +74,7 @@ static void do_print_item(WINDOW * win, const char *item, int line_y,
 	j = first_alpha(menu_item, "YyNnMmHh");
 
 	/* Clear 'residue' of last item */
-	wattrset(win, dlg.menubox.atr);
+	(void)wattrset(win, dlg.menubox.atr);
 	wmove(win, line_y, 0);
 #if OLD_NCURSES
 	{
@@ -85,10 +85,10 @@ static void do_print_item(WINDOW * win, const char *item, int line_y,
 #else
 	wclrtoeol(win);
 #endif
-	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
+	(void)wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
 	mvwaddstr(win, line_y, item_x, menu_item);
 	if (hotkey) {
-		wattrset(win, selected ? dlg.tag_key_selected.atr
+		(void)wattrset(win, selected ? dlg.tag_key_selected.atr
 			 : dlg.tag_key.atr);
 		mvwaddch(win, line_y, item_x + j, menu_item[j]);
 	}
@@ -118,11 +118,11 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
 	wmove(win, y, x);
 
 	if (scroll > 0) {
-		wattrset(win, dlg.uarrow.atr);
+		(void)wattrset(win, dlg.uarrow.atr);
 		waddch(win, ACS_UARROW);
 		waddstr(win, "(-)");
 	} else {
-		wattrset(win, dlg.menubox.atr);
+		(void)wattrset(win, dlg.menubox.atr);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
@@ -134,11 +134,11 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
 	wrefresh(win);
 
 	if ((height < item_no) && (scroll + height < item_no)) {
-		wattrset(win, dlg.darrow.atr);
+		(void)wattrset(win, dlg.darrow.atr);
 		waddch(win, ACS_DARROW);
 		waddstr(win, "(+)");
 	} else {
-		wattrset(win, dlg.menubox_border.atr);
+		(void)wattrset(win, dlg.menubox_border.atr);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
 		waddch(win, ACS_HLINE);
@@ -211,17 +211,17 @@ do_resize:
 
 	draw_box(dialog, 0, 0, height, width,
 		 dlg.dialog.atr, dlg.border.atr);
-	wattrset(dialog, dlg.border.atr);
+	(void)wattrset(dialog, dlg.border.atr);
 	mvwaddch(dialog, height - 3, 0, ACS_LTEE);
 	for (i = 0; i < width - 2; i++)
 		waddch(dialog, ACS_HLINE);
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	wbkgdset(dialog, dlg.dialog.atr & A_COLOR);
 	waddch(dialog, ACS_RTEE);
 
 	print_title(dialog, title, width);
 
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	print_autowrap(dialog, prompt, width - 2, 1, 3);
 
 	menu_width = width - 6;
diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index c704712..7452c85 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -95,7 +95,7 @@ do_resize:
 	boxh = height - 4;
 	boxw = width - 2;
 	box = subwin(dialog, boxh, boxw, y + 1, x + 1);
-	wattrset(box, dlg.dialog.atr);
+	(void)wattrset(box, dlg.dialog.atr);
 	wbkgdset(box, dlg.dialog.atr & A_COLOR);
 
 	keypad(box, TRUE);
@@ -104,11 +104,11 @@ do_resize:
 	draw_box(dialog, 0, 0, height, width,
 		 dlg.dialog.atr, dlg.border.atr);
 
-	wattrset(dialog, dlg.border.atr);
+	(void)wattrset(dialog, dlg.border.atr);
 	mvwaddch(dialog, height - 3, 0, ACS_LTEE);
 	for (i = 0; i < width - 2; i++)
 		waddch(dialog, ACS_HLINE);
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	wbkgdset(dialog, dlg.dialog.atr & A_COLOR);
 	waddch(dialog, ACS_RTEE);
 
@@ -383,7 +383,7 @@ static void print_position(WINDOW * win)
 {
 	int percent;
 
-	wattrset(win, dlg.position_indicator.atr);
+	(void)wattrset(win, dlg.position_indicator.atr);
 	wbkgdset(win, dlg.position_indicator.atr & A_COLOR);
 	percent = (page - buf) * 100 / strlen(buf);
 	wmove(win, getmaxy(win) - 3, getmaxx(win) - 9);
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index f2375ad..97a60ab 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -240,7 +240,7 @@ void attr_clear(WINDOW * win, int height, int width, chtype attr)
 {
 	int i, j;
 
-	wattrset(win, attr);
+	(void)wattrset(win, attr);
 	for (i = 0; i < height; i++) {
 		wmove(win, i, 0);
 		for (j = 0; j < width; j++)
@@ -256,7 +256,7 @@ void dialog_clear(void)
 	if (dlg.backtitle != NULL) {
 		int i;
 
-		wattrset(stdscr, dlg.screen.atr);
+		(void)wattrset(stdscr, dlg.screen.atr);
 		mvwaddstr(stdscr, 0, 1, (char *)dlg.backtitle);
 		wmove(stdscr, 1, 1);
 		for (i = 1; i < COLS - 1; i++)
@@ -313,7 +313,7 @@ void print_title(WINDOW *dialog, const char *title, int width)
 {
 	if (title) {
 		int tlen = MIN(width - 2, strlen(title));
-		wattrset(dialog, dlg.title.atr);
+		(void)wattrset(dialog, dlg.title.atr);
 		mvwaddch(dialog, 0, (width - tlen) / 2 - 1, ' ');
 		mvwaddnstr(dialog, 0, (width - tlen)/2, title, tlen);
 		waddch(dialog, ' ');
@@ -393,22 +393,22 @@ void print_button(WINDOW * win, const char *label, int y, int x, int selected)
 	int i, temp;
 
 	wmove(win, y, x);
-	wattrset(win, selected ? dlg.button_active.atr
+	(void)wattrset(win, selected ? dlg.button_active.atr
 		 : dlg.button_inactive.atr);
 	waddstr(win, "<");
 	temp = strspn(label, " ");
 	label += temp;
-	wattrset(win, selected ? dlg.button_label_active.atr
+	(void)wattrset(win, selected ? dlg.button_label_active.atr
 		 : dlg.button_label_inactive.atr);
 	for (i = 0; i < temp; i++)
 		waddch(win, ' ');
-	wattrset(win, selected ? dlg.button_key_active.atr
+	(void)wattrset(win, selected ? dlg.button_key_active.atr
 		 : dlg.button_key_inactive.atr);
 	waddch(win, label[0]);
-	wattrset(win, selected ? dlg.button_label_active.atr
+	(void)wattrset(win, selected ? dlg.button_label_active.atr
 		 : dlg.button_label_inactive.atr);
 	waddstr(win, (char *)label + 1);
-	wattrset(win, selected ? dlg.button_active.atr
+	(void)wattrset(win, selected ? dlg.button_active.atr
 		 : dlg.button_inactive.atr);
 	waddstr(win, ">");
 	wmove(win, y, x + temp + 1);
@@ -423,7 +423,7 @@ draw_box(WINDOW * win, int y, int x, int height, int width,
 {
 	int i, j;
 
-	wattrset(win, 0);
+	(void)wattrset(win, 0);
 	for (i = 0; i < height; i++) {
 		wmove(win, y + i, x);
 		for (j = 0; j < width; j++)
@@ -457,7 +457,7 @@ void draw_shadow(WINDOW * win, int y, int x, int height, int width)
 	int i;
 
 	if (has_colors()) {	/* Whether terminal supports color? */
-		wattrset(win, dlg.shadow.atr);
+		(void)wattrset(win, dlg.shadow.atr);
 		wmove(win, y + height, x + 2);
 		for (i = 0; i < width; i++)
 			waddch(win, winch(win) & A_CHARTEXT);
diff --git a/scripts/kconfig/lxdialog/yesno.c b/scripts/kconfig/lxdialog/yesno.c
index 4e6e809..b1db7d9 100644
--- a/scripts/kconfig/lxdialog/yesno.c
+++ b/scripts/kconfig/lxdialog/yesno.c
@@ -61,16 +61,16 @@ do_resize:
 
 	draw_box(dialog, 0, 0, height, width,
 		 dlg.dialog.atr, dlg.border.atr);
-	wattrset(dialog, dlg.border.atr);
+	(void)wattrset(dialog, dlg.border.atr);
 	mvwaddch(dialog, height - 3, 0, ACS_LTEE);
 	for (i = 0; i < width - 2; i++)
 		waddch(dialog, ACS_HLINE);
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	waddch(dialog, ACS_RTEE);
 
 	print_title(dialog, title, width);
 
-	wattrset(dialog, dlg.dialog.atr);
+	(void)wattrset(dialog, dlg.dialog.atr);
 	print_autowrap(dialog, prompt, width - 2, 1, 3);
 
 	print_buttons(dialog, height, width, 0);
-- 
1.7.0.4

