Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1EFWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:09:57 -0400
Received: from mail.atheros.com ([12.19.149.2]:15495 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1EFWJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:09:50 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 2/2] x86: add Atheros ar1520 platform support for mrst
Date: Fri, 6 May 2011 15:09:40 -0700
Message-ID: <1304719780-27347-3-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
In-Reply-To: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allen Kao <allen.kao@atheros.com>

This adds platform driver support for Atheros ar1520 GPS device
on the Intel Moorestown Low Power Intel Architecture (LPIA) based
Moblin Internet Device (MID) platform.

Cc: Roman Gezikov <roman.gezikov@atheros.com>
Cc: Joonas Viskari <joonas.viskari@atheros.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Allen Kao <allen.kao@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 arch/x86/platform/mrst/mrst.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 7000e74..e02d92f 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -19,6 +19,7 @@
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
+#include <linux/ar1520.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
@@ -475,6 +476,22 @@ static void __init *lis331dl_platform_data(void *info)
 	return &intr2nd_pdata;
 }
 
+static void __init *ar1520_gps_platform_data(void *info)
+{
+	static struct ar1520_platform_data ar1520_i2c_pdata;
+	int rts = get_gpio_by_name("gps_rts");
+	int wakeup = get_gpio_by_name("gps_wakeup");
+	int reset = get_gpio_by_name("gps_reset");
+
+	if (rts == -1 || wakeup == -1 || reset == -1)
+		return NULL;
+	ar1520_i2c_pdata.gps_gpio_rts = rts;
+	ar1520_i2c_pdata.gps_gpio_wakeup = wakeup;
+	ar1520_i2c_pdata.gps_gpio_reset = reset;
+
+	return &ar1520_i2c_pdata;
+}
+
 static void __init *no_platform_data(void *info)
 {
 	return NULL;
@@ -489,6 +506,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
 	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
 	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{"ath1520a", SFI_DEV_TYPE_I2C, 1, &ar1520_gps_platform_data},
 	{},
 };
 
-- 
1.7.4.15.g7811d

