Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1JVSXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 14:23:15 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:43905 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1JVSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 14:23:14 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 14:23:14 EDT
Date: Sat, 22 Oct 2011 13:19:02 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: fix warnings by specifing format arguments
Message-id: <alpine.LNX.2.00.1110221317230.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify format arguments to fix warnings.

  HOSTCC  scripts/kconfig/gconf.o
/usr/src/lto/scripts/kconfig/gconf.c: In function 'on_introduction1_activate':
/usr/src/lto/scripts/kconfig/gconf.c:686:6: warning: format not a string literal and no format arguments
/usr/src/lto/scripts/kconfig/gconf.c: In function 'on_about1_activate':
/usr/src/lto/scripts/kconfig/gconf.c:704:6: warning: format not a string literal and no format arguments
/usr/src/lto/scripts/kconfig/gconf.c: In function 'on_license1_activate':
/usr/src/lto/scripts/kconfig/gconf.c:723:6: warning: format not a string literal and no format arguments

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/gconf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 9f44380..b9e26a5 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -683,7 +683,7 @@ void on_introduction1_activate(GtkMenuItem * menuitem, gpointer user_data)
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, intro_text);
+					GTK_BUTTONS_CLOSE, "%s", intro_text);
 	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
 				 GTK_OBJECT(dialog));
@@ -701,7 +701,7 @@ void on_about1_activate(GtkMenuItem * menuitem, gpointer user_data)
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, about_text);
+					GTK_BUTTONS_CLOSE, "%s", about_text);
 	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
 				 GTK_OBJECT(dialog));
@@ -720,7 +720,7 @@ void on_license1_activate(GtkMenuItem * menuitem, gpointer user_data)
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, license_text);
+					GTK_BUTTONS_CLOSE, "%s", license_text);
 	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
 				 GTK_OBJECT(dialog));
-- 
1.7.7

