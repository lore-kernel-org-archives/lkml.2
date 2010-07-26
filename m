Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0GZHdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:33:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43285 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0GZHdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PMh+O1ZJVmuxnpzFZ5LMHMN31TkBzDVtxJM01rg6JbIZ3+RqYmLXBOTMZ7du5r6906
         qVgfnCwY0azB9MwpIolroJ62UmBqJWCQ4fE+4NHjt+aQbHVzUrfWk0E0znTUPkwvB/x4
         4zXeUehINJJF5AxOCeJZ3oS3M0Ql6t0XvSfkY=
Subject: [PATCH resend] ab3100: fix off-by-one value range checking for
	voltage selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain
Date: Mon, 26 Jul 2010 15:34:14 +0800
Message-Id: <1280129654.26844.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use voltage selector as an array index for typ_voltages.
Thus the valid range for voltage selector should be 0..voltages_len-1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Simply update the changelog explaining that the reason for the limit is that it's an array index.

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



