Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0GZFfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:35:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53976 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0GZFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WDOsrUlQXgSzt09w9yMuzpfuICVVGRLbpnq8jFVlshfOJi0+z8STGGsgrDw/Y7wRlx
         AaL9s5wqJvx571lzgWHu0DJjK7zdJ3bjsg7VFX+wLWSAPfdyZdH9HaawytcigH50LDt3
         iYqIzZ+q3+ewCXiwzJmD/l2H6XOdnP/NAjKOE=
Subject: [PATCH] ab3100: fix off-by-one value range checking for voltage
	selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain
Date: Mon, 26 Jul 2010 13:35:49 +0800
Message-Id: <1280122549.20830.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid typ_voltages range should be 0..voltages_len-1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 7b14a67..1179099 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -286,7 +286,7 @@ static int ab3100_list_voltage_regulator(struct regulator_dev *reg,
 {
 	struct ab3100_regulator *abreg = reg->reg_data;
 
-	if (selector > abreg->voltages_len)
+	if (selector >= abreg->voltages_len)
 		return -EINVAL;
 	return abreg->typ_voltages[selector];
 }
@@ -318,7 +318,7 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 	regval &= 0xE0;
 	regval >>= 5;
 
-	if (regval > abreg->voltages_len) {
+	if (regval >= abreg->voltages_len) {
 		dev_err(&reg->dev,
 			"regulator register %02x contains an illegal voltage setting\n",
 			abreg->regreg);
-- 
1.5.4.3



