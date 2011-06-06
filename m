Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1FFS7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:59:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab1FFS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=atzA1ugiSxj/vCkXCINuCPINacgM5YThktQIpnTeWJAnszZN6IXewgsHy5stRgt3yy
         /qrP1Selsuz+VYy3ILZRnYdvXCnOGkDsUQyWZbujV+gjrQhZ16NPaDFFAUybBMsFBb7X
         Tk4irOU3AwyBjRVGCEhGr0cS2M3Ila6AFJxEY=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 8/9] kconfig/gconf: kill deadcode
Date: Mon,  6 Jun 2011 14:58:30 -0400
Message-Id: <1307386711-8866-9-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only call site of renderer_toggled() has been commented out since Apr. 2003,
as per Linus' Linux history repository:

 commit e7f67eb3c0570aa50c1cc0707b478a6d93bdc255
 Author: Roman Zippel <zippel@linux-m68k.org>
 Date:   Fri Apr 4 04:18:05 2003 -0800

    [PATCH] gconf update

    A gconf update by Romain Li<C3><A9>vin <roms@tilp.info>
    - fixed bug when double-clicking for changing value.
    - expand row when enabling a row with a submenu.
    - various bug fixes

As this result in a warning:

scripts/kconfig/gconf.c:891:13: warning: 'renderer_toggled' defined but not used

just nuke that code.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/gconf.c |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 0426fda..e2db621 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -285,8 +285,6 @@ void init_left_tree(void)
 static void renderer_edited(GtkCellRendererText * cell,
 			    const gchar * path_string,
 			    const gchar * new_text, gpointer user_data);
-static void renderer_toggled(GtkCellRendererToggle * cellrenderertoggle,
-			     gchar * arg1, gpointer user_data);
 
 void init_right_tree(void)
 {
@@ -320,8 +318,6 @@ void init_right_tree(void)
 					    "inconsistent", COL_BTNINC,
 					    "visible", COL_BTNVIS,
 					    "radio", COL_BTNRAD, NULL);
-	/*g_signal_connect(G_OBJECT(renderer), "toggled",
-	   G_CALLBACK(renderer_toggled), NULL); */
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_column_pack_start(GTK_TREE_VIEW_COLUMN(column),
 					renderer, FALSE);
@@ -888,35 +884,6 @@ static void toggle_sym_value(struct menu *menu)
 		display_tree_part();	//fixme: keep exp/coll
 }
 
-static void renderer_toggled(GtkCellRendererToggle * cell,
-			     gchar * path_string, gpointer user_data)
-{
-	GtkTreePath *path, *sel_path = NULL;
-	GtkTreeIter iter, sel_iter;
-	GtkTreeSelection *sel;
-	struct menu *menu;
-
-	path = gtk_tree_path_new_from_string(path_string);
-	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
-
-	sel = gtk_tree_view_get_selection(GTK_TREE_VIEW(tree2_w));
-	if (gtk_tree_selection_get_selected(sel, NULL, &sel_iter))
-		sel_path = gtk_tree_model_get_path(model2, &sel_iter);
-	if (!sel_path)
-		goto out1;
-	if (gtk_tree_path_compare(path, sel_path))
-		goto out2;
-
-	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
-	toggle_sym_value(menu);
-
-      out2:
-	gtk_tree_path_free(sel_path);
-      out1:
-	gtk_tree_path_free(path);
-}
-
 static gint column2index(GtkTreeViewColumn * column)
 {
 	gint i;
-- 
1.7.3.4.574.g608b.dirty

