Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0FIJmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:42:20 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:36452 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab0FIJmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:42:17 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 05:42:15 EDT
X-ClientAddr: 91.119.7.171
Date: Wed, 9 Jun 2010 11:25:05 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/savage: fixed brace coding style issues
Message-ID: <20100609112505.2d3666fe@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o599V6cM019724
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/savage/savage_bci.c   |   16 ++++++----------
 drivers/gpu/drm/savage/savage_state.c |    3 +--
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index 2d0c9ca..0db51f1 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -525,9 +525,8 @@ static void savage_fake_dma_flush(drm_savage_private_t * dev_priv)
 		}
 #endif
 		BEGIN_BCI(dev_priv->dma_pages[i].used);
-		for (j = 0; j < dev_priv->dma_pages[i].used; ++j) {
+		for (j = 0; j < dev_priv->dma_pages[i].used; ++j)
 			BCI_WRITE(dma_ptr[j]);
-		}
 		dev_priv->dma_pages[i].used = 0;
 	}
 
@@ -855,11 +854,10 @@ static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
 	dev_priv->event_wrap = 0;
 	dev_priv->bci_ptr = (volatile uint32_t *)
 	    ((uint8_t *) dev_priv->mmio->handle + SAVAGE_BCI_OFFSET);
-	if (S3_SAVAGE3D_SERIES(dev_priv->chipset)) {
+	if (S3_SAVAGE3D_SERIES(dev_priv->chipset))
 		dev_priv->status_used_mask = SAVAGE_FIFO_USED_MASK_S3D;
-	} else {
+	else
 		dev_priv->status_used_mask = SAVAGE_FIFO_USED_MASK_S4;
-	}
 	if (dev_priv->status != NULL) {
 		dev_priv->status_ptr =
 		    (volatile uint32_t *)dev_priv->status->handle;
@@ -868,11 +866,10 @@ static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
 		dev_priv->status_ptr[1023] = dev_priv->event_counter;
 	} else {
 		dev_priv->status_ptr = NULL;
-		if (S3_SAVAGE3D_SERIES(dev_priv->chipset)) {
+		if (S3_SAVAGE3D_SERIES(dev_priv->chipset))
 			dev_priv->wait_fifo = savage_bci_wait_fifo_s3d;
-		} else {
+		else
 			dev_priv->wait_fifo = savage_bci_wait_fifo_s4;
-		}
 		dev_priv->wait_evnt = savage_bci_wait_event_reg;
 	}
 
@@ -1040,9 +1037,8 @@ int savage_bci_buffers(struct drm_device *dev, void *data, struct drm_file *file
 
 	d->granted_count = 0;
 
-	if (d->request_count) {
+	if (d->request_count)
 		ret = savage_bci_get_buffers(dev, file_priv, d);
-	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/savage/savage_state.c b/drivers/gpu/drm/savage/savage_state.c
index 8a3e315..d14dba4 100644
--- a/drivers/gpu/drm/savage/savage_state.c
+++ b/drivers/gpu/drm/savage/savage_state.c
@@ -993,8 +993,7 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 			return -ENOMEM;
 
 		if (DRM_COPY_FROM_USER(kcmd_addr, cmdbuf->cmd_addr,
-				       cmdbuf->size * 8))
-		{
+				       cmdbuf->size * 8)) {
 			kfree(kcmd_addr);
 			return -EFAULT;
 		}
-- 
1.6.4.4

