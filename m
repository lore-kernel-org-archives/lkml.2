Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1LNEs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:48:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39091 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1LNEsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:48:55 -0500
Date: Wed, 14 Dec 2011 15:48:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20111214154844.3ad4e1d685c7987cba0820a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_15_48_44_+1100_vueZBRwQda_XK_qD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_15_48_44_+1100_vueZBRwQda_XK_qD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build
(powerpc_ppc64_defconfig) failed like this:

In file included from include/linux/slab.h:185:0,
                 from include/linux/kref.h:19,
                 from include/linux/kobject.h:24,
                 from include/linux/sysdev.h:24,
                 from include/linux/node.h:17,
                 from include/linux/swap.h:10,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/slub_def.h:100:17: error: field 'kobj' has incomplete type

Caused by commit 4af679cd7cbb ("kref: Inline all functions") ... we now
have kref.h -> slab.h -> slub_def.h -> kobject.h -> kref.h when
CONFIG_SLUB is set.

I have used the driver-core tree from next-20111213 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Dec_2011_15_48_44_+1100_vueZBRwQda_XK_qD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6CqsAAoJEECxmPOUX5FElB8P/1mQCuIXST/ksrf9eMS0R9MS
fVpmbfEx1fF1p1TaRpd75OyIuxT6qB7N3UARGe3PwcoFQDgFbzSMjIGXKia1ffsZ
fM37VDjwUiEA4g7fw+qXcBk4bgOwSUOfoAr4IKlG7W2H31i6n2WDWGlCpvuDCtt2
vaDJuPmA9zknAA5OBtyyIUhS/QUIxrXxFZETF15Ao4fMzznxGWRGgnDZmi51Unlq
J93M9xvVs0Uur9AGY4nJGLaU9kXZ7mQWBnnWfqVNKXj8dVXnseoOORZraqzIeBhQ
gm+NHpQga6+Om7K1FBPvGkZWD0skbwf40PB96Hyp3vbxuGPraWRHLM+Vj8gc/g0N
asm4an8dT0Uv1VK/90g26JactgGsv/zGOwX9M8PyxhQahvB93HcHSDmktyglen6H
Cxbp/LyKEI96D6ON9SlVQMKG9buiGjGBsnW4tOXCBYvaCHsEoEX5FwjNqlwOvNf1
KzHurj9WFb3IyEaV/Y1/h0L8hWkndyIBT76pBY44u0+EnZEPylVP64+4aanAtkU9
+91TDW1aVDESdrevelekBtcrZfV6QfmmxcqPbw0pPH9Gc/djJmPK99KlvS7Z/tgK
slQkhwptNqwBhI9KaJIkrjgmbCxtX+DsHRjWpKika/jMbZa+20ZX8mnOtk/jqoeu
/WSrrqpXONTbtnocYhZd
=9ylO
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_15_48_44_+1100_vueZBRwQda_XK_qD--
