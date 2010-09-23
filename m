Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0IWGuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:50:54 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:37554
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab0IWGux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:50:53 -0400
From: matt mooney <mfm@muteddisk.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 01/20] kernel: change to new flag variable
Date: Wed, 22 Sep 2010 23:49:45 -0700
Message-Id: <1285224585-29457-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 kernel/gcov/Makefile  |    2 +-
 kernel/power/Makefile |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index 3f76100..e97ca59 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
 obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index f9063c6..0f98685 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -1,7 +1,5 @@
 
-ifeq ($(CONFIG_PM_DEBUG),y)
-EXTRA_CFLAGS	+=	-DDEBUG
-endif
+ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
-- 
1.7.2.1

