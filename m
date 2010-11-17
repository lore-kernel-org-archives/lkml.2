Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934774Ab0KQP1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:27:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab0KQP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:27:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/7] BKL: disable by default
Date: Wed, 17 Nov 2010 16:26:57 +0100
Message-Id: <1290007619-5787-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:B0TIq36v/ih5YeOUtSysHEzXkrMnK5fMAzZAruwc+9a
 3zAWqAZPfVykZQTOnoospi8jjxENb7tjTKBk1V5k1KkZ9jhh1Z
 OhLkT2uLpRHzjHw27SSma+ykviFqaZkwdkWmHVVtEKM9pUA2Q/
 nbwdlbvR4Xk/JuR6+o8QWg8H7rLj0/9a16BjTURibZ5aqAqfOD
 yvlQwLmGduqlKAZxxWZ7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at the kernel summit, this change disables
the big kernel lock by default. It is still possible to
enable it in order to build the modules that use it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/Kconfig.debug |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28b42b9..65aaefd 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -471,12 +471,12 @@ config DEBUG_MUTEXES
 
 config BKL
 	bool "Big Kernel Lock" if (SMP || PREEMPT)
-	default y
+	default !(SMP || PREEMPT)
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

