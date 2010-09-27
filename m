Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0I0E3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 00:29:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56131 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0I0E3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 00:29:18 -0400
Date: Mon, 27 Sep 2010 14:29:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sukumar Ghorai <s-ghorai@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the omap tree
Message-Id: <20100927142915.081bbf24.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
arch/arm/mach-omap2/board-zoom-peripherals.c between commit
6db649c505ddc6665176807c16745b9e01cf5031 ("omap: mmc: extended to pass
host capabilities from board file") from the omap tree and commits
b642fde7f137566c993991fd2e7bf6b8274bf625 ("omap: zoom: add fixed
regulator device for wlan") and 80b517f362605f2b6a6cfe086604534290aab2de
("omap: zoom: add mmc3/wl1271 device support") from the net tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-zoom-peripherals.c
index e5eac46,6aa0728..0000000
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@@ -16,7 -16,8 +16,9 @@@
  #include <linux/gpio.h>
  #include <linux/i2c/twl.h>
  #include <linux/regulator/machine.h>
 +#include <linux/mmc/host.h>
+ #include <linux/regulator/fixed.h>
+ #include <linux/wl12xx.h>
  
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
