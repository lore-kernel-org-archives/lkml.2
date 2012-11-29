Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2K2DnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:43:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40244 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2K2DnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:43:05 -0500
Date: Thu, 29 Nov 2012 14:43:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129144302.f19a1984d498e0cebae8d5d0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_43_02_+1100__v+AqdtTFiRENftW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_43_02_+1100__v+AqdtTFiRENftW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/gpio/gpio-tps6586x.c between commit fe39f2f4dc84 ("mfd: Implement
tps6586x gpio_to_irq") from the mfd tree and commit 3836309d9346 ("gpio:
remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-tps6586x.c
index 62e9e1c,c1b82da..0000000
--- a/drivers/gpio/gpio-tps6586x.c
+++ b/drivers/gpio/gpio-tps6586x.c
@@@ -80,15 -80,7 +80,15 @@@ static int tps6586x_gpio_output(struct=20
  				val, mask);
  }
 =20
 +static int tps6586x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 +{
 +	struct tps6586x_gpio *tps6586x_gpio =3D to_tps6586x_gpio(gc);
 +
 +	return tps6586x_irq_get_virq(tps6586x_gpio->parent,
 +				TPS6586X_INT_PLDO_0 + offset);
 +}
 +
- static int __devinit tps6586x_gpio_probe(struct platform_device *pdev)
+ static int tps6586x_gpio_probe(struct platform_device *pdev)
  {
  	struct tps6586x_platform_data *pdata;
  	struct tps6586x_gpio *tps6586x_gpio;

--Signature=_Thu__29_Nov_2012_14_43_02_+1100__v+AqdtTFiRENftW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQttnGAAoJEECxmPOUX5FEvoMP/3sbspu3QhHaOpK1FUkbQciU
dpYeTmmSpdjnyAQm5jKK7iGX/jG//GZScNfS6Ugc2rNJ932acm9AygOAxSM3r9CY
5AHBx58ppgMmljU6BVEWW91vyB4UZBOWUOujjI30zvEMQ/+644R13CV4xAyZuley
iEyk4Idx+Ebkdeo+V7PCLMq/aJkZUPBZidyTNsPgBHexpNHrSF06r1YfpGOCXz2D
+VbshP3V0Yb8m82d8tL5OFAVGGx9qaxbC4fcnVgwoPLVs6cs91MqLjGLnqT4eUPc
ErOIQUflRRcUagEtMn4B6IVL1onO/CRr5X5IhkYBNSbQcNIugGFDpeAy3vWEARto
vvK8JDXrybM2KTYerDKxYEdmG8rUesaB3U+LtJ20e+8qzAji2FH+ZTw/vjUY9Xvw
exVcNH0z1pq2xvDobikNxFAkPwmXmcOaz0KCZa+f2mTKzuf5M6lHKfkPtu/RHpJd
4QLUqL4UFkDGo5CSr0sa7ShFfBR5qr4XS0tNbZ87QRvrP2sEJrxJ8OYKQ64BXpWu
hfvo7Z7SGLPuU38LogyJBs2BTRDSn4JDU2t8wnjWdE7fBsVIonApU0FG+P/k7vIn
QICfBkbozqwU+jnJmaa4IFtm2Me6QXtEpnfhrMt0iQ7W0j9d9VqDF3X+FZUybzk+
fsFfL3HtIzkjM3l6egOa
=7Jfx
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_43_02_+1100__v+AqdtTFiRENftW--
