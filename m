Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1GEHi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:38:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:19050 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1GEHi4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 5 Jul 2011 03:38:56 -0400
Message-Id: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Jul 2011 08:38:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <rtc-linux@googlegroups.com>, <dannf@hp.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: enable rtc-efi
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides a Kconfig change this just requires creating a respective
platform device.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: dann frazier <dannf@hp.com>

---
 arch/x86/platform/efi/efi.c |   16 ++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- 3.0-rc6/arch/x86/platform/efi/efi.c
+++ 3.0-rc6-x86-EFI-RTC/arch/x86/platform/efi/efi.c
@@ -31,6 +31,7 @@
 #include <linux/efi.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
+#include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/time.h>
@@ -679,6 +680,21 @@ void __init efi_enter_virtual_mode(void)
 	kfree(new_memmap);
 }
 
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+arch_initcall(rtc_init);
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
--- 3.0-rc6/drivers/rtc/Kconfig
+++ 3.0-rc6-x86-EFI-RTC/drivers/rtc/Kconfig
@@ -556,7 +556,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.



