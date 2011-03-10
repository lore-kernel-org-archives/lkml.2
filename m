Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1CJNo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:44:27 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:59309 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab1CJNoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:44:11 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] regulator: add support for USB voltage regulator
Date: Thu, 10 Mar 2011 14:43:31 +0100
Message-ID: <1299764611-2499-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c       |   17 ++++++++++++++++-
 include/linux/regulator/ab8500.h |    1 +
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index d9a052c..5a77630 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -9,7 +9,7 @@
  * AB8500 peripheral regulators
  *
  * AB8500 supports the following regulators:
- *   VAUX1/2/3, VINTCORE, VTVOUT, VAUDIO, VAMIC1/2, VDMIC, VANA
+ *   VAUX1/2/3, VINTCORE, VTVOUT, VUSB, VAUDIO, VAMIC1/2, VDMIC, VANA
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -432,6 +432,21 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x82,
 		.update_val_enable	= 0x02,
 	},
+	[AB8500_LDO_USB] = {
+		.desc = {
+			.name           = "LDO-USB",
+			.ops            = &ab8500_regulator_fixed_ops,
+			.type           = REGULATOR_VOLTAGE,
+			.id             = AB8500_LDO_USB,
+			.owner          = THIS_MODULE,
+			.n_voltages     = 1,
+		},
+		.fixed_uV               = 3300000,
+		.update_bank            = 0x03,
+		.update_reg             = 0x82,
+		.update_mask            = 0x03,
+		.update_val_enable      = 0x01,
+	},
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 6a210f1..d4eacde 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -17,6 +17,7 @@ enum ab8500_regulator_id {
 	AB8500_LDO_AUX3,
 	AB8500_LDO_INTCORE,
 	AB8500_LDO_TVOUT,
+	AB8500_LDO_USB,
 	AB8500_LDO_AUDIO,
 	AB8500_LDO_ANAMIC1,
 	AB8500_LDO_ANAMIC2,
-- 
1.7.3.2

