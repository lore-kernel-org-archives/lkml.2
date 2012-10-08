Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2JHA1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:27:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33105 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2JHA1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:27:06 -0400
Date: Mon, 8 Oct 2012 11:26:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the sound tree with the v4l-dvb tree
Message-Id: <20121008112657.d0c141b6f15c148c636a3a6a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Oct_2012_11_26_57_+1100_oeq3bHSJRIWroa3J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Oct_2012_11_26_57_+1100_oeq3bHSJRIWroa3J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/mach-davinci/include/mach/da8xx.h between commit 154d54a8ce99
("[media] ARM: davinci: da850: Add SoC related definitions for VPIF")
from the v4l-dvb tree and commit 896f66b7de29 ("ASoC/ARM: Davinci: McASP:
split asp header into platform and audio specific") from the sound tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/include/mach/da8xx.h
index 13d2295,c74a6ab..0000000
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@@ -16,18 -16,15 +16,18 @@@
  #include <linux/platform_device.h>
  #include <linux/davinci_emac.h>
  #include <linux/spi/spi.h>
+ #include <linux/platform_data/davinci_asp.h>
 +#include <linux/videodev2.h>
 =20
  #include <mach/serial.h>
  #include <mach/edma.h>
- #include <mach/asp.h>
 -#include <mach/i2c.h>
 -#include <mach/mmc.h>
 -#include <mach/usb.h>
  #include <mach/pm.h>
 -#include <mach/spi.h>
 +#include <linux/platform_data/i2c-davinci.h>
 +#include <linux/platform_data/mmc-davinci.h>
 +#include <linux/platform_data/usb-davinci.h>
 +#include <linux/platform_data/spi-davinci.h>
 +
 +#include <media/davinci/vpif_types.h>
 =20
  extern void __iomem *da8xx_syscfg0_base;
  extern void __iomem *da8xx_syscfg1_base;

--Signature=_Mon__8_Oct_2012_11_26_57_+1100_oeq3bHSJRIWroa3J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQch3RAAoJEECxmPOUX5FEhVYP/2DQvw1gLlsPIJk8HMkhTadA
Y55++73DRuHhF62/3W9MoSi7khY8+/TQt5d7p47QIbSHJhUPQW0mFwyIFLLU65zu
s+6nag+HeblByMkInFp/iFGi/IXfjHuVPgigDmt/BtU2E9wZ5kMYtSJVx5u6dUTA
BCfshfYaiGcN1a7FAoScyhYWMi+X2uNlIgScQ5No5x4CodH0wywyx0y+dYUw97Xg
F0r2O92WHzPHmyzNice0SvB0d72uu0AcRqJb/U9mOUJ9z1LncClmhhFaabA3Exi9
Rd2nrt6HeV1QrkMp9HtFUZsyE+up6TUKT1dKr7NoHgiBhIkFduF2m4A3CwP5ugON
vReqcosxDtxIDFZgvb44P768wrZBRJ/grqXx3emKVJQRwP23Qa+HTekD48X7GtvG
pPxEPua4ah/g3lg3cyMKwiH5ESs2KVPLdbyYzkiwO9cLFKmMI17i0zwy+4Mchjh5
I+z3pB5Ql5Rnzaz1k5l4cWUVG23BuGGHd/PJoHJgevQZNidsucfwTQzVfgTjoHF3
cBckgnnPh70oygxm/S8SiNw+nclcNOb5NVCvEgNP/pWu67itW08+N1QVuyHhZ7qa
wOuNkP4TAEXrqpF7GLi9LlmAw2w2H0OsPlrVm4Ry/nQ+D60YDjbKf068UhVbbWwh
zKGBjMHtAUFmtUuNoK9f
=G3H7
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Oct_2012_11_26_57_+1100_oeq3bHSJRIWroa3J--
