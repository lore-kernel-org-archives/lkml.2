Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1KJWKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:10:34 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:47499 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab1KJWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:10:33 -0500
Subject: [PATCH] ARM: mini2440: Fix Kconfig select of LEDS_TRIGGER
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 23:10:14 +0100
Message-ID: <1320963014.27598.77.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e18edf75d ("ARM: mini2440: Fix Kconfig to allow kernel to
build") added "select LEDS_TRIGGER" to the MACH_MINI2440 entry. That
Kconfig symbol doesn't exist. What actually should be selected is
LEDS_TRIGGERS.

(This shouldn't be a problem with the mini2440 defconfig, since it
contains "CONFIG_MAC80211_LEDS=y" and MAC80211_LEDS selects
LEDS_TRIGGERS. But it seems that nothing mini2440 related pulls in
MAC80211_LEDS.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "yes "" | make ARCH=arm config", using the
mini2440_defconfig with the CONFIG_MAC80211_LEDS=y line commented out.

 arch/arm/mach-s3c2440/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 914e620..e505701 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -178,7 +178,7 @@ config MACH_MINI2440
 	select EEPROM_AT24
 	select NEW_LEDS
 	select LEDS_CLASS
-	select LEDS_TRIGGER
+	select LEDS_TRIGGERS
 	select LEDS_TRIGGER_BACKLIGHT
 	select S3C_DEV_NAND
 	select S3C_DEV_USB_HOST
-- 
1.7.4.4



