Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1ACP5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:57:47 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33431 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1ACP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fYkx9+7bfUfkI0rL3GeSFMI18l3DFRaaVlbrAZsPYfob31nfi5AbtPYU2mwzqVOPHZ
         rOJmH/M41cbcsbgMksNtfCESot8D51ItiFIRzV8BYw+TBNHbfvKeK8TRrDrXSH7oARol
         I8QqHmDfUDCXGgqdqkLyfWzUqNL23N+Gf/00Q=
Subject: [PATCH] regulator: Assign return value of mc13xxx_reg_rmw to ret
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 23:57:38 +0800
Message-ID: <1294070258.3320.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, we will not return error if write to MC13892_SWITCHERS5 failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 16a0532..1b8f739 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -550,7 +550,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_free;
 
-		mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
+		ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
 			MC13892_SWITCHERS5_SW3MODE_M |
 			MC13892_SWITCHERS5_SW4MODE_M,
 			MC13892_SWITCHERS5_SW3MODE_AUTO |
-- 
1.7.0.4



