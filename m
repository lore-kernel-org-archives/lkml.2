Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1JNGCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:02:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58993 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1JNGCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:02:22 -0400
Date: Fri, 14 Oct 2011 17:02:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the moduleh tree with the gpio tree
Message-Id: <20111014170215.d26ef7d8cdc4320794c79cd6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_17_02_15_+1100_t8r6MJNxiiQgjl0S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_17_02_15_+1100_t8r6MJNxiiQgjl0S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/gpio/gpio-ml-ioh.c between commit 54be566317b6 ("gpio-ml-ioh:
Support interrupt function") from the gpio tree and commit d331aa9b3a0b
("drivers/gpio: Fix drivers who are implicit users of module.h") from the
moduleh tree.

Just context changes.  I fxied it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-ml-ioh.c
index 274fd4d,16c7b5b..0000000
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@@ -18,18 -18,8 +18,19 @@@
  #include <linux/slab.h>
  #include <linux/pci.h>
  #include <linux/gpio.h>
 +#include <linux/interrupt.h>
 +#include <linux/irq.h>
+ #include <linux/module.h>
 =20
 +#define IOH_EDGE_FALLING	0
 +#define IOH_EDGE_RISING		BIT(0)
 +#define IOH_LEVEL_L		BIT(1)
 +#define IOH_LEVEL_H		(BIT(0) | BIT(1))
 +#define IOH_EDGE_BOTH		BIT(2)
 +#define IOH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
 +
 +#define IOH_IRQ_BASE		0
 +
  #define PCI_VENDOR_ID_ROHM             0x10DB
 =20
  struct ioh_reg_comn {

--Signature=_Fri__14_Oct_2011_17_02_15_+1100_t8r6MJNxiiQgjl0S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl9BnAAoJEECxmPOUX5FELHUP/iu+VluKPt9T6uke5R9aOp1Y
UHfD/wa4b1i17tTprzQAGLqXDDwDdnO+StdidXncueyOrO9mnUYtom8igOZaykW0
QiITpva7niiUD8MCU7etl3pC0f+pMokzDf68NIB1BnD6NKpGDqldpKUPDN/043jJ
ouRo49KtQPtFc4IEvDpIZPc61NTYP8zkWjuOWqp95ioQtpS+OjBkjjozdvMUvbjZ
fOLx17sDbDcTmhlxh3BI2PBVhbIyfWF/MIWC3YG3aq3z8Ic6Nr5bADYPfFOc3hyU
/tWNKSxvdZPXGsNI/hodfKJlgbL++qexlRt+pnr6IE4MNavgtKWZR4tzLnl2O1VP
BUDMX80k8RjrNKgqfUMxQLpp8cUXIHQ2Tvz5yYJtAQUQNLlFiu3COwf4IOlUzYs7
UvlBIM9IOETm4d2WVWUsjQPOUpwwFVafvFBnp2ZDWROpzgXgPrYGGxNxM+GVoYAj
PmqYhx0Hj7XQ+0P2SKvdCebCF6KQvnElSTpEXEq1zmSEG80F4gmCfnMkI5sBWpbU
+z9sqLzV+s3Ev3d9P2zIrreVZjwZT6GPquSkLu8D6UrroaylgbxLXpenaOnTM0ar
pPWhEeSeiwRLmmyGmseAYXdQzEUclfLIiXJTuSg66r2AO87CoF2FXKMUw7Rgeo3g
xtquDUcd+YYj/4l1LuXo
=oykX
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_17_02_15_+1100_t8r6MJNxiiQgjl0S--
