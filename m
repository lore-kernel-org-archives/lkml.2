Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0LLXqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36056 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0LLXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jmaggard10@gmail.com, neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [91/223] md: fix return value of rdev_size_change()
Message-Id: <20101212234631.00D62B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Justin Maggard <jmaggard10@gmail.com>

commit c26a44ed1e552aaa1d4ceb71842002d235fe98d7 upstream.

When trying to grow an array by enlarging component devices,
rdev_size_store() expects the return value of rdev_size_change() to be
in sectors, but the actual value is returned in KBs.

This functionality was broken by commit
     dd8ac336c13fd8afdb082ebacb1cddd5cf727889
so this patch is suitable for any kernel since 2.6.30.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c
+++ linux/drivers/md/md.c
@@ -1278,7 +1278,7 @@ super_90_rdev_size_change(mdk_rdev_t *rd
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 
@@ -1644,7 +1644,7 @@ super_1_rdev_size_change(mdk_rdev_t *rde
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 static struct super_type super_types[] = {
