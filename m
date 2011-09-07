Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1IGRB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:01:59 -0400
Received: from mail2.nsc.com ([12.238.8.132]:53795 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754738Ab1IGRB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:01:57 -0400
X-WSS-ID: 0LR5A60-0A-COB-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@nsc.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbou@mail.ru" <cbou@mail.ru>
Date: Wed, 7 Sep 2011 01:56:14 -0700
Subject: [PATCH 3/3] power: Add LP8727 charger driver
Thread-Topic: [PATCH 3/3] power: Add LP8727 charger driver
Thread-Index: AcxtOZHwsfRfFQT8RpKYDbb2wllC3QAAAS8gAAAQ+JAAAAc/AAAAfS/A
Message-ID: <B567DBAB974C0544994013492B949F8E380F619DE6@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6279EE3A1LS6373964-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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



