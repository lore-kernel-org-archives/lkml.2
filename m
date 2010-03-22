Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0CVPBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:01:43 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49465 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838Ab0CVPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:01:42 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: users@rt2x00.serialmonkey.com
Subject: [PATCH RFC] rt2500usb: disable broken HW encryption by default
Date: Mon, 22 Mar 2010 16:01:35 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003221601.36559.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since HW encryption was added to rt2500usb in 2.6.29, the driver does not
work. It has been discussed before but never solved:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
https://bugzilla.redhat.com/show_bug.cgi?id=484888

The problem is caused by this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dddfb478b26e29a2b47f655ec219e743b8111015

Disable HW encryption by default to fix it.


--- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
+++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-22 15:40:39.000000000 +0100
@@ -36,11 +36,11 @@
 #include "rt2500usb.h"
 
 /*
- * Allow hardware encryption to be disabled.
+ * Allow hardware encryption to be enabled.
  */
-static int modparam_nohwcrypt = 0;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+static int modparam_hwcrypt = 0;
+module_param_named(hwcrypt, modparam_hwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(hwcrypt, "Enable hardware encryption.");
 
 /*
  * Register access.
@@ -1732,7 +1732,7 @@
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
-	if (!modparam_nohwcrypt) {
+	if (modparam_hwcrypt) {
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}

-- 
Ondrej Zary
