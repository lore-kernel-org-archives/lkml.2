Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1KKBAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:00:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36833 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KKBAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:00:23 -0500
Date: Fri, 11 Nov 2011 12:00:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boojin Kim <boojin.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the slave-dma tree with the s5p tree
Message-Id: <20111111120013.e425db4686acbd346e10a49b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Nov_2011_12_00_13_+1100_ASC/S.0MAtN/PJ4J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Nov_2011_12_00_13_+1100_ASC/S.0MAtN/PJ4J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/pl330.c between commit c6e00b47067b ("DMA: PL330: Add device
tree support") from the s5p tree and commit dab6538e29e6 ("DMA: PL330:
Fix build warning") from the slave-dma tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/pl330.c
index a626e15,186b822..0000000
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@@ -870,8 -856,8 +870,8 @@@ pl330_probe(struct amba_device *adev, c
  	INIT_LIST_HEAD(&pd->channels);
 =20
  	/* Initialize channel parameters */
- 	num_chan =3D max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
- 			(u8)pi->pcfg.num_chan);
 -	num_chan =3D max(pdat ? (int)pdat->nr_valid_peri : 0,
 -					(int)pi->pcfg.num_chan);
++	num_chan =3D max(pdat ? (int)pdat->nr_valid_peri : (int)pi->pcfg.num_per=
i,
++			(int)pi->pcfg.num_chan);
  	pdmac->peripherals =3D kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
 =20
  	for (i =3D 0; i < num_chan; i++) {

--Signature=_Fri__11_Nov_2011_12_00_13_+1100_ASC/S.0MAtN/PJ4J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOvHOdAAoJEECxmPOUX5FEzzIP/AgLG0xN3oQOHL0zhsH7KpMI
MwpAq5aggaBzlCU5mPipHlaJzawj317w4oEBku1zWzjxW3R33YTBs+b2SA7xxpmy
T8+8sr8RWFBIkEDLQjwAp6We+jJg/KUzfGst9T4y4poX4IXYntCBGBaZNJMqbf1y
KcACzDsVjv5jDg7A/UyGp/PoIQBBrc27x6yiGmqn5QsV6XPac6wFRPTp12/Gs0zv
3HDiNNtWTjW6RdC4grCtNS53c8PLmE0xmzmIoj1KLE5jkjXezopQzrSQUL3sCxnf
HlZd+bVNjZ9/NPTi+InevXdESfMvFw7ZjQYdep5E5FJ98A8PM8TTr+HVDRYwi98e
LSmedOCQ0GSXGJVpvbq5b1Rt6tTUI4gzg96QD4KOVbSqCmtVUdh7M8KdqTO24Qpj
3eG38j8HT5AHZgKSXPK2J6k8IF/GT2qgbHZGI71E43MSRDGoRjS9Jmpd1EpXUJQa
78pCUWFZeMWggT8CbgvAy0IrSyj8MEE4HQIJrC9fmn/O5EbLtqzNrcD8IjLlSJXe
BERChRe1EGBzkaMbRl+EYpKn0w5YrGbILj23rR1+gWe9TNbqzNv2NL1s6GuCD52s
ipRElKPMU4TG2IgRzPkw24VEYPCTPTYui6f6Bxgvh3aqgBXH+v4HTXGYSWlC445f
gsCESoZm2CrXrMoGHq9T
=/U1w
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Nov_2011_12_00_13_+1100_ASC/S.0MAtN/PJ4J--
