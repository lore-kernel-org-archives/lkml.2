Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1F2Dnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 23:43:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41169 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1F2Dnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 23:43:40 -0400
Subject: [PATCH] platform-drivers-x86: set backlight type to
 BACKLIGHT_PLATFORM
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>,
        Yin Kangkai <kangkai.yin@intel.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 11:43:30 +0800
Message-ID: <1309319010.17370.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some newly added drivers do not set backlight type, as a result
/sys/class/backlight/<backlight>/type shows incorrect backlight type.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>
Cc: Yin Kangkai <kangkai.yin@intel.com>
---
 drivers/platform/x86/asus-wmi.c       |    1 +
 drivers/platform/x86/intel_oaktrail.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 00460cb..3c7857c7 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1025,6 +1025,7 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 		return power;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = max;
 	bd = backlight_device_register(asus->driver->name,
 				       &asus->platform_device->dev, asus,
diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
index e936364..7f88c79 100644
--- a/drivers/platform/x86/intel_oaktrail.c
+++ b/drivers/platform/x86/intel_oaktrail.c
@@ -250,6 +250,7 @@ static int oaktrail_backlight_init(void)
 	struct backlight_properties props;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = OT_EC_BL_BRIGHTNESS_MAX;
 	bd = backlight_device_register(DRIVER_NAME,
 				       &oaktrail_device->dev, NULL,
-- 
1.7.4.1



