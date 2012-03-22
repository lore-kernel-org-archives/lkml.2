Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381Ab2CVC4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:56:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36876 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2CVC4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:56:36 -0400
Date: Thu, 22 Mar 2012 13:56:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Vinod Koul <vinod.koul@intel.com>, Huang Shijie <b32955@freescale.com>
Subject: linux-next: manual merge of the l2-mtd tree with theslave-dma tree
Message-Id: <20120322135629.65b2377c86d6605957086587@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_13_56_29_+1100_vcA=PV29BuBjZTr4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_13_56_29_+1100_vcA=PV29BuBjZTr4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mmc/host/mxs-mmc.c between commit 16052827d98f
("dmaengine/dma_slave: introduce inline wrappers") from the slave-dma
tree and commit c790d78c631f ("mxs-dma : rewrite the last parameter of
mxs_dma_prep_slave_sg()") from the l2-mtd tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/mxs-mmc.c
index 65f36cf,4062812..0000000
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@@ -324,8 -324,8 +324,8 @@@ static struct dma_async_tx_descriptor *
  		sg_len =3D SSP_PIO_NUM;
  	}
 =20
 -	desc =3D host->dmach->device->device_prep_slave_sg(host->dmach,
 +	desc =3D dmaengine_prep_slave_sg(host->dmach,
- 				sgl, sg_len, host->slave_dirn, append);
+ 				sgl, sg_len, host->slave_dirn, flags);
  	if (desc) {
  		desc->callback =3D mxs_mmc_dma_irq_callback;
  		desc->callback_param =3D host;

--Signature=_Thu__22_Mar_2012_13_56_29_+1100_vcA=PV29BuBjZTr4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapTdAAoJEECxmPOUX5FEt6MP/2zPsswX6tbc/CZ6w6lDqvBc
d2VE4nIrXUGKIM9xJitXj0Ukstg5j5h1h0qv/sJMUAWRDhj2zGefd8JENCb92xs1
kLASDZ6+aH+EnjVjP47a2XpWGK/o0ube/O3pbzglXSj6SERij8ad29awcUsMH8Ik
1Clkblrfhj9pf2yX0942UZtBadH06cfpXmhp6F0jdi48djpZMVBVCqB8ZjbEjs1S
1sguH4YSdJSLgRw94odnA6cx+8/OnviMPk5TYiiMZnDiok6Sgki6H/OjTxdtbIqx
hke++LrddU/DnBIsG9j9vWMI1IixgnJOUrohKFlKHdmmiZNZfFRHSR05ngL4F3wn
4Mrh6fXriI417l7dST8B1EnOozHn+zpVHXhYAujQGiC0BmcjWG8Cd9UG3D0DBqM/
JWGjhIp2HvuxzDU8bAHiwtmGXx+ezpvmdqZOXRwR5LLcYDFdnisn07HrTycoouIW
EN40c0us1UL42AYzj9GceFHM+qu0JsmkWumaIuNsIFTiyeqPP+8827d/2jI3nfgx
A5eBNTdlWjGYuJ+y46hfi+3lhMWE1yeR5noLJC5zVIhs2GrCCAxHr23u+44QaOb7
np9ZbhdmAKOdT76bgwUVDgsRAKOSPlweYpLkmI1T0tqfpepbxT1bVLjwO7iW2BJA
HjQAn7hXsQPsXE2uReGc
=kk8P
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_13_56_29_+1100_vcA=PV29BuBjZTr4--
