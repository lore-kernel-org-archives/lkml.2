Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031473Ab2CPEXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:23:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2CPEWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:35 -0400
Date: Fri, 16 Mar 2012 15:19:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] init: remove CONFIG_PPC_ISERIES
Message-Id: <20120316151908.e982ce41d848c2b2a4bc045f@canb.auug.org.au>
In-Reply-To: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_19_08_+1100__bNtYMZJkaVLtRLN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_19_08_+1100__bNtYMZJkaVLtRLN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

It is no longer selectable, so remove the check for it.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 init/do_mounts_rd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 887629e..01f1306 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -178,7 +178,7 @@ int __init rd_load_image(char *from)
 	char *buf =3D NULL;
 	unsigned short rotate =3D 0;
 	decompress_fn decompressor =3D NULL;
-#if !defined(CONFIG_S390) && !defined(CONFIG_PPC_ISERIES)
+#if !defined(CONFIG_S390)
 	char rotator[4] =3D { '|' , '/' , '-' , '\\' };
 #endif
=20
@@ -264,7 +264,7 @@ int __init rd_load_image(char *from)
 		}
 		sys_read(in_fd, buf, BLOCK_SIZE);
 		sys_write(out_fd, buf, BLOCK_SIZE);
-#if !defined(CONFIG_S390) && !defined(CONFIG_PPC_ISERIES)
+#if !defined(CONFIG_S390)
 		if (!(i % 16)) {
 			printk("%c\b", rotator[rotate & 0x3]);
 			rotate++;
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_15_19_08_+1100__bNtYMZJkaVLtRLN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr88AAoJEECxmPOUX5FE26kQAKAru4g7+e+btRLi2S0+2jvv
SqpBQO22lwNd7ww6IjL/5/EqFgRbVAu7S9Srdf/ffKO+tiluGsnbo4vple3YPWEi
Bd6zis3o31ULVbPIv+dIagWv9jgCeOgwfLnreOIN/CCR5P312g+BPSWtMKk0AEUn
eQrg71Qrkcwl/L+OkZxB4pxuNONJsxvZEcOSMYpSqrSWXiy8xvwzwty3gf4pcG3R
NqUUcY+dKB7fceASLzqVRfTUyO9xHXtFkSRmsW+ZWdA82P4Gud1e4TVru2bTWIJt
gE9FvPkL78GsNXlXLCWe56Zxlsg0nRIzIvivyGAv3ybSmipRrIoSYL8RvIQWxUto
CDSlq0bETpPEI7/mqZAGzLOODVpSRMTeZyFTCWdJYMui3yu4qVZZjC37AxqNstOS
Ks8+/nVX6I88zGEgvItoA/p7SXAbcZp/QpLIy+EYf/F64M0CTYgKaEa0FU5YU9kp
l5SjzldLB+KiWDI/vbXadLCeKAeM8Vv+u8NI6Oo4uXWzP+siTSU0Sf6memlv1G8x
UgEK5Ei+sjVmqT2PJ4o4uh0aFu6ojOuHKQxjBJHihGUpi+JBZjrvyM2ZkHnQEuGq
PyG51BvfLYmB0nj6d4fyxrF+LHt2QDkktXL2s+pcxHdKN78KRd8/o7AZ8VOqin9M
u/Qwd6Q6zwtwdlwNAB1w
=NWox
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_19_08_+1100__bNtYMZJkaVLtRLN--
