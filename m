Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0HVOmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 10:42:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63799 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0HVOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 10:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SrxWgZpgWTK1L+m9IYUqoWOQtP7VIyhIw84OC4nKM2lIWH6Ows6+rMupg7BSgv/oXK
         yG0JWIfT4C95Q/1cpLw6A11g5Yh40QzNpTbk7W+Y54/X0rDxmLrJoskoC1lbk3GmVQL2
         tuMiGb0ehTP8FVbBqdcsQA4aNX0rHyjuo1WWI=
Subject: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask parameter
 for tps6586x_set_bits()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1282487895.23014.19.camel@phoenix>
References: <1282487895.23014.19.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 22:42:42 +0800
Message-ID: <1282488162.23014.24.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third parameter of tps6586x_set_bits() is the bit_mask,
thus we should use (1 << ri->go_bit) instead of ri->go_bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index facd439..51237fb 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -150,7 +150,7 @@ static int tps6586x_dvm_set_voltage(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	return tps6586x_set_bits(parent, ri->go_reg, ri->go_bit);
+	return tps6586x_set_bits(parent, ri->go_reg, 1 << ri->go_bit);
 }
 
 static int tps6586x_regulator_enable(struct regulator_dev *rdev)
-- 
1.7.0.4



