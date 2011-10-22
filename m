Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1JVTFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 15:05:30 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:45583 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1JVTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 15:05:29 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 15:05:29 EDT
Date: Sat, 22 Oct 2011 14:01:24 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: fix set but not used warnings
Message-id: <alpine.LNX.2.00.1110221400040.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove set but not used variables to fix warnings.

  HOSTCC  scripts/kconfig/gconf.o
/usr/src/lto/scripts/kconfig/gconf.c: In function 'change_sym_value':
/usr/src/lto/scripts/kconfig/gconf.c:833:11: warning: variable 'oldval' set but not used [-Wunused-but-set-variable]
/usr/src/lto/scripts/kconfig/gconf.c: In function 'update_tree':
/usr/src/lto/scripts/kconfig/gconf.c:1281:19: warning: variable 'prop' set but not used [-Wunused-but-set-variable]

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/gconf.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index b9e26a5..adc2306 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -830,7 +830,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 static void change_sym_value(struct menu *menu, gint col)
 {
 	struct symbol *sym = menu->sym;
-	tristate oldval, newval;
+	tristate newval;
 
 	if (!sym)
 		return;
@@ -847,7 +847,6 @@ static void change_sym_value(struct menu *menu, gint col)
 	switch (sym_get_type(sym)) {
 	case S_BOOLEAN:
 	case S_TRISTATE:
-		oldval = sym_get_tristate_value(sym);
 		if (!sym_tristate_within_range(sym, newval))
 			newval = yes;
 		sym_set_tristate_value(sym, newval);
@@ -1278,7 +1277,6 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
 	gboolean valid;
 	GtkTreeIter *sibling;
 	struct symbol *sym;
-	struct property *prop;
 	struct menu *menu1, *menu2;
 
 	if (src == &rootmenu)
@@ -1287,7 +1285,6 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
 	valid = gtk_tree_model_iter_children(model2, child2, dst);
 	for (child1 = src->list; child1; child1 = child1->next) {
 
-		prop = child1->prompt;
 		sym = child1->sym;
 
 	      reparse:
-- 
1.7.7

