Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1ARVRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:17:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1ARVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:17:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/4] BKL: disable by default
Date: Tue, 18 Jan 2011 22:17:00 +0100
Message-Id: <1295385422-3592-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295385422-3592-1-git-send-email-arnd@arndb.de>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:u16o65Z/NjdKkc0YCQnYMFM5DUnzGlF7tKMFEXBGQpL
 IHsNujkSiH2h2D7yoscfAiojQ0oQxCrG4cIrBFoZeJXeUmD1mv
 m8o8B0Z/CfQ689tY+N58Pm6xkyrI36NllqPyYG6mQd9QQvRCJp
 b4CE8OUaRJXg3xPZ6uwrY52PA4ObCxV/osByXH0bQ01WQkn7NN
 /6D7VRdIFa9tpapEpSlcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at the kernel summit, this change disables
the big kernel lock by default. It is still possible to
enable it in order to build the modules that use it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/Kconfig.debug |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d05adb..f2a399c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -472,12 +472,11 @@ config DEBUG_MUTEXES
 
 config BKL
 	bool "Big Kernel Lock" if (SMP || PREEMPT)
-	default y
 	help
 	  This is the traditional lock that is used in old code instead
-	  of proper locking. All drivers that use the BKL should depend
-	  on this symbol.
-	  Say Y here unless you are working on removing the BKL.
+	  of proper locking. The big kernel lock will go away in 2.6.39,
+	  so all modules that still depend on it need to be changed or
+	  they will be removed as well.
 
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
-- 
1.7.1

