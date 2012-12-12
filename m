Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2LLMVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:21:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2LLMVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:21:48 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] pinctrl: imx5: fix GPIO_8 pad CAN1_RXCAN configuration
Date: Wed, 12 Dec 2012 13:21:44 +0100
Message-Id: <1355314904-10174-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 is an invalid value for the CAN1_IPP_IND_CANRX_SELECT_INPUT
register. Set it to 2, which correctly selects the GPIO_8 pad.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/pinctrl/pinctrl-imx53.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx53.c b/drivers/pinctrl/pinctrl-imx53.c
index 783feb1..e069027 100644
--- a/drivers/pinctrl/pinctrl-imx53.c
+++ b/drivers/pinctrl/pinctrl-imx53.c
@@ -1371,7 +1371,7 @@ static struct imx_pin_reg imx53_pin_regs[] = {
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 0, 0x7F8, 1), /* MX53_PAD_GPIO_8__ESAI1_TX5_RX0 */
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 1, 0x000, 0), /* MX53_PAD_GPIO_8__GPIO1_8 */
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 2, 0x000, 0), /* MX53_PAD_GPIO_8__EPIT2_EPITO */
-	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 3, 0x760, 3), /* MX53_PAD_GPIO_8__CAN1_RXCAN */
+	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 3, 0x760, 2), /* MX53_PAD_GPIO_8__CAN1_RXCAN */
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 4, 0x880, 5), /* MX53_PAD_GPIO_8__UART2_RXD_MUX */
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 5, 0x000, 0), /* MX53_PAD_GPIO_8__FIRI_TXD */
 	IMX_PIN_REG(MX53_PAD_GPIO_8, 0x6C8, 0x338, 6, 0x000, 0), /* MX53_PAD_GPIO_8__SPDIF_SRCLK */
-- 
1.7.10.4

