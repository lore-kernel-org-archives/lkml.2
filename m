Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0KJWnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:43:37 -0500
Received: from xenotime.net ([72.52.115.56]:60916 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757363Ab0KJWng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:36 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] Documentation: remove anticipatory scheduler info
Message-ID: <12894188301171@xenotime.net>
In-Reply-To: <1289418830794@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove anticipatory block I/O scheduler info from Documentation/
since the code has been deleted.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jens Axboe <axboe@kernel.dk>
---
 Documentation/block/switching-sched.txt |    8 ++++----
 Documentation/kernel-parameters.txt     |    2 +-
 Documentation/rbtree.txt                |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.37-rc1-git8.orig/Documentation/block/switching-sched.txt
+++ linux-2.6.37-rc1-git8/Documentation/block/switching-sched.txt
@@ -16,7 +16,7 @@ you can do so by typing:
 As of the Linux 2.6.10 kernel, it is now possible to change the
 IO scheduler for a given block device on the fly (thus making it possible,
 for instance, to set the CFQ scheduler for the system default, but
-set a specific device to use the anticipatory or noop schedulers - which
+set a specific device to use the deadline or noop schedulers - which
 can improve that device's throughput).
 
 To set a specific scheduler, simply do this:
@@ -31,7 +31,7 @@ a "cat /sys/block/DEV/queue/scheduler" -
 will be displayed, with the currently selected scheduler in brackets:
 
 # cat /sys/block/hda/queue/scheduler
-noop anticipatory deadline [cfq]
-# echo anticipatory > /sys/block/hda/queue/scheduler
+noop deadline [cfq]
+# echo deadline > /sys/block/hda/queue/scheduler
 # cat /sys/block/hda/queue/scheduler
-noop [anticipatory] deadline cfq
+noop [deadline] cfq
--- linux-2.6.37-rc1-git8.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.37-rc1-git8/Documentation/kernel-parameters.txt
@@ -706,7 +706,7 @@ and is between 256 and 4096 characters. 
 			arch/x86/kernel/cpu/cpufreq/elanfreq.c.
 
 	elevator=	[IOSCHED]
-			Format: {"anticipatory" | "cfq" | "deadline" | "noop"}
+			Format: {"cfq" | "deadline" | "noop"}
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
--- linux-2.6.37-rc1-git8.orig/Documentation/rbtree.txt
+++ linux-2.6.37-rc1-git8/Documentation/rbtree.txt
@@ -21,8 +21,8 @@ three rotations, respectively, to balanc
 To quote Linux Weekly News:
 
     There are a number of red-black trees in use in the kernel.
-    The anticipatory, deadline, and CFQ I/O schedulers all employ
-    rbtrees to track requests; the packet CD/DVD driver does the same.
+    The deadline and CFQ I/O schedulers employ rbtrees to
+    track requests; the packet CD/DVD driver does the same.
     The high-resolution timer code uses an rbtree to organize outstanding
     timer requests.  The ext3 filesystem tracks directory entries in a
     red-black tree.  Virtual memory areas (VMAs) are tracked with red-black


-- 

