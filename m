Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1EHSvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:23 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:46557 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:42:44 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/14] HPFS: Make HPFS compile on preempt and SMP
Message-ID: <alpine.DEB.2.00.1105082024070.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make HPFS compile on preempt and SMP

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/Kconfig |    1 -
 fs/hpfs/super.c |    5 -----
 2 files changed, 6 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/Kconfig
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/Kconfig	2011-05-05 01:01:58.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/Kconfig	2011-05-05 01:02:36.000000000 +0200
@@ -1,7 +1,6 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
-	depends on BROKEN || !PREEMPT
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:01:58.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:36.000000000 +0200
@@ -479,11 +479,6 @@ static int hpfs_fill_super(struct super_
 
 	int o;
 
-	if (num_possible_cpus() > 1) {
-		printk(KERN_ERR "HPFS is not SMP safe\n");
-		return -EINVAL;
-	}
-
 	save_mount_options(s, options);
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
