Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0GSBBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 21:01:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43512 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab0GSBBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 21:01:03 -0400
Date: Mon, 19 Jul 2010 11:00:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the sound tree with the arm tree
Message-Id: <20100719110054.de489964.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/mach-ep93xx/clock.c between commit
5c6649e3c1511b183f12d2e884d2c172fe9001e0 ("ARM: AMBA: Add pclk definition
for platforms using primecells") from the arm tree and commit
ed67ea82c0d9a163458dc6a69a7a3123db1a8b3b ("EP93xx: Add i2s core support")
from the sound tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ep93xx/clock.c
index d40826a,8031624..0000000
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@@ -43,9 -43,9 +43,11 @@@ static unsigned long get_uart_rate(stru
  
  static int set_keytchclk_rate(struct clk *clk, unsigned long rate);
  static int set_div_rate(struct clk *clk, unsigned long rate);
+ static int set_i2s_sclk_rate(struct clk *clk, unsigned long rate);
+ static int set_i2s_lrclk_rate(struct clk *clk, unsigned long rate);
  
 +static struct clk dummy_apb_pclk;
 +
  static struct clk clk_xtali = {
  	.rate		= EP93XX_EXT_CLK_RATE,
  };
