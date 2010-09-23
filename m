Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0IWBUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:20:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46744 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IWBUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:20:09 -0400
Date: Thu, 23 Sep 2010 11:20:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20100923112004.b47923b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_11_20_04_+1000_VmlG_6+.M+3MrtVF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_11_20_04_+1000_VmlG_6+.M+3MrtVF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/file.c: In function 'cifs_writepages':
fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named 'tcon'
fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named 'tcon'
fs/cifs/file.c:1366: error: 'struct cifs_sb_info' has no member named 'tcon'

Caused by commit 2eff6be391f00d606b43e60d9727b70c44917b7e ("cifs:
temporarily rename cifs_sb->tcon to ptcon to catch stragglers").

Really, such testing code should not be in linux-next ...

I have used the cifs tree fomr next-20100921 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_11_20_04_+1000_VmlG_6+.M+3MrtVF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmqtEAAoJEDMEi1NhKgbslIcH+wbgmWft1bgYI1bKhVx0MYqJ
jEJmU4qsk6b1VOHy8TeMnh7qDsZo6eh0531LEP9EWlR9qvyoZ0EisyVoQZCvVbPi
9uaFDxEKtxOhcC4UwDyqSTk+AH82OBm75AYm40MyQZXCCLKED2NQPh1+rgkWtRHo
o6hrHYu8Ci3+B49Knf71vgvSWEOZQIJ5hnKqe9E9KJWHtWfoRgmYwuF2lZhtVEnD
VrXC4TKC1WdWu+6hqVnuvK/DSWDOGFcURi7nj3Dl9LPHwHMn4rgPjEQMUMVWbKKo
l2Oa9fj39AGOG7aOs7uabMYNH0UAc20u1fG+7J/eC7u4Kl9GSsaitxg6r5yxXv4=
=X3SY
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_11_20_04_+1000_VmlG_6+.M+3MrtVF--
