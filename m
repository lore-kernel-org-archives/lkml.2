Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab2CVCxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:53:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33284 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2CVCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:53:18 -0400
Date: Thu, 22 Mar 2012 13:53:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Vinod Koul <vinod.koul@intel.com>, Huang Shijie <b32955@freescale.com>
Subject: linux-next: manual merge of the l2-mtd tree with the slave-dma tree
Message-Id: <20120322135309.c27700c17c78d7c93de3d7db@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_13_53_09_+1100_2vhV1cYZ_o11R=3u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_13_53_09_+1100_2vhV1cYZ_o11R=3u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/dma/mxs-dma.c between commit 185ecb5f4fd4 ("dmaengine: add
context parameter to prep_slave_sg and prep_dma_cyclic") from the
slave-dma tree and commit c790d78c631f ("mxs-dma : rewrite the last
parameter of mxs_dma_prep_slave_sg()") from the l2-mtd tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/mxs-dma.c
index 65334c4,0ddfd30..0000000
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@@ -25,11 -26,8 +26,10 @@@
 =20
  #include <asm/irq.h>
  #include <mach/mxs.h>
- #include <mach/dma.h>
  #include <mach/common.h>
 =20
 +#include "dmaengine.h"
 +
  /*
   * NOTE: The term "PIO" throughout the mxs-dma implementation means
   * PIO mode of mxs apbh-dma and apbx-dma.  With this working mode,
@@@ -340,7 -374,7 +362,7 @@@ static void mxs_dma_free_chan_resources
  static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
  		struct dma_chan *chan, struct scatterlist *sgl,
  		unsigned int sg_len, enum dma_transfer_direction direction,
- 		unsigned long append, void *context)
 -		unsigned long flags)
++		unsigned long flags, void *context)
  {
  	struct mxs_dma_chan *mxs_chan =3D to_mxs_dma_chan(chan);
  	struct mxs_dma_engine *mxs_dma =3D mxs_chan->mxs_dma;

--Signature=_Thu__22_Mar_2012_13_53_09_+1100_2vhV1cYZ_o11R=3u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapQVAAoJEECxmPOUX5FEEXYP/3oow1aVLqmSE78nGbMdopx8
MvM90sFcPsuP34se5JzMBrhdosXvmyrVgOUsbpxRplL3KkWnuNPW92LLikKOgU+H
ZBtXiICeLMrZYd666jMsXT7XXTALDPmDeFcII57m1JaQZywiTZPHeUOQeLDZr9Vz
L8kgVTzs2ON5VHhMWyPffUUh1zcHjvmljVuMpoTiQKqRAaIy9v0RGocKNV2q60PE
E44BzqcIQuoxzDJJ91n5dkAzZl5TUz5FG/e3gHc86WxnNO4X6brVU5hSzV92Eaa4
NhE3vrXUTuy2ASre0WZV6kzsxRYrRDKvlXypUNSNtRxfai3xhH0wsuC6M3oXSdVT
wuMUd8wwmpLq5wt11n5HijhN4+GW+H31wrfky/+uJAJ3yLD/8pFRieLKtirz/hVN
Oc0nqb9tzaQSA+tvkce7V/wOBge7nLGL/+dBD5nFufdB51gDDdA1idTMUMbUqhrU
24Zu1C9Bd+/mpc2mIDlJIEPmVzEu10mj8FN1a3RC57VpLarCB5RII5Tyrfb3mWNT
GM6czYjZDhSp+EYhkAomRtGjDwnrMozcMSHnSraXuM0CsRpHOtUUon96dkPp0nUy
gMVc5xlcj9RmplhPVTzCepjezQXlJVtIAkKhOUjZu/Z4CcRJPe8EF4pm/8iIirwC
v99pHf4E3XDZd+8LmAsl
=HE2h
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_13_53_09_+1100_2vhV1cYZ_o11R=3u--
