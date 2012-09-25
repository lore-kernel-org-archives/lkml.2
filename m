Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2IYF36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:29:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14385 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2IYF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:29:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Sep 2012 22:20:40 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <akpm@linux-foundation.org>, <swarren@wwwdotorg.org>,
        <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2] rtc: tps65910: Use platform_get_irq to get RTC irq details
Date: Tue, 25 Sep 2012 10:59:24 +0530
Message-ID: <1348550964-32534-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As RTC driver needs only irq number from platform data,
using platform_get_irq(), instead of generic dev_get_platdata().

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v1:

Removed unrelated clean up done in the RTC driver, with patch #1.

 drivers/rtc/rtc-tps65910.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 691ab96..2290508 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -226,7 +226,6 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = NULL;
 	struct tps65910_rtc *tps_rtc = NULL;
-	struct tps65910_board *pmic_plat_data;
 	int ret;
 	int irq;
 	u32 rtc_reg;
@@ -253,15 +252,13 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	pmic_plat_data = dev_get_platdata(tps65910->dev);
-	irq = pmic_plat_data->irq_base;
+	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
 			irq);
 		return ret;
 	}
 
-	irq += TPS65910_IRQ_RTC_ALARM;
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
 		"rtc-tps65910", &pdev->dev);
-- 
1.7.1.1

