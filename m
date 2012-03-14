Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030972Ab2CNTw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:52:56 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:33777 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030724Ab2CNTwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:52:55 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 15:52:54 EDT
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] watchdog: it87_wdt: Add support for IT8728F watchdog.
Date: Wed, 14 Mar 2012 20:49:04 +0100
Message-Id: <1331754544-14902-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.7.8.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This works the same way IT8721F works, but it supports WDT_PWROK
(checked on the datasheet).

CC: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 drivers/watchdog/Kconfig    |    2 +-
 drivers/watchdog/it87_wdt.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 123b60c..40eb9f8 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -602,7 +602,7 @@ config IT87_WDT
 	depends on X86 && EXPERIMENTAL
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
-	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 Super I/O chips.
+	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726, IT8728 Super I/O chips.
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index a2d9a12..060a9ce 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -84,6 +84,7 @@
 #define IT8720_ID	0x8720
 #define IT8721_ID	0x8721
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
+#define IT8728_ID	0x8728
 
 /* GPIO Configuration Registers LDN=0x07 */
 #define WDTCTRL		0x71
@@ -95,7 +96,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not in it8718, it8720, it8721 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720, it8721, it8728 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -617,6 +618,7 @@ static int __init it87_wdt_init(void)
 	case IT8718_ID:
 	case IT8720_ID:
 	case IT8721_ID:
+	case IT8728_ID:
 		max_units = 65535;
 		try_gameport = 0;
 		break;
-- 
1.7.8.5

