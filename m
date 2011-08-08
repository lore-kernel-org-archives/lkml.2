Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1HHLUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:20:53 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:54442 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1HHLUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:20:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>, Hans Berglund <hb@spacetec.no>
Cc: Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
Date: Mon,  8 Aug 2011 13:20:46 +0200
Message-Id: <1312802446-19154-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k, I get:

drivers/i2c/busses/i2c-elektor.c: In function ‘pcf_isa_init’:
drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function ‘ioport_map’
drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
drivers/i2c/busses/i2c-elektor.c: In function ‘elektor_probe’:
drivers/i2c/busses/i2c-elektor.c:287: error: implicit declaration of function ‘ioport_unmap’

Since commit 82ed223c264def2b15ee4bec2e8c3048092ceb5f ("iomap: make IOPORT/PCI
mapping functions conditional"), ioport_map() is only available on platforms
that set HAS_IOPORT.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/i2c/busses/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 646068e..d1fc5cf 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -789,7 +789,7 @@ config I2C_ACORN
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
-	depends on ISA && BROKEN_ON_SMP
+	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
 	select I2C_ALGOPCF
 	help
 	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
-- 
1.7.0.4

