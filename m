Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2I1BNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:13:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50799 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2I1BNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:13:12 -0400
Date: Fri, 28 Sep 2012 11:13:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hadar Hen Zion <hadarh@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-Id: <20120928111303.2963979b43b08a07138a6b29@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Sep_2012_11_13_03_+1000_7+BZhSEYlwZo6MUI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Sep_2012_11_13_03_+1000_7+BZhSEYlwZo6MUI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/net/ethernet/mellanox/mlx4/mlx4.h between commit a8edc3bf05a3
("net/mlx4_core: Put Firmware flow steering structures in common header
files") from Linus' tree and commit 6b6f29c687ce ("mlx4_core: Stash PCI
ID driver_data in mlx4_priv structure") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/mellanox/mlx4/mlx4.h
index dba69d9,f7156b7..0000000
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@@ -690,82 -692,11 +692,87 @@@ struct mlx4_steer=20
  	struct list_head steer_entries[MLX4_NUM_STEERS];
  };
 =20
 +struct mlx4_net_trans_rule_hw_ctrl {
 +	__be32 ctrl;
 +	__be32 vf_vep_port;
 +	__be32 qpn;
 +	__be32 reserved;
 +};
 +
 +struct mlx4_net_trans_rule_hw_ib {
 +	u8 size;
 +	u8 rsvd1;
 +	__be16 id;
 +	u32 rsvd2;
 +	__be32 qpn;
 +	__be32 qpn_mask;
 +	u8 dst_gid[16];
 +	u8 dst_gid_msk[16];
 +} __packed;
 +
 +struct mlx4_net_trans_rule_hw_eth {
 +	u8	size;
 +	u8	rsvd;
 +	__be16	id;
 +	u8	rsvd1[6];
 +	u8	dst_mac[6];
 +	u16	rsvd2;
 +	u8	dst_mac_msk[6];
 +	u16	rsvd3;
 +	u8	src_mac[6];
 +	u16	rsvd4;
 +	u8	src_mac_msk[6];
 +	u8      rsvd5;
 +	u8      ether_type_enable;
 +	__be16  ether_type;
 +	__be16  vlan_id_msk;
 +	__be16  vlan_id;
 +} __packed;
 +
 +struct mlx4_net_trans_rule_hw_tcp_udp {
 +	u8	size;
 +	u8	rsvd;
 +	__be16	id;
 +	__be16	rsvd1[3];
 +	__be16	dst_port;
 +	__be16	rsvd2;
 +	__be16	dst_port_msk;
 +	__be16	rsvd3;
 +	__be16	src_port;
 +	__be16	rsvd4;
 +	__be16	src_port_msk;
 +} __packed;
 +
 +struct mlx4_net_trans_rule_hw_ipv4 {
 +	u8	size;
 +	u8	rsvd;
 +	__be16	id;
 +	__be32	rsvd1;
 +	__be32	dst_ip;
 +	__be32	dst_ip_msk;
 +	__be32	src_ip;
 +	__be32	src_ip_msk;
 +} __packed;
 +
 +struct _rule_hw {
 +	union {
 +		struct {
 +			u8 size;
 +			u8 rsvd;
 +			__be16 id;
 +		};
 +		struct mlx4_net_trans_rule_hw_eth eth;
 +		struct mlx4_net_trans_rule_hw_ib ib;
 +		struct mlx4_net_trans_rule_hw_ipv4 ipv4;
 +		struct mlx4_net_trans_rule_hw_tcp_udp tcp_udp;
 +	};
 +};
 +
+ enum {
+ 	MLX4_PCI_DEV_IS_VF		=3D 1 << 0,
+ 	MLX4_PCI_DEV_FORCE_SENSE_PORT	=3D 1 << 1,
+ };
+=20
  struct mlx4_priv {
  	struct mlx4_dev		dev;
 =20

--Signature=_Fri__28_Sep_2012_11_13_03_+1000_7+BZhSEYlwZo6MUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQZPmfAAoJEECxmPOUX5FEKOoQAJekwG6EweGvIJe+qU+0EOUc
yScWS6rWnAml3PIf2rrWsLWV8G0H62sNrOiInrXhucW7QDDgLcbw6Sk1WNyEDo0f
oAx4+wqSrTWxPpa38CvNedRUfPXaJb74/UinCIBTK6eb9RwBmFfKmUXp0fVVuIPO
AQuRoJDFMYa3zlztIGI2Y1oIYaSu2sS9v91Q2OHUFxmfRVYDnoLrWf1zzHrvXcwD
CilVv3D2IP1aD915j9rJQj1peRUlDyL/7LSMxUpKOJPSnx7hfHuIOA+q4uqstVJr
SLS2d8oPCCHhXw6xQNuqdxKcwLIY+3+XFGzvcWJKziRPXpzXcq3N+LwheSjozW1a
UXLI2booXq55zMMkWkA1KJlW7ovY8R1g2MCQdez9bRLUgl1C5D4vy53OVyso14Zd
tPhtW1wJsfC4lP1Cd6zayeJ1HfPHseIe0J+llBRNleBveL80G3j4Mkm8HFZ24xXz
5fplQTVh8DHrYVlTaVj0YF6Wm/NP4OYqKWk3Hw1m2bWS6G30qM3Ly+H3aDl3yamJ
MngWcqWmxnup/S9qfzQOvxWeAMSAGuHtLDbV8FQlNnJeAIbqokGCRWUmChwHaGip
FuY0OqcB704kg6hi6I3aWw7VpgdBNPkFHpgEShognZNrMz7jlP0If//0Jfg9TKvV
Jl0NJOlwxs+0OUrZKje/
=ZxUx
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Sep_2012_11_13_03_+1000_7+BZhSEYlwZo6MUI--
