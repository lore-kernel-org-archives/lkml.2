Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2GSOxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:53:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2GSOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:53:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: spi/omap2: mark omap2_mcspi_master_setup as __devinit
Date: Thu, 19 Jul 2012 14:52:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Shubhrajyoti D <shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191452.56549.arnd@arndb.de>
X-Provags-ID: V02:K0:UPZGfjRZKYox7jjxRzo+8/hbr/JpCFweXnCC9nnelkY
 zCIJkWMzvYkwJS1ftEDZoWKVcGTILKDq/RFZvRwpi4uvyJW3WV
 kBXo3nymzU0mcwoKt8DIZiQEqf3Vmf0UE2+mYdn8csaa3m0+0B
 K96S7vyFuL227rxHcFcM2jxwrh1z6jcQ6MKYTldbWkhrlHiQ3T
 d3lJjB5e1evSr5E5U0+TLTqsJVsNDYe2BdWjuMCCc4r3PlFibT
 UULQUrB67GVHXav9CHrypY+81K7wwexBdQD1VRKKh894J0Debz
 nwDvHbmfGdhFQFn7lpfJ+hBMP4YObzKBmNSXEflQ4Y1a71VoiX
 v/1v9JGd4aQ6gFksn4rI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning recently appeared with omap2plus_defconfig:

WARNING: drivers/spi/built-in.o(.devinit.text+0x3c4): Section mismatch in reference from the function omap2_mcspi_probe() to the function .init.text:omap2_mcspi_master_setup()
The function __devinit omap2_mcspi_probe() references
a function __init omap2_mcspi_master_setup().
If omap2_mcspi_master_setup is only used by omap2_mcspi_probe then
annotate omap2_mcspi_master_setup with a matching annotation.

The fix is obviously to mark the omap2_mcspi_master_setup function as
__devinit, rather than __init.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 0c73dd4..dc02f2f 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1032,7 +1032,7 @@ static int omap2_mcspi_transfer_one_message(struct spi_master *master,
 	return 0;
 }
 
-static int __init omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
+static int __devinit omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*master = mcspi->master;
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
