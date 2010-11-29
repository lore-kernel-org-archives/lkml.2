Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0K2CHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:07:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54194 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0K2CHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:07:37 -0500
Date: Mon, 29 Nov 2010 13:07:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20101129130729.64d26563.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Nov_2010_13_07_29_+1100_RNjT.Z1Bf92/TELP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Nov_2010_13_07_29_+1100_RNjT.Z1Bf92/TELP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from include/linux/splice.h:11,
                 from net/core/skbuff.c:54:
include/linux/pipe_fs_i.h: In function 'get_pipe_info':
include/linux/pipe_fs_i.h:171: error: dereferencing pointer to incomplete t=
ype
include/linux/pipe_fs_i.h:173: error: dereferencing pointer to incomplete t=
ype
include/linux/pipe_fs_i.h:173: error: dereferencing pointer to incomplete t=
ype

Caused by commit c66fb347946ebdd5b10908866ecc9fa05ee2cf3d ("Export
'get_pipe_info()' to other users") from Linus' tree.

I cherry-picked the fix from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Nov_2010_13_07_29_+1100_RNjT.Z1Bf92/TELP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8wrhAAoJEDMEi1NhKgbsnycH/jhwFrTpyJM+ANwr4pdUgzlR
tv7FjQAqh3fUlu4nSa9dxwm8Sn068cpnyVPt6NAnKMDM/v94jtJcQefqpcP/9OoP
tLslgsT6jE16hO+rgIToyZrTIcYdzyJznAk9CcilOzdG06F7CV+HuqRjMQube0aR
O1T/MA6w3al082H0wxPO4aTLvW55wltUhfnadge8fGeK2t/+iI2HdExBVxw7JSpN
UGxL7rwlnFu12UxcgMqaHncAIUv37ND7C6cenKs8w/e7LJF+jjYGRIu+Bgwv00V2
8H0OoecCEmIHyBWAWrXUY7mXaiGv0LYNYP5Kjwlqqq6Fe8kDZGOUhjBqNYeI9K0=
=sRkm
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Nov_2010_13_07_29_+1100_RNjT.Z1Bf92/TELP--
