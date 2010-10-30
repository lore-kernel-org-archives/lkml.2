Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab0J3EE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 00:04:26 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:32772 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0J3EEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 00:04:23 -0400
Date: Fri, 29 Oct 2010 21:04:19 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: mtd: fix build error in m25p80.c
Message-ID: <20101029210419.70f99e96@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While building an x86 distro kernel, I hit the following:

Kernel: arch/x86/boot/bzImage is ready  (#7)
ERROR: "of_mtd_parse_partitions" [drivers/mtd/devices/m25p80.ko]
undefined!

of_mtd_parse_partitions is defined with MTD_OF_PARTS, and that's only
built on PPC and microblaze.  The code in question should be wrapped w/
a stricter #ifdef.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mtd/devices/m25p80.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index ea22520..184ddd5 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -924,7 +924,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
 			nr_parts = data->nr_parts;
 		}
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_MTD_OF_PARTS
 		if (nr_parts <= 0 && spi->dev.of_node) {
 			nr_parts = of_mtd_parse_partitions(&spi->dev,
 					spi->dev.of_node, &parts);
-- 
1.7.1

