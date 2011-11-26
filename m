Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1KZKBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:01:15 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:43507 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1KZKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:01:12 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/16] samsung-laptop: cleanup KConfig
Date: Sat, 26 Nov 2011 11:00:07 +0100
Message-Id: <1322301613-8801-11-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f43cf8..ec13bc5 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -744,13 +744,16 @@ config XO15_EBOOK
 
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
-	depends on RFKILL && BACKLIGHT_CLASS_DEVICE && X86
+	depends on X86
+	depends on RFKILL || RFKILL = n
+	depends BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This module implements a driver for a wide range of different
 	  Samsung laptops.  It offers control over the different
-	  function keys, wireless LED, LCD backlight level, and
-	  sometimes provides a "performance_control" sysfs file to allow
-	  the performance level of the laptop to be changed.
+	  function keys, wireless LED, LCD backlight level.
+
+	  It may also provide some sysfs files described in
+	  <file:Documentation/ABI/testing/sysfs-platform-samsung-laptop>
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called samsung-laptop.
-- 
1.7.5.4

