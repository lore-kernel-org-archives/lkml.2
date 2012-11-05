Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2KENYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:24:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab2KENYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:24:01 -0500
Message-ID: <1352121830.14769.2.camel@phoenix>
Subject: [PATCH] pinctrl: at91: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 21:23:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-at91.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 65f066c..b9e2cbd 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -566,9 +566,9 @@ static int at91_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
-int at91_gpio_request_enable(struct pinctrl_dev *pctldev,
-			    struct pinctrl_gpio_range *range,
-			    unsigned offset)
+static int at91_gpio_request_enable(struct pinctrl_dev *pctldev,
+				    struct pinctrl_gpio_range *range,
+				    unsigned offset)
 {
 	struct at91_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
 	struct at91_gpio_chip *at91_chip;
@@ -598,9 +598,9 @@ int at91_gpio_request_enable(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-void at91_gpio_disable_free(struct pinctrl_dev *pctldev,
-			   struct pinctrl_gpio_range *range,
-			   unsigned offset)
+static void at91_gpio_disable_free(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *range,
+				   unsigned offset)
 {
 	struct at91_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
 
@@ -952,7 +952,7 @@ err:
 	return ret;
 }
 
-int __devexit at91_pinctrl_remove(struct platform_device *pdev)
+static int __devexit at91_pinctrl_remove(struct platform_device *pdev)
 {
 	struct at91_pinctrl *info = platform_get_drvdata(pdev);
 
@@ -1249,9 +1249,11 @@ static int at91_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-int at91_gpio_irq_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
-			const u32 *intspec, unsigned int intsize,
-			irq_hw_number_t *out_hwirq, unsigned int *out_type)
+static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
+				      struct device_node *ctrlr,
+				      const u32 *intspec, unsigned int intsize,
+				      irq_hw_number_t *out_hwirq,
+				      unsigned int *out_type)
 {
 	struct at91_gpio_chip *at91_gpio = d->host_data;
 	int ret;
-- 
1.7.9.5



