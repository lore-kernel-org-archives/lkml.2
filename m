Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab1GTHct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 03:32:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33167 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1GTHcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 03:32:47 -0400
Date: Wed, 20 Jul 2011 17:32:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (maybe vfs
 tree related)
Message-Id: <20110720173232.3c7e46d310e2224e459b0ac1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_17_32_32_+1000_YP5gKc7V3.Wm_vis"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_17_32_32_+1000_YP5gKc7V3.Wm_vis
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc defconfig)
failed like this:

In file included from /scratch/sfr/next/arch/sparc/include/asm/prom.h:22:0,
                 from /scratch/sfr/next/include/linux/of.h:130,
                 from /scratch/sfr/next/arch/sparc/include/asm/openprom.h:1=
4,
                 from /scratch/sfr/next/arch/sparc/include/asm/oplib_32.h:1=
1,
                 from /scratch/sfr/next/arch/sparc/include/asm/oplib.h:6,
                 from /scratch/sfr/next/arch/sparc/include/asm/pgtable_32.h=
:22,
                 from /scratch/sfr/next/arch/sparc/include/asm/pgtable.h:6,
                 from /scratch/sfr/next/include/linux/mm.h:41,
                 from /scratch/sfr/next/include/linux/fs.h:397,
                 from /scratch/sfr/next/init/do_mounts_initrd.c:3:
/scratch/sfr/next/include/linux/proc_fs.h:275:15: error: field 'vfs_inode' =
has incomplete type
/scratch/sfr/next/include/linux/proc_fs.h: In function 'PROC_I':
/scratch/sfr/next/include/linux/proc_fs.h:280:9: warning: type defaults to =
'int' in declaration of '__mptr'
/scratch/sfr/next/include/linux/proc_fs.h:280:9: warning: initialization fr=
om incompatible pointer type

And many more similar.  Again, I assume some include files changed.
Maybe commit 347727d3f51d ("superblock: introduce per-sb cache shrinker
infrastructure") which included linux/mm.h in linux/fs.h ...

I have left this again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_17_32_32_+1000_YP5gKc7V3.Wm_vis
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJoSQAAoJEDMEi1NhKgbsc9IH/Ai58gEc5V/SilzrHQzCR+DC
gfWuDh2tJx+JuzB3elEVnNTpl4AoMWZubh7VBI+Gk1ccHigdG4faKtQoemxlzQHq
u5tlfsPkbkue9WRbhAVHDOCZeAhHnA0BEtx80NQRqVT1k2xVnQKzqYbPsRPtLbcY
aJ2n50PMYbQrOLMkQFuelxjnROSUPOi91K3JaDgdDzU7/eDTIXmt+mIMGDrVj/tL
61s7Utyy4jVPKXspJ1QN0S7M0HR4zSN3y8ypoq2+CIRQrXMP9ZsMubsKU7yRPQtk
tM6S7Tsm3cw2npo/FtapM1FEo9jZ3CuNEB/ZoOlZ3X0OtsavnMV+2ANHLhkmXPQ=
=jIyw
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_17_32_32_+1000_YP5gKc7V3.Wm_vis--
