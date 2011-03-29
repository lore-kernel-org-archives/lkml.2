Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1C2JzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:55:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1C2JzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MfzCxAyG2LYp3ok0KuW6GLdLsTXESOgI/zHYUjNpxp0u3VzzREeO10A0H2xYKDuo+w
         JiRgXOv1tWP/GMRM6gxUtCD+tJ8ht51aIGX5fnECo0MyPM20gRskwjlrM4DaVK4/t43z
         Kgqki+noSHRdMBmXQGTsTxnMnXz4yaIotjyGw=
Subject: [PATCH v2] regulator: Add missing platform_set_drvdata in
 tps6105x_regulator_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 17:54:58 +0800
Message-ID: <1301392498.2253.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, calling platform_get_drvdata in tps6105x_regulator_remove
returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
v2: update commit log

 drivers/regulator/tps6105x-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index 1661499..5f975c2 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -158,6 +158,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 			"failed to register regulator\n");
 		return ret;
 	}
+	platform_set_drvdata(pdev, tps6105x);
 
 	return 0;
 }
-- 
1.7.1



