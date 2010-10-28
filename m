Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab0J1NmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:42:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64894 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab0J1NmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=NfuzN1au8F+Bbsz8glKDuP6QyJY8Wto/n5TKMsfJMYwxfyXar6Rvm6fWLpjZBsvjit
         VTkLoXxaMsEVANbC+DlJQkxirByj9Mm9L9J1vrJZZMRvPtxRFWpsbdl9f7Wm3nhsE+f3
         iGbuQGoFPKj8IP+ImCxk/oqlgTX7YQcdjN8Ew=
Date: Thu, 28 Oct 2010 15:41:56 +0200
From: Dan Carpenter <error27@gmail.com>
To: Yong Wang <yong.y.wang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dma/intel_mid_dma: remove unneeded null check
Message-ID: <20101028134156.GD6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Yong Wang <yong.y.wang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains because we dereference "mid" before checking it.  It
turns out that "mid" is always a valid pointer here so we can just
remove the check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 338bc4e..41941d0 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1021,11 +1021,6 @@ static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
 
 	/*DMA Interrupt*/
 	pr_debug("MDMA:Got an interrupt on irq %d\n", irq);
-	if (!mid) {
-		pr_err("ERR_MDMA:null pointer mid\n");
-		return -EINVAL;
-	}
-
 	pr_debug("MDMA: Status %x, Mask %x\n", tfr_status, mid->intr_mask);
 	tfr_status &= mid->intr_mask;
 	if (tfr_status) {
