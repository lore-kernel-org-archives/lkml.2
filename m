Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1JNGeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:34:36 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58331 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1JNGef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:34:35 -0400
Date: Fri, 14 Oct 2011 17:34:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the akpm with the ext3 tree
Message-Id: <20111014173423.839933d5c22913a06bd721fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_17_34_23_+1100_8Qey/J5/Q.htmvA8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_17_34_23_+1100_8Qey/J5/Q.htmvA8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/udf/udfdecl.h between various commits from the ext3 tree and commit
2ea9eff85131 ("treewide: use __printf not __attribute__((format
(printf,...)))") from the scsi-post-merge tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/udf/udfdecl.h
index f7273fb,4a33c72..0000000
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@@ -18,21 -16,6 +18,21 @@@
  #define UDF_PREALLOCATE
  #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 =20
- __attribute__((format(printf, 3, 4)))
- extern void _udf_err(struct super_block *sb, const char *function,
++extern __printf(3, 4)
++void _udf_err(struct super_block *sb, const char *function,
 +		     const char *fmt, ...);
 +#define udf_err(sb, fmt, ...)					\
 +	_udf_err(sb, __func__, fmt, ##__VA_ARGS__)
 +
- __attribute__((format(printf, 3, 4)))
- extern void _udf_warn(struct super_block *sb, const char *function,
++extern __printf(3, 4)
++void _udf_warn(struct super_block *sb, const char *function,
 +		      const char *fmt, ...);
 +#define udf_warn(sb, fmt, ...)					\
 +	_udf_warn(sb, __func__, fmt, ##__VA_ARGS__)
 +
 +#define udf_info(fmt, ...)					\
 +	pr_info("INFO " fmt, ##__VA_ARGS__)
 +
  #undef UDFFS_DEBUG
 =20
  #ifdef UDFFS_DEBUG

--Signature=_Fri__14_Oct_2011_17_34_23_+1100_8Qey/J5/Q.htmvA8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl9fvAAoJEECxmPOUX5FE9VAQAJq+fJFwF/6zAWJUgI3ilLVE
YsQEEdJ8nE7P3IN/gOhkou0pmNxjwhWnVqpGh6LceMXTmhqa7o7fE2hqW6PF1YZ/
gjl/o+xySjM+BHOsCqUJDZQSjPMBrZIKrWjnTo2rTsvuWsqbC6YkM9+dnnt+sBh0
5Qg1my83ryzhHjDIJ9hED96H7TTeOUYaKCDWFp9lUeec0ASGcki4/Y1LY5BcPUSk
zX7QIMXFQ9eIjW99uTsz7YtByJ9IfXfmmu4BIt6eZyjOD2WnyYMWiQUJp/xjz6Cd
TdpmsV5jBJl1Y9flUCWiauVmPy/rDxlVynO+M337g0JVS/WzA1tgxMavZF79llPh
6MOvYYy981PcboiDWNES9iTgHJ80emxVhTK1vGOgUhTmVMKMBi0XH4BRq7M+VDwu
sX5bVCMXV+VEgBq4VYZSMJY7TYSnUiN8Sl/y/i+Ma3VhdNPw4R/U/AlKCl0FEjC5
0NSwpfKfssaOZ/f2VqvYhfnsGg+0ghQywlN4GDrchE8dc0pJO/cFc96po3Fl4rIC
iGuGnCPNzM1Ub8GJk/5jWpyUk+oFwEljdqRcOHMT4iwJV+sDoa7dgrC/XgRKS65k
jjkyTaKJkKNGFUowfeK/tYLqn489Fsy0FoftQblNdLIOBFdvufgi5Fi3p7IB6iDZ
9mkMv+ja8yYqccaMzhSf
=fhcG
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_17_34_23_+1100_8Qey/J5/Q.htmvA8--
