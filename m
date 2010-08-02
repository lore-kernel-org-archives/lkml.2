Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0HBQX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:23:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab0HBQX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:23:27 -0400
Date: Tue, 3 Aug 2010 02:23:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Aug_2010_02_23_10_+1000_nCZes58pOMQVGzDz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Aug_2010_02_23_10_+1000_nCZes58pOMQVGzDz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Lots (if not all) of the arm builds failed for next-20100802 with these
errors:

arch/arm/mm/init.c: In function 'arm_bootmem_init':
arch/arm/mm/init.c:184: error: implicit declaration of function 'memblock_s=
tart_pfn'
arch/arm/mm/init.c:186: error: implicit declaration of function 'memblock_e=
nd_pfn'
arch/arm/mm/init.c:188: error: implicit declaration of function 'memblock_s=
ize_bytes'

Caused by commit 53e16bfaf19346f59b3502e207aa66c61332075c ("memblock:
Introduce for_each_memblock() and new accessors, and use it") interacting
with commit 2778f62056ada442414392d7ccd41188bb631619 ("ARM: initial LMB
trial") and some others from the arm tree.

Ben, is there no way to retain the old APIs while creating the new ones?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Aug_2010_02_23_10_+1000_nCZes58pOMQVGzDz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVvDuAAoJEDMEi1NhKgbsxJwH/11Ku8bXGEFF7zS01u+u9fK+
B6jZG3rZUvyPvVxktHBLIWVW3mGUDV+3RsEIS8+wiUwjLZFGW75P7xsujsgn22YU
SKfZd74czN28KyNbDVeP+HMye1nTFXSDliub9va3m8L3X/K+hj6LZPDxJGJlfp9a
QqzVBgY+FKXrmla30gXuQRZXpmARYUULQBD5wUR3H6KwpLKjkg1ojr7wQjJwjdWY
IcB3PFapKORHNnj5iz82kS3aPQZ89/JA4IjcbivoLqapwyebtyGHkUOQkygOPcj6
F9+1jN1QJ0D0UJccSSD69vJA7atSLHRkHuwYUk5Dno8d0AwMVNuqU/6wzWA5B6M=
=7EHL
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Aug_2010_02_23_10_+1000_nCZes58pOMQVGzDz--
