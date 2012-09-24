Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2IXHal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:30:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44167 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2IXHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:30:39 -0400
Date: Mon, 24 Sep 2012 17:30:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120924173024.f102e9efb9b24d2b275509be@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_17_30_24_+1000_zuZTd9kjn8VnFYnq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_17_30_24_+1000_zuZTd9kjn8VnFYnq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-davinci/davinci.h between commit 896f66b7de29 ("ASoC/ARM:
Davinci: McASP: split asp header into platform and audio specific") from
the sound tree and commit ec2a0833e515 ("ARM: davinci: move platform_data
definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/davinci.h
index 8661b20,a37fc44..0000000
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@@ -22,11 -22,10 +22,11 @@@
  #include <linux/davinci_emac.h>
  #include <linux/platform_device.h>
  #include <linux/spi/spi.h>
 +#include <linux/platform_data/davinci_asp.h>
 =20
- #include <mach/keyscan.h>
 -#include <mach/asp.h>
+ #include <linux/platform_data/keyscan-davinci.h>
  #include <mach/hardware.h>
 +#include <mach/edma.h>
 =20
  #include <media/davinci/vpfe_capture.h>
  #include <media/davinci/vpif_types.h>

--Signature=_Mon__24_Sep_2012_17_30_24_+1000_zuZTd9kjn8VnFYnq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYAwQAAoJEECxmPOUX5FEZHgP/R1uYvA2QQwoqdmTH+34Oo0j
WMarzBDC2FzW5zD0j+Hfxo94/zPNWvj6paw7Zk+WI8/TmvgFNYRS86r3Bqv5RNfe
AwYk1gxqAoG7lIYecnZUNSTbMQ38Kg57XoXsoA4v0+tXc4hC0FJbxoG9ynRYFrKs
FkSUzjYCtovwCn4UnczP/q/uGiICZDBzJf6Wfs6dPB4UTmThwAd1maTB3I5PmudV
8MtVTuvWaLNV2MFVq2lLXOGSzqZwIYH6/ahI2YeCrscB4WZuqyXwv1z3ztRPA3G4
AtsVtvOrZvg1quq5Gyx4PWQ77fsKO++XIZE3kWjQy1TaoEcgF/96yqiIcLX55J9z
UU4xs0f/2ZDBDX2HfgPSgXVN76mmMoV7jzH/oWWmWZ0p1WRl+pk7hqmzjYhF8zXi
MWtzvNVv796BJqE3qwHQeWVpmktJxspyvHg6yoluYx4aEh3hC1y2u2UkO0QilNLu
sMYA6xwF+ZKYwN3517IX6Y5ymy7NM6J95Fc69aqAccQ0T6cAtQ6Ka+OBLdP0HYSW
+kFFvN3cw4cXy4m9Fhd1l5XcuI9mwXUYO7s6IK1f9X26Nb0Qf7eebx1LhQFw2g+W
xUlDUXG4yZWwrJ44aoaD413MJNWcWoAi8KCRCKM0zbr3GPCv52l/OLxUkh2NlinD
Ji9iZIzEfxV5Oyav8Kqf
=EMm4
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_17_30_24_+1000_zuZTd9kjn8VnFYnq--
