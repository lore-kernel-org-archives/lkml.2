Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0HBBLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:11:08 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63993 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0HBBLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Rkwlinos8Ee6gseaDfrs4c92ENPwuvD9oXngjL7dU7GaP22g8E8+PT4PVnfoPUtHkO
         TILn2p+DsqyEcMyNivkYFpqkXmARlWKsfxPxsmK08cRA6uOW1Ke7jMnVNF5O2xTHt8lg
         4N8jYIrclrRfHS/veuSrOB8Ux/8B+S29TvTcM=
Subject: [PATCH RESEND] jz4740-adc: check kmalloc() result
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Mon, 02 Aug 2010 09:12:04 +0800
Message-Id: <1280711524.6538.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 40f965e63c4aefb402d85cf8392681565e172d2d Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 2 Aug 2010 09:02:02 +0800
Subject: [PATCH] jz4740-adc: check kmalloc() result

If kmalloc() fails exit with -ENOMEM.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next.
This resend separates the fix for jz4740-hwmon and jz474-adc in 2 patches.
 drivers/mfd/jz4740-adc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 7a844ae..2846d24 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -260,6 +260,10 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	int irq;
 
 	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
+	if (!adc) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
 
 	adc->irq = platform_get_irq(pdev, 0);
 	if (adc->irq < 0) {
-- 
1.5.4.3



