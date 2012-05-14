Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2ENIoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:44:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52005 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2ENIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:44:37 -0400
Date: Mon, 14 May 2012 18:44:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20120514184425.5747f862e369e2f291bfba69@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_44_25_+1000_eG7kjnC4kUkEgaXZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_44_25_+1000_eG7kjnC4kUkEgaXZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/dma/imx-sdma.c between commit 2ccaef0520d1 ("dma: imx-sdma: make
channel0 operations atomic") from the slave-dma tree and commit
7560e3f3581e ("dmaengine i.MX SDMA: do not depend on grouped clocks")
from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/imx-sdma.c
index a472a29,fddccae..0000000
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@@ -323,8 -322,9 +323,9 @@@ struct sdma_engine=20
  	struct sdma_context_data	*context;
  	dma_addr_t			context_phys;
  	struct dma_device		dma_device;
- 	struct clk			*clk;
+ 	struct clk			*clk_ipg;
+ 	struct clk			*clk_ahb;
 -	struct mutex			channel_0_lock;
 +	spinlock_t			channel_0_lock;
  	struct sdma_script_start_addrs	*script_addrs;
  };
 =20

--Signature=_Mon__14_May_2012_18_44_25_+1000_eG7kjnC4kUkEgaXZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMXpAAoJEECxmPOUX5FEUaEP/3mrDk9nJLncCJK1tZMiF7L7
pm9plblEV3+MrPNKKjOav68NRMrwhjfRDRm0sQmg5NBGWLerxQinUPktgckL5Y/Z
8VfYlWUMBMnF5jB9gZbfQZ1ObdHcAKKA7P+QEaDGFQCkLEeMolDD9oWAmw19u8d/
KCgXh+qeBxb8+fGZVaJt3fjfkug2tpzyBiOLstoWsTJvEaZfKZsG/D7Xt2sNgD+f
OYHcbga7sdr2PR0GDUCZcp77NueEJexKul3EoT+FJvqZ9m3YZKCjYKsaZgDhqLae
zZGZ1uK8wg/kftLBtABgMOhNBk9pLQ081rfMdfO3+iwkV0F8f4+YSKMBxp06IMAV
tqiAai3e7CetWGtBY4VezwgBk1htLiDHzOprJXpkdkfPUk6ihec+pHOq4AiGar/p
/N+RhKv04CXleYefYFZUGPNl1ksvcMINlSBU/qsTGKT36gvs8RQ94y3fn+r0GdgJ
sZlwGKeQ80nfwGjDIYeIVMnQbCrK/WoAeUaLIIpXrON3mxpPHRaMJ4G24kmCdLuW
z1liNxgJ4KL/EcOX9Il/t+RXOqx9DyejUrLInmm4FBULfN7UDUOD65Jv46F4Y54w
DvYzF0Fg3q3onxAqmQHTySgnDLXhmhCELH25yVRjv+UkB8U68Yyx+O3zcRvnuFHE
/GehfaMTzM6GiIw5q81P
=Xrh4
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_44_25_+1000_eG7kjnC4kUkEgaXZ--
