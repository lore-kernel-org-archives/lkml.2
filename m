Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2K2E53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:57:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36779 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2K2E51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:57:27 -0500
Date: Thu, 29 Nov 2012 15:57:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the gpio tree with the driver-core tree
Message-Id: <20121129155723.60035c6419fd9a00f46e4d69@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_57_23_+1100__LazIBMRox..XRr_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_57_23_+1100__LazIBMRox..XRr_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpio-em.c between commit 3836309d9346 ("gpio: remove use of
__devinit") from the driver-core tree and commit 7385500a49b7 ("gpio/em:
convert to linear IRQ domain") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-em.c
index 320a718,b007063..0000000
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@@ -234,41 -233,7 +233,7 @@@ static struct irq_domain_ops em_gio_irq
  	.map	=3D em_gio_irq_domain_map,
  };
 =20
- static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
- {
- 	struct platform_device *pdev =3D p->pdev;
- 	struct gpio_em_config *pdata =3D pdev->dev.platform_data;
-=20
- 	p->irq_base =3D irq_alloc_descs(pdata->irq_base, 0,
- 				      pdata->number_of_pins, numa_node_id());
- 	if (p->irq_base < 0) {
- 		dev_err(&pdev->dev, "cannot get irq_desc\n");
- 		return p->irq_base;
- 	}
- 	pr_debug("gio: hw base =3D %d, nr =3D %d, sw base =3D %d\n",
- 		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
-=20
- 	p->irq_domain =3D irq_domain_add_legacy(pdev->dev.of_node,
- 					      pdata->number_of_pins,
- 					      p->irq_base, 0,
- 					      &em_gio_irq_domain_ops, p);
- 	if (!p->irq_domain) {
- 		irq_free_descs(p->irq_base, pdata->number_of_pins);
- 		return -ENXIO;
- 	}
-=20
- 	return 0;
- }
-=20
- static void em_gio_irq_domain_cleanup(struct em_gio_priv *p)
- {
- 	struct gpio_em_config *pdata =3D p->pdev->dev.platform_data;
-=20
- 	irq_free_descs(p->irq_base, pdata->number_of_pins);
- 	/* FIXME: irq domain wants to be freed! */
- }
-=20
 -static int __devinit em_gio_probe(struct platform_device *pdev)
 +static int em_gio_probe(struct platform_device *pdev)
  {
  	struct gpio_em_config *pdata =3D pdev->dev.platform_data;
  	struct em_gio_priv *p;

--Signature=_Thu__29_Nov_2012_15_57_23_+1100__LazIBMRox..XRr_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuszAAoJEECxmPOUX5FEfsUQAJgiFXT0GwrnUiIFcSrv9tuP
oU4ZcZYlArhj2du7QxX6K3COODcayTl+d4XnoIcOmmKvvEIG+gmy7rFQbiFma5Bi
/XBxvkbZt538NmSUbp1F0laXayUkpXcr/Gsp8Erx2YrPhZFLw+PE1BohZyi1DNjs
6e3FvZYOStnCcJrCqHroMbu9V7f2XFExjAHdSLGv0GmSmZ2xSG2phrDZfVi4Zmga
UKajFujhKBZlSkVyhwklv1XIMMv6wjftvU2o8LfZ+xcW9AD/zAKQQ68rTMsjP0TW
t4fGzk9sgTFhAeY8LIwJqz1ITp0SqbfI7Zg469Ww9inO82nMWYfhQZuzIu6HXMt2
SBlLmObKUq9Ye+u98b3cDVNhcUCv2EfIz8uWwL6j0LJRu04OZEzQuDt9yWWJ+gsd
1CBZIDbdaqbGwZRxoqBAqyzR4tJxFtTvBv3hshzz857l2E5VagnECi9wTQYXpl+o
GLg+c3yeg4enh9QcAz0hUtXIQOUn+UQTUQdRDNsuvntWQ74qdUWY2mFoywAn/czG
clB3CO90aTLjQPtPxlBrNFutap4ZL2QZzbQRc0rS6cqAT1rER1viSagtYx3LduiJ
Pgy9DtLwUyRqrMl0QwLXX7AxOvS9DkICOoaoIDtTlm8lihzW51fLcRMO0r5EPfPY
oYVxpfM4qouaKPSIRd4L
=gAKq
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_57_23_+1100__LazIBMRox..XRr_--
