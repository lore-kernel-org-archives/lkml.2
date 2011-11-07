Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1KGAET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:04:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52403 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab1KGAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:04:17 -0500
Date: Mon, 7 Nov 2011 11:04:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20111107110416.59490dfd73e3faeb2021da78@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_11_04_16_+1100_ezNaBrlVRXJ0lg4a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_11_04_16_+1100_ezNaBrlVRXJ0lg4a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
arch/mips/alchemy/common/dbdma.c between commit f2e442fd2ff4 ("MIPS:
Alchemy: clean DMA code of CONFIG_SOC_AU1??? defines") from Linus' tree
and commit 6e8722f887b2 ("MIPS: irq: Remove IRQF_DISABLED") from the mips
tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/alchemy/common/dbdma.c
index 0e63ee4,4025d77..0000000
--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@@ -1019,8 -1037,19 +1019,7 @@@ static int __init dbdma_setup(unsigned=20
  	dbdma_gptr->ddma_inten =3D 0xffff;
  	au_sync();
 =20
- 	ret =3D request_irq(irq, dbdma_interrupt, IRQF_DISABLED, "dbdma",
- 			  (void *)dbdma_gptr);
 -	switch (alchemy_get_cputype()) {
 -	case ALCHEMY_CPU_AU1550:
 -		irq_nr =3D AU1550_DDMA_INT;
 -		break;
 -	case ALCHEMY_CPU_AU1200:
 -		irq_nr =3D AU1200_DDMA_INT;
 -		break;
 -	default:
 -		return -ENODEV;
 -	}
 -
 -	ret =3D request_irq(irq_nr, dbdma_interrupt, 0,
 -			"Au1xxx dbdma", (void *)dbdma_gptr);
++	ret =3D request_irq(irq, dbdma_interrupt, 0, "dbdma", (void *)dbdma_gptr=
);
  	if (ret)
  		printk(KERN_ERR "Cannot grab DBDMA interrupt!\n");
  	else {

--Signature=_Mon__7_Nov_2011_11_04_16_+1100_ezNaBrlVRXJ0lg4a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOtyCAAAoJEECxmPOUX5FEr98P/iS2e+rsaNZZrXsJlWTdcCQ8
DBjrJpoSyWj0SQb898htEZ1r23+WDgpxLM8E0eMKn7tDmHxk0SR6D9zsYO5kP4V+
N5jZ6gKX9COSzFZKj9IqWsX5pQ0grmz2Y4Jd8yqn+/aOkGAU5au/k4cxmERBvrly
yGmElzX1nFqmE47rfax62gavNRkg6NAb+ZXiVIEy34jjL3mHVXYHzLZj/o4xv3yD
v6NNGdjEqnhhRCzDR8x3XG60FSk7bQeATPtNtP5x/P7Mt/zx+ml5jzTDA/jnz1vS
qFm+0C3GrL7DBRxo2I4PIeWrg7IiOgLkleCIEF1b41wvRIl86CoIap0qGWLg15Bs
KoPN3zTJAtTQxRcDXZhjGwm4G8wFFD1++195OAKlOTcTh1J+C9S2sfpQbH9zNgOR
XE0OBCfJK5P3bcOg3VYbZz15WpirQfLZz0NCRTFOPK8ZUgXM8dyt0kBoo9juStdy
wEK4WdqD1cY6gY9L+50vQZjG4fdHbsbLCHqT3xIfaOsXtR0/rbpu98pcFyNqc97d
RqA7Oblg5/c9oTy9crBPau/GG8VGP4x8HcwZfaLBaQvjD57DqXTAP5y5yQTDT2wp
yVSeNdtrmRdYyUslBkzsOw+L4uPBBLkazxc3r9cjT4sLW70z7KRE30hgacnNYmIo
JNbJCeK3GJFY8i/AvlnW
=BkpZ
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_11_04_16_+1100_ezNaBrlVRXJ0lg4a--
