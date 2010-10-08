Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0JHJxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:53:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49548 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0JHJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=k01qGotVrrmetodSFfCRl5qtj7YmpD6urF/LMZfddgQDjCrA24ATCexOLYs7TxKJd9
         qoyKtUXwST3FP5GjwymipMB83UnT0WMJVcxUgWUuF6unfAhiFVvm31gkxY688c0C02Tt
         SpNrsNf6iePeJMOsmtqUTsF2Ps8IkEByx2mEE=
Subject: [PATCH] intel_pmic_gpio: fix off-by-one value range checking
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Alek Du <alek.du@intel.com>,
        Alan Cox <alan@linux.intel.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 08 Oct 2010 17:54:31 +0800
Message-Id: <1286531671.6060.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pmic_irq_type(), we use gpio as array index for trigger,
thus the valid value range for gpio should be 0 .. NUM_GPIO - 1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
index c6e2a1d..f540ff9 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -197,7 +197,7 @@ static int pmic_irq_type(unsigned irq, unsigned type)
 	u32 gpio = irq - pg->irq_base;
 	unsigned long flags;
 
-	if (gpio > pg->chip.ngpio)
+	if (gpio >= pg->chip.ngpio)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pg->irqtypes.lock, flags);
-- 
1.7.2



