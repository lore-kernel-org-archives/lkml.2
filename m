Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2GVBo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 21:44:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56857 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2GVBoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 21:44:24 -0400
Date: Sun, 22 Jul 2012 11:44:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the mmc tree with the slave-dma tree
Message-Id: <20120722114409.2437cbc5ad4835dd99089e6d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_11_44_09_+1000_Ev4vqNkPf=LoUAGc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_11_44_09_+1000_Ev4vqNkPf=LoUAGc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/sh_mmcif.c between commits 916001fe33b7 ("mmc: sh_mmcif:
remove unneeded struct sh_mmcif_dma, prepare to shdma conversion") and
0e79f9ae1610 ("mmc: sh_mmcif: switch to the new DMA channel allocation
and configuration") from the slave-dma tree and commit bf68a812f06c
("mmc: sh-mmcif: add OF support, make platform data optional") from the
mmc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sh_mmcif.c
index 0f07d28,b2af713..0000000
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@@ -372,14 -376,17 +374,14 @@@ static void sh_mmcif_start_dma_tx(struc
  static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
  				 struct sh_mmcif_plat_data *pdata)
  {
 -	struct sh_dmae_slave *tx, *rx;
 +	struct resource *res =3D platform_get_resource(host->pd, IORESOURCE_MEM,=
 0);
 +	struct dma_slave_config cfg;
 +	dma_cap_mask_t mask;
 +	int ret;
 +
  	host->dma_active =3D false;
 =20
- 	if (pdata->slave_id_tx <=3D 0 || pdata->slave_id_rx <=3D 0)
 -	if (!pdata)
++	if (!pdata || pdata->slave_id_tx <=3D 0 || pdata->slave_id_rx <=3D 0)
  		return;
 =20
  	/* We can only either use DMA for both Tx and Rx or not use it at all */

--Signature=_Sun__22_Jul_2012_11_44_09_+1000_Ev4vqNkPf=LoUAGc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQC1rpAAoJEECxmPOUX5FEIvwP/2nU1BqXYOMibs3azm5JS7Wy
BpQS1xPhqnnD6Zt72A6OPJ5Os460zZPP//Hf69ceNhPEBGtSPWPJK/pB1nyUoD9V
1EvGiwkx9AxM8UIMvRjW0GuThyyj037ruN+H9bF//S1IfwYcQ4IQbviarJtlRQOJ
GhdR1FWTArycNC26M8YyrHojIWZVSk7UU1Rrdt/8ydkwGKHIlnginL86BjFhqP7j
Pf/akWIZQ4LS7F+YUnLvQmFGfvXuP1blABybFTlr6Zbhh06KXAbTlAKz21+dXz32
hb3WJ1ZMIP3LGFBXUYKL6eCmo56H3x36pAD9xGJHRF8tKDh3L3AQrpeAkOLhHFwg
/eylUbsYTOFwiEeIWvbUqm8hESI6ZGgArxMo8ZTRcXcW1fijGBhd1qMgB5v3tFqn
qLJ+s21sj8vSJhF9RY40bVCcmDY0Ga4TQvYAUT2FTKtDVYg6copA8aIaqvOUwEN7
vso/RFpN0X0cv4iqNdc+HUVy+MAlZmyC1G0hweIPFvtOapnn7kejslvZOYn9c6kq
p3TSLhyVpq1AUE2M/Wo+MIglrH/Fjdj7oUD7gfrq14pR4PFVoygbQUmhQTpAC8/u
kA2vl0LxpYT0NjqIpnTxKOhKQ3akaGlTPRmNLgivpXriAASwqrO8OVLCBUGnnvbS
XE/md/7KI42FCwmDHkrR
=Gtp3
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_11_44_09_+1000_Ev4vqNkPf=LoUAGc--
