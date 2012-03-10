Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2CJSpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:45:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58588 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2CJSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:44:43 -0500
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH 1/2] ARM: at91: only RM9200 has ISA-style PIO
Date: Sat, 10 Mar 2012 13:44:35 -0500
Message-Id: <1331405075-3231-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331405049-3186-1-git-send-email-alan@signal11.us>
References: <1331405049-3186-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Most at91 systems have no support for PCMCIA or other
PC-style buses, so we can select NO_IOPORT in order to
disable compilationf or all drivers that need these.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dfb0312..1306f0d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -322,6 +322,7 @@ config ARCH_AT91
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select CLKDEV_LOOKUP
+	select NO_IOPORT if !ARCH_AT91RM9200
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
-- 
1.7.0.4

