Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2K0EsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:48:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59851 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab2K0EsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:48:04 -0500
Date: Tue, 27 Nov 2012 15:48:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Shiraz Hashim <shiraz.hashim@st.com>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20121127154801.42dea58ad974f4792bc85edf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_15_48_01_+1100_NAd9ea6z1hfrJ2Bj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_15_48_01_+1100_NAd9ea6z1hfrJ2Bj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-spear13xx/spear13xx.c between commit b47394911c26 ("ARM:
SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree
and commit 3e270ba6e915 ("ARM: SPEAr13xx: Remove fields not required for
ssp controller") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-spear13xx/spear13xx.c
index 0e166fa,c4af775..0000000
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@@ -25,14 -25,60 +25,12 @@@
  #include <mach/generic.h>
  #include <mach/spear.h>
 =20
 -/* common dw_dma filter routine to be used by peripherals */
 -bool dw_dma_filter(struct dma_chan *chan, void *slave)
 -{
 -	struct dw_dma_slave *dws =3D (struct dw_dma_slave *)slave;
 -
 -	if (chan->device->dev =3D=3D dws->dma_dev) {
 -		chan->private =3D slave;
 -		return true;
 -	} else {
 -		return false;
 -	}
 -}
 -
  /* ssp device registration */
 -static struct dw_dma_slave ssp_dma_param[] =3D {
 -	{
 -		/* Tx */
 -		.cfg_hi =3D DWC_CFGH_DST_PER(DMA_REQ_SSP0_TX),
 -		.cfg_lo =3D 0,
 -		.src_master =3D DMA_MASTER_MEMORY,
 -		.dst_master =3D DMA_MASTER_SSP0,
 -	}, {
 -		/* Rx */
 -		.cfg_hi =3D DWC_CFGH_SRC_PER(DMA_REQ_SSP0_RX),
 -		.cfg_lo =3D 0,
 -		.src_master =3D DMA_MASTER_SSP0,
 -		.dst_master =3D DMA_MASTER_MEMORY,
 -	}
 -};
 -
  struct pl022_ssp_controller pl022_plat_data =3D {
- 	.bus_id =3D 0,
  	.enable_dma =3D 1,
 -	.dma_filter =3D dw_dma_filter,
 -	.dma_rx_param =3D &ssp_dma_param[1],
 -	.dma_tx_param =3D &ssp_dma_param[0],
 -};
 -
 -/* CF device registration */
 -struct dw_dma_slave cf_dma_priv =3D {
 -	.cfg_hi =3D 0,
 -	.cfg_lo =3D 0,
 -	.src_master =3D 0,
 -	.dst_master =3D 0,
 -};
 -
 -/* dmac device registeration */
 -struct dw_dma_platform_data dmac_plat_data =3D {
 -	.nr_channels =3D 8,
 -	.chan_allocation_order =3D CHAN_ALLOCATION_DESCENDING,
 -	.chan_priority =3D CHAN_PRIORITY_DESCENDING,
 -	.block_size =3D 4095U,
 -	.nr_masters =3D 2,
 -	.data_width =3D { 3, 3, 0, 0 },
 +	.dma_filter =3D dw_dma_generic_filter,
 +	.dma_rx_param =3D "ssp0_rx",
 +	.dma_tx_param =3D "ssp0_tx",
- 	.num_chipselect =3D 3,
  };
 =20
  void __init spear13xx_l2x0_init(void)

--Signature=_Tue__27_Nov_2012_15_48_01_+1100_NAd9ea6z1hfrJ2Bj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtEYBAAoJEECxmPOUX5FEAdgQAIR21lIDzIwN4QV0daKinDs/
zf+JjEYyMuJSiFjr8BFB2ymUsUiyeaFlAato4t3rZs6ZbbTLLZ0r+nEQfZa7EpIT
Z5664/bJtPtlC1vMfkPCv67ogks2VhX2L7BJO/MRqROladSjevbxxtm/MzbZE8Pc
aah5PjbDuAXdOX6D5F951cIa22eafFTMq1WIgOqYBRQm3GrkVv2lkZsfBnmJs0Vd
DUZd+7c9l9VbjJK8xZgqeZ9ie404soFCQ2o3M0WRcFwwn+Iy20Cuu4y90W1RThDj
9+SOWaht1LuAcuGSKpnqyCOSe8FSU43D0mkRL8xYmpoV0985wznJXAvo7evou5LH
EXCjUXAuSRVeYGJxQEjzGrjZbr/0gW2Qbc6m2ILaoLvUbONA8Dbk8yZgF6+uuHTZ
oqDwErtkfWcGWYbsMCDfErg0nTwwc7xfdxfyGfxTazr7OUQGXKW81fOBWvz+40J1
jLld/oSZWJrypF268l2QIhRFl0upDDu53ZtxBKUc/OdANUVAOHDJGyhleu8ergNH
UJHD7FzDZjQYGqiE1Ca+0dQ9mLnEB5MJXjGnUHmDhAvCvn4dqeSxePJotU0ht1Rl
Il8OMhOlZdUWDX6BLvAOU8LrBdl4doT+P8HNzf+uOAJjKMR+xBEpj7yaEe13fn9t
9HsTvTUlVdItHN7qM/T7
=72s2
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_15_48_01_+1100_NAd9ea6z1hfrJ2Bj--
