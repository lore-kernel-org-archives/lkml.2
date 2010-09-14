Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0INTkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0INTk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] parisc: remove big kernel lock
Date: Tue, 14 Sep 2010 21:40:12 +0200
Message-Id: <1284493213-7263-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0vkTJS7m2amwwyXvfyO+Si0C5L8id936GwjrO8PQDvJ
 tZn577XfZUN/+3sUW1rhf3ik1zsKGdtbd6UZs+nzcJTWqX3auW
 CHEOfezI3zfjfnKouOxpxSqihEFX19SoXOyLXk+66keT3ncA+O
 5lw63fuIUVeTwzSBb8ZMiCEuavvfQwq0rqPyHJQTl7keaSyzq8
 CQtndFDYwXPyCq1iWL5bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parisc version of the perf code is sufficiently
protected by its own spinlock, no need to use the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/perf.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index f9f6783..ba0c053 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -46,7 +46,6 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
@@ -261,16 +260,13 @@ printk("Preparing to start counters\n");
  */
 static int perf_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&perf_lock);
 	if (perf_enabled) {
 		spin_unlock(&perf_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 	perf_enabled = 1;
  	spin_unlock(&perf_lock);
-	unlock_kernel();
 
 	return 0;
 }
-- 
1.7.1

