Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1KKCMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:12:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39453 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1KKCME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:12:04 -0500
Date: Fri, 11 Nov 2011 13:11:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Nov_2011_13_11_59_+1100_AdL_f4SKr1=7DVHd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Nov_2011_13_11_59_+1100_AdL_f4SKr1=7DVHd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/keyboard/Kconfig between commit 007205aa47e9 ("input:
samsung-keypad: Add HAVE_SAMSUNG_KEYPAD config option") from the s5p tree
and commit 5862c02d745f ("Input: samsung-keypad - enable compiling on
other platforms") from the input tree.

I have fixed it up (probably incorrectly - see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/Kconfig
index d80b4ea,cdc385b..0000000
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@@ -423,18 -439,12 +439,19 @@@ config KEYBOARD_PMIC8XX
  	  To compile this driver as a module, choose M here: the module will
  	  be called pmic8xxx-keypad.
 =20
 +config HAVE_SAMSUNG_KEYPAD
 +	bool
 +	help
 +	  This will include Samsung Keypad controller driver support. If you
 +	  want to include Samsung Keypad support for any machine, kindly
 +	  select this in the respective mach-xxxx/Kconfig file.
 +
  config KEYBOARD_SAMSUNG
  	tristate "Samsung keypad support"
- 	depends on SAMSUNG_DEV_KEYPAD || HAVE_SAMSUNG_KEYPAD
 -	depends on HAVE_CLK
++	depends on HAVE_CLK || HAVE_SAMSUNG_KEYPAD
  	help
- 	  Say Y here if you want to use the Samsung keypad.
+ 	  Say Y here if you want to use the keypad on your Samsung mobile
+ 	  device.
 =20
  	  To compile this driver as a module, choose M here: the
  	  module will be called samsung-keypad.

--Signature=_Fri__11_Nov_2011_13_11_59_+1100_AdL_f4SKr1=7DVHd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOvIRvAAoJEECxmPOUX5FEiMwQAJ2fEgFrPIxXrjAbjGJ1epkr
ZRtk9CuGfn/pEDY00zSxk3Ty8vEScOoqL7Q4zDDiTSS0IcA8Td+d2rHP0liBO/Zu
mH2ogujOKF/1Cv5zX07w37wK6rLUQpxjA2GsMhxcEcd1A6RubMMJ8/6uOYde7xws
c1GLgLlDYaP8lOAWv2t5n/2rq5cP/OMwLDgRpgHrT98JAGyCHbvse9YaGKcBdZEo
ZbuqfsPtWNuUYkKa2MrfxrePWYZ6ZobIoEv2ISq6Ryoomb/MM+LlPVqom0bnrmLL
72qtXJJz8h63SuY2l0oct/l3+6Px5IdaLNJDJ+MG2yr4d3cFaaSV9TEr4Tv+BcQd
n7iLfkBgS7rbODyLSW4YgcvnZdI7oDWYmQxX9IH5Lkcci7TzlpvTE1Ee5W9TGmji
U6mW9ZdMYc4kwUMn/zjEIC8SWmn7xqVmIbmzCndn3BePpqIGLc+bFE8bmS2wCyVj
30Zjh3rlyYzfbh/UbedVfMqV0pPxugn29QYsWJKrJDqvgQE+FNduHxwd9flejtLK
Y2bQt/ISowllX7OobroMSbKL3y4aAwxXmSRp3xry+Z0tezoDGri0cyBRaiFbvLXU
SIWuA7tDgA/Tr9CaU16TbSOqR6OHre3bKQjS0ucUhxfHUFu5g9/ASYyDyRc6iQV2
FT44bXO3n209ohku2NrT
=1rVX
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Nov_2011_13_11_59_+1100_AdL_f4SKr1=7DVHd--
