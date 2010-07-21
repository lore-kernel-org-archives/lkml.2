Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797Ab0GUHsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:48:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55161 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0GUHsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:48:21 -0400
Date: Wed, 21 Jul 2010 17:48:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-Id: <20100721174809.4781c244.sfr@canb.auug.org.au>
In-Reply-To: <20100721002907.639802cd.akpm@linux-foundation.org>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
	<20100720033656.0ce6356f.akpm@linux-foundation.org>
	<20100720224525.GO32635@dastard>
	<20100720174424.12a4bf64.akpm@linux-foundation.org>
	<20100721052007.GT32635@dastard>
	<20100721002907.639802cd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Jul_2010_17_48_09_+1000_8xF1fgJn6NCZ1u62"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Jul_2010_17_48_09_+1000_8xF1fgJn6NCZ1u62
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Jul 2010 00:29:07 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 21 Jul 2010 15:20:07 +1000 Dave Chinner <david@fromorbit.com> wro=
te:
>=20
> > > and they were dirtied within dquot_free_space().
> >=20
> > AFAICT dquot_free_space() is called deep in the guts of
> > ext3_truncate() via dquot_free_block(), which is called directly
> > before end_writeback(). That should overwrite any state changes made
> > inside ext3_truncate. I wonder if iput_final() is racing with
> > something else here?
> >=20
>=20
> This isn't a race.  I type `make' and the warnings spew out at hundreds
> per second - every unlink, I'd say.

Bisected to:

commit 8bfe4a06746e5f03c02afe3ceb97b5364c099f63
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jun 6 07:08:19 2010 -0400

    convert ext3 to ->evict_inode()
   =20
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Jul_2010_17_48_09_+1000_8xF1fgJn6NCZ1u62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMRqY5AAoJEDMEi1NhKgbsW2YH/1hgOhJqbL6A5RNibQJEssw0
xcBx/TAkS9yYg/9Rb1PROUtGtMjbosM9gmFW7gLTBJ2ryhdMs+Hzq6ak/2Hel+id
93m2iynjiQyGrsDwb/3VaGGXH+JICxz98mjhKvZXvhlSmA2+ho/skhKW33mHg3aQ
mJlwqCKfx5wv/wMK203WU/HYoZo50VbLS22ioa/xl48CTXJ0YT8GKWVjwU7XsWIL
XCMFASlWSY7ya6gRLKL2dhUzcGk9/kBfFK7q5qmRM9ruEAclvLZu1Kf9U1eFen9a
LgsXlVBParWvxmqPbfim77+DFxwuBVfjanH9a6ZcObZJLiGSDAMXPUGiYwtqoPk=
=r5Wd
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Jul_2010_17_48_09_+1000_8xF1fgJn6NCZ1u62--
