Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1IGRBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:01:00 -0400
Received: from mail2.nsc.com ([12.238.8.132]:52329 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753565Ab1IGRA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:00:57 -0400
X-WSS-ID: 0LR5A33-0A-CM0-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@nsc.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbou@mail.ru" <cbou@mail.ru>
Date: Wed, 7 Sep 2011 01:54:34 -0700
Subject: [PATCH 1/3] power: Add LP8727 charger driver
Thread-Topic: [PATCH 1/3] power: Add LP8727 charger driver
Thread-Index: AcxtOZHwsfRfFQT8RpKYDbb2wllC3QAAAS8gAACF8RA=
Message-ID: <B567DBAB974C0544994013492B949F8E380F619DDF@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6279EEC61LS6373910-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Woogyom Kim <milo.kim@nsc.com>

>From 83130c4498cff1b40b68babfba405cacbb27e291 Mon Sep 17 00:00:00 2001
From: Woogyom Kim <milo.kim@nsc.com>
Date: Wed, 7 Sep 2011 17:34:46 +0900
Subject: [PATCH] LP8727 is the battery charger with Micro/Mini USB interface.
 This IC includes below functions
  - I2c interface for accessing user registers
  - Single input Li-Ion battery charger
  - Charger input ID detection from Micro/Mini USB
  - multiplexing switches on USB, UART

---
 drivers/power/Kconfig          |    6 +
 drivers/power/Makefile         |    1 +
 drivers/power/lp8727_charger.c |  491 ++++++++++++++++++++++++++++++++++++++++
 include/linux/lp8727.h         |   54 +++++
 4 files changed, 552 insertions(+), 0 deletions(-)
 create mode 100755 drivers/power/lp8727_charger.c
 create mode 100755 include/linux/lp8727.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 57de051..51cb302 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -249,4 +249,10 @@ config CHARGER_MAX8998
 	  Say Y to enable support for the battery charger control sysfs and
 	  platform data of MAX8998/LP3974 PMICs.
 
+config CHARGER_LP8727
+	tristate "National Semiconductor LP8727 charger driver"
+	depends on I2C
+	help
+	  Say Y here to enable support for LP8727 Charger Driver.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b4af13d..aed6098 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
+obj-$(CONFIG_CHARGER_LP8727)	+= lp8727_charger.o


