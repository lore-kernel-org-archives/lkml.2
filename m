Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1H2Qce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:32:34 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:34694 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859Ab1H2Qca convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:32:30 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Mon, 29 Aug 2011 09:32:04 -0700
Subject: [PATCH] power: max8925 - Enable power change notifications
Thread-Topic: [PATCH] power: max8925 - Enable power change notifications
Thread-Index: AcxmaTCP9f+JjRcaTb+RRCPjCSVHiA==
Message-ID: <03653C9B-09A4-40D0-B63F-ABDDDC0124D9@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The power core infrastructure allow external power change
events to be passed to drivers what are listed in the
supplied_to call back field.  Enable this feature by
allowing the supplied_to field to be passed to the driver.

This feature will enable drivers named in the supplied_to field that have a
external_power_changed callback to be notified when power
was been turned on or off.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/max8925_power.c |    5 +++++
 include/linux/mfd/max8925.h   |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index fd32c08..29b5d2c 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -455,6 +455,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->ac.properties = max8925_ac_props;
 	info->ac.num_properties = ARRAY_SIZE(max8925_ac_props);
 	info->ac.get_property = max8925_ac_get_prop;
+	info->ac.supplied_to = pdata->supplied_to;
+	info->ac.num_supplicants = pdata->num_supplicants;
 	ret = power_supply_register(&pdev->dev, &info->ac);
 	if (ret)
 		goto out;
@@ -465,6 +467,9 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->usb.properties = max8925_usb_props;
 	info->usb.num_properties = ARRAY_SIZE(max8925_usb_props);
 	info->usb.get_property = max8925_usb_get_prop;
+	info->usb.supplied_to = pdata->supplied_to;
+	info->usb.num_supplicants = pdata->num_supplicants;
+
 	ret = power_supply_register(&pdev->dev, &info->usb);
 	if (ret)
 		goto out_usb;
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index e742e04..008f807 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -225,6 +225,8 @@ struct max8925_power_pdata {
 	unsigned	fast_charge:3;	/* charge current */
 	unsigned	no_temp_support:1; /* set if no temperature detect */
 	unsigned	no_insert_detect:1; /* set if no ac insert detect */
+	char		**supplied_to;
+	int		num_supplicants;
 };
 
 /*
-- 
1.7.6


