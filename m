Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2EVCKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:10:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53320 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2EVCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:10:09 -0400
Date: Tue, 22 May 2012 12:10:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the nfs tree with Linus' tree
Message-Id: <20120522121003.f8f163ec2514308b8f000166@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_12_10_03_+1000_icI6.EdUpIFTcnku"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_12_10_03_+1000_icI6.EdUpIFTcnku
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

Today's linux-next merge of the nfs tree got a conflict in
fs/nfs/nfs4proc.c between commit 26fe57502870 ("vfs: make it possible to
access the dentry hash/len as one 64-bit entry") from Linus' tree and
commit 778d28172f71 ("NFSv4: Simplify the NFSv4 REMOVE, LINK and RENAME
compounds") from the nfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/nfs4proc.c
index ab985f6,78784e5..0000000
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@@ -2782,8 -2799,8 +2799,7 @@@ static int _nfs4_proc_remove(struct ino
  	struct nfs_server *server =3D NFS_SERVER(dir);
  	struct nfs_removeargs args =3D {
  		.fh =3D NFS_FH(dir),
 -		.name.len =3D name->len,
 -		.name.name =3D name->name,
 +		.name =3D *name,
- 		.bitmask =3D server->attr_bitmask,
  	};
  	struct nfs_removeres res =3D {
  		.server =3D server,

--Signature=_Tue__22_May_2012_12_10_03_+1000_icI6.EdUpIFTcnku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuvV7AAoJEECxmPOUX5FEj1oP/RpJNdOc4krBO0UxeloC6pg9
f8G+9tqLO7bKmmF4joInTvm+iivaa3dwJYFTj6eaK9CEDsEfLiTXjtQplDNP7xxW
F/SyVnl0xeiVHX++7fqu15h3sc+6CetbpSagiQsRtGKQOnBbbz7QOjKsE87YH6wM
9rl6oz5G7oqOWbBI5d9gfYRIHi6I92Ql4rPXeO4lPoRJt04m3RlXa3XM8XhlyNub
2/cJemLWYS/OJeHWTg9Wva2I6CNTyQWUFnYj2aKKcwDmq2h3965f8I3wriyWFTDg
zFWoqWzaLsnn1igmH120/aJTSe3ivPNFOdbRsC+MzbL1In9vqprM2uzrlO9bpwGP
eYYu/tv6DWUd3+TJ+bCcm5iIkeGTnRlOI/hp+/4e2IzNKs3RDetJ/L4k3UZKcqtA
9oAEuhAULx+7zY++KDahW4qI8Bpr/AGh4uGPkpXoaXRqvYzFMH7bpDt7xj66O/4w
M9GQHK+UdPZR3qguQiJX0Y8ug0lIozTTeSU8U/Q755ItLCqKdZx+tOGYfE1DzZQk
ul4Lbjjt5W8Mk8yIES93XqCaBOyuzCWszRi6uGdgDFNRcC4VEymJI+F1bN5aArhr
YATmnPDZa84dGamfZzYoVGSqVuIzQ5sZ1IodY/TX2nb/0EaFPjgZ3AEpLaIG4q+n
9ZiCNQVwLbRpkp+n7Pd6
=nms4
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_12_10_03_+1000_icI6.EdUpIFTcnku--
