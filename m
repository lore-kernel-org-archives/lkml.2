Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1LAHIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:08:50 -0500
Received: from mail2.nsc.com ([12.238.8.132]:46639 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751201Ab1LAHIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:08:48 -0500
X-WSS-ID: 0LVIJUI-0A-0JM-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Wed, 30 Nov 2011 23:08:33 -0800
Subject: [PATCH] power_supply: add "unknown" in power supply type
Thread-Topic: [PATCH] power_supply: add "unknown" in power supply type
Thread-Index: Acyv8Yx0TslvyXSaQH6dbCoxANvAkgAAIsaA
Message-ID: <B567DBAB974C0544994013492B949F8E38125B223C@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 62C9F87E1LS8665352-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Anton

For the default value of power supply type, "unknown" is added.
With default prop value, supply type property can be displayed as default - "Unknown".

And union propval is set to zero.
Then no data abort exception even if the propval is not updated by xxx_get_property().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/power_supply_sysfs.c |    4 +++-
 include/linux/power_supply.h       |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 58cc490..6250686 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -42,7 +42,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf) {
 	static char *type_text[] = {
-		"Battery", "UPS", "Mains", "USB",
+		"Unknown", "Battery", "UPS", "Mains", "USB",
 		"USB_DCP", "USB_CDP", "USB_ACA"
 	};
 	static char *status_text[] = {
@@ -67,6 +67,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 	const ptrdiff_t off = attr - power_supply_attrs;
 	union power_supply_propval value;
 
+	memset(&value, 0, sizeof(value));
+
 	if (off == POWER_SUPPLY_PROP_TYPE)
 		value.intval = psy->type;
 	else
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 204c18d..9c83e04 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -123,7 +123,8 @@ enum power_supply_property {
 };
 
 enum power_supply_type {
-	POWER_SUPPLY_TYPE_BATTERY = 0,
+	POWER_SUPPLY_TYPE_UNKNOWN = 0,
+	POWER_SUPPLY_TYPE_BATTERY,
 	POWER_SUPPLY_TYPE_UPS,
 	POWER_SUPPLY_TYPE_MAINS,
 	POWER_SUPPLY_TYPE_USB,		/* Standard Downstream Port */
-- 
1.7.4.1


Best Regards

Milo (Woogyom) Kim
Texas Instruments Incorporated




