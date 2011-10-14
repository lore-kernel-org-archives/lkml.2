Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1JNGCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:02:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49683 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab1JNGCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:02:16 -0400
Date: Fri, 14 Oct 2011 17:02:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the moduleh tree with the gpio tree
Message-Id: <20111014170202.1260e712d288e87c05ccd29d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_17_02_02_+1100_oGA9g97ZPYP=nEnQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_17_02_02_+1100_oGA9g97ZPYP=nEnQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/gpio/gpio-pch.c between commit 38eb18a6f92d ("gpio-pch: Support
interrupt function") from the gpio tree and commit d331aa9b3a0b
("drivers/gpio: Fix drivers who are implicit users of module.h") from the
moduleh tree.

Just context changes.  I fxied it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-pch.c
index 46b5209,c9c4297..0000000
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@@ -17,17 -17,10 +17,18 @@@
  #include <linux/kernel.h>
  #include <linux/pci.h>
  #include <linux/gpio.h>
 +#include <linux/interrupt.h>
 +#include <linux/irq.h>
+ #include <linux/module.h>
 =20
 -#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
 -#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
 +#define PCH_EDGE_FALLING	0
 +#define PCH_EDGE_RISING		BIT(0)
 +#define PCH_LEVEL_L		BIT(1)
 +#define PCH_LEVEL_H		(BIT(0) | BIT(1))
 +#define PCH_EDGE_BOTH		BIT(2)
 +#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
 +
 +#define PCH_IRQ_BASE		24
 =20
  struct pch_regs {
  	u32	ien;

--Signature=_Fri__14_Oct_2011_17_02_02_+1100_oGA9g97ZPYP=nEnQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl9BaAAoJEECxmPOUX5FEn6QP/RqYgSEnwiuEvqFzf3uFJgYS
3XIPbcMEEhgqarQuBBMKqmQdvr2oUgx/MxInqYp5FnxqKyMQmuUx93KCJ1DHgWIm
ZK4Ij4bEbOGNU9pmY3ArWzcw19brdccr1G1rVaAc2uoK5pX4YqNB/zNx3ESP+fTm
PdHImgiRD9nvTcNPe+x+0iKCPgzgTErOD737EBSoIYg3UiIdvue+g0F2ntkIi3go
JVxNN26LhikcDbo6QfBFWtHmnCPEfn+6I8SNdkmxTFjaM3NObnzPkf7Zey1kn197
lcHwYyF/1SdrQOcOY75E2NYMKDEK4bjE07KCp1oHLKBb5uG6nDqXow/iK9VbmYHS
E1k7UYLxWCEd4FlaDsihF0QrD/eThCqGjrBWdPlKO1UmdKnQMpbSSWJ0eqr/YtlL
2ANaor6a/XJW2PoczXnxAkgN4ZpZz2PHRioc/LNGMXK3Z88iCae9SqQ5LQmUfXza
53An2jJ3/HAYU8DdZiRHTynLXr2D5uSz0SW+lne8+kEdPCsyItQ02zMgctIIRBh9
ysX7DroxpOhO32FDMoA8s57jCBFz2FcSY9XPOl6B4fvRYw4EfccBPfpQ4Hi008E3
P4IbwRYP0UNCiajPeoREfWa89XqbWuPuHIrPjZE+8mmGyZ5SzdvnlxtKlULqCyMf
XRKTURnhaqtcD2+Ymiod
=Pvuf
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_17_02_02_+1100_oGA9g97ZPYP=nEnQ--
