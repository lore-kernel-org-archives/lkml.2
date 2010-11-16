Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab0KPCJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 21:09:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58384 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab0KPCJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 21:09:07 -0500
Date: Tue, 16 Nov 2010 13:08:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the bkl-config tree
Message-Id: <20101116130853.a3c66c4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Nov_2010_13_08_53_+1100_z+zak2hhkn9X=iNz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Nov_2010_13_08_53_+1100_z+zak2hhkn9X=iNz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

After merging the bkl-config tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/sched.c: In function 'schedule':
kernel/sched.c:3896: error: implicit declaration of function 'release_kerne=
l_lock'
kernel/sched.c:3960: error: implicit declaration of function 'reacquire_ker=
nel_lock'

Caused by commit 8bbc75c71b8a821edd8abb43452c78fbfd4789dc ("BKL: remove
extraneous #include <smp_lock.h>").  Not well build tested :-(

I have used the version of the bkl-config tree from next-20101115 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Nov_2010_13_08_53_+1100_z+zak2hhkn9X=iNz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4ee1AAoJEDMEi1NhKgbsxNsH/2W2dIkuMTqQRHXCy5MaKmu/
byghHNdSB1t8hU+ZHf5zYYAztsXaNRyPhyiNeZEjiQ73QWomaKf14QfKy2Ca8eIK
pIfiVQG6O9HBsi/0j4DJ28jD7p3xuD2kE8eNbxmgb9Cd3NQPWJzO5YJn2tM4FuzW
rf+7sTXGAvlP+wGIsjBnFSQJPSOKCHrM3lZ1Bf+3rHOYPYqeUTO9RWQSf1cW8Mxt
qn/TpReMM73lIzvQYdNeWcmz9e2fqT0U6JnGvgjd9dUHgINUuZXokGo6oKX2aYDv
HjasiJiep3vnXKlXDPAmRLRu49yQirqxtuG7Cyd2H14JghRj1KYo/3rFKlAwdS0=
=MjGf
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Nov_2010_13_08_53_+1100_z+zak2hhkn9X=iNz--
