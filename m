Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2BXFZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:25:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59312 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2BXFZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:25:19 -0500
Date: Fri, 24 Feb 2012 16:25:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: linux-next: manual merge of the irqdomain tree with the powerpc
 tree
Message-Id: <20120224162504.49480de981431c3fd95601a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_16_25_04_+1100_8Q22evHa1fQA+kVT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_16_25_04_+1100_8Q22evHa1fQA+kVT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
arch/powerpc/sysdev/mpic.c between commits 3a7a7176e840 ("powerpc/mpic:
Fix use of "flags" variable in mpic_alloc()") and c1b8d45db4db
("powerpc/mpic: Add "last-interrupt-source" property to override
hardware") from the powerpc tree and commit a8db8cf0d894 ("irq_domain:
Replace irq_alloc_host() with revmap-specific initializers") from the
irqdomain tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/sysdev/mpic.c
index b9b989d,c83a512..0000000
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@@ -1351,9 -1345,9 +1351,8 @@@ struct mpic * __init mpic_alloc(struct=20
  	mpic->isu_shift =3D 1 + __ilog2(mpic->isu_size - 1);
  	mpic->isu_mask =3D (1 << mpic->isu_shift) - 1;
 =20
- 	mpic->irqhost =3D irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
- 				       mpic->isu_size, &mpic_host_ops,
- 				       intvec_top + 1);
+ 	mpic->irqhost =3D irq_domain_add_linear(mpic->node,
 -				       isu_size ? isu_size : mpic->num_sources,
 -				       &mpic_host_ops, mpic);
++				       mpic->isu_size, &mpic_host_ops, mpic);
 =20
  	/*
  	 * FIXME: The code leaks the MPIC object and mappings here; this

--Signature=_Fri__24_Feb_2012_16_25_04_+1100_8Q22evHa1fQA+kVT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRx8wAAoJEECxmPOUX5FE97UP/3iKdDLLhELVMIZPQMigQ9nl
yoixmEGTZf0DIT8B1JDSIeV+gyE1D7/fFUEZvJ5MrDhS1z/d8Z4DWuTmLMv5frJ0
Il7aiG9kuObzlBf3ZnRiwQnuZnWSSUKQ0j5mcCgAJt/oqJWD3rAESW1toGdGSyv7
JHkDeYrIXP3tFzF9F7t9ojZbqN9kRsi2cxcvBa+TccTqNupy+/M6KrzFmM3ERi63
B41mGcaRIOV/MBTgNUSLoTUueuAs3Oo9GqM4x16ugYqUvqja8AmqlV+rsPyJtSJq
ZUvZslkCoNkHsei4iScNY1DJJeYB4K5R1nh2dwMbnm7Xwqc9FgGgLYgdmSh2kfxk
ButjV4LFGOnDrcjt+zhxbN3Cghm6CCo6e1xZMT86Gx1RBka2r9bYeCcbiU7ABjjc
YhvI+0qwxvRQTUBgeI63NbdmaptOGz+2EYTSght4nIuTy3ypH7aMkFRNN/pI+H+O
93wl20K+BJ70rPf8hr4vJnX1aLAQl7mNyIDRAqao/pWkesUqnFIpMSlOhtd/6NPc
hERa348sl1ksHAnuee8pt/ve3N6zVl9XAI40xGafD4zHaE36n+0SxqDofeGC3Oeh
3hcEo8IkDxELkEUB0NsaAbHrATeTcdp1z0P0By2yBIOjudwP3XA7m2FgEuQSWOQf
OpMM2wOHat5gtwKzfRw6
=E/Yy
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_16_25_04_+1100_8Q22evHa1fQA+kVT--
