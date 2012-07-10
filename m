Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2GJFcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:32:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56897 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2GJFcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:32:21 -0400
Date: Tue, 10 Jul 2012 15:32:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120710153210.45caf9cf0644898ab3d1c70b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_15_32_10_+1000_xNN4FiWCO/IemVts"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_15_32_10_+1000_xNN4FiWCO/IemVts
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "devm_gpio_request_one" [drivers/extcon/extcon-arizona.ko] undefined!

Caused by commit 01eaf2458773 ("extcon: Convert extcon_gpio to
devm_gpio_request_one").  devm_gpio_request_one is not currently exported
to modules.

This has not been seen earlier because CONFIG_MFD_ARIZONA only got added
today :-(

I have added the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 10 Jul 2012 15:25:14 +1000
Subject: [PATCH] extcon: extcon-arizone can not be built as a module for now

fixes this build error:

ERROR: "devm_gpio_request_one" [drivers/extcon/extcon-arizona.ko] undefined!

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/extcon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index dbd96af..a2071e4 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -30,7 +30,7 @@ config EXTCON_MAX8997
 	  detector and switch.
=20
 config EXTCON_ARIZONA
-	tristate "Wolfson Arizona EXTCON support"
+	bool "Wolfson Arizona EXTCON support"
 	depends on MFD_ARIZONA
 	help
 	  Say Y here to enable support for external accessory detection
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Jul_2012_15_32_10_+1000_xNN4FiWCO/IemVts
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+75aAAoJEECxmPOUX5FE2PIP/jdyBDLWoYm2pvXlF4+Pv6mb
8iS9m2LjQ7NHk0xRDsPdjwygxPjzZY7LPdZBZmKjSqD5/o2zpiP948sDmuQoBr/e
/uJgUT8/fkUPj1OpuLUwFf/SWMnJTjoQ1X7+beeca9XYAUhnCKBOzvQPpWlLV/O8
KhzSAycrR868nDPrd5uzknJXH7YU5NQG4jFYQi6vkvYf+bJZ8ZxCxRulNFe4kqww
Vn8pbKXjAKYlvIKnto45skE3GPn/FzuTfR7ydBNy4UpOjgFCKcP4QcFbrkQd/kK7
QcyWDCaYT9YKbV/xswn6Apij83mmqQVUqFL0hhrU+tXVaBX7zm+gWKephJqmRmai
gfiHDl6yfGyS85hvmPhG8LUQewdryjB8Mq6wHUeRlzA0nnIFNK0hz71NkA1KLWOX
a8Cv4QkhzVvEr516iczEEwRP+UjHIJkWpUTPhmEagNn3IR3J827RTw4nM2aDTnzF
cEWsAq7xjwOoHJafvUFmUo/pYSvNYVKOeqJrvW7zTdJTepz+Y2iRt1CAfnU4I7Rt
CN4y2AYU8LYLA0P6NfwXjxWhh8LSaPXUuQzaUcJZE9967McEumIAP8W9Toncb20h
30iztu+XJOgNUSAoprL4/ELfb2zNirVw5p/vTkOyCxDHYZQ0mBHMw7xUQiv3x3Og
JeLxf/LT5iMZP4nCvy4k
=8mia
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_15_32_10_+1000_xNN4FiWCO/IemVts--
