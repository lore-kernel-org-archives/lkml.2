Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2JWDgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:36:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46102 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2JWDf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:35:59 -0400
Date: Tue, 23 Oct 2012 14:35:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Leach <matthew@mattleach.net>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20121023143542.2655ba712aff06de5685b6fb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Oct_2012_14_35_42_+1100_xVEGwDXb8CIyawvF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Oct_2012_14_35_42_+1100_xVEGwDXb8CIyawvF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/pasemi/idle.c:88:1: error: macro "__define_initcall"=
 passed 3 arguments, but takes just 2
arch/powerpc/platforms/pasemi/idle.c:88:1: error: data definition has no ty=
pe or storage class [-Werror]
arch/powerpc/platforms/pasemi/idle.c:88:1: error: type defaults to 'int' in=
 declaration of '__define_initcall' [-Werror=3Dimplicit-int]
arch/powerpc/platforms/pasemi/idle.c:88:1: error: '__machine_initcall_pasem=
i_pasemi_idle_init' defined but not used [-Werror=3Dunused-function]

Caused by commit e509970f45d1 ("include/linux/init.h: use the stringify
operator for the __define_initcall macro").

Please use grep, it is your friend.

I have reverted that commit for today (and the following commit
("init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatc=
h-fixes")
that depends on it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Oct_2012_14_35_42_+1100_xVEGwDXb8CIyawvF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhhCOAAoJEECxmPOUX5FEehIP/2DbXojhYU4Vs1wGhk2JFxww
vIdZKw/oNPFrky4WQ8WGVPhIfZSaXDPO+aK90/41EZk70P0z+Qducl/rpB1eElEY
uw0HYFdz3POj9BhWXHZQrekckdtcE+yoy6D7rjW8QWFm8mzJH39k7XKBThlYqY3U
6q47Y5Ji4d4EIDR2rEo/NqUoOsRRL93moP5z4jF+q6PzWd2XpRk8wE0DdoDkiUEm
6N+zYozJj/OhmWC6fqf+gHQ59XT3pz0pAarv3DQ4OpAu9SiyglbRUFQDnTkaNTk2
PuruLVIyhF0HTOevZZjE58L0ZNPHsI9KHULTm7j6gM5yC68ltIw50kMX1iRAsrsE
5Ctiy9ZZIy3qD4hAkCPvyKNFb8+Md7XclCyR6g8Ey7tk3sgsQkaGTCUAuVdJv01l
qR+CfDkL64MlFvzCzfO9tsS26tVPLkgllIi01AMgEPzkSK9sPwLfbCR8Ut9kybnC
cev9+wQQBNA31TdqAN7jJCHI4tZSnUH99jDgymvERGFVf8qFW2jVc5yRQzksJBPR
Fz8J2EgmCWOAMileQVkrB97o2xzi1WcmsEO7MEclGHJzXG//Zx3QJAR3gIbXae8W
95UU97vq/g/sa96TsTqcEzyh3iG+9wK4lgE7S3wXVxczYPIPIkq6CMMAdisryYr8
A6XoYE2xsnsEaOd0S7LW
=Te6t
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Oct_2012_14_35_42_+1100_xVEGwDXb8CIyawvF--
