Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab2ACBnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:43:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45393 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2ACBnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:43:42 -0500
Date: Tue, 3 Jan 2012 12:43:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, Jan Kara <jack@suse.cz>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_12_43_31_+1100_FhJo32_+dnbpO/BL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_12_43_31_+1100_FhJo32_+dnbpO/BL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/super.c:230:13: error: static declaration of 'put_super' follows non-sta=
tic declaration
include/linux/fs.h:2493:13: note: previous declaration of 'put_super' was h=
ere

Caused by commit eab99e355c00 ("trim fs/internal.h") interacting with
commit 4789fd4495a4 ("quota: Fix deadlock with suspend and quotas") from
the ext3 tree.

I applied the following (probably not the best) merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 3 Jan 2012 12:38:21 +1100
Subject: [PATCH] fs: make put_super global again

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 3682e6c..cb6d718 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -227,7 +227,7 @@ static void __put_super(struct super_block *sb)
  *	Drops a temporary reference, frees superblock if there's no
  *	references left.
  */
-static void put_super(struct super_block *sb)
+void put_super(struct super_block *sb)
 {
 	spin_lock(&sb_lock);
 	__put_super(sb);
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jan_2012_12_43_31_+1100_FhJo32_+dnbpO/BL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAl1DAAoJEECxmPOUX5FEe6YQAKYaQcZCC2ID8AfQyylKuRmv
JlDz3n9ciosAue5pxwCeOuF8ToPvVTAAj6BBC0kv9gvjWeebwJvtUoB+KPym9f/U
54BcWuBNo8/H9BXBjJdJu7HnxwB6JvgzKyIAb3I4l0JiAEhkFOIN+8LR/PByVFI7
JA8lYUStTqm/FBf2z5RKdHTCOIncHguYl0n3VfSkxb8ozZOQeHV9gLVCQyWiqcVc
q8MbGVD1ZlvfEe2qVJsRpuLT/fNQO6O4xhdWHXokhJKqRTAMjxf94FjSsRSJFLsV
WLS6XKZmHgfP7dXezD1fF/pHJDYJJhmWrvTYtpX1ORMPqmjCnp63Sa42UvfPDUQ4
fTBwUS9pdmy8WrhD7+vgX9p36D8NtRV0NwA0hbWV128S7EpPEDMRe1RVpeMthDIN
5/cYMSvYnVmSn1tEA8Tvvim/eKHzl+EJUKOnGkQxpw4T+h4VFO9JKycck9JO0X6i
bjDUvo78V8E9cgx7aAQ+c+8mBUiD2haNI6c8FteGLMfr0pi7gYCotHhcIsUYTlad
gZKwYsOPFIC4lPGiOVmOjEag1FFIEmblS/VL89/EJsLUMmyThDPJwLZoQMFmwXhC
5pcUmxFcFi0Zfp18WhXinjAZZQim3URKgp+gxt955eX/eRfu+WzN/Nnxc9sjj4X+
fHsurckiPGbr4JwY3wvr
=CGj9
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_12_43_31_+1100_FhJo32_+dnbpO/BL--
