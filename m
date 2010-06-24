Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0FXLOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:14:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52575 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0FXLON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:14:13 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 3/6] mfd/stmpexxx: add touchscreen platform data
Date: Thu, 24 Jun 2010 13:13:38 +0200
Message-Id: <1277378021-16802-4-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100622135635.GA30720@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 include/linux/mfd/stmpe.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index cf2155f..3d319a1 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -124,6 +124,47 @@ struct stmpe_gpio_platform_data {
 };
 
 /**
+ * struct stmpe_ts_platform_data - stmpe811 touch screen controller platform
+ * data
+ * @sample_time: ADC converstion time in number of clock.
+ * (0 -> 36 clocks, 1 -> 44 clocks, 2 -> 56 clocks, 3 -> 64 clocks,
+ * 4 -> 80 clocks, 5 -> 96 clocks, 6 -> 144 clocks),
+ * recommended is 4.
+ * @mod_12b: ADC Bit mode (0 -> 10bit ADC, 1 -> 12bit ADC)
+ * @ref_sel: ADC reference source
+ * (0 -> internal reference, 1 -> external reference)
+ * @adc_freq: ADC Clock speed
+ * (0 -> 1.625 MHz, 1 -> 3.25 MHz, 2 || 3 -> 6.5 MHz)
+ * @ave_ctrl: Sample average control
+ * (0 -> 1 sample, 1 -> 2 samples, 2 -> 4 samples, 3 -> 8 samples)
+ * @touch_det_delay: Touch detect interrupt delay
+ * (0 -> 10 us, 1 -> 50 us, 2 -> 100 us, 3 -> 500 us,
+ * 4-> 1 ms, 5 -> 5 ms, 6 -> 10 ms, 7 -> 50 ms)
+ * recommended is 3
+ * @settling: Panel driver settling time
+ * (0 -> 10 us, 1 -> 100 us, 2 -> 500 us, 3 -> 1 ms,
+ * 4 -> 5 ms, 5 -> 10 ms, 6 for 50 ms, 7 -> 100 ms)
+ * recommended is 2
+ * @fraction_z: Length of the fractional part in z
+ * (fraction_z ([0..7]) = Count of the fractional part)
+ * recommended is 7
+ * @i_drive: current limit value of the touchscreen drivers
+ * (0 -> 20 mA typical 35 mA max, 1 -> 50 mA typical 80 mA max)
+ *
+ * */
+struct stmpe_ts_platform_data {
+       u8 sample_time;
+       u8 mod_12b;
+       u8 ref_sel;
+       u8 adc_freq;
+       u8 ave_ctrl;
+       u8 touch_det_delay;
+       u8 settling;
+       u8 fraction_z;
+       u8 i_drive;
+};
+
+/**
  * struct stmpe_platform_data - STMPE platform data
  * @id: device id to distinguish between multiple STMPEs on the same board
  * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
@@ -133,6 +174,7 @@ struct stmpe_gpio_platform_data {
  *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
  * @gpio: GPIO-specific platform data
  * @keypad: keypad-specific platform data
+ * @ts: touchscreen-specific platform data
  */
 struct stmpe_platform_data {
 	int id;
@@ -143,6 +185,7 @@ struct stmpe_platform_data {
 
 	struct stmpe_gpio_platform_data *gpio;
 	struct stmpe_keypad_platform_data *keypad;
+	struct stmpe_ts_platform_data *ts;
 };
 
 #define STMPE_NR_INTERNAL_IRQS	9
-- 
1.7.1

