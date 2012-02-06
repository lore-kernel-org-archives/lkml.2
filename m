Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2BFBHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:07:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49004 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2BFBHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:07:16 -0500
Date: Mon, 6 Feb 2012 12:07:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: build failure after merge of the l2-mtd tree
Message-Id: <20120206120706.cf5d951972d22eb7fa134fbd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Feb_2012_12_07_06_+1100_eT63kgjx0G/_OeaK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Feb_2012_12_07_06_+1100_eT63kgjx0G/_OeaK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the l2-mtd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mtd/devices/pmc551.c:191:12: error: conflicting types for 'pmc551_u=
npoint'
include/linux/mtd/pmc551.h:37:13: note: previous declaration of 'pmc551_unp=
oint' was here
drivers/mtd/devices/pmc551.c: In function 'pmc551_unpoint':
drivers/mtd/devices/pmc551.c:196:1: warning: no return statement in functio=
n returning non-void [-Wreturn-type]

Caused by commit 753c57f84b57 ("mtd: return error code from
mtd_unpoint").  [Mind you, I don't understand why those static functions
would be declared in a header file ...]

I have used the l2-mtd tree from next-20120203 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Feb_2012_12_07_06_+1100_eT63kgjx0G/_OeaK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPLye6AAoJEECxmPOUX5FEE2YP/3sRlaf0iR6qSsui/6eiuq1s
sksfUC3rl3b9SSrB6Pko6birHQ1ZsDrzJNQqb8hYQdIwSdtlQB8hkANP34C7AdAs
B+I4nYHQ9NwcN5U/t/bd4eDw2gz3H4W3vZnpdKg4MdNKaRLzPolUA8723z7qabgR
tyuz0DbViCHrIOV+HTp2QKLgrPlBvgZ4Ta5+omQg50ZgeUhZcmn+uPff2QhXcovr
Gl6yOsKgZXQz5riy4BEt4Ix2eiTh5NWK4IORfZVPLRSy8mUR87m14HlnpLvOnTFv
EE3QUmi1lAsbmJYu9BNNy8fI3mdXi8tOsPeFYuByQdI0RE01QG66l8K01qRyjlab
qO0KyXM5fhj5QCsmtl9iRDjLgaztYQoMw7g7N82xwsaeR4HiDkrbH0ZqrU1IvSEw
iAOBlRYFM0OlRGjohr7UL0Q7zoCNlBzci5vTHcxh43V0A8iIfNeZ1Nt/LhF+rp00
XGRNjkPwG1MAnW5AaFR2ALfcfxoiE4BbK1lJbT9rF2qXtvbC67oK0NHB8V+C1fpR
BJcjtzTiyMQZ/RNjZlLm6YmCuRPhA2C0q0L4pJyp+iNkNvGCXHarScNpQauVyI8G
tnXiZepd71vAg/+CoQmxxf3grsgqd5WkJjvSbOETPheT05GHSp769j9HrcEW7e/2
sYeGoujmKT8mpOc8h9+e
=kZG4
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Feb_2012_12_07_06_+1100_eT63kgjx0G/_OeaK--
