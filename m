Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0DNDnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:43:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0DNDnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:43:06 -0400
Message-ID: <4BC53A22.9050009@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:44:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 3/6] gconfig: remove dbg_print_ptype() and dbg_print_stype()
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use sym_get_type() and prop_get_type_name().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/gconf.c |   67 +++--------------------------------------------
 1 files changed, 4 insertions(+), 63 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 6546436..80fe9ca 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -76,36 +76,7 @@ static void conf_changed(void);
 
 /* Helping/Debugging Functions */
 
-
-const char *dbg_print_stype(int val)
-{
-	static char buf[256];
-
-	bzero(buf, 256);
-
-	if (val == S_UNKNOWN)
-		strcpy(buf, "unknown");
-	if (val == S_BOOLEAN)
-		strcpy(buf, "boolean");
-	if (val == S_TRISTATE)
-		strcpy(buf, "tristate");
-	if (val == S_INT)
-		strcpy(buf, "int");
-	if (val == S_HEX)
-		strcpy(buf, "hex");
-	if (val == S_STRING)
-		strcpy(buf, "string");
-	if (val == S_OTHER)
-		strcpy(buf, "other");
-
-#ifdef DEBUG
-	printf("%s", buf);
-#endif
-
-	return buf;
-}
-
-const char *dbg_print_flags(int val)
+const char *dbg_sym_flags(int val)
 {
 	static char buf[256];
 
@@ -131,40 +102,10 @@ const char *dbg_print_flags(int val)
 		strcat(buf, "auto/");
 
 	buf[strlen(buf) - 1] = '\0';
-#ifdef DEBUG
-	printf("%s", buf);
-#endif
-
-	return buf;
-}
-
-const char *dbg_print_ptype(int val)
-{
-	static char buf[256];
-
-	bzero(buf, 256);
-
-	if (val == P_UNKNOWN)
-		strcpy(buf, "unknown");
-	if (val == P_PROMPT)
-		strcpy(buf, "prompt");
-	if (val == P_COMMENT)
-		strcpy(buf, "comment");
-	if (val == P_MENU)
-		strcpy(buf, "menu");
-	if (val == P_DEFAULT)
-		strcpy(buf, "default");
-	if (val == P_CHOICE)
-		strcpy(buf, "choice");
-
-#ifdef DEBUG
-	printf("%s", buf);
-#endif
 
 	return buf;
 }
 
-
 void replace_button_icon(GladeXML * xml, GdkDrawable * window,
 			 GtkStyle * style, gchar * btn_name, gchar ** xpm)
 {
@@ -1469,12 +1410,12 @@ static void display_tree(struct menu *menu)
 #ifdef DEBUG
 		printf("%*c%s: ", indent, ' ', menu_get_prompt(child));
 		printf("%s", child->flags & MENU_ROOT ? "rootmenu | " : "");
-		dbg_print_ptype(ptype);
+		printf("%s", prop_get_type_name(ptype));
 		printf(" | ");
 		if (sym) {
-			dbg_print_stype(sym->type);
+			printf("%s", sym_type_name(sym->type));
 			printf(" | ");
-			dbg_print_flags(sym->flags);
+			printf("%s", dbg_sym_flags(sym->flags));
 			printf("\n");
 		} else
 			printf("\n");
-- 
1.6.3

