Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab1CBF6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:58:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52002 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab1CBF6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:58:07 -0500
Date: Wed, 2 Mar 2011 16:58:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the usb tree with the omap tree
Message-Id: <20110302165805.65d55351.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-omap2/clock3xxx_data.c between commit
0005ae73cfe44ee42d0be12a12cc82bf982f518e ("OMAP: hsmmc: Rename the device
and driver") from the omap tree and commit
53689ac1b677532be666a779e24b0ac9bd266354 ("arm: omap: usb: clock entries
for omap3 and omap4") from the usb tree.

Just context changes.  I have fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/clock3xxx_data.c
index f43e7ec,fbb1e30..0000000
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@@ -3322,8 -3322,8 +3322,8 @@@ static struct omap_clk omap3xxx_clks[] 
  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_34XX | CK_36XX),
  	CLK(NULL,	"core_l4_ick",	&core_l4_ick,	CK_3XXX),
  	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
- 	CLK("ehci-omap.0",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
+ 	CLK("usbhs-omap.0",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 -	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 +	CLK("omap_hsmmc.2",	"ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
  	CLK(NULL,	"icr_ick",	&icr_ick,	CK_34XX | CK_36XX),
  	CLK("omap-aes",	"ick",	&aes2_ick,	CK_34XX | CK_36XX),
  	CLK("omap-sham",	"ick",	&sha12_ick,	CK_34XX | CK_36XX),
