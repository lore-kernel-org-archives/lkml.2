Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1DASFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:05:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37989 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756871Ab1DASFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:05:04 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 7/9] gma500: cleanup the SDVO messages
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:42:22 +0100
Message-ID: <20110401174214.18112.25445.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c        |    3 ++-
 drivers/staging/gma500/psb_intel_sdvo.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index be8f11d..8978ed6 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -493,7 +493,8 @@ static int psb_do_init(struct drm_device *dev)
         PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) | _PSB_MMU_ER_MASK,
 							PSB_CR_BIF_CTRL);
 	psb_spank(dev_priv);
-       
+
+	printk(KERN_INFO "TWOD base %08lX\n", (u32) pg->mmu_gatt_start);
       	PSB_WSGX32(pg->mmu_gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
 	return 0;
diff --git a/drivers/staging/gma500/psb_intel_sdvo.c b/drivers/staging/gma500/psb_intel_sdvo.c
index 731a5a2..d005227 100644
--- a/drivers/staging/gma500/psb_intel_sdvo.c
+++ b/drivers/staging/gma500/psb_intel_sdvo.c
@@ -204,7 +204,7 @@ static void psb_intel_sdvo_write_cmd(struct psb_intel_output *psb_intel_output,
 	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
 	int i;
 
-	if (1) {
+	if (0) {
 		DRM_DEBUG("%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
 		for (i = 0; i < args_len; i++)
 			printk(KERN_INFO"%02X ", ((u8 *) args)[i]);
@@ -266,7 +266,7 @@ static u8 psb_intel_sdvo_read_response(
 					 SDVO_I2C_CMD_STATUS,
 					 &status);
 
-		if (1) {
+		if (0) {
 			DRM_DEBUG("%s: R: ", SDVO_NAME(sdvo_priv));
 			for (i = 0; i < response_len; i++)
 				printk(KERN_INFO"%02X ", ((u8 *) response)[i]);

