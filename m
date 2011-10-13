Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1JMGGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:06:20 -0400
Received: from mail2.nsc.com ([12.238.8.132]:53330 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750960Ab1JMGGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:06:19 -0400
X-WSS-ID: 0LSZQAE-0A-2HI-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Wed, 12 Oct 2011 23:06:10 -0700
Subject: RE: [PATCH 3/3] power: Add LP8727 charger driver
Thread-Topic: [PATCH 3/3] power: Add LP8727 charger driver
Thread-Index: AcxtOZHwsfRfFQT8RpKYDbb2wllC3QAAAS8gAAAQ+JAAAAc/AAAAfS/ABwx9ZdA=
Message-ID: <B567DBAB974C0544994013492B949F8E380FB92912@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6288A05E1LS7421719-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Anton Vorontsov

I send the revised patch.

Signed-off-by: Woogyom Kim <milo.kim@ti.com>

>From 809577ee23f2d27df449b84310eb6ebf0ea98332 Mon Sep 17 00:00:00 2001
From: Milo(Woogyom) Kim <milo.kim@ti.com>
Date: Thu, 13 Oct 2011 14:56:08 +0900
Subject: [PATCH] power: lp8727 coding style changes

Pointer coding style changes
: add space between return type and function pointer
  ex) u8(*get_batt_present) (void)
   -> u8 (*get_batt_present) (void)
---
 include/linux/lp8727.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
index 3ec5589..ef30c7c 100755
--- a/include/linux/lp8727.h
+++ b/include/linux/lp8727.h
@@ -43,10 +43,10 @@ struct lp8727_chg_param {
 };
 
 struct lp8727_platform_data {
-	u8(*get_batt_present) (void);
-	u16(*get_batt_level) (void);
-	u8(*get_batt_capacity) (void);
-	u8(*get_batt_temp) (void);
+	u8 (*get_batt_present) (void);
+	u16 (*get_batt_level) (void);
+	u8 (*get_batt_capacity) (void);
+	u8 (*get_batt_temp) (void);
 	struct lp8727_chg_param ac;
 	struct lp8727_chg_param usb;
 };
-- 
1.7.4.1

Thanks & BR
Milo (Woogyom) Kim
milo.kim@ti.com

-----Original Message-----
From: Kim, Milo 
Sent: Wednesday, September 07, 2011 5:56 PM
To: 'cbouatmailru@gmail.com'
Cc: 'linux-kernel@vger.kernel.org'; 'dwmw2@infradead.org'; 'cbou@mail.ru'
Subject: [PATCH 3/3] power: Add LP8727 charger driver


diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
new file mode 100755
index 0000000..3ec5589
--- /dev/null
+++ b/include/linux/lp8727.h
@@ -0,0 +1,54 @@
+/*
+ * lp8727.h - Driver for LP8727 Micro/Mini USB IC with intergrated charger
+ *
+ *			Copyright (C) 2011 National Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP8727_H
+#define _LP8727_H
+
+enum lp8727_eoc_level {
+	EOC_5P,
+	EOC_10P,
+	EOC_16P,
+	EOC_20P,
+	EOC_25P,
+	EOC_33P,
+	EOC_50P,
+};
+
+enum lp8727_ichg {
+	ICHG_90mA,
+	ICHG_100mA,
+	ICHG_400mA,
+	ICHG_450mA,
+	ICHG_500mA,
+	ICHG_600mA,
+	ICHG_700mA,
+	ICHG_800mA,
+	ICHG_900mA,
+	ICHG_1000mA,
+};
+
+struct lp8727_chg_param {
+	/* end of charge level setting */
+	enum lp8727_eoc_level eoc_level;
+	/* charging current */
+	enum lp8727_ichg ichg;
+};
+
+struct lp8727_platform_data {
+	u8(*get_batt_present) (void);
+	u16(*get_batt_level) (void);
+	u8(*get_batt_capacity) (void);
+	u8(*get_batt_temp) (void);
+	struct lp8727_chg_param ac;
+	struct lp8727_chg_param usb;
+};
+
+#endif
-- 
1.7.1


Best Regards
------------------------------------------------------------------------------------------------------------
Milo (Woo Gyom) KIM
National Semiconductor
milo.kim@nsc.com
------------------------------------------------------------------------------------------------------------



