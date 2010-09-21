Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0IUCJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:09:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46911 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0IUCJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:09:23 -0400
Date: Tue, 21 Sep 2010 12:09:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20100921120919.a38723d3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
arch/arm/mach-omap2/board-omap3pandora.c between commit
79ccf549b33c613b57eebcb03f8b24644c545a88 ("omap3: pandora: add NAND and
wifi support") from Linus' tree and commit
664279b5121b480f31ffecf202cd2d1591ff356e ("wl12xx: make wl12xx.h common
to both spi and sdio") from the wireless tree.

The wireless tree commit copied the include/linux/spi/wl12xx.h to
include/linux but did not remove the spi/ one.  Later patches modified
only the new one ... I fixed the above conflict (see below) on the
assumption that the spi/ version of the header file should have been
removed.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap3pandora.c
index dd3af2b,9b62b62..0000000
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@@ -25,9 -25,7 +25,9 @@@
  #include <linux/spi/ads7846.h>
  #include <linux/regulator/machine.h>
  #include <linux/i2c/twl.h>
- #include <linux/spi/wl12xx.h>
+ #include <linux/wl12xx.h>
 +#include <linux/mtd/partitions.h>
 +#include <linux/mtd/nand.h>
  #include <linux/leds.h>
  #include <linux/input.h>
  #include <linux/input/matrix_keypad.h>
