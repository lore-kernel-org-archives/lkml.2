Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1L1Ff7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:35:59 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33077 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1L1Ffy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:35:54 -0500
Date: Wed, 28 Dec 2011 16:35:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: manual merge of the driver-core tree with the  arm tree
Message-Id: <20111228163545.7034aa9b783d46ac4b46c545@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_35_45_+1100_HKgmOhNuCOQVOUT5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_35_45_+1100_HKgmOhNuCOQVOUT5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-s5pv210/common.c between commit 37775320458e ("ARM: 7252/1:
restart: S5PV210: use new restart hook") from the arm tree and commit
4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
the driver-core tree (where it is called arch/arm/mach-s5pv210/cpu.c).

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pv210/common.c
index a4921bc,28e71ef..0000000
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@@ -239,8 -185,9 +240,8 @@@ static struct device s5pv210_dev =3D=20
 =20
  static int __init s5pv210_core_init(void)
  {
- 	return sysdev_class_register(&s5pv210_sysclass);
+ 	return subsys_system_register(&s5pv210_subsys, NULL);
  }
 -
  core_initcall(s5pv210_core_init);
 =20
  int __init s5pv210_init(void)
@@@ -250,31 -197,8 +251,31 @@@
  	/* set idle function */
  	pm_idle =3D s5pv210_idle;
 =20
- 	return sysdev_register(&s5pv210_sysdev);
 -	/* set sw_reset function */
 -	s5p_reset_hook =3D s5pv210_sw_reset;
 -
+ 	return device_register(&s5pv210_dev);
  }
 +
 +static struct s3c24xx_uart_clksrc s5pv210_serial_clocks[] =3D {
 +	[0] =3D {
 +		.name		=3D "pclk",
 +		.divisor	=3D 1,
 +		.min_baud	=3D 0,
 +		.max_baud	=3D 0,
 +	},
 +};
 +
 +/* uart registration process */
 +
 +void __init s5pv210_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 +{
 +	struct s3c2410_uartcfg *tcfg =3D cfg;
 +	u32 ucnt;
 +
 +	for (ucnt =3D 0; ucnt < no; ucnt++, tcfg++) {
 +		if (!tcfg->clocks) {
 +			tcfg->clocks =3D s5pv210_serial_clocks;
 +			tcfg->clocks_size =3D ARRAY_SIZE(s5pv210_serial_clocks);
 +		}
 +	}
 +
 +	s3c24xx_init_uartdevs("s5pv210-uart", s5p_uart_resources, cfg, no);
 +}

--Signature=_Wed__28_Dec_2011_16_35_45_+1100_HKgmOhNuCOQVOUT5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qqxAAoJEECxmPOUX5FEgLsQAJsLoYMge6ZriuEYlCrVq53N
Nh+6n8ZNY5B5pS4nC9WT/9BfbLESnhS00MgUwSrImO2E9q4FQYkpmXtRPlSfiNEn
bhC3XkZA6ssxjvtezSIPXxllVC4FxT+vsfXMJZnk4MlNKSyxHfEGhIxvQJUg06sA
hl9cjpNO/2m3BiTkXiEzeQUoZtjf1rbyouKy/seItsk8h6W3XbwFc0fOoXhue0vr
5ZGzubpuY1oogtplBohv00lBDInb+Cg2KW8pqz2pOmIj/7XaydiEkwzMXCKKsXKd
2lTGqvUvhCc+GPqJSCQTLvyh+gCOTksLHhpAY7Nb77h6U0QSux6jRyQZHjvOBYc4
gl8lbPoHeQdb19H7nqeQU6UXEQb3S19nQOQE+uQssvP5P7YgF0KpF7u6J7Ik1k6R
3UqXJ8AFfh1IMho18VR15+1eNcjKZ8augGRPNFxvuxhYAnFHbgoofHWof3dfDn7Q
mSYagX645hy8chArbPCnBUYenH8R+neJTGNGysw5XmeBc7Y74Lcg1mSTDrzjcdEC
jvYjgXQl+cEh4EkUxIFK4QrmFKxM9sTEhskOpy49KhK88wKT2G67Rm9Dyd3amsrj
atUHlsZlyyW8deLr3Y0XzWeU+2x77+LKGe7EFxbMjAUs7gOBUffE2Hj3SKVgCc7R
A2KK19SeVtjEBZrOmOZz
=i2YL
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_35_45_+1100_HKgmOhNuCOQVOUT5--
