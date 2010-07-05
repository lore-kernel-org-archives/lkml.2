Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0GEABd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:01:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35471 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0GEABc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:01:32 -0400
Date: Mon, 5 Jul 2010 10:01:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build warning after merge of the vfs tree
Message-Id: <20100705100121.d089bf12.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Jul_2010_10_01_21_+1000_+1uQkm45lh48RSCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Jul_2010_10_01_21_+1000_+1uQkm45lh48RSCF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

fs/cifs/cifsfs.c: In function 'cifs_drop_inode':
fs/cifs/cifsfs.c:481: warning: 'return' with a value, in function returning=
 void
fs/cifs/cifsfs.c:483: warning: 'return' with a value, in function returning=
 void
fs/cifs/cifsfs.c: At top level:
fs/cifs/cifsfs.c:491: warning: initialization from incompatible pointer type

Introduced by commit 12420ac341533f3715b3deb788637568f22b78ff ("cifs:
implement drop_inode superblock op") (which entered Linus' tree on June
28) interacting with commit 1fd3b83deb5125288bee98f32a41c3267b8ed534
("Make ->drop_inode() just return whether inode needs to be dropped")
from the vfs tree.  I guess the cifs tree was missed bye the vfs tree
update.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Jul_2010_10_01_21_+1000_+1uQkm45lh48RSCF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMMSDRAAoJEDMEi1NhKgbsj/oIAI4yfnoG//KXXBKGY4fHBKIF
xKD5xJgGrYcdqBRFp8WwkNadeVfLNDTSExzjDNC/pV/Q407XKt3gqKXYInIRXUtQ
/mx27D5ZxpET16Y6xZM8yTQIxgzrxdp2ANq8NNUTxJqOBFiSG8GHPs5qNat5Cnxz
8XN7RHoI1JsRLD/zZgblr7ker6JFkqKWqSkV8es9KCT93fUIH39U4xccceF3ITS7
gvrUdxUlykB0NAWSDoNEl0N5FkwelVraJ47ICNg29sj5odL32329LnjgCrr7QMv7
MHE6yIddL9b8V9Y8RcPHJW/jYgd4VlRe+Fkd+cClMPR8vjlClDDYPvHtZh/J7iU=
=KNhN
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Jul_2010_10_01_21_+1000_+1uQkm45lh48RSCF--
