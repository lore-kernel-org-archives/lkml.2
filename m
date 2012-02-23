Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2BWAkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:40:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2BWAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:40:50 -0500
Date: Thu, 23 Feb 2012 11:40:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: linux-next: manual merge of the mmc tree with the slave-dma tree
Message-Id: <20120223114041.06b21971f11b4c396b193607@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Feb_2012_11_40_41_+1100_keDDzuqLViL9K780"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Feb_2012_11_40_41_+1100_keDDzuqLViL9K780
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/atmel-mci.c between commit e2b35f3dbfc0
("dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config
changes") from the slave-dma tree and commit 43df92914ea0 ("mmc:
atmel-mci: don't use dma features when dma is present but there is no
chan available") from the mmc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/atmel-mci.c
index 44062d3,390863e..0000000
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@@ -1970,19 -1971,13 +1970,21 @@@ static bool atmci_configure_dma(struct=20
  			dma_request_channel(mask, atmci_filter, pdata->dma_slave);
  	}
  	if (!host->dma.chan) {
- 		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
+ 		dev_warn(&host->pdev->dev, "no DMA channel available\n");
+ 		return false;
  	} else {
  		dev_info(&host->pdev->dev,
- 					"Using %s for DMA transfers\n",
+ 					"using %s for DMA transfers\n",
  					dma_chan_name(host->dma.chan));
 +
 +		host->dma_conf.src_addr =3D host->mapbase + ATMCI_RDR;
 +		host->dma_conf.src_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
 +		host->dma_conf.src_maxburst =3D 1;
 +		host->dma_conf.dst_addr =3D host->mapbase + ATMCI_TDR;
 +		host->dma_conf.dst_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
 +		host->dma_conf.dst_maxburst =3D 1;
 +		host->dma_conf.device_fc =3D false;
+ 		return true;
  	}
  }
 =20

--Signature=_Thu__23_Feb_2012_11_40_41_+1100_keDDzuqLViL9K780
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRYsJAAoJEECxmPOUX5FElXEQAIKkGlSrXd95JVm8bfU9uK4k
AlUxP0OjGWXe7VcIyCXUlFlGaSPatzVl/6EUdAM1PPe31hHdC7JEwKxYYtDnE6se
FTPFd4aiEVtNjFVPighbd9ZQCRQzrNz+pTGo0jYAkRVuMDaCzKVkCweY9DVJe/4p
m0ozwF/pAX7awND5+Y1b8Onc/nI1U/q4hJ4cf/10+Egz1nxb54vrc2e834w+w2ll
JCKqm/QoDFlBG8GCOYmCYw0H00RT6VXIa2kJSyKEgyOsbS0XyDYxRFj6y8WRS2in
hD+ab3M4Uz4rGqmJ1mUFhdFRvd8epLWnjGN0kdB49MuztoVmSOCpSBX+S+8EISly
Yzgn8+aGOeHvr/fnKH7RXbwx9EX+rDCRIlq2Jm5xInboPcE2Gl1RQFqOIcnWf/lu
yq2C5yNYFFbJ4Kg/jDf2Gx4PMbXHF6fuWQVQkmX1ED92vOaMoViQ+tVxIuCjK9p/
YZROLhg2Z6oz+F84Dm01uf/UT3M5rOsMjKFMnMzH5MIwJiJ+o+89JJgR88/StsNt
pmknBJYUL1uBXpTBWj4haDaetCtsdrioNDNrery4Q9EnQnec33fmPQzhma3B4wJi
87wfes5mUnl71kRDumef+H6lAjP3bmD+463MXuGxj4Pd9NT0WoyRQcMz5X1Ek/qg
kM33EUS0rlXKHEdWhxjL
=6tfG
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Feb_2012_11_40_41_+1100_keDDzuqLViL9K780--
