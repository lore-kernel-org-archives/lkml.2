Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2HFCDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:03:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59451 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab2HFCDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:03:15 -0400
Date: Mon, 6 Aug 2012 12:03:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: linux-next: build failure after merge of the spi-mb tree
Message-Id: <20120806120301.cafca6614722b92d92600904@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Aug_2012_12_03_01_+1000_7Pb7Iy5ykOatWtmf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Aug_2012_12_03_01_+1000_7Pb7Iy5ykOatWtmf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi-mb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/spi/spi-gpio.c: In function 'spi_gpio_setup':
drivers/spi/spi-gpio.c:255:8: warning: cast from pointer to integer of diff=
erent size [-Wpointer-to-int-cast]

Caused by casting a pointer to "unsigned int" in commit a38e7a71f120
("spi: spi-gpio: Add DT bindings").


drivers/spi/spi-gpio.c: In function 'spi_probe_dt':
drivers/spi/spi-gpio.c:389:39: error: parameter name omitted
drivers/spi/spi-gpio.c: In function 'spi_gpio_probe':
drivers/spi/spi-gpio.c:404:2: error: implicit declaration of function 'spi_=
gpio_probe_dt' [-Werror=3Dimplicit-function-declaration]

Caused by commit a38e7a71f120 ("spi: spi-gpio: Add DT bindings").  This
build does not have CONFIG_OF set.

I have used the spi-mb tree from next-20120803 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Aug_2012_12_03_01_+1000_7Pb7Iy5ykOatWtmf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQHyXVAAoJEECxmPOUX5FEkwMP/1JhC2KwwlsOHkE8nM08B2aA
q+AcKR3F7xpimhsf0s9ICOwaIBuy8Mkgyvt2uUHTT0K4lsqhjS3TAB+adMOcwWSt
HEVYIJ9j3gJAGgJ0ZzrnKqIynKjKaGSn3a4JsBnpwOJq9Lob1jt3tUnzARwvSWl/
YFI2g3hxn8akyG7uRvjyy+ySBR6YngsniHytUc07V3CgjrbggQan6GRu+O6+z0Kb
3j5z9B/MHdN3w/g9FcqNbUCBQ7gFNaDELCDMCc7GCwfxZItMm48BTvZaOEKVv8TK
RZmUUhaC7AV+pxdN8A/nQ+1agqGKF1X6/KK7OU7zvCMsQVQZ8mVznYUIZcGb8EBG
OnEEei5768uNXyv+N1KQZ4QLMhobYO4Udbmsb3W3hqWSOzZGLE/wsSlqOHLfxtgc
M7jfDSsdRaUDY3iQSZOcz/NVBRGFDI63TlaZNDm6R4XvhLxihoSQXKciS0ubj0df
+jgqze/V1I6lxEBkIqKy9BZBV+SYjXWs3EFDzbkIL5hNl3ileSV+a0/4rMsxal4s
lJOQ4U7mL5zX3W/nB0jbCm2TSx5ngUwh6P8YcSxSNSZSfWKih9nE0xrJZYtDcP9E
hNRvD4kVnXfK0AgY5tESk/vB2CDKlm7PLmp33wUtx8Tw3QI1KAgFLdRIsKIPmhI3
86Yd/ZUZFu/sIUILwMcA
=V7WA
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2012_12_03_01_+1000_7Pb7Iy5ykOatWtmf--
