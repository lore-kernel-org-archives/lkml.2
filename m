Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab1FWOi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:38:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43143 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1FWOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:38:58 -0400
Date: Thu, 23 Jun 2011 10:38:54 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com
Subject: Re: [PATCH] events: Ensure that timers are updated without requiring
 read() call
Message-ID: <20110623143853.GA5033@mgebm.net>
References: <1308838537-6682-1-git-send-email-emunson@mgebm.net>
 <1308839150.1022.130.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <1308839150.1022.130.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jun 2011, Peter Zijlstra wrote:

> On Thu, 2011-06-23 at 10:15 -0400, Eric B Munson wrote:
> > The event tracing infrastructure exposes two timers which should be upd=
ated
> > each time the value of the counter is updated.  Currently, these counte=
rs are
> > only updated when userspace calls read() on the fd associated with an e=
vent.
> > This means that counters which are read via the mmap'd page exclusively=
 never
> > have their timers updated.  This patch adds ensures that the timers are=
 updated
> > each time the values in the mmap'd page are updated.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > ---
> >  kernel/events/core.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 9efe710..3dd4ebe 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3369,6 +3369,7 @@ void perf_event_update_userpage(struct perf_event=
 *event)
> >  	struct perf_buffer *buffer;
> > =20
> >  	rcu_read_lock();
> > +	update_event_times(event);
> >  	buffer =3D rcu_dereference(event->buffer);
> >  	if (!buffer)
> >  		goto unlock;
>=20
> Not that easy, perf_event_update_userpage() can happen from NMI context,
> and update_event_times() needs to be done under ctx->lock.
>=20

I was afraid that might be the case, is there an easy-ish way to accomplish
the timer update?

Eric

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOA0/9AAoJEH65iIruGRnNKDsH/3e+1ETxSnpVEUJ+q/wjlqv2
DrdpgCY6YawXVuoVKRT9W+NLmOV3HY1FVNfVH9V/tmJ3AEIg4+mLQsAavyKLVNgO
U8jzTscOx0jnJKBTkzqAEmAA7toWk3QsdjFkb9e7B1AMAQETRbP8RYpd3dK732h3
XucHihrTZ9qAKOJcbK+xP6Vp4tlRFrWaUSJeiFAqpFWi6P+68ureclGbkfsEi7IL
4Kkjrm2EgTrL4aPjLzCaLoEfz8RglwNZjBdxjqItvZ1TtW2H6a6KrdVSL4L2nWyv
0bmG9iVimG/R8Cy61JCUqEJtFLse2k82/ioOpvXnul4/2/y3htgzHvATaqFDUVM=
=a9ZT
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
