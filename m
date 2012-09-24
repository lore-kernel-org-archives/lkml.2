Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2IXJbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:31:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2IXJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:31:11 -0400
Date: Mon, 24 Sep 2012 19:31:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Vinod Koul <vinod.koul@linux.intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20120924193108.f399195b821a835e0d3db08a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_31_08_+1000_59XR_D6=0fTI2e1Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_31_08_+1000_59XR_D6=0fTI2e1Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mmc/host/davinci_mmc.c between commit b5daabbd3d18 ("mmc:
davinci_mmc: convert to DMA engine API") from the slave-dma tree and
commit ec2a0833e515 ("ARM: davinci: move platform_data definitions") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/davinci_mmc.c
index c5e1eeb,3dfd347..0000000
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@@ -30,12 -30,11 +30,12 @@@
  #include <linux/io.h>
  #include <linux/irq.h>
  #include <linux/delay.h>
 +#include <linux/dmaengine.h>
  #include <linux/dma-mapping.h>
 +#include <linux/edma.h>
  #include <linux/mmc/mmc.h>
 =20
- #include <mach/mmc.h>
+ #include <linux/platform_data/mmc-davinci.h>
 -#include <mach/edma.h>
 =20
  /*
   * Register Definitions

--Signature=_Mon__24_Sep_2012_19_31_08_+1000_59XR_D6=0fTI2e1Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYChcAAoJEECxmPOUX5FE31gP/ipG/Z2g4QvYT359l5mpM28B
s7w/Q/jDNkMuE+WMBXsKoJBMTrFaI9TmBg8xcSBwzUlOBl+sA6yuzg09KSWkFRF9
Ge1VMtr1OFQPO4+eEVb6xdaoYD+IwqgJWmLwOIV309Dju9Y3qf4F453+8Ebovsx6
e+UrFl7IBE1K0HD70hcrKnzBNvS1QbcSjRF5EuDefZp5xFwKnfzBXf/4+j7e/gqO
qZEy13rK1HU1oCfcjNvsjjAm5C9La39NVltyE/zdJGAlAF1ZNtA4pz/s8ibsHgwG
tj037rRsndvEV2pYjE7yKrdkFvznO7Jk0a7f48KdU8k5KBobY2IBNBuWPsmGmdOx
rYIVo5a+X1K8jR1v4tEbdYbG74Szz2f4s3j36jiiQYi2rylJGeYLVN7jZHPYDBTP
C6IAworY0kwQ787Rl1tkAMKRwgCsLSGcHojsa4XEZhqfTP9CKeGDa/e6D2UncV/h
v2fNptAepbdxtW/CSLXjqQ+sQhLzeP/erAig3KjAdiTldtqcGme+GbMKlIvie/nn
QDfjYwOdl0MPdGAtB03mlkMRUN2vErZnrqi9UUtsujEqTPu5oCtrqy74gNsrBHk9
68r4bY41DOxtOZzxp7LgpyP2vc8l43Je7DJz2whgCPHr9JUAFnW0/QkzzSIsA5Ux
gu1xAGWhDldbCV8hUoYG
=zBOU
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_31_08_+1000_59XR_D6=0fTI2e1Y--
