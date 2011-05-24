Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab1EXD7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:59:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60992 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab1EXD7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:59:43 -0400
Date: Tue, 24 May 2011 13:59:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20110524135930.bb4c5506.sfr@canb.auug.org.au>
In-Reply-To: <20110524025151.GA26939@kroah.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au>
	<BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
	<20110524025151.GA26939@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_May_2011_13_59_30_+1000_1BVbB7zxwiOU+ANZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_May_2011_13_59_30_+1000_1BVbB7zxwiOU+ANZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 23 May 2011 19:51:51 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Mon, May 23, 2011 at 10:06:40PM -0400, Mike Frysinger wrote:
> > On Fri, May 20, 2011 at 02:18, Stephen Rothwell wrote:
> > > Caused by commit e66eed651fd1 ("list: remove prefetching from regular=
 list
> > > iterators").
> > >
> > > I added the following patch for today:
> >=20
> > probably should get added to whatever tree that commit is coming from
> > so we dont have bisect hell ?
> >=20
> > more failures:
> > drivers/usb/host/isp1362-hcd.c: In function 'isp1362_write_ptd':
> > drivers/usb/host/isp1362-hcd.c:355: error: implicit declaration of
> > function 'prefetch'
> > drivers/usb/host/isp1362-hcd.c: In function 'isp1362_read_ptd':
> > drivers/usb/host/isp1362-hcd.c:377: error: implicit declaration of
> > function 'prefetchw'
> > make[3]: *** [drivers/usb/host/isp1362-hcd.o] Error 1
> >=20
> > drivers/usb/musb/musb_core.c: In function 'musb_write_fifo':
> > drivers/usb/musb/musb_core.c:219: error: implicit declaration of
> > function 'prefetch'
> > make[3]: *** [drivers/usb/musb/musb_core.o] Error 1
> >=20
> > although it seems like it should be fairly trivial to look at the
> > funcs in linux/prefetch.h, grep the tree, and find a pretty good list
> > of the files that are missing the include
>=20
> How did this not show up in linux-next?  Where did the patch that caused
> this show up from?
>=20
> totally confused,

:-)

sfr said above:
> Caused by commit e66eed651fd1 ("list: remove prefetching from regular
> list iterators").

The cause was a patch from Linus ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_May_2011_13_59_30_+1000_1BVbB7zxwiOU+ANZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2y0iAAoJEDMEi1NhKgbsjRAH/2ox4kXxSwC9b5AfrusaS+sv
3ZC8b4SqS46BIU5v0oCfWYFwEO0orWI17yDdpr6flSjln+ZQ4nBh50BSDbYq7Zdl
Eq6wC97bWEQL2hwjzOOcK9IbJJ/x2xJGG1TAnRvsq2IWiGxepoJvDMGPzaqerJg9
AonDVQIh6fNqVMhX+d3llbdC8P3ZNffFAekb19VccBui3pSSTIGbwUt9SWQnOpou
6xo/ltWwvkBEPJFkLaNPMLXvMdkSei9PeLg9Q6SiuUejGRgsPJZZi/VzY3BVc/7T
8vi8u53SNudAfn0tWonqH9IqGS40QhX8Wt2yUQfQ+VUn6uOgLV7tsHzF+N5XKno=
=48nt
-----END PGP SIGNATURE-----

--Signature=_Tue__24_May_2011_13_59_30_+1000_1BVbB7zxwiOU+ANZ--
