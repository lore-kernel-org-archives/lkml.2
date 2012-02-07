Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2BGC6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:58:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44537 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2BGC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:58:32 -0500
Date: Tue, 7 Feb 2012 13:58:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the l2-mtd tree
Message-Id: <20120207135815.b551929e844a3824d7943e76@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Feb_2012_13_58_15_+1100_S3y2lrrQP0dJ8NPr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Feb_2012_13_58_15_+1100_S3y2lrrQP0dJ8NPr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the l2-mtd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mtd/devices/pmc551.c: In function 'pmc551_erase':
drivers/mtd/devices/pmc551.c:157:2: error: implicit declaration of function=
 'pmc551_point' [-Werror=3Dimplicit-function-declaration]
drivers/mtd/devices/pmc551.c: At top level:
drivers/mtd/devices/pmc551.c:194:12: error: static declaration of 'pmc551_p=
oint' follows non-static declaration
drivers/mtd/devices/pmc551.c:157:2: note: previous implicit declaration of =
'pmc551_point' was here
drivers/mtd/devices/pmc551.c: In function 'pmc551_unpoint':
drivers/mtd/devices/pmc551.c:229:1: warning: no return statement in functio=
n returning non-void [-Wreturn-type]

Caused by commit 1e43e2c68ec0 ("mtd: remove junk pmc551.h").  The last
warning was already there.  Please try to build test this stuff before
publishing ...

I have used the version of the l2-mtd tree from next-20120203 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_Feb_2012_13_58_15_+1100_S3y2lrrQP0dJ8NPr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPMJNHAAoJEECxmPOUX5FEWmQQAKgscuIkKAdjEy8/UaKf9V0M
1uwKYYq3oaobbANlWP3EUwsbw2pQiK/Q8KGVLPDioDrUR9Xm3S020gaUVeNJNUI+
W8vl8DdD+hGWo3G+Upgx5ONwGWUHhtmBv6ij2769A+o+WPAcO7SyV223St5gFNhj
CB3XIqdsdbsMOXYhPdAUbBswpZ1ARgM5Mz7+xJAs/SRBrmtNzcDf8dHmUjN2951I
XRYdXLq0hbqBcc/n4HZywlUBssPrjfTW5awOZGAWLMHtdo0tPGd3aE5dCNub/0LV
6TM65FEtTDeR9AYUvdL1zEujkdH523nJdHi5EcbLseQcccwK8vHwBYpW8mvnJDkd
5FhfjUhJ6QkqBJKi8/FbRDdxaEmI3B/wcvB1cnFd26CQFivg3PsQknLHqHUuD5A3
zZ1Wdw9acEDEP/IYM3oxQ1IBFmXSq+9qYeLHqOUObrhkkyu+DlOZpQYvI0rEQb91
U31iBCzKK64JPRh+zbf1SpUQY3gG6HrMiWIKB7ZihwlJY//+Dm/MP/YFD/buCkce
vJcoms8Vo2J9qGxomP17iiPoa0+l3qGbbCHjR/TKsyEBc8RxM9VqUXMy8qgjPKNG
xp8uMbop+GKjkuZTFRJdX8LMgrm5+21U7w+G+nlv0704pz7rexrzR/yDG1zH4yzW
7YpEm0bRXM6w4OQO9+Cx
=0Kh0
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Feb_2012_13_58_15_+1100_S3y2lrrQP0dJ8NPr--
