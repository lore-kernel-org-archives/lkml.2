Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2IYGpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:45:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49640 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2IYGpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:45:01 -0400
Date: Tue, 25 Sep 2012 16:44:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>, Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120925164458.8c856b4b20f77879a0173e71@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_44_58_+1000_Or6Thghi9Cu0nPfI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_44_58_+1000_Or6Thghi9Cu0nPfI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
sound/soc/omap/omap-mcbsp.c between commit 04564e325830 ("ASoC: OMAP:
mcbsp, mcpdm, dmic: Let omap-pcm to pick the dma_type") from the sound
tree and commits 7d7e1eba7e92 ("ARM: OMAP2+: Prepare for irqs.h removal")
and 2203747c9771 ("ARM: omap: move platform_data definitions") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/omap/omap-mcbsp.c
index fef2f59,1b186277..0000000
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@@ -34,7 -32,9 +34,8 @@@
  #include <sound/initval.h>
  #include <sound/soc.h>
 =20
- #include <plat/mcbsp.h>
+ #include <plat/cpu.h>
 -#include <plat/dma.h>
+ #include <linux/platform_data/asoc-ti-mcbsp.h>
  #include "mcbsp.h"
  #include "omap-mcbsp.h"
  #include "omap-pcm.h"

--Signature=_Tue__25_Sep_2012_16_44_58_+1000_Or6Thghi9Cu0nPfI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYVLqAAoJEECxmPOUX5FEMUUP/jq68FFXb9y2Mw8rB2PXNtVD
9PLCOkGrHsARPifCjl16Hp3fiNYzt0QOSeSSKZtoKCWnu0XzYuusau6WvelnUIgB
lviV4OSOSJ9sSfKvmrS1ipAFx/WDViQKQw6Vipr1wHFNa1elTCRabPFHfnXbLqaF
NwtRQyfDobCHFW5jHUCJH2ac+UycbYHQu5VNwQZMrQqn3Lj6ngRkFHvqbumvq+t1
qNmiyUC+JFs+BUPR9+Exso5O2trrzDrLFvC2Ft1Kd4n5YwERGs45ENpfQ0JyftQN
K0iaZovkYokTbVPIabVeLvQgd12DdlQqUwjk67IujLbbdYqlFg+XI60rbvZ4fVVk
0byxQA/3Lm6vAS8qe23RbzGcPU+KbjOzzhGzfhCpnOsnvEt0xLRDEB9objI3W800
XrJg31M8uT6RyzYRSE8vFndytg2ljCD5ewD3F+BcnEzG03lfvccEojcGFgZuu9oe
ta2+YOhmrOjnL32i4RISGRnBG5pFQocHFgvD8ZwmWmokXrzxnPyR+NM7ut9boCrQ
kianKuWJygVbl8VIoshzDM/IoOBk58ePvjam4h+6pbsO8IqzsmVcy6xoifpgJ3JF
7izckGb1e+C6/lAbWflUxVOko/7BvZGuIriFoIne3R+f5xDVKQ7lFr3AlF+jJbMs
eqrVvAlJZqt1TRy8MJqV
=QWKo
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_44_58_+1000_Or6Thghi9Cu0nPfI--
