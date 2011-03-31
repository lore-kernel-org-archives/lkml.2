Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab1CaV4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:56:32 -0400
Received: from mail.tpi.com ([70.99.223.143]:3198 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1CaV4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:56:31 -0400
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 17:56:31 EDT
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tim Gardner <tim.gardner@canonical.com>,
        Dan Kegel <dank@kegel.com>
Subject: [PATCH] Raise default hard ulimit on number of files to 4096
Date: Thu, 31 Mar 2011 15:26:50 -0600
Message-Id: <1301606810-11001-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apps are increasingly using more than 1024 file descriptors.
See discussion in several distro bug trackers, e.g.
https://bugs.launchpad.net/bugs/663090
https://issues.rpath.com/browse/RPL-2054

Cc: Dan Kegel <dank@kegel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/asm-generic/resource.h |    2 +-
 include/linux/fs.h             |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 587566f..61fa862 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -78,7 +78,7 @@
 	[RLIMIT_CORE]		= {              0,  RLIM_INFINITY },	\
 	[RLIMIT_RSS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_NPROC]		= {              0,              0 },	\
-	[RLIMIT_NOFILE]		= {       INR_OPEN,       INR_OPEN },	\
+	[RLIMIT_NOFILE]		= {   INR_OPEN_CUR,   INR_OPEN_MAX },	\
 	[RLIMIT_MEMLOCK]	= {    MLOCK_LIMIT,    MLOCK_LIMIT },	\
 	[RLIMIT_AS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_LOCKS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 52f283c..6e1e4e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -23,7 +23,8 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define INR_OPEN 1024		/* Initial setting for nfile rlimits */
+#define INR_OPEN_CUR 1024	/* Initial setting for nfile rlimits */
+#define INR_OPEN_MAX 4096	/* Hard limit for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
-- 
1.7.0.4

