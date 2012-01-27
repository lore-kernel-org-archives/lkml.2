Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2A0Ium (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:50:42 -0500
Received: from mail2.nsc.com ([12.238.8.132]:35152 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029Ab2A0Iuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:50:39 -0500
X-WSS-ID: 0LYG8KA-0A-361-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>, "Kim, Milo" <Milo.Kim@nsc.com>
Date: Fri, 27 Jan 2012 00:50:23 -0800
Subject: [PATCH v3 2/3] backlight: new backlight driver for LP855x
 devices
Thread-Topic: [PATCH v3 2/3] backlight: new backlight driver for LP855x
 devices
Thread-Index: Aczc0LTLWEKBCg2tRH22NeNC7vFcjw==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB8C@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633CBAD81LS9967020-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header file is created.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/lp855x.h |  133 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/lp855x.h

diff --git a/include/linux/lp855x.h b/include/linux/lp855x.h
new file mode 100644
index 0000000..4b124c1
--- /dev/null
+++ b/include/linux/lp855x.h
@@ -0,0 +1,133 @@
+/*
+ * LP855x Backlight Driver
+ *
+ *			Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP855X_H
+#define _LP855X_H
+
+#define BL_CTL_SHFT	(0)
+#define BRT_MODE_SHFT	(1)
+#define BRT_MODE_MASK	(0x06)
+
+/* Enable backlight. Only valid when BRT_MODE=10(I2C only) */
+#define ENABLE_BL	(1)
+#define DISABLE_BL	(0)
+
+#define I2C_CONFIG(id)	id ## _I2C_CONFIG
+#define PWM_CONFIG(id)	id ## _PWM_CONFIG
+
+/* DEVICE CONTROL register - LP8550 */
+#define LP8550_PWM_CONFIG	(LP8550_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8550_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
+				(LP8550_I2C_ONLY << BRT_MODE_SHFT))
+
+/* DEVICE CONTROL register - LP8551 */
+#define LP8551_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8551_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8552 */
+#define LP8552_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8552_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8553 */
+#define LP8553_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8553_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8556 */
+#define LP8556_PWM_CONFIG	(LP8556_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8556_COMB1_CONFIG	(LP8556_COMBINED1 << BRT_MODE_SHFT)
+#define LP8556_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
+				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
+#define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
+
+/* ROM area boundary */
+#define EEPROM_START	(0xA0)
+#define EEPROM_END	(0xA7)
+#define EPROM_START	(0xA0)
+#define EPROM_END	(0xAF)
+
+enum lp855x_chip_id {
+	LP8550,
+	LP8551,
+	LP8552,
+	LP8553,
+	LP8556,
+};
+
+enum lp855x_brightness_ctrl_mode {
+	PWM_BASED = 1,
+	REGISTER_BASED,
+};
+
+enum lp8550_brighntess_source {
+	LP8550_PWM_ONLY,
+	LP8550_I2C_ONLY = 2,
+};
+
+enum lp8551_brighntess_source {
+	LP8551_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8551_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8552_brighntess_source {
+	LP8552_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8552_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8553_brighntess_source {
+	LP8553_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8553_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8556_brightness_source {
+	LP8556_PWM_ONLY,
+	LP8556_COMBINED1,	/* pwm + i2c before the shaper block */
+	LP8556_I2C_ONLY,
+	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
+};
+
+struct lp855x_pwm_data {
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+	int (*pwm_get_intensity) (int max_brightness);
+};
+
+struct lp855x_rom_data {
+	u8 addr;
+	u8 val;
+};
+
+/**
+ * struct lp855x_platform_data
+ * @name : Backlight driver name. If it is not defined, default name is set.
+ * @mode : brightness control by pwm or lp855x register
+ * @device_control : value of DEVICE CONTROL register
+ * @initial_brightness : initial value of backlight brightness
+ * @max_brightness : maximum value of backlight brightness
+ * @pwm_data : platform specific pwm generation functions.
+		Only valid when mode is PWM_BASED.
+ * @load_new_rom_data :
+	0 : use default configuration data
+	1 : update values of eeprom or eprom registers on loading driver
+ * @size_program : total size of lp855x_rom_data
+ * @rom_data : list of new eeprom/eprom registers
+ */
+struct lp855x_platform_data {
+	char *name;
+	enum lp855x_brightness_ctrl_mode mode;
+	u8 device_control;
+	int initial_brightness;
+	int max_brightness;
+	struct lp855x_pwm_data pwm_data;
+	u8 load_new_rom_data;
+	int size_program;
+	struct lp855x_rom_data *rom_data;
+};
+
+#endif
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




