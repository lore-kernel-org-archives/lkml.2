Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0E0Q0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:26:43 -0400
Received: from mail.thanoulis.net ([86.35.2.10]:46903 "EHLO
	enigma.wired-net.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0E0Q0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:26:42 -0400
From: nanakos@wired-net.gr
To: gregkh@suse.de
Cc: pavel@ucw.cz, julia@diku.dk, tj@kernel.org, jochen.maes@sejo.be,
       linux-kernel@vger.kernel.org,
       Nanakos Chrysostomos <nanakos@wired-net.gr>
Subject: [PATCH] Staging: dream: pmem.c: Fix checkpatch.pl issues.
Date: Thu, 27 May 2010 16:19:52 +0000
Message-Id: <1274977192-5839-1-git-send-email-nanakos@wired-net.gr>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nanakos Chrysostomos <nanakos@wired-net.gr>

This patch resolves checkpatch.pl issues in the pmem.c file.

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/staging/dream/pmem.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index 6387365..064b59e 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -24,8 +24,8 @@
 #include <linux/mempolicy.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/cacheflush.h>
 
 #define PMEM_MAX_DEVICES 10
@@ -175,7 +175,7 @@ static int pmem_mmap(struct file *, struct vm_area_struct *);
 static int pmem_open(struct inode *, struct file *);
 static long pmem_ioctl(struct file *, unsigned int, unsigned long);
 
-struct file_operations pmem_fops = {
+const struct file_operations pmem_fops = {
 	.release = pmem_release,
 	.mmap = pmem_mmap,
 	.open = pmem_open,
@@ -399,8 +399,8 @@ static int pmem_allocate(int id, unsigned long len)
 	DLOG("order %lx\n", order);
 
 	/* look through the bitmap:
-	 * 	if you find a free slot of the correct order use it
-	 * 	otherwise, use the best fit (smallest with size > order) slot
+	 *	if you find a free slot of the correct order use it
+	 *	otherwise, use the best fit (smallest with size > order) slot
 	 */
 	while (curr < end) {
 		if (PMEM_IS_FREE(id, curr)) {
@@ -426,8 +426,8 @@ static int pmem_allocate(int id, unsigned long len)
 	}
 
 	/* now partition the best fit:
-	 * 	split the slot into 2 buddies of order - 1
-	 * 	repeat until the slot is of the correct order
+	 *	split the slot into 2 buddies of order - 1
+	 *	repeat until the slot is of the correct order
 	 */
 	while (PMEM_ORDER(id, best_fit) > (unsigned char)order) {
 		int buddy;
-- 
1.5.6.5

