Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0IAPqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:46:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0IAPqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:46:46 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH] xconfig: Change the titlebar if using Qt3
Date: Wed,  1 Sep 2010 17:46:37 +0200
Message-Id: <1283355997-6900-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qt4 is now used by default and will get more testing. In case someone
still uses Qt3 and reports a bug, make it easy to recognize that this is
Qt3.

Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/qconf.cc |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 88d3874..a04e451 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1274,8 +1274,14 @@ ConfigMainWindow::ConfigMainWindow(void)
 	char title[256];
 
 	QDesktopWidget *d = configApp->desktop();
-	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),
-		getenv("KERNELVERSION"));
+	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration%s"),
+		getenv("KERNELVERSION"),
+#if QT_VERSION < 0x040000
+		" (Qt3)"
+#else
+		""
+#endif
+		);
 	setCaption(title);
 
 	width = configSettings->readNumEntry("/window width", d->width() - 64);
-- 
1.7.1

