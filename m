Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1KBBAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:00:15 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56994 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1KBBAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:00:12 -0400
Date: Wed, 2 Nov 2011 11:59:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the ext3 tree with Linus' tree
Message-Id: <20111102115957.debce4217875e9f7d4e427da@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_11_59_57_+1100_zmTD8GfE=qUl2t/o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_11_59_57_+1100_zmTD8GfE=qUl2t/o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

Today's linux-next merge of the ext3 tree got a conflict in
fs/udf/udfdecl.h between commit b9075fa968a0 ("treewide: use __printf not
__attribute__((format(printf,...)))") from Linus' tree and commit
7e273e3b41e3 ("udf: Promote some debugging messages to udf_error") from
the ext3 tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/udf/udfdecl.h
index dc8a8dc,79aae3f..0000000
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@@ -16,6 -18,21 +18,21 @@@
  #define UDF_PREALLOCATE
  #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 =20
 -__attribute__((format(printf, 3, 4)))
 -extern void _udf_err(struct super_block *sb, const char *function,
 -		     const char *fmt, ...);
++extern __printf(3, 4) void _udf_err(struct super_block *sb,
++				     const char *function,
++				     const char *fmt, ...);
+ #define udf_err(sb, fmt, ...)					\
+ 	_udf_err(sb, __func__, fmt, ##__VA_ARGS__)
+=20
 -__attribute__((format(printf, 3, 4)))
 -extern void _udf_warn(struct super_block *sb, const char *function,
 -		      const char *fmt, ...);
++extern __printf(3, 4) void _udf_warn(struct super_block *sb,
++				      const char *function,
++				      const char *fmt, ...);
+ #define udf_warn(sb, fmt, ...)					\
+ 	_udf_warn(sb, __func__, fmt, ##__VA_ARGS__)
+=20
+ #define udf_info(fmt, ...)					\
+ 	pr_info("INFO " fmt, ##__VA_ARGS__)
+=20
  #undef UDFFS_DEBUG
 =20
  #ifdef UDFFS_DEBUG

--Signature=_Wed__2_Nov_2011_11_59_57_+1100_zmTD8GfE=qUl2t/o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsJYNAAoJEECxmPOUX5FERNMP/1lS/GWeq1m+GSDxd5H/npmX
/93K24v9lHrBAryNzjFMyGDkE6mCMBkcMn/YrjQ1+sW/BPY/i/bnee+TAdbECX4i
lcb6bIRs2/dyDVnF2yn9y+AQqzGJVQ37qpnCQ04XIlHsR12QkgyALoIUCbUDQi1p
AyQemRVpoaQ5n7p2GkQq064WMvRSpITqNXqJyBsxO6sniUTB1DR4K/TdeJoDV+oV
IvKKsGr4lf/1pBQL3/pTtryKMcwlNl+Ls84yyh6NAPpa90N2C97lKbJCJrt7Wq97
kr8u9GAojOzsvyE4ML665RZQq7IEyAz3XMoPLg6XNsqX/SF/FBKOIvaxiq2Z6ezF
lUOi3RSXgUjsAXIt7GO/aH+WC+77u0UnLuqMBN8r2j2g4oWKskoacgdBVGIyZauJ
fjUwJXsAhB15/V7+JPkz0M1/gI71FxlkDx6a9k8Lph9Y68ixY3PEfzG0aiCGbsXH
Gzt4+XYGsixkv//rfzK7CjN0MYCZx0cFXlL1+jGJRPRkBajPFkiAmjoK0oWcCHF2
6U0LBfD29ZxbR+uk9iy0YNkRNPUUjk6X2/xLTIVB7Txe7D/2BJPO5lILvnOKd6wt
I4o20PdHN9S1Rlc2/Bg0ruw++fVO0gHlBwk8YnyVjLNQOPM9Lk+m7mwH/09zXWbP
SNY7VA01WcpRre/ogC7Y
=3zge
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_11_59_57_+1100_zmTD8GfE=qUl2t/o--
