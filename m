Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2HAVFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:05:41 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:36448 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab2HAVFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:05:39 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
Subject: [PATCH 1/2] leds-clevo-mail: add MODULE_DEVICE_TABLE
Date: Wed, 1 Aug 2012 23:04:46 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201208012304.46593.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autoloading of leds-clevo-mail by using MODULE_DEVICE_TABLE.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -31,7 +31,7 @@ static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
 }
 
 /*
- * struct mail_led_whitelist - List of known good models
+ * struct clevo_mail_led_dmi_table - List of known good models
  *
  * Contains the known good models this driver is compatible with.
  * When adding a new model try to be as strict as possible. This
@@ -39,7 +39,7 @@ static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
  * detected as working, but in reality it is not) as low as
  * possible.
  */
-static struct dmi_system_id __initdata mail_led_whitelist[] = {
+static struct dmi_system_id __initdata clevo_mail_led_dmi_table[] = {
 	{
 		.callback = clevo_mail_led_dmi_callback,
 		.ident = "Clevo D410J",
@@ -89,6 +89,7 @@ static struct dmi_system_id __initdata mail_led_whitelist[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(dmi, clevo_mail_led_dmi_table);
 
 static void clevo_mail_led_set(struct led_classdev *led_cdev,
 				enum led_brightness value)
@@ -180,7 +181,7 @@ static int __init clevo_mail_led_init(void)
 
 	/* Check with the help of DMI if we are running on supported hardware */
 	if (!nodetect) {
-		count = dmi_check_system(mail_led_whitelist);
+		count = dmi_check_system(clevo_mail_led_dmi_table);
 	} else {
 		count = 1;
 		printk(KERN_ERR KBUILD_MODNAME ": Skipping DMI detection. "




-- 
Ondrej Zary
