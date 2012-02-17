Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab2BQEKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:10:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42987 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2BQEKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:10:46 -0500
Date: Fri, 17 Feb 2012 15:10:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20120217151030.59ce998d4b844faa0023750b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_15_10_30_+1100_l1GRMH5zDlSwE8C6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_15_10_30_+1100_l1GRMH5zDlSwE8C6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `r2hb_hb_group_drop_item':
heartbeat.c:(.text+0x12cd7a): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2hb_hb_group_make_item':
heartbeat.c:(.text+0x12cdc7): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2hb_alloc_hb_set':
(.text+0x12cf2f): undefined reference to `config_group_init_type_name'
drivers/built-in.o: In function `r2nm_cluster_group_drop_item':
nodemanager.c:(.text+0x12d34f): undefined reference to `config_item_put'
nodemanager.c:(.text+0x12d378): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2nm_node_put':
(.text+0x12d3a0): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2nm_node_group_drop_item':
nodemanager.c:(.text+0x12dc4d): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2nm_node_get':
(.text+0x12e407): undefined reference to `config_item_get'
drivers/built-in.o: In function `r2nm_get_node_by_ip':
(.text+0x12e482): undefined reference to `config_item_get'
drivers/built-in.o: In function `r2nm_get_node_by_num':
(.text+0x12e514): undefined reference to `config_item_get'
drivers/built-in.o: In function `r2nm_node_group_make_item':
nodemanager.c:(.text+0x12e664): undefined reference to `config_item_init_ty=
pe_name'
drivers/built-in.o: In function `r2nm_cluster_group_make_group':
nodemanager.c:(.text+0x12e762): undefined reference to `config_group_init_t=
ype_name'
nodemanager.c:(.text+0x12e77f): undefined reference to `config_group_init_t=
ype_name'
drivers/built-in.o: In function `r2nm_depend_item':
(.text+0x12e878): undefined reference to `configfs_depend_item'
drivers/built-in.o: In function `r2nm_undepend_item':
(.text+0x12e8a0): undefined reference to `configfs_undepend_item'
drivers/built-in.o: In function `r2nm_depend_this_node':
(.text+0x12e907): undefined reference to `config_item_put'
drivers/built-in.o: In function `r2nm_undepend_this_node':
(.text+0x12e973): undefined reference to `config_item_put'
drivers/built-in.o: In function `init_r2nm':
nodemanager.c:(.init.text+0xefdb): undefined reference to `config_group_ini=
t'
nodemanager.c:(.init.text+0xf00f): undefined reference to `configfs_registe=
r_subsystem'
drivers/built-in.o: In function `exit_r2nm':
nodemanager.c:(.exit.text+0x99b): undefined reference to `configfs_unregist=
er_subsystem'

This after I moved the tmem tree to before the staging tree to fix
yesterday's build failure.

I have cherry-picked Greg's patch to disable building of the ramster code
for today (since it wasn't in his tree when I fetched it this morning).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_15_10_30_+1100_l1GRMH5zDlSwE8C6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPdM2AAoJEECxmPOUX5FEQN8P/2qRwDUGdbxc30eXOg6SgskF
5qW+HHjFUR2j8oAXSUuRsfhutOE+yrCySApEal5Fesl33FU1xeX9clsnFt9pYkrf
vnGEQl2yktjLAjPsroV14EaQiw7j0Mm04MmRO4QJOsX15wdsDRY54UhT293LmlYf
tydADKwEVynrWQz5IOW63Vi9wRnGh0bIyvQDvSUQ8X9EO75wYoFJ30lPuOKk8FZ1
pGXCmLihNbh4FXpQBzMsJCt4+9H8pD0B1JbtIOO96TE3CXmav3H/Z0MkmtqPqome
Y0MIviYNcr+RvosKc4ft6gYBTJH/QwqxF9aXJSKG/Q0MH19GXZJuh6iM63qGIocS
Fdf6vWWp12uLjy1NwHJ64lJyiG3f0+ELBWuNZbpuWyOLQTlHPUVPWZ9o4/hscM/M
XkFVt+LEviP/7EiZVeKf0bXIARHC47basoJewcETQgL0b2xNz8mSLNVMkEnOnqMc
WwxvLXOfmdvihXzXGE+B8DWMjLjjhT1IiSTuzvNC7wCl6f/AkmXBSbIyoxi7YPP5
qc/I4HX2q68nLJtmGcMwg1rLIXuM17wqQmA1U7oWzLjJ4ZgtQi4jjWI8eF/LYNOo
256HDYnaBCIY+rcDA7EZ+6tYCrwGBVprsOfWLPfTcOo2CMWKfti5myYAHkMmqunM
NRNbpD4quTarOyRVkpHu
=QsGx
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_15_10_30_+1100_l1GRMH5zDlSwE8C6--
