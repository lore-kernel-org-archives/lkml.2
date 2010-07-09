Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0GIKhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:37:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36510 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0GIKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C0nqJZ9jagoL2lpVW/SaSavxu3khn4KqhJUOfr58ktEYjTWF23wMtX7JOtXhHZ6Z9K
         PuMCgquW/mvoZB3hZqgpYb3IQVcyGgWhBctMaOY5ltYkbYeswzbBopprUHcCbvjiw1wu
         LeLxjVwIaUOzQyjtLcrkBdznB7r0Egnrh0fGU=
Date: Fri, 9 Jul 2010 13:42:06 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100709104047.GA3965@swordfish.minsk.epam.com>
References: <20100702093451.GA3973@swordfish.minsk.epam.com>
 <20100702131248.GA5324@nowhere>
 <20100703092441.GM31073@ZenIV.linux.org.uk>
 <20100703094323.GN31073@ZenIV.linux.org.uk>
 <20100704091523.GP31073@ZenIV.linux.org.uk>
 <20100709031622.GL6405@nowhere>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20100709031622.GL6405@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/09/10 05:16), Frederic Weisbecker wrote:
> On Sun, Jul 04, 2010 at 10:15:23AM +0100, Al Viro wrote:
> > On Sat, Jul 03, 2010 at 10:43:23AM +0100, Al Viro wrote:
> > > On Sat, Jul 03, 2010 at 10:24:42AM +0100, Al Viro wrote:
> > >=20
> > > > Gyah...  For the 1001st time: readdir() is far from being the only =
thing that
> > > > nests mmap_sem inside i_mutex.  In particular, write() does the sam=
e thing.
> > > >=20
> > > > So yes, it *is* a real deadlock, TYVM, with no directories involved=
=2E  Open the
> > > > same file twice, mmap one fd, close it, then have munmap() hitting =
i_mutex
> > > > in reiserfs_file_release() race with write() through another fd.
> > > >=20
> > > > Incidentally, reiserfs_file_release() checks in the fastpath look c=
ompletely
> > > > bogus.  Checking i_count?  What the hell is that one about?  And no=
, these
> > > > checks won't stop open() coming between them and grabbing i_mutex, =
so they
> > > > couldn't prevent the deadlock in question anyway.
> > >=20
> > > ... and unfortunately it's been that way since the the initial merge =
in 2.4.early.
> > > FWIW, it seems that i_count check was a misguided attempt to check th=
at no other
> > > opened struct file are there, but it's
> > > 	a) wrong, since way, _way_ back - open() affects d_count, not i_count
> > > 	b) wrong even with such modification (consider hardlinks)
> > > 	c) wrong for even more reasons since forever - i_count and d_count c=
ould
> > > be bumped by many things at any time
> > > 	d) hopelessly racy anyway, since another open() could very well have
> > > happened just as we'd finished these checks.
> >=20
> > OK...  See 22093b8f3d387f77 in vfs-2.6.git for-next (should propagate to
> > git.kernel.org shortly).  That ought to deal with this crap, assuming I=
 hadn't
> > fucked up somewhere...
>=20
>=20
> Looks good. Thanks for fixing this!
>=20

Seems to work fine with my test app.

Reported-by/Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


	Sergey

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkw2/P4ACgkQfKHnntdSXjSl2AQAkeV05CDIc9tBicAJIVZAoq9C
XbmFffnVyFKe2vYFtQ9pc8lvgDh4FEm+nPZ0ib8vp1JJO/emw9sXo9WT2uZVLnDi
MTFE4H/mG+qKTt6o+7SyThkhYmNYLkNncxnLoI63F7tH+Lanp7CZy4IIZT65SiuV
P8WzoDMMr8rqLMHIkBs=
=3sLv
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
