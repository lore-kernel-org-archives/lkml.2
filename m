Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1GBBsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:48:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1GBBsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:48:01 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 7/7] kconfig: add stub for nconf checks
Date: Fri,  1 Jul 2011 21:47:39 -0400
Message-Id: <1309571259-15241-8-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/kconfig/Makefile |    4 +---
 scripts/kconfig/check.sh |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 4e934f1..2eb71ee 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -176,7 +176,7 @@ KC_CHECK := gettext
 
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
-	KC_CHECK += ncurses
+	KC_CHECK += menu panel ncurses
 endif
 
 ifeq ($(MAKECMDGOALS),menuconfig)
@@ -211,8 +211,6 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
 HOSTCFLAGS_gconf.o	= -Wno-missing-prototypes
 
-HOSTLOADLIBES_nconf	= -lmenu -lpanel
-
 need-check := $(addprefix $(obj)/,$(frontends-objs))
 need-check += $(addprefix $(obj)/,$(lxdialog))
 
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index ec551b7..d19eca8 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -47,6 +47,12 @@ check_gtk()
 	echo "HOSTLOADLIBES_gconf	+= $libs"   >> ${obj}/.tmp_check
 }
 
+check_menu()
+{
+
+	echo "HOSTLOADLIBES_nconf	+= -lmenu" >> ${obj}/.tmp_check
+}
+
 check_ncurses()
 {
 	local cflags=""
@@ -96,6 +102,12 @@ check_ncurses()
 	echo "HOSTLOADLIBES_nconf	+= $libs"   >> ${obj}/.tmp_check
 }
 
+check_panel()
+{
+
+	echo "HOSTLOADLIBES_nconf	+= -lpanel" >> ${obj}/.tmp_check
+}
+
 check_qt()
 {
 	local cflags=""
@@ -163,7 +175,9 @@ for arg in $*; do
 	case $arg in
 	gettext)	;;
 	gtk)		;;
+	menu)		;;
 	ncurses)	;;
+	panel)		;;
 	qt)		;;
 	*)
 		echo "  *"
-- 
1.7.3.4.574.g608b.dirty

