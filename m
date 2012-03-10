Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2CJSy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:54:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55773 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CJSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:54:18 -0500
From: Alan Ott <alan@signal11.us>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH 1/1] ata: AT91 ata driver requires specific platforms
Date: Sat, 10 Mar 2012 13:54:12 -0500
Message-Id: <1331405652-4100-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331405617-4053-1-git-send-email-alan@signal11.us>
References: <1331405617-4053-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver uses registers defined in a per-soc header file.
Since not every soc in the at91 platform defines those, make
the Kconfig option dependent on specifically the socs that
do.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/ata/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 6bdedd7..16c6b78 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -731,6 +731,7 @@ config PATA_AT32
 config PATA_AT91
 	tristate "PATA support for AT91SAM9260"
 	depends on ARM && ARCH_AT91
+	depends on ARCH_AT91SAM9260 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9261 ||  ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9
 	help
 	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
 
-- 
1.7.0.4

