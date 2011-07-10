Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1GJSlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:41:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:56377 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab1GJSlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:41:52 -0400
Date: Sun, 10 Jul 2011 11:41:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] usb/gadget: fix langwell printk formats
Message-Id: <20110710114127.ebb0d803.randy.dunlap@oracle.com>
In-Reply-To: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020205.4E19F268.008B:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk formats to use %zu for size_t args, to fix these
build warnings:

drivers/usb/gadget/langwell_udc.c:3274: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/gadget/langwell_udc.c:3289: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/gadget/langwell_udc.c:3473: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/gadget/langwell_udc.c:3487: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/gadget/langwell_udc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20110706.orig/drivers/usb/gadget/langwell_udc.c
+++ linux-next-20110706/drivers/usb/gadget/langwell_udc.c
@@ -3271,7 +3271,7 @@ static int langwell_udc_probe(struct pci
 
 	/* allocate device dQH memory */
 	size = dev->ep_max * sizeof(struct langwell_dqh);
-	dev_vdbg(&dev->pdev->dev, "orig size = %d\n", size);
+	dev_vdbg(&dev->pdev->dev, "orig size = %zu\n", size);
 	if (size < DQH_ALIGNMENT)
 		size = DQH_ALIGNMENT;
 	else if ((size % DQH_ALIGNMENT) != 0) {
@@ -3286,7 +3286,7 @@ static int langwell_udc_probe(struct pci
 		goto error;
 	}
 	dev->ep_dqh_size = size;
-	dev_vdbg(&dev->pdev->dev, "ep_dqh_size = %d\n", dev->ep_dqh_size);
+	dev_vdbg(&dev->pdev->dev, "ep_dqh_size = %zu\n", dev->ep_dqh_size);
 
 	/* initialize ep0 status request structure */
 	dev->status_req = kzalloc(sizeof(struct langwell_request), GFP_KERNEL);
@@ -3470,7 +3470,7 @@ static int langwell_udc_resume(struct pc
 
 	/* allocate device dQH memory */
 	size = dev->ep_max * sizeof(struct langwell_dqh);
-	dev_vdbg(&dev->pdev->dev, "orig size = %d\n", size);
+	dev_vdbg(&dev->pdev->dev, "orig size = %zu\n", size);
 	if (size < DQH_ALIGNMENT)
 		size = DQH_ALIGNMENT;
 	else if ((size % DQH_ALIGNMENT) != 0) {
@@ -3484,7 +3484,7 @@ static int langwell_udc_resume(struct pc
 		return -ENOMEM;
 	}
 	dev->ep_dqh_size = size;
-	dev_vdbg(&dev->pdev->dev, "ep_dqh_size = %d\n", dev->ep_dqh_size);
+	dev_vdbg(&dev->pdev->dev, "ep_dqh_size = %zu\n", dev->ep_dqh_size);
 
 	/* create dTD dma_pool resource */
 	dev->dtd_pool = dma_pool_create("langwell_dtd",
