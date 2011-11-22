Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab1KVWD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:03:56 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:33994 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab1KVWDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:03:53 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] samsung-laptop: cleanup KConfig
Date: Tue, 22 Nov 2011 23:02:41 +0100
Message-Id: <1321999366-23784-11-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f43cf8..2f7a9a7 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -744,13 +744,16 @@ config XO15_EBOOK
 
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
-	depends on RFKILL && BACKLIGHT_CLASS_DEVICE && X86
+	depends on X86
+	depends on RFKILL || RFKILL = n
+	depends on BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This module implements a driver for a wide range of different
 	  Samsung laptops.  It offers control over the different
-	  function keys, wireless LED, LCD backlight level, and
-	  sometimes provides a "performance_control" sysfs file to allow
-	  the performance level of the laptop to be changed.
+	  function keys, wireless LED, LCD backlight level.
+
+	  It may also provides some sysfs files described in
+	  <file:Documentation/ABI/testing/sysfs-platform-samsung-laptop>
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called samsung-laptop.
-- 
1.7.5.4

