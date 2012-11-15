Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768351Ab2KOQBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:01:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57511 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768293Ab2KOQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:01:47 -0500
Message-ID: <1352995295.10636.1.camel@phoenix>
Subject: [PATCH] pinctrl: nomadik: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 16 Nov 2012 00:01:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not referenced outside of this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-nomadik.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 238060e..cf99e0a 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1285,8 +1285,8 @@ void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up)
 	}
 }
 
-int nmk_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			  irq_hw_number_t hwirq)
+static int nmk_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+			    irq_hw_number_t hwirq)
 {
 	struct nmk_gpio_chip *nmk_chip = d->host_data;
 
@@ -1670,9 +1670,9 @@ static void nmk_pmx_disable(struct pinctrl_dev *pctldev,
 	dev_dbg(npct->dev, "disable group %s, %u pins\n", g->name, g->npins);
 }
 
-int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
-			    struct pinctrl_gpio_range *range,
-			    unsigned offset)
+static int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *range,
+				   unsigned offset)
 {
 	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
 	struct nmk_gpio_chip *nmk_chip;
@@ -1701,9 +1701,9 @@ int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-void nmk_gpio_disable_free(struct pinctrl_dev *pctldev,
-			   struct pinctrl_gpio_range *range,
-			   unsigned offset)
+static void nmk_gpio_disable_free(struct pinctrl_dev *pctldev,
+				  struct pinctrl_gpio_range *range,
+				  unsigned offset)
 {
 	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
 
@@ -1721,17 +1721,15 @@ static struct pinmux_ops nmk_pinmux_ops = {
 	.gpio_disable_free = nmk_gpio_disable_free,
 };
 
-int nmk_pin_config_get(struct pinctrl_dev *pctldev,
-		       unsigned pin,
-		       unsigned long *config)
+static int nmk_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
+			      unsigned long *config)
 {
 	/* Not implemented */
 	return -EINVAL;
 }
 
-int nmk_pin_config_set(struct pinctrl_dev *pctldev,
-		       unsigned pin,
-		       unsigned long config)
+static int nmk_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
+			      unsigned long config)
 {
 	static const char *pullnames[] = {
 		[NMK_GPIO_PULL_NONE]	= "none",
-- 
1.7.9.5



