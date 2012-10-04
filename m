Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2JDCtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:49:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50571 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2JDCtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:49:00 -0400
Date: Thu, 4 Oct 2012 12:48:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the modules tree with Linus' tree
Message-Id: <20121004124851.6704ba1ecb3d79c2a8ef5bf7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_12_48_51_+1000_VNW1T4WsQCMQd6Kw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_12_48_51_+1000_VNW1T4WsQCMQd6Kw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the modules tree got a conflict in Makefile
between commit d183e6f570f3 ("UAPI: Move linux/version.h") from Linus'
tree and commit 91657140708d ("MODSIGN: Make mrproper should remove
generated files") from the modules tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Makefile
index 5d8e7f2,e70ebfe..0000000
--- a/Makefile
+++ b/Makefile
@@@ -996,8 -993,12 +996,11 @@@ CLEAN_DIRS  +=3D $(MODVERDIR
  # Directories & files removed with 'make mrproper'
  MRPROPER_DIRS  +=3D include/config usr/include include/generated         =
 \
                    arch/*/include/generated
 -MRPROPER_FILES +=3D .config .config.old .version .old_version            =
 \
 -                  include/linux/version.h                               \
 +MRPROPER_FILES +=3D .config .config.old .version .old_version $(version_h=
) \
- 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
+ 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
+ 		  signing_key.priv signing_key.x509 x509.genkey		\
+ 		  extra_certificates signing_key.x509.keyid		\
+ 		  signing_key.x509.signer
 =20
  # clean - Delete most, but leave enough to build external modules
  #

--Signature=_Thu__4_Oct_2012_12_48_51_+1000_VNW1T4WsQCMQd6Kw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbPkTAAoJEECxmPOUX5FE+qsQAIuedn8ITMrGyHgtA2YSPbRO
a6FjBFFxA291aoUWiAdhyQmvpa15Klhj0HjS4YrC48ByPBqgF3eEcNFqBrXWLjSP
w+/pHeWq+3QFiOW5TeXzGRByZ6cGnXzXDPDrwIwr884jh6miZUkzawqZ4X8nMRkc
eEw8m9uIKxQrn+at2TCnAPJIu5ZeD40Zs5VXMk37YIAYQ5N/s4F/ckdzcoxH037K
HZXDkETlf7la9YjNtLwoLqWyYST7XUf9EcTyAxpOhTqyu67+OiXR0U6VjfzNSpfA
YPIT2eViabHcxhwE3plKOQPcASPO6nuhDcMH2U7J2jb0G3uAmFUTayfOS8/Nqjfz
y1VSP10vLj/7zkUb7/zHlTF3EXknQEhHL6iLpfZEhrme2STUnH/EfWMWRTgfgXlf
MbWRUivql6xUU/9yr6ZRAfuvIuoccR0xZfZR/xRP19wRDyBEmLOwpiJMLXrzJFmJ
SohPkR2+du0fSWX/KVo0I+5FJDYFB98nTvqb89G8kznRH5u2Gw/8XLR1FteCEFu5
F4MeAwCt9lWqUojMOFQKhVjHxWA6nkhKsBKIq4Mpqw15uDZHrvKX4F5ykaBsoDBM
+9y1WAKg4kSYocKC35H7tv0s4sJU87ezotTpmM0qTvbad1AhqLJk75QK46gh1IqE
FKp+q7QaJR8OC65H0Bg+
=ymSC
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_12_48_51_+1000_VNW1T4WsQCMQd6Kw--
