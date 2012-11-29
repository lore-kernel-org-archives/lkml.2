Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2K2DrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:47:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60220 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2K2DrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:47:14 -0500
Date: Thu, 29 Nov 2012 14:47:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129144712.d6fcfdc94dbdd6f2d4bc7e79@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_47_12_+1100_ae.WRt.m2T/yKsSp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_47_12_+1100_ae.WRt.m2T/yKsSp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mfd/ab8500-core.c between commit 8ae754ebd5ed ("mfd: ab8500-core:
Remove unused ab8500-gpio IRQ ranges") from the mfd tree and commit
a9e9ce4c4167 ("mfd: remove use of __devinitdata") from the driver-core
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/ab8500-core.c
index 3385db6,127b00a..0000000
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@@ -591,7 -591,39 +591,7 @@@ int ab8500_suspend(struct ab8500 *ab850
  		return 0;
  }
 =20
- static struct resource __devinitdata ab8500_gpadc_resources[] =3D {
 -/* AB8500 GPIO Resources */
 -static struct resource __devinitdata ab8500_gpio_resources[] =3D {
 -	{
 -		.name	=3D "GPIO_INT6",
 -		.start	=3D AB8500_INT_GPIO6R,
 -		.end	=3D AB8500_INT_GPIO41F,
 -		.flags	=3D IORESOURCE_IRQ,
 -	}
 -};
 -
 -/* AB9540 GPIO Resources */
 -static struct resource __devinitdata ab9540_gpio_resources[] =3D {
 -	{
 -		.name	=3D "GPIO_INT6",
 -		.start	=3D AB8500_INT_GPIO6R,
 -		.end	=3D AB8500_INT_GPIO41F,
 -		.flags	=3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name	=3D "GPIO_INT14",
 -		.start	=3D AB9540_INT_GPIO50R,
 -		.end	=3D AB9540_INT_GPIO54R,
 -		.flags	=3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name	=3D "GPIO_INT15",
 -		.start	=3D AB9540_INT_GPIO50F,
 -		.end	=3D AB9540_INT_GPIO54F,
 -		.flags	=3D IORESOURCE_IRQ,
 -	}
 -};
 -
+ static struct resource ab8500_gpadc_resources[] =3D {
  	{
  		.name	=3D "HW_CONV_END",
  		.start	=3D AB8500_INT_GP_HW_ADC_CONV_END,
@@@ -1010,16 -1038,11 +1010,16 @@@ static struct mfd_cell abx500_common_de
  	},
  };
 =20
- static struct mfd_cell __devinitdata ab8500_bm_devs[] =3D {
+ static struct mfd_cell ab8500_bm_devs[] =3D {
  	{
  		.name =3D "ab8500-charger",
 +		.of_compatible =3D "stericsson,ab8500-charger",
  		.num_resources =3D ARRAY_SIZE(ab8500_charger_resources),
  		.resources =3D ab8500_charger_resources,
 +#ifndef CONFIG_OF
 +		.platform_data =3D &ab8500_bm_data,
 +		.pdata_size =3D sizeof(ab8500_bm_data),
 +#endif
  	},
  	{
  		.name =3D "ab8500-btemp",
@@@ -1070,9 -1080,11 +1070,9 @@@ static struct mfd_cell ab8500_devs[] =3D=20
  	},
  };
 =20
- static struct mfd_cell __devinitdata ab9540_devs[] =3D {
+ static struct mfd_cell ab9540_devs[] =3D {
  	{
  		.name =3D "ab8500-gpio",
 -		.num_resources =3D ARRAY_SIZE(ab9540_gpio_resources),
 -		.resources =3D ab9540_gpio_resources,
  	},
  	{
  		.name =3D "ab9540-usb",
@@@ -1445,9 -1460,20 +1445,9 @@@ static int ab8500_probe(struct platform
  		dev_err(ab8500->dev, "error creating sysfs entries\n");
 =20
  	return ret;
 -
 -out_freeirq:
 -	free_irq(ab8500->irq, ab8500);
 -out_freeoldmask:
 -	kfree(ab8500->oldmask);
 -out_freemask:
 -	kfree(ab8500->mask);
 -out_free_ab8500:
 -	kfree(ab8500);
 -
 -	return ret;
  }
 =20
- static int __devexit ab8500_remove(struct platform_device *pdev)
+ static int ab8500_remove(struct platform_device *pdev)
  {
  	struct ab8500 *ab8500 =3D platform_get_drvdata(pdev);
 =20

--Signature=_Thu__29_Nov_2012_14_47_12_+1100_ae.WRt.m2T/yKsSp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQttrAAAoJEECxmPOUX5FEJVIP/2Q8yDvVgGHCwLi7RBFqakJQ
fE8EMXkfmsolmiwzTKS1/aPKL8BKkQ3jw2dhRUF4aazZdrYvdGrVbWChlxNpdcZm
K9BM4ZRW0y0LVbgJm8yXOT//O/hKaXVlOjfSqebL2W8Rq77GztKRi8mBkArbZKkW
z1iSR/EV+bBYnTajMjVBPxaZoF9Oly+LZPeBiCv0WfEcc1OvVUXJbJ5H5+BLp+uj
sM2P32hg23kVAxYt9ry3hLNToAIlP1ddIsIVowgxmfmsZqV9VY/aoptDgmSboSni
2hjWPQ+snM9EQGU40rOcr543t0NnAgJAgE1Ld5ZL61YNGiOkQ6O9DZM1HjbptIlE
nrap+Y8CtTVVuOqYrRJasDgJoRL4/pd6a0+IvFuKidPP2gzVM+2GnBzhDg3RM53p
v2ekJmShOZtzzG5t69PI4GnG8CiaKQXB8z5eYL2sNpW1t/ZuPGeqjYvhZZ1TD8J0
3ik57uoaPnAzqgbOQGxIZp1GC3Mi+Ha79GWaQN/3qiO05LpqHO4gdXRkTlMoJJTo
vhZFjgMa0Z9t0qyosGS8cREHhYnvtWIj73DjZw+GCItACLp+6Vr2gY31CBTeazXZ
5pAG2AFyRIFCd18XYUHC0J6op5tK49F1JhdBnLd4YYQn6HVIAirO9EW/tJmb5a2O
X4yW4NAOieuD3uPF9edX
=9CuG
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_47_12_+1100_ae.WRt.m2T/yKsSp--
