Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2CJVj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:39:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49958 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2CJVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:39:25 -0500
From: Alan Ott <alan@signal11.us>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>, Arnd Bergmann <arnd@arndb.de>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH v2 2/2] ata: AT91 ata driver requires AT91_HAS_PATA
Date: Sat, 10 Mar 2012 16:39:22 -0500
Message-Id: <1331415562-10994-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331415380-10928-1-git-send-email-alan@signal11.us>
References: <1331415380-10928-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses registers defined in a per-soc header file.
Since not every soc in the at91 platform defines those, make
the Kconfig option dependent on those which define
AT91_HAS_PATA.

This is based on a patch by Arnd Bergmann.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
CC: Ben Dooks <ben-linux@fluff.org>
---
 drivers/ata/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 6bdedd7..fdb8c90 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -731,6 +731,7 @@ config PATA_AT32
 config PATA_AT91
 	tristate "PATA support for AT91SAM9260"
 	depends on ARM && ARCH_AT91
+	depends on AT91_HAS_PATA
 	help
 	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
 
-- 
1.7.0.4

