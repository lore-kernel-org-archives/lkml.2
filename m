Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1LFDiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:38:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51607 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab1LFDiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:38:18 -0500
Date: Tue, 6 Dec 2011 14:38:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the memblock tree
Message-Id: <20111206143808.3fa5f3785538a37c9686734d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_14_38_08_+1100_YAB2kWqK3inb_TwP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_14_38_08_+1100_YAB2kWqK3inb_TwP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the memblock tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/mm/numa.c: In function 'get_node_active_region':
arch/powerpc/mm/numa.c:143:11: error: dereferencing pointer to incomplete t=
ype
arch/powerpc/mm/numa.c:144:11: error: dereferencing pointer to incomplete t=
ype
arch/powerpc/mm/numa.c:145:11: error: dereferencing pointer to incomplete t=
ype
arch/powerpc/mm/numa.c: In function 'mark_reserved_regions_for_nid':
arch/powerpc/mm/numa.c:960:29: error: storage size of 'node_ar' isn't known
arch/powerpc/mm/numa.c:960:29: error: unused variable 'node_ar' [-Werror=3D=
unused-variable]
cc1: all warnings being treated as errors

Caused by commit 9d0d131f9f6d ("memblock: Kill early_node_map[]") which
seems to have misspelled CONFIG_HAVE_MEMBLOCK_NODE_MAP as
CONFIG_MEMBLOCK_HAVE_NODE_MAP in include/linux/mmzone.h.

I have dropped the memblock tree for today - we can try again tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Dec_2011_14_38_08_+1100_YAB2kWqK3inb_TwP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3Y4gAAoJEECxmPOUX5FEXnAP/0ur1LGLBKjbfSRk+Yk2gDN3
eKTqHGN2ZkDhRqVJHUMrbXUYdJsr9SoGbBBE0m/qqiwJoOFpPT/HZRoIJ+NKoVzw
Tpm6n/WObVPF/EKUNz6XEZzqy137bEEsaNNVSHGWNOpfPVfoACVMnRhcc9QKEOqo
0TdCnr9trpVcIDjYoXbmhu9rDfK/pILxs+8awO5LETVlVQB/wc0RgUAhtyz8cHZ/
h2+W7StF2dWgaMyjAIxsCGkRis2BREFVtlY+1ASIaebiQBAPga5aNl/VArlqrOi/
HeeV4yttba2rM6/e9DCvJNfnSp8vd3pcoaad9Omv+VTkTApAcaFicQU7GiyycTeP
mCnjQuTgwWzpuEKD7iYbnJ/klSoI4AJTzOtA8VovbAklh187dSZP5YeXMWSK+oHx
kRGU+yVQ6isCyQsKz2Pr96IJeBxda6IzC0h5OxXH0K1sxeTM2oVKVq2uphkQgfGb
pwK6bkVfebqf7r5SqyZ7qwQmHMigc1vOAWTfcbrMkDzYnXBuLycRZq4jDmFIveYm
VbQtLzsC0erLhrxU9urEFKyXdxCSyQmhHWs1guWzrNTSPPLAPZH46SGz54PAOw2/
z/OH3DUG0MsDrA5Snt9eLi4f9ss7SmSAkl7IPwqQS9oRwd1VpPBkofZLZVFy4apA
f+AyXMLxBFAEkHrLU+2v
=qNFz
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_14_38_08_+1100_YAB2kWqK3inb_TwP--
