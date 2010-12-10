Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0LJKLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:11:02 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58079 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0LJKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:10:59 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 2/9] regulators: Fixed errors in ab8500 register mapping
Date: Fri, 10 Dec 2010 11:08:41 +0100
Message-ID: <1291975728-12525-3-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For INTCORE and TVOUT regulators, the low power register bit is
included in the mask so that enable will set the regulator in
normal (high power) mode.

ANAMIC1, ANAMIC2, DMIC regulator settings are swapped with each
other so that the correct regulator gets enabled/disabled.

ANA regulator register address is corrected.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5670775..4efe3cf 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -330,19 +330,19 @@ static struct ab8500_regulator_info ab8500_regulator_info[] = {
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
 	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0xf,
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x4, 0x4, 0x03, 0x80, 0x38,
+	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x44, 0x4, 0x03, 0x80, 0x38,
 		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
 
 	/*
 	 * Fixed Voltage LDOs
 	 *		 name,	o/p uV, ctrl bank, ctrl reg, enable, disable
 	 */
-	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03,      0x80,     0x2,    0x2),
+	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03,      0x80,     0x82,    0x2),
 	AB8500_FIXED_LDO(AUDIO,   2000, 0x03,      0x83,     0x2,    0x2),
-	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03,      0x83,     0x4,    0x4),
-	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03,      0x83,     0x8,    0x8),
-	AB8500_FIXED_LDO(DMIC,    1800, 0x03,      0x83,     0x10,   0x10),
-	AB8500_FIXED_LDO(ANA,     1200, 0x03,      0x83,     0xc,    0x4),
+	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03,      0x83,     0x08,    0x08),
+	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03,      0x83,     0x10,    0x10),
+	AB8500_FIXED_LDO(DMIC,    1800, 0x03,      0x83,     0x04,   0x04),
+	AB8500_FIXED_LDO(ANA,     1200, 0x04,      0x06,     0xc,    0x4),
 };
 
 static inline struct ab8500_regulator_info *find_regulator_info(int id)
-- 
1.7.2.2

