Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2EUHKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:10:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40833 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2EUHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:10:06 -0400
Date: Mon, 21 May 2012 17:09:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the arm-soc tree with the gpio tree
Message-Id: <20120521170952.7cd6e01690000b93db80b2b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_17_09_52_+1000_AXExm./6PE0R0h50"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_17_09_52_+1000_AXExm./6PE0R0h50
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/gpio/gpio-mxs.c between commit 3e11f7b840b4 ("gpio/generic:
initialize basic_mmio_gpio shadow variables properly") from the gpio tree
and commit 164387d2b4ae ("gpio/mxs: get rid of the use of cpu_is_xxx")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-mxs.c
index b413650,429228b..0000000
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@@ -242,11 -283,11 +283,11 @@@ static int __devinit mxs_gpio_probe(str
  	irq_set_handler_data(port->irq, port);
 =20
  	err =3D bgpio_init(&port->bgc, &pdev->dev, 4,
- 			 port->base + PINCTRL_DIN(port->id),
- 			 port->base + PINCTRL_DOUT(port->id), NULL,
- 			 port->base + PINCTRL_DOE(port->id), NULL, 0);
+ 			 port->base + PINCTRL_DIN(port),
+ 			 port->base + PINCTRL_DOUT(port), NULL,
 -			 port->base + PINCTRL_DOE(port), NULL, false);
++			 port->base + PINCTRL_DOE(port), NULL, 0);
  	if (err)
- 		goto out_iounmap;
+ 		return err;
 =20
  	port->bgc.gc.to_irq =3D mxs_gpio_to_irq;
  	port->bgc.gc.base =3D port->id * 32;

--Signature=_Mon__21_May_2012_17_09_52_+1000_AXExm./6PE0R0h50
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuepAAAoJEECxmPOUX5FEuZQQAKjPN6UjAtv4DiC9zV9lLQn4
wyXrDYkQ7Y1vkJhqH2Q180dFjVVcudFnP2tK6meD0mTnFwMcFnYGERi9ksLIkJHR
2Xh9zkqWraQ6njcyHMFjKQkVuNTrEQmQ2wnrl3DeSVkjQLhz38lf213QQfuubbQo
LGKDvnM4GOaWiEGGk85ZD+1Qd8cKFqZ6esNUdMWCjNF6sg/+jwdrtBObomNUW/nY
n83NpNgR7VNRA/KJu2yOKfEtTUPYRxkylH12cIDyyV3tK9DgctywA1TuEZsO0nAY
++Xuv0y1FiqTOA66Nw+v2uTw4Ac15UOKBLBmhFqxm5U7armHz5qnNcQ5QFtgQLT3
UsehFvZrImiWjz6QdmOAe+piaKkZ79ajn/HOtGFMjuwciyqb+dRcJsIFqFnrlFCl
GF0m/1iUf9b87HaFWiAP1BXkvAkxEols2Lfn3prrFeKF8jixwUl1YP+wflnNxpX5
N85WPORaCI1eciPZ6narG/YFQcr9qjDchCHxQEPvaIH+LVj//5ZpQeVS/d6PU3Uk
TbWlUE99E8HCAX4yknSfK/aouK4cIM1ZsquBuQIm/E0NaU6ivcUJRATf8SEpLLGc
cWwKDJxyaowZQB6gpM8ZMMEAlZoNmjNAXP/TSOCBT7XnBomt+0pgF+VPOUmvJwvJ
R37p0JGnGLc6e0ArCs5n
=2ZwO
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_17_09_52_+1000_AXExm./6PE0R0h50--
