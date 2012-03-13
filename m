Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2CMDTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:19:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45280 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2CMDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:19:09 -0400
Date: Tue, 13 Mar 2012 14:18:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the l2-mtd tree with the vfs tree
Message-Id: <20120313141859.302878a8e2246979c288440d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_14_18_59_+1100_SuclbATR4GqMGJfj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_14_18_59_+1100_SuclbATR4GqMGJfj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
fs/jffs2/fs.c between commit de071e1a7466 ("switch open-coded instances
of d_make_root() to new helper") from the vfs tree and commit
ab9b393d6ee8 ("jffs2: Convert most D1/D2 macros to jffs2_dbg") from the
l2-mtd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

[Al, I suspect that your patch should have changed the debug print as
well ...]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/jffs2/fs.c
index c0d5c9d,43052fa..0000000
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@@ -560,10 -572,10 +572,10 @@@ int jffs2_do_fill_super(struct super_bl
 =20
  	ret =3D -ENOMEM;
 =20
- 	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): d_alloc_root()\n"));
+ 	jffs2_dbg(1, "%s(): d_alloc_root()\n", __func__);
 -	sb->s_root =3D d_alloc_root(root_i);
 +	sb->s_root =3D d_make_root(root_i);
  	if (!sb->s_root)
 -		goto out_root_i;
 +		goto out_root;
 =20
  	sb->s_maxbytes =3D 0xFFFFFFFF;
  	sb->s_blocksize =3D PAGE_CACHE_SIZE;

--Signature=_Tue__13_Mar_2012_14_18_59_+1100_SuclbATR4GqMGJfj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXryjAAoJEECxmPOUX5FEYa4P/Ap8yQ74ao1Ih1s2B4Y2lznq
AfmimLg704VO4zE44+tY5virObCXOpM97FYKoxKQb2m5V96lWP60ISKRmQwNyvHg
WMBKqealAUFZoRIiWqtN+1yK3j5hAf7BGV3BNvcsMXS7zL2Et31I8Id6NVNAmEFH
G8WxB/05RAhEWFPiuplKwGcvTdkAnJXMVw9kEfSSgT7tWGH7GpgaXbxx+xvVWiVm
nlVPn2ZREVG0+xhBPrKvHGFX2Wp/gX3eqg+RYoLtI3Fdm3SQI6A1YvEoGxWZ+etz
wi9zmzSiiao6KQS++U/1x129CRFSzK5OGUZCzmhonAyDx+mfHBlONYnzP6kc/nBF
kFkosTIkC97pLvF4Z2jNOikH0EstHPOmqOukqZVHBACCU+lt0kYiTwJiAZNg45Q0
4twSkEDnbgjbir0eM2HnUEnRK5yOybMgt5apqtKjBHf4YLNBq9onq+IbvLPyDKfR
RokkuV3phsTIiIX22WJQbfXBgQaVwf4U2JgcLtoHf1jT0hPpPjKCMg7p2mIlM7Kw
/ttuvh3LnXrVzjcfH4jpq0D7RjR1tUwJpO1oYw/fQUK+VXGl3ZIAVu+oIURctuVE
ftZoIBIwNi9x0AIQUB3L9ObES+yyrHXIF7xfjLq2l1RWoEM6/jj81Pm/oue0BvER
3bTMUUmgB04fpv9pTvy2
=e6/O
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_14_18_59_+1100_SuclbATR4GqMGJfj--
