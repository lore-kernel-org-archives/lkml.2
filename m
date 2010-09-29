Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0I2C6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 22:58:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0I2C6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 22:58:05 -0400
Date: Wed, 29 Sep 2010 12:57:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (hwpoison tree related)
Message-Id: <20100929125756.2e264f7a.sfr@canb.auug.org.au>
In-Reply-To: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
References: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Sep_2010_12_57_56_+1000_Y_eNBaPeI8kX+WGo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Sep_2010_12_57_56_+1000_Y_eNBaPeI8kX+WGo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Mon, 27 Sep 2010 15:55:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc allnoconf=
ig)
> failed like this:
>=20
> mm/mprotect.o: In function `migrate_huge_page_move_mapping':
> mprotect.c:(.text+0x0): multiple definition of `migrate_huge_page_move_ma=
pping'
> mm/shmem.o:shmem.c:(.text+0x0): first defined here
> mm/rmap.o: In function `migrate_huge_page_move_mapping':
> rmap.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mappin=
g'
> mm/shmem.o:shmem.c:(.text+0x0): first defined here
>=20
> Caused by commit 7b217c52ce7f33379beb27aa7685109fa74ed6bf ("hugetlb:
> hugepage migration core").
>=20
> This function is declared as "extern int ..." with a body in
> include/linux/migrate.h for the non CONFIG_MIGRATION case.
>=20
> I reverted the whole hwpoison tree for today.

This is still not fixed ... so I am still using the hwpoison tree from
next-20100924.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Sep_2010_12_57_56_+1000_Y_eNBaPeI8kX+WGo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoqs0AAoJEDMEi1NhKgbs3p4H/05uX5jJP12fEKV+V+LT0pZa
O4pExKUQv4Fc0UzCN+vxW+lITV4ws7hysT2Kds4Z5Ad3Sxtvs5lOdk5oYompT+aM
94zgg3jwqapxnlIdiolk0kpbCpvx+At+qNtDIR/nIk99AvGNkZ+9SaZTjhCIsDZe
lLe0VYnfDE2uSUl1gFbJR9FsdI+qptO1YC7oWafBVY7ofTDnkUTSMnUU7Ute99nh
9Ong3lx8TLq0TisXQd8L7NdlFUp3X2OPWKYWCRIT6V89W++ZlXlS2YDjQeE7CoYE
YLtaCgjxN+ZbG8mjeVNxlybCVEZeQ1wdAQgnTkCqq9LprdV9Q5IOgHTD6LHnKyM=
=RUkc
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Sep_2010_12_57_56_+1000_Y_eNBaPeI8kX+WGo--
