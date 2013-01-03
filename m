Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3ACGal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:30:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49597 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3ACGae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:30:34 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] lp8788-charger: fix a parent device in _probe()
Thread-Topic: [PATCH 1/2] lp8788-charger: fix a parent device in _probe()
Thread-Index: Ac3pe8s/JrF4WCUbRQyI6nhyFaLDrg==
Date: Thu, 3 Jan 2013 06:30:16 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10FE8@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The lp8788-charger is a platform driver of lp8788-mfd.
 The platform device is allocated when mfd_add_devices() is called
 in lp8788-mfd.
 On the other hand, 'lp->dev' is the i2c client device.

 Therefore, this 'platform_device' is a proper parent device in case of
 resource managed mem alloc and device kernel message.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 22b6407..126a83a 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -690,9 +690,10 @@ static int lp8788_charger_probe(struct platform_device *pdev)
 {
 	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
 	struct lp8788_charger *pchg;
+	struct device *dev = &pdev->dev;
 	int ret;
 
-	pchg = devm_kzalloc(lp->dev, sizeof(struct lp8788_charger), GFP_KERNEL);
+	pchg = devm_kzalloc(dev, sizeof(struct lp8788_charger), GFP_KERNEL);
 	if (!pchg)
 		return -ENOMEM;
 
@@ -718,7 +719,7 @@ static int lp8788_charger_probe(struct platform_device *pdev)
 
 	ret = lp8788_irq_register(pdev, pchg);
 	if (ret)
-		dev_warn(lp->dev, "failed to register charger irq: %d\n", ret);
+		dev_warn(dev, "failed to register charger irq: %d\n", ret);
 
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


