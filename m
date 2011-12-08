Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1LHMzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1LHMzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:55:10 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 27/30] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Thu,  8 Dec 2011 18:22:22 +0530
Message-Id: <1323348745-31477-27-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed ifdef CB_PCIDAS_DEBUG.
Included KERN_facility levels for printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 80c981d..00427c2 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1572,10 +1572,9 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	async->events = 0;
 
 	s5933_status = inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-	printk("intcsr 0x%x\n", s5933_status);
-	printk("mbef 0x%x\n", inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
-#endif
+	printk(KERN_DEBUG "intcsr 0x%x\n", s5933_status);
+	printk(KERN_DEBUG "mbef 0x%x\n",
+	       inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
 
 	if ((INTCSR_INTR_ASSERTED & s5933_status) == 0)
 		return IRQ_NONE;
-- 
1.7.0.4

