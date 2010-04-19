Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0DSB6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:58:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:1740 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0DSB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=FCqK8U56YMJLf3jAdJ2Hl1e1paKxHnB6DTOHbJxiYaHFD52OdJM98uxPJH2U808LaX
         JEN0CxWPWLvDn2QBrKKyxkFMWDLDs97z9+WogFWgpECPZwvpxVHecXErvYZ2Sue8/KnN
         lXN0MCyBvXG8oJXaisKkU9it0iw7TMhsbtVM4=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 19 Apr 2010 09:58:02 +0800
Message-ID: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
Subject: [PATCH] mc13783-regulator: fix a memory leak in mc13783_regulator_remove
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak by freeing priv in mc13783_regulator_remove

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/regulator/mc13783-regulator.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c
b/drivers/regulator/mc13783-regulator.c
index a681f5e..ad036dd 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -618,9 +618,12 @@ static int __devexit
mc13783_regulator_remove(struct platform_device *pdev)
                dev_get_platdata(&pdev->dev);
        int i;

+       platform_set_drvdata(pdev, NULL);
+
        for (i = 0; i < pdata->num_regulators; i++)
                regulator_unregister(priv->regulators[i]);

+       kfree(priv);
        return 0;
 }

-- 
1.5.4.3
