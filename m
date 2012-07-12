Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2GLCKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:10:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36315 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2GLCKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:10:00 -0400
Date: Thu, 12 Jul 2012 12:09:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Hadar Hen Zion <hadarh@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the infiniband
 tree
Message-Id: <20120712120950.223be053857381046b7d5db6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_12_09_50_+1000_pdnzaz+9F0Ba7ZsB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jul_2012_12_09_50_+1000_pdnzaz+9F0Ba7ZsB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/ethernet/mellanox/mlx4/main.c between commit 6634961c14d3
("mlx4: Put physical GID and P_Key table sizes in mlx4_phys_caps struct
and paravirtualize them") from the infiniband tree and commit
0ff1fb654bec ("{NET, IB}/mlx4: Add device managed flow steering firmware
API") from the net-next tree.

Just context changes (I think).  I have fixed it up (see below) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/mellanox/mlx4/main.c
index 5df3ac4,4264516..0000000
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@@ -1232,10 -1231,26 +1258,29 @@@ static int mlx4_init_hca(struct mlx4_de
  			goto err_stop_fw;
  		}
 =20
 +		if (mlx4_is_master(dev))
 +			mlx4_parav_master_pf_caps(dev);
 +
+ 		priv->fs_hash_mode =3D MLX4_FS_L2_HASH;
+=20
+ 		switch (priv->fs_hash_mode) {
+ 		case MLX4_FS_L2_HASH:
+ 			init_hca.fs_hash_enable_bits =3D 0;
+ 			break;
+=20
+ 		case MLX4_FS_L2_L3_L4_HASH:
+ 			/* Enable flow steering with
+ 			 * udp unicast and tcp unicast
+ 			 */
+ 			init_hca.fs_hash_enable_bits =3D
+ 				MLX4_FS_UDP_UC_EN | MLX4_FS_TCP_UC_EN;
+ 			break;
+ 		}
+=20
  		profile =3D default_profile;
+ 		if (dev->caps.steering_mode =3D=3D
+ 		    MLX4_STEERING_MODE_DEVICE_MANAGED)
+ 			profile.num_mcg =3D MLX4_FS_NUM_MCG;
 =20
  		icm_size =3D mlx4_make_profile(dev, &profile, &dev_cap,
  					     &init_hca);

--Signature=_Thu__12_Jul_2012_12_09_50_+1000_pdnzaz+9F0Ba7ZsB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/jHuAAoJEECxmPOUX5FEZQ8P+gLLWSj9a99XcmAur2V9iA/J
0e45RhoEug5TZvnW6DFfCAIxQQ2vcUgQttPzjwx6gXEId/E1LM92Uc42sLjYgfqf
m6kCM6HModyOxihQ46hlaW2w2s4eI26fCSA8vivf3YEtJJ/bQodVYgOoAAc4uKA1
yNSET1INTkpSU2qfhxNKrtz1gz3bWyy2xs3vgn6I6tGAnijn1cAGVuEJVl0DAr58
OxF9tor/Mct30fFaLaQ+u6YSzq3/4nRuWxQyijAChrEIM4+oeuH3iDOxhQIZCf/m
sYOy+SGE+/hnkMXcKWObhngiZdfyqauKYeN+iMy/2NirvZQu7FcC5cTz7Y5pDUd1
bJDfMtM3ozesBak+1sbGfGPPdinPNhgRa5js1BNx57OdjoU9LhTx460GhcnjL7Q7
0AhltNCVGSU2O+Fikq7hvQF0eMS7fLTOsJiQbKeRoA0F4sHO5PKQgUsxIXaPW5Cy
Uo7JoscmwWHf9eKnxhVzXJAI+dBIv60IC/cxBo1aslv0BCrdDXnFGCHNsUYK/v8y
SPs+NxcXl16WwOtI6YZFzTdT3tE9l62PgDxbR8L6z4d8ldat2fG4sVPraUmx4aTR
hnZalOcI/bOWCkKheSBHCisFFGopI3Ne7jSjLkehsnrdCpFS9ZVni04CGKwixoeM
vubOGMBXhZ8NXBTVbXWB
=1ReT
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_12_09_50_+1000_pdnzaz+9F0Ba7ZsB--
