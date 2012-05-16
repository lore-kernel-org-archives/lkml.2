Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966418Ab2EPCt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:49:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52451 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2EPCty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:49:54 -0400
Date: Wed, 16 May 2012 12:49:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20120516124942.5d776132d69f82bd8ed50e08@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_12_49_42_+1000_OwxR31zA5g0RAQ2k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_12_49_42_+1000_OwxR31zA5g0RAQ2k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/super.c: In function 'nfs_get_cache_cookie':
fs/nfs/super.c:2361:12: error: 'struct nfs_server' has no member named 'fsc=
ache_key'
fs/nfs/super.c:2362:16: error: 'struct nfs_server' has no member named 'fsc=
ache_key'
fs/nfs/super.c:2363:16: error: 'struct nfs_server' has no member named 'fsc=
ache_key'
fs/nfs/super.c:2367:2: warning: passing argument 3 of 'nfs_fscache_get_supe=
r_cookie' makes pointer from integer without a cast [enabled by default]
fs/nfs/fscache.h:173:20: note: expected 'struct nfs_clone_mount *' but argu=
ment is of type 'int'

Casued by commit 2311b9439ce8 ("NFS: Don't pass mount data to
nfs_fscache_get_super_cookie()").  This build has CONFIG_NFS_FSCACHE
unset.  grep is your friend.

I have used the nfs tree from next-20120514 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_12_49_42_+1000_OwxR31zA5g0RAQ2k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsxXGAAoJEECxmPOUX5FEuWIP/ii/IEVnZZAxXcN7WvJ5e3NS
DxDYf9F+Pb8viW+CX/uLu0dtayRE1JPUw3dEDLek9JzkXj+VcmvM2YCcqPjkBs0S
rObcogYMkiXu0sIbKixOPoCLRfJ5VEH/HpPrD4XOdpjOktq9m5bejEp9IymbGdCe
5H/TVXKf6sMQaQ7vhEcQoG2b2RRGF8Xhesy0S8PA/htvg8QfbJ4mWuF8BhN3vwnf
RRtxdw7z7eHShOllukl1HWQwEJtbH6sN91KXAOib3BLgscJwd/AgZDRKUM3ATWju
ZqSz849IAOCpVvLOVTB4a891DBplAMtX1Zns3h5PozZUCJCqXXwRVHv20e7Jm0R5
N5RwLJ2qs9jEmdyQm7dtYlTo6gRoP5RyY7iiEzU2fjsMpYllbMMWktL3N+habwPG
d1XkAYSuG29ACmseZM0kXz8pXMa20P0dFiWkDfXmEO4hGIiJYX57eJABTkYtgYT3
E9/Qyo++pgcAuFrs7YjjvpQqmxDlAToD1BzYz8ynuXwVMqOszYlfFPdXPiRKdOR0
vExsEn3N0AwLUmi4SXO003URNci4vBnrhwRV77KvCYb+J8krUnXZ8qogdLniZXvp
XBtt42T5wJg4lH+lrN6+PpVWqh+J7Ae2e4IGMpN0Cua4beXWcEc3DBQB1pKqRmYk
Gt2fzs1jm3MLlNNsFnpD
=qSv9
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_12_49_42_+1000_OwxR31zA5g0RAQ2k--
