Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1JKFvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:51:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40966 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1JKFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:51:04 -0400
Date: Tue, 11 Oct 2011 16:50:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm-soc
 tree
Message-Id: <20111011165056.7220219065d219bf4ee1f91c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_16_50_56_+1100_70QG16D28EnZMD52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_16_50_56_+1100_70QG16D28EnZMD52
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-h4.c between commit be7324605873 ("ARM: OMAP2+:
Remove custom init_irq for remaining boards") from the arm-soc tree and
commit cbf1455bfc9f ("OMAP: H4: Port the display driver to new DSS2")
from the omap_dss2 tree.

Just context changes If fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-h4.c
index a65effe,f7c09de..0000000
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@@ -285,10 -301,17 +300,6 @@@ static struct omap_usb_config h4_usb_co
  	.hmc_mode	=3D 0x00,		/* 0:dev|otg 1:disable 2:disable */
  };
 =20
- static struct omap_board_config_kernel h4_config[] __initdata =3D {
- 	{ OMAP_TAG_LCD,		&h4_lcd_config },
- };
-=20
 -static void __init omap_h4_init_early(void)
 -{
 -	omap2_init_common_infrastructure();
 -	omap2_init_common_devices(NULL, NULL);
 -}
 -
 -static void __init omap_h4_init_irq(void)
 -{
 -	omap2_init_irq();
 -}
 -
  static struct at24_platform_data m24c01 =3D {
  	.byte_len	=3D SZ_1K / 8,
  	.page_size	=3D 16,
@@@ -359,17 -379,24 +367,19 @@@ static void __init omap_h4_init(void
  	platform_add_devices(h4_devices, ARRAY_SIZE(h4_devices));
  	omap2_usbfs_init(&h4_usb_config);
  	omap_serial_init();
 +	omap_sdrc_init(NULL, NULL);
  	h4_init_flash();
+=20
+ 	omap_display_init(&h4_dss_data);
  }
 =20
 -static void __init omap_h4_map_io(void)
 -{
 -	omap2_set_globals_242x();
 -	omap242x_map_common_io();
 -}
 -
  MACHINE_START(OMAP_H4, "OMAP2420 H4 board")
  	/* Maintainer: Paul Mundt <paul.mundt@nokia.com> */
 -	.boot_params	=3D 0x80000100,
 +	.atag_offset	=3D 0x100,
  	.reserve	=3D omap_reserve,
 -	.map_io		=3D omap_h4_map_io,
 -	.init_early	=3D omap_h4_init_early,
 -	.init_irq	=3D omap_h4_init_irq,
 +	.map_io		=3D omap242x_map_io,
 +	.init_early	=3D omap2420_init_early,
 +	.init_irq	=3D omap2_init_irq,
  	.init_machine	=3D omap_h4_init,
  	.timer		=3D &omap2_timer,
  MACHINE_END

--Signature=_Tue__11_Oct_2011_16_50_56_+1100_70QG16D28EnZMD52
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk9lAAAoJEECxmPOUX5FE1CcP/jydPAjDrrtQMXXQmXAF+oOo
kd8aab8KdZfKcF/yNdoLQexcrP4jwFd+mOyUopOY5OMYs43iDJ5uWmh3wVvFSu/J
19PP0I/aNPNWUCrpy/Ykt8FDakxkmxF7LT/0Z0DBx6H+61eDthHSU54vIgOKnHhs
+30Qv+tqAPp5yt4aTAua3Vt8ZqfrJgR+rVhTdNmHEkRPUqtfKhT4cFE5Z8Sy+KPU
qS4hzxf1hq+BlTAO4aA4IZNOYQY1VDPe7Khsib186PODgT56tdqFmfGEKBUCVMrD
REUtGERHWZFKJqxYT+f5xNpyCl3jrKc/PGmrUKeHsJymF7MGRy9Bu8MQ2rGZbIiA
ZLCud3xCCaefXvediHCSyZrO+Vts+6JRb2Xy8oy0FiNHgb9AdiZO33R4bhCi+4Gi
QKHpPOB6HQvM4MUYBWBLJUBdKrFEjzkmoAluAG5t5Fv4kAgYsZ3zahcHWLR3G59A
zosZjyOzNVExXnVMSg6U2FwIlq8AhWfzqRuh701mKyRTVCe7QquiAWPyPvcgNquY
arQfYztgZ+R/OM7cEA4eJb3n/v30KmZC+pwqAtmhpOxqhpd9F3b7p1wFPqNCYfor
di9S2uP52X4mfZt1mOeRGQGdJMa4QINxtGA2PsqKkP6UvAbFcKqID+LtO1PNurOa
QKBR8e2vr2qRxtq18yl0
=ylqA
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_16_50_56_+1100_70QG16D28EnZMD52--
