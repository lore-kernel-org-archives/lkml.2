Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2JaFTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:19:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53881 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JaFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:19:32 -0400
Date: Wed, 31 Oct 2012 16:19:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <rob@ti.com>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the staging tree
Message-Id: <20121031161921.3c9a46bd03f5864eed88fc87@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Oct_2012_16_19_21_+1100_0=2cAiRBVlzRDUJU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Oct_2012_16_19_21_+1100_0=2cAiRBVlzRDUJU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/drm.c between commit 5e3b08749951 ("staging:
drm/omap: add support for ARCH_MULTIPLATFORM") from the staging tree and
commit 2a296c8f89bc ("ARM: OMAP: Make plat/omap_hwmod.h local to
mach-omap2") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/drm.c
index 49a7ffb,6282cc8..0000000
--- a/arch/arm/mach-omap2/drm.c
+++ b/arch/arm/mach-omap2/drm.c
@@@ -23,11 -23,9 +23,11 @@@
  #include <linux/init.h>
  #include <linux/platform_device.h>
  #include <linux/dma-mapping.h>
 +#include <linux/platform_data/omap_drm.h>
 =20
- #include <plat/omap_device.h>
- #include <plat/omap_hwmod.h>
+ #include "omap_device.h"
+ #include "omap_hwmod.h"
 +#include <plat/cpu.h>
 =20
  #if defined(CONFIG_DRM_OMAP) || (CONFIG_DRM_OMAP_MODULE)
 =20

--Signature=_Wed__31_Oct_2012_16_19_21_+1100_0=2cAiRBVlzRDUJU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkLTZAAoJEECxmPOUX5FELHgP/3XnqeaxsRJMmFNnRedaTjER
zjSW0j5+5Uj0/caKmEDvVKNNy9s2p5Db/dvylH1xP1dkvcrjj6cJDOU25193FL8z
iSnNlu6l0lU7FedHOZvjlRuHD9cbVsAza/RHuGYusD2/Lo8+0n9zj6yWrntm4DDm
9JyAv2eywLDuOuJUqD2kIwnMWiUhWoQbnE/fZScK9BovA2k8ZGcXbXFtvjtfDf75
KWOk26vBnq+eYgPiW7kEhTXHhSySMByxhst+Y2GtplGwhhB1JWfygXbva91I2LLg
YP0kVj77bAjOeY7K9UOZdk2HyqsdFdh3Hqq28yFvgp8J2jkoqmO0g0qfV8FfSaFi
hYWqCnuP/JL9+k9yHDiXcPgZi+/7ZgX01KkHVUdQGvLnZZgWQ1b2/joGcAHRxR/+
wco62CZWmiEOCJ6ChHt1j25GX1gtHTUVyBk8ITH/6mM39zdb7WjdfqSEiV40dkmB
NZuX6yquUvPskPZIr6XF/ih92QyXmy4hp4ozmMZzXgkXTV9wdPoBGK0FZz+X8LTG
/WhFlS2kxiomY46zVrxstBMgXfdVZCfoOnV2kbpfngA7L5xfIHeNyonITiUGzqqk
BbJbHCdOJ2t4HkxwnP6MyGoff5WV0FMDGXnV/mssBf2lnR8bNiqrQmmzeyg7nPCR
+IugNL1ltfT1nk4Bob8L
=hURv
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Oct_2012_16_19_21_+1100_0=2cAiRBVlzRDUJU--
