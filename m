Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2HaJYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:24:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab2HaJYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:24:16 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/22] lp8727_charger: clear interrrupts at inital time
Thread-Topic: [PATCH 07/22] lp8727_charger: clear interrrupts at inital time
Thread-Index: Ac2HWmAQc/KMNYhHRwqUI4lP8TzQpQ==
Date: Fri, 31 Aug 2012 09:24:09 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1EBA@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To initialize the device, previous interrupts need to be cleared
 while loading the driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 134ed5c..b5567bc 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -17,6 +17,7 @@
 #include <linux/power_supply.h>
 #include <linux/platform_data/lp8727.h>
 
+#define LP8788_NUM_INTREGS	2
 #define DEFAULT_DEBOUNCE_MSEC	270
 
 /* Registers */
@@ -136,6 +137,13 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 {
 	u8 val;
 	int ret;
+	u8 intstat[LP8788_NUM_INTREGS];
+
+	/* clear interrupts */
+	ret = lp8727_read_bytes(pchg, INT1, intstat, LP8788_NUM_INTREGS);
+	if (ret)
+		return ret;
+
 
 	val = ID200_EN | ADC_EN | CP_EN;
 	ret = lp8727_write_byte(pchg, CTRL1, val);
-- 
1.7.9.5


Best Regards,
Milo


