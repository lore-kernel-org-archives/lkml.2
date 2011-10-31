Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1JaQav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:30:51 -0400
Received: from portal.weinmann.de ([62.8.140.122]:27366 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1JaQau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:30:50 -0400
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
CC: "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>
Date: Mon, 31 Oct 2011 17:14:28 +0100
Subject: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Topic: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Index: AcyX6Cm/2dVSkjQYT5eJRnFoe3SMtA==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pdata->scl_is_open_drain was set, the driver used push-pull output
for SCL, not open-drain output.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/i2c/busses/i2c-gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a651779..b161335 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -104,7 +104,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_request_scl;
 
-	if (pdata->sda_is_open_drain) {
+	if (!pdata->sda_is_open_drain) {
 		gpio_direction_output(pdata->sda_pin, 1);
 		bit_data->setsda = i2c_gpio_setsda_val;
 	} else {
@@ -112,7 +112,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 		bit_data->setsda = i2c_gpio_setsda_dir;
 	}
 
-	if (pdata->scl_is_open_drain || pdata->scl_is_output_only) {
+	if (!pdata->scl_is_open_drain || pdata->scl_is_output_only) {
 		gpio_direction_output(pdata->scl_pin, 1);
 		bit_data->setscl = i2c_gpio_setscl_val;
 	} else {
-- 
1.7.4.1

