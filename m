Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2JRGLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:11:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58554 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab2JRGLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:11:52 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] lp8788-charger: use consumer device name on setting IIO
 channels
Thread-Topic: [PATCH 1/3] lp8788-charger: use consumer device name on
 setting IIO channels
Thread-Index: Ac2s92rd0sUDvIZHQma0x4B1QLcflQ==
Date: Thu, 18 Oct 2012 06:11:33 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64178F97@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 To get the ADC value for the battery voltage and temperature,
 LP8788 ADC driver is used.
 LP8788 charger driver is the consumer of LP8788 ADC driver.
 Thus, specific ADC driver name is required on getting the channel
 using iio_channel_get().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index e852d12..614e6aa 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -592,7 +592,8 @@ static void lp8788_irq_unregister(struct platform_device *pdev,
 	}
 }
 
-static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
+static void lp8788_setup_adc_channel(const char *consumer_name,
+				struct lp8788_charger *pchg)
 {
 	struct lp8788_charger_platform_data *pdata = pchg->pdata;
 	struct device *dev = pchg->lp->dev;
@@ -616,7 +617,7 @@ static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
 	case LPADC_VBATT_5P5:
 	case LPADC_VBATT_6P0:
 	case LPADC_VBATT_5P0:
-		chan = iio_channel_get(NULL, chan_name[id]);
+		chan = iio_channel_get(consumer_name, chan_name[id]);
 		pchg->chan[LP8788_VBATT] = IS_ERR(chan) ? NULL : chan;
 		break;
 	default:
@@ -631,7 +632,7 @@ static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
 	case LPADC_ADC2:
 	case LPADC_ADC3:
 	case LPADC_ADC4:
-		chan = iio_channel_get(NULL, chan_name[id]);
+		chan = iio_channel_get(consumer_name, chan_name[id]);
 		pchg->chan[LP8788_BATT_TEMP] = IS_ERR(chan) ? NULL : chan;
 		break;
 	default:
@@ -747,7 +748,7 @@ static __devinit int lp8788_charger_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	lp8788_setup_adc_channel(pchg);
+	lp8788_setup_adc_channel(pdev->name, pchg);
 
 	ret = lp8788_psy_register(pdev, pchg);
 	if (ret)
-- 
1.7.9.5


Best Regards,
Milo


