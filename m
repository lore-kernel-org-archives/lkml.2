Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab1ESMia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:38:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57428 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab1ESMi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UmdrBCRzkWjGqNoQrjgh/q7to7H4SBowzgeBm+tfzahUVbXabqwB5AANo5eYyhzjQg
         KZE4YippqGnwkyyk8uHaKuBwTj31EJT8439zgTTEpDDgylyOuL2IuWK7qiDCtnU1hBH1
         YwCLXcww0d8Mi9SaUFJuDbXzvEhmoH8QIBqo8=
Subject: [PATCH 2/2] gconfig: Hide unused left treeview when start up the
 interface
From: Eduardo Silva <edsiper@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 08:38:25 -0400
Message-ID: <1305808705.11775.4.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the gconfig program starts in full mode view, it shows the
left treeview which belongs to the 'split mode view'. The patch
fix this visual issue.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 scripts/kconfig/gconf.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 0c8db7d..52d14bf 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -756,7 +756,6 @@ void on_load_clicked(GtkButton * button, gpointer user_data)
 void on_single_clicked(GtkButton * button, gpointer user_data)
 {
 	view_mode = SINGLE_VIEW;
-	gtk_paned_set_position(GTK_PANED(hpaned), 0);
 	gtk_widget_hide(tree1_w);
 	current = &rootmenu;
 	display_tree_part();
@@ -782,7 +781,6 @@ void on_split_clicked(GtkButton * button, gpointer user_data)
 void on_full_clicked(GtkButton * button, gpointer user_data)
 {
 	view_mode = FULL_VIEW;
-	gtk_paned_set_position(GTK_PANED(hpaned), 0);
 	gtk_widget_hide(tree1_w);
 	if (tree2)
 		gtk_tree_store_clear(tree2);
@@ -1444,6 +1442,12 @@ static void display_tree(struct menu *menu)
                 if (((menu != &rootmenu) && !(menu->flags & MENU_ROOT))
 		    || (view_mode == FULL_VIEW)
 		    || (view_mode == SPLIT_VIEW))*/
+
+		/* Change paned position if the view is not in 'split mode' */
+		if (view_mode == SINGLE_VIEW || view_mode == FULL_VIEW) {
+			gtk_paned_set_position(GTK_PANED(hpaned), 0);
+		}
+		
 		if (((view_mode == SINGLE_VIEW) && (menu->flags & MENU_ROOT))
 		    || (view_mode == FULL_VIEW)
 		    || (view_mode == SPLIT_VIEW)) {
-- 
1.7.4.1



