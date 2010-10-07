Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab0JGHue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:50:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46574 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126Ab0JGHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SJcylChK2GhMKu8dL1+30Wvfms9cu3gp7/KVHSEJIFrbgAlHID8iv1ftR3VQJQiKqz
         WqCl+P4tazuUwn25tqaBZEjosiOQgiLL1Im9JyuKLVAwy4rf3Yirr8qFVATq0qAxsMin
         KeYI9JS1KX6Qi/ilk8cVkcitrJPRPBC2kUQSI=
Subject: [PATCH] mfd: jz4740-adc - fix jz4740_adc_set_enabled
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain
Date: Thu, 07 Oct 2010 15:51:20 +0800
Message-Id: <1286437880.18303.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabled is false, clear BIT(engine) of JZ_REG_ADC_ENABLE register.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/jz4740-adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 3ad492c..9dd1b33 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -153,7 +153,7 @@ static inline void jz4740_adc_set_enabled(struct jz4740_adc *adc, int engine,
 	if (enabled)
 		val |= BIT(engine);
 	else
-		val &= BIT(engine);
+		val &= ~BIT(engine);
 	writeb(val, adc->base + JZ_REG_ADC_ENABLE);
 
 	spin_unlock_irqrestore(&adc->lock, flags);
-- 
1.7.2



