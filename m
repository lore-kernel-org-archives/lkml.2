Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1CGFy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 00:54:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab1CGFyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 00:54:25 -0500
Date: Mon, 7 Mar 2011 16:54:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Sakoman <steve@sakoman.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with the omap_dss2 tree
Message-Id: <20110307165418.f17fdf4d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-omap2/board-overo.c between commit fd045fe21361 ("OMAP:
DSS2: Add DSS2 support for Overo") from the omap_dss2 tree and commits
181b250cf532 ("arm: omap: usb: create common enums and structures for
ehci and ohci") and 9e64bb1e9f06 ("arm: omap: usb: Invoke usbhs core
device initialization") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-overo.c
index d621ee8,08770cc..0000000
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@@ -580,12 -414,19 +580,12 @@@ static void __init overo_init_early(voi
  	omap2_init_common_infrastructure();
  	omap2_init_common_devices(mt46h32m32lf6_sdrc_params,
  				  mt46h32m32lf6_sdrc_params);
 -	omap_init_irq();
  }
  
- static const struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
- 	.port_mode[0] = EHCI_HCD_OMAP_MODE_UNKNOWN,
- 	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
- 	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
 -static struct platform_device *overo_devices[] __initdata = {
 -	&overo_lcd_device,
 -};
 -
+ static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+ 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
+ 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
+ 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
  
  	.phy_reset  = true,
  	.reset_gpio_port[0]  = -EINVAL,
@@@ -613,10 -454,9 +613,10 @@@ static void __init overo_init(void
  	omap_serial_init();
  	overo_flash_init();
  	usb_musb_init(&musb_board_data);
- 	usb_ehci_init(&ehci_pdata);
+ 	usbhs_init(&usbhs_bdata);
 -	overo_ads7846_init();
 +	overo_spi_init();
  	overo_init_smsc911x();
 +	overo_display_init();
  
  	/* Ensure SDRC pins are mux'd for self-refresh */
  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
