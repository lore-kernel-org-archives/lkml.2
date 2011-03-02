Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1CBF6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:58:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51997 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1CBF6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:58:04 -0500
Date: Wed, 2 Mar 2011 16:58:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Senthilvadivu Guruswamy <svadivu@ti.com>,
        Sumit Semwal <sumit.semwal@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the usb tree with the omap and
 omap_dss2 trees
Message-Id: <20110302165802.8fb72a8b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-omap2/board-omap3evm.c between commit
d5e13227c32f12de3afb2e26a86bc9f3e5aaf7b6 ("OMAP2, 3: DSS2: board files:
replace platform_device_register with omap_display_init()") from the omap
and omap_dss2 trees and commit 181b250cf53233a7a7c6d7e1e9df402506712e93
("arm: omap: usb: create common enums and structures for ehci and ohci")
from the usb tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap3evm.c
index 730e297,38a2d91..0000000
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@@ -735,13 -631,18 +735,13 @@@ static void __init omap3_evm_init_early
  	omap_board_config_size = ARRAY_SIZE(omap3_evm_config);
  	omap2_init_common_infrastructure();
  	omap2_init_common_devices(mt46h32m32lf6_sdrc_params, NULL);
 -	omap_init_irq();
  }
  
- static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
 -static struct platform_device *omap3_evm_devices[] __initdata = {
 -	&omap3_evm_dss_device,
 -};
 -
+ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
  
- 	.port_mode[0] = EHCI_HCD_OMAP_MODE_UNKNOWN,
- 	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
- 	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+ 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
+ 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
+ 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
  
  	.phy_reset  = true,
  	/* PHY reset GPIO will be runtime programmed based on EVM version */
