Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2KDRfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:35:18 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40985 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2KDRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:35:15 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Sun,  4 Nov 2012 17:35:06 +0000
Message-Id: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

We've started getting reports of users seeing Machine Check Exceptions
when booting their Samsung laptops in UEFI mode,

     https://bugzilla.kernel.org/show_bug.cgi?id=47121

This module seems to be the culprit as it's grovelling around in the
0xf0000 region which has no mapping in either the e820 or EFI memory
maps on the affected machines.

Reported-by: Alessandro Crismani <alessandro.crismani@gmail.com>
Reported-by: Mikhail Bakhterev <mike.bakhterev@gmail.com>
Tested-by: Patrick H <kernel@feystorm.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c86bae8..0fe5200 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -717,7 +717,7 @@ config XO15_EBOOK
 
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
-	depends on X86
+	depends on X86 && !EFI
 	depends on RFKILL || RFKILL = n
 	depends on BACKLIGHT_CLASS_DEVICE
 	select LEDS_CLASS
-- 
1.7.11.7

