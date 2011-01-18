Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1ARVRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:17:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1ARVRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:17:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Date: Tue, 18 Jan 2011 22:17:02 +0100
Message-Id: <1295385422-3592-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295385422-3592-1-git-send-email-arnd@arndb.de>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qtumuCiYk4g3HpJ7zUC5+XKJ3WKXzPcPC9Uh9f462x0
 6OAZiRg63CP0pPW8Nf0FeCj8pAo4nINeZb2Z5Hoi6+w/XDE7/R
 o7TmBmXzzgAVgfCszPzWlqvp2I39kgtyQ9ORnO879ay7sZb63N
 XU/wJEnMh6MXhZerayHBth/eY+LmTEjlCJUr4imEYEUIHWiG86
 KFSupbkRhcTnU35ERKcsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of moving the actual code to staging for stuff that
depends on CONFIG_BKL, this moves just the configuration
option it depends on.

As a consequence, the remaining non-staging drivers that use
the BKL (i830, appletalk, ipx, x25, adfs, hpfs and ufs)
implicitly depend on staging until they get fixed.

This sets 2.6.39 as the arbitrary date when we actually remove
the option along with its last users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/Kconfig |   10 ++++++++++
 lib/Kconfig.debug       |    8 --------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 5c8fcfc..1327ccc 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -41,6 +41,16 @@ config STAGING_EXCLUDE_BUILD
 
 if !STAGING_EXCLUDE_BUILD
 
+config BKL
+	bool "Include drivers that depend on the Big Kernel Lock" if (SMP || PREEMPT)
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  A small number of drivers still require this. All drivers that
+	  use the BKL should be changed to a better serialisation method
+	  or they will be removed in 2.6.39.
+
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f2a399c..4a78f8c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -470,14 +470,6 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
-config BKL
-	bool "Big Kernel Lock" if (SMP || PREEMPT)
-	help
-	  This is the traditional lock that is used in old code instead
-	  of proper locking. The big kernel lock will go away in 2.6.39,
-	  so all modules that still depend on it need to be changed or
-	  they will be removed as well.
-
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.7.1

