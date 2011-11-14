Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1KNADR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:03:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40591 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1KNADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:03:15 -0500
Date: Mon, 14 Nov 2011 11:03:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kars de Jong <jongk@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the m68knommu tree with the m68k tree
Message-Id: <20111114110305.5b04e0b5509cd0489c7d9440@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_11_03_05_+1100_eF+sZc44Kr_Mwl2B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_11_03_05_+1100_eF+sZc44Kr_Mwl2B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/Kconfig.debug between commit 049755db2c3f ("m68k/mvme16x: Add
support for EARLY_PRINTK") from the m68k tree and commit d0106cf0aa29
("m68k: support configure time command line for MMU m68k") from the
m68knommu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/m68k/Kconfig.debug
index a0c8863,af4fd5f..0000000
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@@ -2,17 -2,14 +2,25 @@@ menu "Kernel hacking
 =20
  source "lib/Kconfig.debug"
 =20
 +config EARLY_PRINTK
 +	bool "Early printk" if EMBEDDED
 +	depends on MVME16x || MAC
 +	default y
 +	help
 +          Write kernel log output directly to a serial port.
 +
 +          This is useful for kernel debugging when your machine crashes v=
ery
 +          early before the console code is initialized.
 +          You should normally say N here, unless you want to debug such a=
 crash.
 +
+ config BOOTPARAM
+ 	bool 'Compiled-in Kernel Boot Parameter'
+=20
+ config BOOTPARAM_STRING
+ 	string 'Kernel Boot Parameter'
+ 	default 'console=3DttyS0,19200'
+ 	depends on BOOTPARAM
+=20
  if !MMU
 =20
  config FULLDEBUG

--Signature=_Mon__14_Nov_2011_11_03_05_+1100_eF+sZc44Kr_Mwl2B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwFq5AAoJEECxmPOUX5FEXe0QAInuZmPlmQdbkX2bWAzGm/Tg
3fgcCKceTjJjmROqf/IXuhYumLXu4WJp7EDvYcVKyzPcaegQOJX3T+EBvp5I2F/a
mOieIesAm17+kwoXEykKqootUfQhaVejwfV9NmPe8BT+Urc/3SxSrK7/9z7RQz9b
Hg5+xTgWDArjkz0R8liKxRGT1u6tFuPKYHYeNA8qeTtUC6BxeHEuyJrbrFKfZNuM
zdMFuXDcdas6rNPcbeyUMpj9Jfmg67IgKxPhrm8NvYu4Iseu4EJ3xjuZKsu7r3WE
FTHLWbILYLTEm6lAzkMaOWhnlDlruoDTi5cvBgXEwTH9OZapIFQZEft+j+ZxuuQ1
5xZSCFT/B+XRt7Jmh5OVpip3jDW3g8dI5LKryqBJArD9YpjqOCkZvBPrAbDts0SM
xgUuZ4vFw737oM222Dci391s9Eswgu2rqzbxim8dJHQS+O9jJt2ufbt27D420fyz
zso7UT8OZyEz/D6w17FuG+NkzcI9CKr9n00zQ5bLhI2jopoSzz10k5lUiJ1ayxry
UeqbjHbG+qZl+gQ6P9T/+upTp9ENMU5NH/i4cgJ+rHnAXEV5hhBxQHQKew1VZ+hp
gxHcmhYufcB55vIbc7j+9/fJAakI39agxR2TnTB11QrFx02U9gbUPZvndjcFy2+t
34SXEL5Pg6/oeAe68PoU
=2ES6
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_11_03_05_+1100_eF+sZc44Kr_Mwl2B--
