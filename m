Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2AFGwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:52:40 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43174 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2AFGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:52:39 -0500
Date: Fri, 6 Jan 2012 17:52:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: manual merge of the driver-core tree with the arm tree
Message-Id: <20120106175227.07a7240920f3ccd95c27b9a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_17_52_27_+1100_.3_ruuE16as+AUxb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_17_52_27_+1100_.3_ruuE16as+AUxb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-s5pc100/common.c between commit 109ac862f737 ("ARM:
mach-s5pc100: use standard arch_idle()") from the arm tree and commit
4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pc100/common.c
index 4659fb9,af52c09..0000000
--- a/arch/arm/mach-s5pc100/common.c
+++ b/arch/arm/mach-s5pc100/common.c
@@@ -194,27 -154,17 +195,27 @@@ static struct device s5pc100_dev =3D=20
 =20
  static int __init s5pc100_core_init(void)
  {
- 	return sysdev_class_register(&s5pc100_sysclass);
+ 	return subsys_system_register(&s5pc100_subsys, NULL);
  }
 -
  core_initcall(s5pc100_core_init);
 =20
  int __init s5pc100_init(void)
  {
  	printk(KERN_INFO "S5PC100: Initializing architecture\n");
- 	return sysdev_register(&s5pc100_sysdev);
++	return device_register(&s5pc100_sys);
 +}
 =20
 -	/* set idle function */
 -	pm_idle =3D s5pc100_idle;
 +/* uart registration process */
 =20
 -	return device_register(&s5pc100_sys);
 +void __init s5pc100_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 +{
 +	s3c24xx_init_uartdevs("s3c6400-uart", s5p_uart_resources, cfg, no);
 +}
 +
 +void s5pc100_restart(char mode, const char *cmd)
 +{
 +	if (mode !=3D 's')
 +		arch_wdt_reset();
 +
 +	soft_restart(0);
  }

--Signature=_Fri__6_Jan_2012_17_52_27_+1100_.3_ruuE16as+AUxb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBporAAoJEECxmPOUX5FEntAQAKnX5hF7ChpR7SuEoYI4biNp
Z6xcRXL4iUZ1u1gB2JGjAbAnoMs+RBPaLq9+Y2zHwXK8F6/42TPpFBLtTuInn5r8
QswSs3zStn/dSeA6eoUN6dwebBR/F+Thu2CnrVZPrTu0TyI/q8HyfZk0Y4hu/CvC
Wr0+0QV0Z1NGqj0ZU3xTA6U/JVb17/KXNdOqQnrSdP+UYDUlQnDsWuyQRYxtEDxg
c5nYVlb/VKbwCmcc1LbXwNAUUkkSxXpaFzXGL8x1cdTRgpNCyLu74zdvdwY93x6u
TNcUPRGVMD+uhYt37NkyaulNjOuawSX/QLGqP77lVBg3b6JKVouKd0GGi6oaIqNL
3WkjkX2rFiUYfzCvwQQwJRXm5YLw44ZsIFi20YNnK4qITaTW3OQfrPI6VXn2y/i3
80GBSnKYOUrcZF2O12QDSsPRhaxMRNfrXC1bsf/HH8SBCkWbDd2kOqb61ZMIoWEZ
pzDJgLvvqi/ExALvtNChUWSnkfx6HTVrRC6sbSS1oV/5ZyLuL51HkAHIalhiglqE
RatTkHqQEfXro0t4pNkbiMCwvTGS/x1mfkBGFGyGmbMfoSXlOxm5QhoJY2U9Emkw
GTPfro0M6sSBpzMOk3VfBZ1pYU2DuOYNfd0xV0j6GzFnzQl0r8EInyiKegTUUJ+Y
zU3k00m8Ldio8ZskFJsQ
=30JS
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_17_52_27_+1100_.3_ruuE16as+AUxb--
