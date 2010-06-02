Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0FBC1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:27:24 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:36367 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab0FBC1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:27:23 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 22:27:23 EDT
From: "Luke-Jr" <luke@dashjr.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
Date: Tue, 1 Jun 2010 21:16:53 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006012117.00432.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the comment removed in this patch claims board_n800.c uses "cx3110x", it was never merged to mainline like 
this.
Mainlined board files for Nokia N8x0 devices are expected "p54spi", and thus don't work because the modalias is 
"cx3110x".
To my knowledge, these devices are the only real-world use of p54spi, and will not work without this change.
Tested against my Nokia N810.

Signed-off-by: Luke Dashjr <luke-jr+git@utopios.org>
---
 drivers/net/wireless/p54/p54spi.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index c8f09da..087bf06 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -697,9 +697,7 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 
 static struct spi_driver p54spi_driver = {
 	.driver = {
-		/* use cx3110x name because board-n800.c uses that for the
-		 * SPI port */
-		.name		= "cx3110x",
+		.name		= "p54spi",
 		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
@@ -733,3 +731,4 @@ module_exit(p54spi_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
 MODULE_ALIAS("spi:cx3110x");
+MODULE_ALIAS("spi:p54spi");
-- 
1.6.4.4

