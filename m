Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2GTKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:32:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2GTKcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:32:15 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@opensource.wolfsonmicro.com>, <broonie@sirena.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi/omap2: mark omap2_mcspi_master_setup as __devinit
Date: Fri, 20 Jul 2012 16:01:43 +0530
Message-ID: <1342780303-6596-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This warning recently appeared with omap2plus_defconfig:

WARNING: drivers/spi/built-in.o(.devinit.text+0x3c4): Section mismatch in reference from the function omap2_mcspi_probe() to the function .init.text:omap2_mcspi_master_setup()
The function __devinit omap2_mcspi_probe() references
a function __init omap2_mcspi_master_setup().
If omap2_mcspi_master_setup is only used by omap2_mcspi_probe then
annotate omap2_mcspi_master_setup with a matching annotation.

The fix is obviously to mark the omap2_mcspi_master_setup function as
__devinit, rather than __init.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 37ccdb7..7d46b15 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1034,7 +1034,7 @@ static int omap2_mcspi_transfer_one_message(struct spi_master *master,
 	return 0;
 }
 
-static int __init omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
+static int __devinit omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*master = mcspi->master;
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
-- 
1.7.5.4

