Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2LRXo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:44:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45265 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2LRXoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:44:54 -0500
Date: Wed, 19 Dec 2012 10:44:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: manual merge of the slave-dma tree with Linus' tree
Message-Id: <20121219104446.fdc2f77dd8176f059de63d5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Dec_2012_10_44_46_+1100_zxid0oEAu6oN.ItZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Dec_2012_10_44_46_+1100_zxid0oEAu6oN.ItZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/dmatest.c between commit 632fd28326c0 ("dmatest: implement
two helpers to unmap dma memory") from the  tree and commit f04f98e91bd8
("dmatest: adjust invalid module parameters for number of source
buffers") from the slave-dma tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/dmatest.c
index 64b048d,0e2deaa..0000000
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@@ -228,20 -228,13 +228,27 @@@ static void dmatest_callback(void *arg
  	wake_up_all(done->wait);
  }
 =20
 +static inline void unmap_src(struct device *dev, dma_addr_t *addr, size_t=
 len,
 +			     unsigned int count)
 +{
 +	while (count--)
 +		dma_unmap_single(dev, addr[count], len, DMA_TO_DEVICE);
 +}
 +
 +static inline void unmap_dst(struct device *dev, dma_addr_t *addr, size_t=
 len,
 +			     unsigned int count)
 +{
 +	while (count--)
 +		dma_unmap_single(dev, addr[count], len, DMA_BIDIRECTIONAL);
 +}
 +
+ static unsigned int min_odd(unsigned int x, unsigned int y)
+ {
+ 	unsigned int val =3D min(x, y);
+=20
+ 	return val % 2 ? val : val - 1;
+ }
+=20
  /*
   * This function repeatedly tests DMA transfers of various lengths and
   * offsets for a given operation type until it is told to exit by

--Signature=_Wed__19_Dec_2012_10_44_46_+1100_zxid0oEAu6oN.ItZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0P/uAAoJEECxmPOUX5FEhn8P/2MxZNrImOO5KEuJNCQPD9ya
L1+5NGmoOt4qAIN6OZ/a8Bgy9jzIAiLk0NwZ9Ul8SpsHYcGhOMgbgN7e+YdBz050
mnxFSPCIj0ptCv9+TWyQVKICYgRCZozA0tO7HV8cV5rXF8T3/WiM0hSN7vjA794A
be/FftA4BUSXmeIbm8aC/h3INCsv0LnMaNOxAdKCLdRk0IQMC2TniqY9Bun37fx9
KkUnaD8nGVQJFLxisK8ZARjsGkNh/lxbMXTBpQveNsrzQe6RFXhs8wcrkT0FxP48
5Eguf2zacougf5dbD3jcasd4t0J/Jv4P6Af9wBI15j73r6RIKmOguRxYo+/DEJw9
+39+Vo4GN3w1R1D0zQupVM5e3/WBVWnuJEA/uqchco5NswSmpqE4fxbaRFGF6hoR
MRc1T0Cw6YfBtjQ1vVq90/QjJQ60/7L2gKBYJkPb/iWUSKN4C9Qwvtd/GkbCsPx/
8fJ+ytIx1xWV6lXoBqGti6Boov9SBqyEOubOnF4N+3rG9utcs2NjQi8iqFlu+tpG
dJtTj6rnhPhinNrNDZsZUaevF+aJGyj5AJqkB7hE52j0xw1XOvcA0rO6fULAh2PB
vi+N1XnRqWw4HyW9HkHIZCXfe1nU/M/KzhQTLptMAQvmDNJlyu8yDSrMbKiWYzvT
OTt4abELUQas4CO+/qz+
=bGPI
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Dec_2012_10_44_46_+1100_zxid0oEAu6oN.ItZ--
