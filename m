Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2LSBat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:30:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44519 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2LSBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:30:47 -0500
Date: Wed, 19 Dec 2012 09:30:59 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH 1/2 v3] menuconfig: Add Save/Load buttons
Message-ID: <20121219013059.GA5384@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If menuconfig have Save/Load button like alternative
.config editors, xconfig, nconfig, etc.We will have
a obvious benefit when use menuconfig just like
when we use others, we can Save/Load our .config quickly
and conveniently.

This patch add the Save/Load button for menuconfig.

[remove trailing space while at it for below line:
"*)  Formerly when I used Page Down and Page Up, the cursor would be set"
]

Changes:
V1-V2:
1:use PATH_MAX instead of hard code suggested by Yann E. MORIN
2:drop the spurious empty-line removal suggested by Yann E. MORIN
V2-V3:
1:ajust buttons position well centered reported by Yann E. MORIN

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 Hi Yann E. MORIN, can you give your Rev'ed-by and Tested-by to his patch,
 Thanks very much for your help, I just don't know how to computer out the
 right position :)

 The Changes appear in commit log is ok, I found I am not the first guy
 do it, it maybe useful in some case :)

 scripts/kconfig/lxdialog/menubox.c | 20 +++++++++++---------
 scripts/kconfig/mconf.c            | 30 +++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 1d60473..8b534d5 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -26,7 +26,7 @@
  *
  *    *)  A bugfix for the Page-Down problem
  *
- *    *)  Formerly when I used Page Down and Page Up, the cursor would be set 
+ *    *)  Formerly when I used Page Down and Page Up, the cursor would be set
  *        to the first position in the menu box.  Now lxdialog is a bit
  *        smarter and works more like other menu systems (just have a look at
  *        it).
@@ -154,12 +154,14 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
  */
 static void print_buttons(WINDOW * win, int height, int width, int selected)
 {
-	int x = width / 2 - 16;
+	int x = width / 2 - 26;
 	int y = height - 2;
 
 	print_button(win, gettext("Select"), y, x, selected == 0);
 	print_button(win, gettext(" Exit "), y, x + 12, selected == 1);
 	print_button(win, gettext(" Help "), y, x + 24, selected == 2);
+	print_button(win, gettext(" Save "), y, x + 36, selected == 3);
+	print_button(win, gettext(" Load "), y, x + 48, selected == 4);
 
 	wmove(win, y, x + 1 + 12 * selected);
 	wrefresh(win);
@@ -372,7 +374,7 @@ do_resize:
 		case TAB:
 		case KEY_RIGHT:
 			button = ((key == KEY_LEFT ? --button : ++button) < 0)
-			    ? 2 : (button > 2 ? 0 : button);
+			    ? 4 : (button > 4 ? 0 : button);
 
 			print_buttons(dialog, height, width, button);
 			wrefresh(menu);
@@ -399,17 +401,17 @@ do_resize:
 				return 2;
 			case 's':
 			case 'y':
-				return 3;
+				return 5;
 			case 'n':
-				return 4;
+				return 6;
 			case 'm':
-				return 5;
+				return 7;
 			case ' ':
-				return 6;
+				return 8;
 			case '/':
-				return 7;
+				return 9;
 			case 'z':
-				return 8;
+				return 10;
 			case '\n':
 				return button;
 			}
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 53975cf..9fb90f0 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -280,6 +280,7 @@ static struct menu *current_menu;
 static int child_count;
 static int single_menu_mode;
 static int show_all_options;
+static int save_and_exit;
 
 static void conf(struct menu *menu, struct menu *active_menu);
 static void conf_choice(struct menu *menu);
@@ -651,6 +652,12 @@ static void conf(struct menu *menu, struct menu *active_menu)
 				show_helptext(_("README"), _(mconf_readme));
 			break;
 		case 3:
+			conf_save();
+			break;
+		case 4:
+			conf_load();
+			break;
+		case 5:
 			if (item_is_tag('t')) {
 				if (sym_set_tristate_value(sym, yes))
 					break;
@@ -658,24 +665,24 @@ static void conf(struct menu *menu, struct menu *active_menu)
 					show_textbox(NULL, setmod_text, 6, 74);
 			}
 			break;
-		case 4:
+		case 6:
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, no);
 			break;
-		case 5:
+		case 7:
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, mod);
 			break;
-		case 6:
+		case 8:
 			if (item_is_tag('t'))
 				sym_toggle_tristate_value(sym);
 			else if (item_is_tag('m'))
 				conf(submenu, NULL);
 			break;
-		case 7:
+		case 9:
 			search_conf();
 			break;
-		case 8:
+		case 10:
 			show_all_options = !show_all_options;
 			break;
 		}
@@ -702,6 +709,17 @@ static void show_helptext(const char *title, const char *text)
 	show_textbox(title, text, 0, 0);
 }
 
+static void conf_message_callback(const char *fmt, va_list ap)
+{
+	char buf[PATH_MAX+1];
+
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	if (save_and_exit)
+		printf("%s", buf);
+	else
+		show_textbox(NULL, buf, 6, 60);
+}
+
 static void show_help(struct menu *menu)
 {
 	struct gstr help = str_new();
@@ -870,6 +888,7 @@ static int handle_exit(void)
 {
 	int res;
 
+	save_and_exit = 1;
 	dialog_clear();
 	if (conf_get_changed())
 		res = dialog_yesno(NULL,
@@ -941,6 +960,7 @@ int main(int ac, char **av)
 	}
 
 	set_config_filename(conf_get_configname());
+	conf_set_message_callback(conf_message_callback);
 	do {
 		conf(&rootmenu, NULL);
 		res = handle_exit();
-- 
1.7.11.1.116.g8228a23
