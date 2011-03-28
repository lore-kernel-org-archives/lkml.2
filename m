Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1C1Nhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:37:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35588 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1C1Nhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:37:37 -0400
Date: Tue, 29 Mar 2011 00:37:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@lst.de>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        Jens Axboe <jaxboe@fusionio.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
 Linus' tree
Message-Id: <20110329003725.7815c2a3.sfr@canb.auug.org.au>
In-Reply-To: <20110328104753.GA27327@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au>
	<20110328104753.GA27327@lst.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Mar_2011_00_37_25_+1100_OTu8VdaRoREkp7OX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Mar_2011_00_37_25_+1100_OTu8VdaRoREkp7OX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 28 Mar 2011 12:47:53 +0200 Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Mar 28, 2011 at 12:21:48PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the xfs tree got a conflict in
> > fs/xfs/linux-2.6/xfs_buf.c between commit 7eaceaccab5f ("block: remove
> > per-queue plugging") from Linus' tree and commit 0e6e847ffe37 ("xfs: st=
op
> > using the page cache to back the buffer cache") from the xfs tree.
> >=20
> > I assume that these changes (on both sides) were discussed somewhere, b=
ut
> > maybe not clearly enough?
> >=20
> > I have no idea how to fix this, so I tried to just use the xfs tree
> > version for today.  That failed like this:
> >=20
> > fs/xfs/linux-2.6/xfs_buf.c: In function 'xfs_buf_lock':
> > fs/xfs/linux-2.6/xfs_buf.c:923: error: implicit declaration of function=
 'blk_run_backing_dev'
> >=20
> > So I used the xfs tree from next-20110325 for today.
>=20
> What XFS does is to replace blk_run_address_space, which was a wrapper
> around blk_run_backing_dev with a direct call to blk_run_backing_dev,
> as there change means we don't have the address_space around anymore.
>=20
> Jens' tree removes both these functions, and introduces blk_flush_plug
> as a sort-of replacement.  Sticking to the variant from Jens' tree / main=
line
> with blk_flush_plug is the correct thing here for this case.

So does that mean that the whole xfs tree commit can be removed/ignored?
That is a bit of a pain to do in a merge (especially considering that
there is another commit in the xfs tree that changes that file.  If the
whole commit is no longer needed, maybe it could be dropped from the xfs
tree or reverted.

> Where there more conflicts than just this?

No, the only conflicts (I am pretty sure) were on the lines with the
changed calls.  There was, of course, quite a few other changes in that
commit in the xfs tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Mar_2011_00_37_25_+1100_OTu8VdaRoREkp7OX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkI8VAAoJEDMEi1NhKgbstGEH/i+r/GXy1PIAkgux6/zs4NDz
h4m+kg5CtgTG3I1hR2Kpd3phNo6PY7dZB0mzHfKf8tWrVkAMrlrI4IYPxkd1T7ll
DzCR8HY+CJhU6yFYwMYKNm5aGayXKZaydYY/NCNVxGHOaURg+pv9zNDGQlMFrXJ8
kmXwcXKNqBQhvD7VWtLSs3tLaB7wjraxZhTCr3Ex3kJKi0vWToUMQBGGwWK6tSAt
+wZDSpwwFQTgMrOPN08koDLOo4h4KjxuqnU1XKxANftl7zrZaXaF29PncXRTlVir
WMDWweUpdLEFd3Q9uj8L9DVkX527nuh2Pv1R1vdwBDnOIebxuxxzaGUCumow0YY=
=j3vq
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Mar_2011_00_37_25_+1100_OTu8VdaRoREkp7OX--
