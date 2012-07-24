Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2GXKf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:35:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2GXKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:35:25 -0400
Message-ID: <1343126116.6033.1.camel@phoenix>
Subject: [PATCH] gpio: msic: Fix calculating register address in
 msic_gpio_to_oreg()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 24 Jul 2012 18:35:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case offset is 20 ... 23, the equation to get the register should be:
        INTEL_MSIC_GPIO1HV0CTLO - offset + 20

With above equation, we can get below mapping between offset and the register:
        offset is 20: INTEL_MSIC_GPIO1HV0CTLO
        offset is 21: INTEL_MSIC_GPIO1HV1CTLO
        offset is 22: INTEL_MSIC_GPIO1HV2CTLO
        offset is 23: INTEL_MSIC_GPIO1HV3CTLO

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-msic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-msic.c b/drivers/gpio/gpio-msic.c
index 71a838f..b389862 100644
--- a/drivers/gpio/gpio-msic.c
+++ b/drivers/gpio/gpio-msic.c
@@ -99,7 +99,7 @@ static int msic_gpio_to_oreg(unsigned offset)
 	if (offset < 20)
 		return INTEL_MSIC_GPIO0HV0CTLO - offset + 16;
 
-	return INTEL_MSIC_GPIO1HV0CTLO + offset + 20;
+	return INTEL_MSIC_GPIO1HV0CTLO - offset + 20;
 }
 
 static int msic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
-- 
1.7.9.5



