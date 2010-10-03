Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0JCXgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 19:36:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43486 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0JCXgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 19:36:40 -0400
Date: Mon, 4 Oct 2010 10:36:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (hwpoison tree related)
Message-Id: <20101004103630.9981b9a5.sfr@canb.auug.org.au>
In-Reply-To: <20100929125756.2e264f7a.sfr@canb.auug.org.au>
References: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
	<20100929125756.2e264f7a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Oct_2010_10_36_30_+1100_A=JcM8hs8yaUb5rY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Oct_2010_10_36_30_+1100_A=JcM8hs8yaUb5rY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Wed, 29 Sep 2010 12:57:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 27 Sep 2010 15:55:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the final tree, today's linux-next build (powerpc allnoco=
nfig)
> > failed like this:
> >=20
> > mm/mprotect.o: In function `migrate_huge_page_move_mapping':
> > mprotect.c:(.text+0x0): multiple definition of `migrate_huge_page_move_=
mapping'
> > mm/shmem.o:shmem.c:(.text+0x0): first defined here
> > mm/rmap.o: In function `migrate_huge_page_move_mapping':
> > rmap.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapp=
ing'
> > mm/shmem.o:shmem.c:(.text+0x0): first defined here
> >=20
> > Caused by commit 7b217c52ce7f33379beb27aa7685109fa74ed6bf ("hugetlb:
> > hugepage migration core").
> >=20
> > This function is declared as "extern int ..." with a body in
> > include/linux/migrate.h for the non CONFIG_MIGRATION case.
> >=20
> > I reverted the whole hwpoison tree for today.
>=20
> This is still not fixed ... so I am still using the hwpoison tree from
> next-20100924.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Oct_2010_10_36_30_+1100_A=JcM8hs8yaUb5rY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqRN+AAoJEDMEi1NhKgbsFncH/RLBCI4fSenOLmBZaX97pwRO
8/cdj/A3J7dTnxi8PBGpaOnVCAZDcPzcqo/7kHc4gXJlQZZ53DNdqmHphhWoKjNm
ZtDehGwkEejhQcS7BH7YL0gFyZrAaFyEcSRhnZjE8WezV2dqRJ+V1zDHVdEBUvgO
1eqpfb5GMAjLZlqAuuMOnsfjJL5BiGPaS5X6V4boR7laNYqIeAg7oFXJH8tqseb0
eSM3zVe/ScdvQJA7eRAaCSABIRNkNhBmXeY72ojP/n7O13VhUxeCg5+5dt+RYV/R
fABoHpqTZhbdWnDYlcPegBrh5olBRIasS/2Lsid6pDCswnNEZbS+WKo2lsxgDjg=
=Pnwy
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Oct_2010_10_36_30_+1100_A=JcM8hs8yaUb5rY--
