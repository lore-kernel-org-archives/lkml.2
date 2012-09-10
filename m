Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2IJJAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:00:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53827 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2IJJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:03 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 6/7] pwm: i.MX: use per clock unconditionally
Date: Mon, 10 Sep 2012 10:59:36 +0200
Message-Id: <1347267577-3296-7-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX PWM module has two clocks: The ipg clock and the ipg highfreq
(peripheral) clock. The ipg clock has to be enabled for this hardware
to work. The actual PWM output can either be driven by the ipg clock
or the ipg highfreq. The ipg highfreq has the advantage that it runs
even when the SoC is in low power modes.
Use the always running clock also on i.MX25.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index b4e0ad3..852de6c 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -132,16 +132,11 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 
 	cr = MX3_PWMCR_PRESCALER(prescale) |
 		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
-		MX3_PWMCR_DBGEN;
+		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
 
 	if (imx->enabled)
 		cr |= MX3_PWMCR_EN;
 
-	if (cpu_is_mx25())
-		cr |= MX3_PWMCR_CLKSRC_IPG;
-	else
-		cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
-
 	writel(cr, imx->mmio_base + MX3_PWMCR);
 
 	return 0;
-- 
1.7.10.4

