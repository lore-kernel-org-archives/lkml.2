Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0JAF4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:56:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48919 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0JAF4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aBdSDG6ox4puOHY4yTQdeqiGv/9zc9CrNkE0ZOCk1dQdJAXz6aWt43bYH1p1yOEsaJ
         zMLueidd/tACaoaTpDvfmqJVaE61zx5LjG1XUTnasKOfv6z6FW6uCu6i/az02H3IG6Pt
         Mi8yHqf4eXOPfTfYjzoW6Me53uZJcm3odVebI=
Subject: [PATCH] regulator: max8649 - fix setting extclk_freq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 01 Oct 2010 13:56:27 +0800
Message-Id: <1285912587.12422.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SYNC bits are BIT6 and BIT7 of MAX8649_SYNC register.
pdata->extclk_freq could be [0|1|2].
(MAX8649_EXTCLK_26MHZ|MAX8649_EXTCLK_13MHZ|MAX8649_EXTCLK_19MHZ)
It requires to left shift 6 bits to properly set extclk_freq.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 4520ace..6b60a9c 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -330,7 +330,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 		/* set external clock frequency */
 		info->extclk_freq = pdata->extclk_freq;
 		max8649_set_bits(info->i2c, MAX8649_SYNC, MAX8649_EXT_MASK,
-				 info->extclk_freq);
+				 info->extclk_freq << 6);
 	}
 
 	if (pdata->ramp_timing) {
-- 
1.7.2



