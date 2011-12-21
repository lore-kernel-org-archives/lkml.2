Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1LUASO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:18:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48513 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1LUASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:18:11 -0500
Date: Wed, 21 Dec 2011 11:18:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20111221111801.75611ea16ad03f68e9856bd2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_11_18_01_+1100_g_SF3NmD42vX/vOd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_11_18_01_+1100_g_SF3NmD42vX/vOd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/ioctl.c between commit 5e8af306ef80 ("ext4: fix potential
deadlock with setuid files and EXT4_IOC_MOVE_EXT") from theext4  tree and
commit 99b4f71273d9 ("vfs: mnt_drop_write_file()") from the vfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/ioctl.c
index ff1aab7,d37b3bb..0000000
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@@ -246,7 -246,9 +246,7 @@@ setversion_out
 =20
  		err =3D ext4_move_extents(filp, donor_filp, me.orig_start,
  					me.donor_start, me.len, &me.moved_len);
- 		mnt_drop_write(filp->f_path.mnt);
+ 		mnt_drop_write_file(filp);
 -		if (me.moved_len > 0)
 -			file_remove_suid(donor_filp);
 =20
  		if (copy_to_user((struct move_extent __user *)arg,
  				 &me, sizeof(me)))

--Signature=_Wed__21_Dec_2011_11_18_01_+1100_g_SF3NmD42vX/vOd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8SW5AAoJEECxmPOUX5FEpdsP/3EdSBpAUpFmxUKWfLOHTHLG
wpLuKiV9KD5AH7jlfywmufF9sVD2UrDNIu7xfjhbZE2E2yzUlrWnBibT18SI+DXt
1foSd/jPKitDEdNwlh6d4+L8Lm34C3zquHHT9EALC314qIqcQ3y5POiWKVJbFBcD
5nXW9ym3gG5OG/Gvvxi6YppYpVOvo3MUcL3HvRUSBJZu2dDkTO5ACfkZ7aY4re9P
24edg56doJ36AOjQZQZU0YJ6EhvTaNE6CnZHtxdHiLMj03i3qtJpqWfEG5ZKhelE
vr55k7Pb+oeoyNi2Tt5NvyJLBaHGwcu7S9GRQvdk2W7IwD97LSk/3DAQCgizFjTe
5hZXIw9qvVoNlJfo+iunNgwKE6dQzaeJmR14jQRH9a25/uzgjsVKMNxpB1fFM3wB
kM47kvcSgey6HecTwEsYlslGQX7H3bJ82EfFsx6Z4C7DqeKFLeHrwIDukO8OC0gN
1ntVEtZgMu9gvTWHdyXdmlRWo634usMDEhKvRdO5/XtHaNa/Rqne8UlSTNLw/KdI
ISZRqz5CQqpO+1+vTNx7E8qcuMUsMTxENlCh3d5CNZkQKwCAUbYuUfteXG63sJIi
Pp+WfiT1Z6EvSSNZuuySqni1Ct81QUjOfdZQnXUFudSdax9cZv0HnPDJKNCyL2yX
k68/REMtBArs4rp9VLnO
=jnBg
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_11_18_01_+1100_g_SF3NmD42vX/vOd--
