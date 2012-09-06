Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2IFDuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:50:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55585 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2IFDuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:50:21 -0400
Date: Thu, 6 Sep 2012 13:50:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: linux-next: build failure after merge of the spi-mb tree
Message-Id: <20120906135013.8dd0421cf4afd6947aa4297c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_13_50_13_+1000_3+suHdiaaik5n.qA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_13_50_13_+1000_3+suHdiaaik5n.qA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark, Daniel,

After merging the spi-mb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/spi/spi-gpio.c: In function 'spi_gpio_setup':
drivers/spi/spi-gpio.c:255:8: warning: cast from pointer to integer of diff=
erent size [-Wpointer-to-int-cast]
drivers/spi/spi-gpio.c: In function 'spi_probe_dt':
drivers/spi/spi-gpio.c:389:39: error: parameter name omitted
drivers/spi/spi-gpio.c: In function 'spi_gpio_probe':
drivers/spi/spi-gpio.c:404:2: error: implicit declaration of function 'spi_=
gpio_probe_dt' [-Werror=3Dimplicit-function-declaration]

Caused by commit 38ab18caa0ad ("spi: spi-gpio: Add DT bindings").  Please
build test these sort of patches with and without CONFIG_OF.

I have used the spi-mb tree from next-20120905 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Sep_2012_13_50_13_+1000_3+suHdiaaik5n.qA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSB11AAoJEECxmPOUX5FEbXIP/RdujLENEMJG+RfbrxNLzKWX
rbJcGdOHBIqy5wyRykazXnCmUv+nPqk0tLZSWfDfi/QD5esSWbDXEAZkD+JQAPk0
CjSe80cU5Wr0zN1ZYz9DYzmLOFAcLuw6Fm2wUAE9mXx7nhC6wYdrH+VQyf2dFR87
GSw2uchqLKsQANnkIL6uL73itOv9ps9jphYH07435jiT1qrdRwhIHz1TzARnSNX+
NNJiD+sklXr7x3TqBuRFiv+f2K8MbwSTL2N9cmENNDl24vtLhz38NqFQtXlF5rwp
AmSclMVLdDRKRh8+jilds/DLzcYSXB/5uE6vXpJpVEDntnq/KX1GuMQV3ruxBBU1
RTFR88tm3jvyckEcOSqF1Nk2Xfhr5znu7BbbGOGnhV4dByjqJUZaERD/1Qn3O17k
2D6aFID970mcHOfrIGer8RqGYnPbFUs1ZXNBx6Ki4hE4Wzwr3N/oCTYamC3kXMNd
RMlJ2jIVekIh4kcKCdYQs0MeV47CWeObybQ0k6sP/Nj9D9uiDNmKVgeV5QUE1Z1C
G39hlRB5l8mwNDqOGhu+wvbhmPKp5iNfWd/rXLgfoKaqGDWZk7m0zv8IQsCFcqDE
Ey7Bdd0573HR5D9/i02J/sOA5UdL1M2UswhvHV/lx5+dPm6ULYzmtu9S6CHchi9g
LGcYP+2xkqZHntIANRzU
=yxfg
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_13_50_13_+1000_3+suHdiaaik5n.qA--
