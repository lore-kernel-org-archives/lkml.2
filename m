Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0KXT70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:59:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47197 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932129Ab0KXT7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:59:23 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/12] sep: clean up a couple of spots missed in pass one
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:39:07 +0000
Message-ID: <20101124193905.16425.57578.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Another copy_user case and some formatting of dbg

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ebe7a90..5e27b5a 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1037,8 +1037,6 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		sizeof(struct alloc_struct));
 	if (error) {
 		error = -EFAULT;
-		dev_warn(&sep->pdev->dev,
-			"allocate data pool copy to user error\n");
 		goto end_function;
 	}
 
@@ -1083,13 +1081,10 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	/* Map array */
 	struct sep_dma_map *map_array;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_lock_kernel_pages start\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"kernel_virt_addr is %08x\n", kernel_virt_addr);
-	dev_dbg(&sep->pdev->dev,
-		"data_size is %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "sep_lock_kernel_pages start\n");
+	dev_dbg(&sep->pdev->dev, "kernel_virt_addr is %08x\n",
+							kernel_virt_addr);
+	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
 
 	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
 	if (!lli_array) {
@@ -1182,8 +1177,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	/* Direction of the DMA mapping for locked pages */
 	enum dma_data_direction	dir;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_lock_user_pages start\n");
+	dev_dbg(&sep->pdev->dev, "sep_lock_user_pages start\n");
 
 	/* Set start and end pages  and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;

