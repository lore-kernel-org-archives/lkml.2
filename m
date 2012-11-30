Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2K3FTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:19:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37437 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2K3FTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:19:06 -0500
Date: Fri, 30 Nov 2012 16:18:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Matt Porter <mporter@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20121130161856.985bdeb55e3a9be322e772ec@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Nov_2012_16_18_56_+1100_wdwJQK8fGccNMkea"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Nov_2012_16_18_56_+1100_wdwJQK8fGccNMkea
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-davinci/devices-da8xx.c between commit 3b43ad201dea
("da8xx-fb: cleanup LCDC configurations") from the omap_dss2 tree and
commit 8e0d72d2c7a6 ("ARM: davinci: da8xx: add DA850 PRUSS support") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/devices-da8xx.c
index fcb30d3,46c9a0c..0000000
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@@ -518,9 -520,98 +520,78 @@@ void __init da8xx_register_mcasp(int id
  	}
  }
 =20
+ static struct resource da8xx_pruss_resources[] =3D {
+ 	{
+ 		.start	=3D DA8XX_PRUSS_MEM_BASE,
+ 		.end	=3D DA8XX_PRUSS_MEM_BASE + 0xFFFF,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT0,
+ 		.end	=3D IRQ_DA8XX_EVTOUT0,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT1,
+ 		.end	=3D IRQ_DA8XX_EVTOUT1,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT2,
+ 		.end	=3D IRQ_DA8XX_EVTOUT2,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT3,
+ 		.end	=3D IRQ_DA8XX_EVTOUT3,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT4,
+ 		.end	=3D IRQ_DA8XX_EVTOUT4,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT5,
+ 		.end	=3D IRQ_DA8XX_EVTOUT5,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT6,
+ 		.end	=3D IRQ_DA8XX_EVTOUT6,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start	=3D IRQ_DA8XX_EVTOUT7,
+ 		.end	=3D IRQ_DA8XX_EVTOUT7,
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ };
+=20
+ static struct uio_pruss_pdata da8xx_uio_pruss_pdata =3D {
+ 	.pintc_base	=3D 0x4000,
+ };
+=20
+ static struct platform_device da8xx_uio_pruss_dev =3D {
+ 	.name		=3D "pruss_uio",
+ 	.id		=3D -1,
+ 	.num_resources	=3D ARRAY_SIZE(da8xx_pruss_resources),
+ 	.resource	=3D da8xx_pruss_resources,
+ 	.dev		=3D {
+ 		.coherent_dma_mask	=3D DMA_BIT_MASK(32),
+ 		.platform_data		=3D &da8xx_uio_pruss_pdata,
+ 	}
+ };
+=20
+ int __init da8xx_register_uio_pruss(void)
+ {
+ 	da8xx_uio_pruss_pdata.sram_pool =3D sram_get_gen_pool();
+ 	return platform_device_register(&da8xx_uio_pruss_dev);
+ }
+=20
 -static const struct display_panel disp_panel =3D {
 -	QVGA,
 -	16,
 -	16,
 -	COLOR_ACTIVE,
 -};
 -
  static struct lcd_ctrl_config lcd_cfg =3D {
 -	&disp_panel,
 -	.ac_bias		=3D 255,
 -	.ac_bias_intrpt		=3D 0,
 -	.dma_burst_sz		=3D 16,
 +	.panel_shade		=3D COLOR_ACTIVE,
  	.bpp			=3D 16,
 -	.fdd			=3D 255,
 -	.tft_alt_mode		=3D 0,
 -	.stn_565_mode		=3D 0,
 -	.mono_8bit_mode		=3D 0,
 -	.invert_line_clock	=3D 1,
 -	.invert_frm_clock	=3D 1,
 -	.sync_edge		=3D 0,
 -	.sync_ctrl		=3D 1,
 -	.raster_order		=3D 0,
 -	.fifo_th		=3D 6,
  };
 =20
  struct da8xx_lcdc_platform_data sharp_lcd035q3dg01_pdata =3D {

--Signature=_Fri__30_Nov_2012_16_18_56_+1100_wdwJQK8fGccNMkea
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQuEHAAAoJEECxmPOUX5FEsgcP/2dE/zJgg9tQV1puXGIyQjCm
VAzE7IO5CxuwYgeDjteuNWHRCBnCy98bxtERN/5o4jhCwyVc8WE0lrfLJYEhfb2A
d5nq08f2vDg4wfmcExMZiKzWJD8e/tMaRo6nyifoAm3c9yS+uu2pM29wf5l64F2P
DxaGIC63dsKh5hFjos5dCTr7lFaTENNfBgxGYMeDWx4lUBIOf5U0FeLmuIMi7oDW
B8y1V+gt+Q9oBt2lAcDPV8OVr1QEYaBNz8EgNPQB6t7VvCLXZX1eXfj6/RXOgTo3
1JM6Jww6AHYFKbyweMJSK4JDHVfZs3VdAdNWdnq5M04cxURaAbAU9gZHdjZzN4xl
5AZY9P+ui//1XJf6//b3Y6v8wlxNYpZi9cM6E9kYwKFb+UbghF9TzqKzt5PzwH5v
w0/Z4ZrjAz/9jsr+UEF2qoHjRDvrXQgwt9IPgI0aSIqBv8OELAyF3Uuprea3IqVs
+3Dj8m+9rS2zMoNPbzUE60ZZ00ew9X6Ov6bGyLP20ysp3BtVBSWXL6z/O4MYHFGI
exHI9jIZ1caA/kmLRoyeQ2/q3q3JzGfpLL88vG414NywOau0qfW1h3+JARco1MgQ
Ah8h0y3DPgfm2w3kINzXD8eGleCSg4t/dzmoJ/fTITLCsWex75Tse70tCmeO2mgU
h8JXA8v2l/gnFXsQ279B
=jP3+
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Nov_2012_16_18_56_+1100_wdwJQK8fGccNMkea--
