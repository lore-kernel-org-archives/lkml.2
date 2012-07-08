Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2GHKvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:51:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47768 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GHKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:51:15 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: paul.gortmaker@windriver.com, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] Kernel: dma.c: fixed coding style issues
Date: Sun,  8 Jul 2012 13:51:05 +0300
Message-Id: <1341744665-15678-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues. (checkpatch warnings)

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 kernel/dma.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/dma.c b/kernel/dma.c
index 6c6262f..082cd74 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -38,6 +38,7 @@
 
 
 DEFINE_SPINLOCK(dma_spin_lock);
+EXPORT_SYMBOL(dma_spin_lock);
 
 /*
  *	If our port doesn't define this it has no PC like DMA
@@ -66,7 +67,7 @@ static struct dma_chan dma_chan_busy[MAX_DMA_CHANNELS] = {
  * @dmanr: DMA channel number
  * @device_id: reserving device ID string, used in /proc/dma
  */
-int request_dma(unsigned int dmanr, const char * device_id)
+int request_dma(unsigned int dmanr, const char *device_id)
 {
 	if (dmanr >= MAX_DMA_CHANNELS)
 		return -EINVAL;
@@ -87,12 +88,12 @@ int request_dma(unsigned int dmanr, const char * device_id)
 void free_dma(unsigned int dmanr)
 {
 	if (dmanr >= MAX_DMA_CHANNELS) {
-		printk(KERN_WARNING "Trying to free DMA%d\n", dmanr);
+		pr_warn("Trying to free DMA%d\n", dmanr);
 		return;
 	}
 
 	if (xchg(&dma_chan_busy[dmanr].lock, 0) == 0) {
-		printk(KERN_WARNING "Trying to free free DMA%d\n", dmanr);
+		pr_warn("Trying to free free DMA%d\n", dmanr);
 		return;
 	}
 
@@ -104,12 +105,14 @@ int request_dma(unsigned int dmanr, const char *device_id)
 {
 	return -EINVAL;
 }
+EXPORT_SYMBOL(request_dma);
 
 void free_dma(unsigned int dmanr)
 {
 }
+EXPORT_SYMBOL(free_dma);
 
-#endif
+#endif /* MAX_DMA_CHANNELS */
 
 #ifdef CONFIG_PROC_FS
 
@@ -153,8 +156,4 @@ static int __init proc_dma_init(void)
 }
 
 __initcall(proc_dma_init);
-#endif
-
-EXPORT_SYMBOL(request_dma);
-EXPORT_SYMBOL(free_dma);
-EXPORT_SYMBOL(dma_spin_lock);
+#endif /* CONFIG_PROC_FS */
-- 
1.7.10.4

