Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2INC2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:28:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43288 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2INC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:28:32 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:28:31 +0800
Message-ID: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
Subject: [PATCH] gpio_msm: using for_each_set_bit to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit() to simplify the code.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpio/gpio-msm-v2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index 5cb1227..38305be 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -317,9 +317,7 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 	chained_irq_enter(chip, desc);
 
-	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
-	     i < NR_GPIO_IRQS;
-	     i = find_next_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS, i + 1)) {
+	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
 		if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS))
 			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
 							   i));


