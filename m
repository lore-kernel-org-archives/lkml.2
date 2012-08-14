Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2HNO20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:28:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab2HNO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:28:23 -0400
Message-ID: <1344954487.824.203.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 3/6] floppy: avoid leaking extra reference to queue
 on do_floppy_init error handling
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 14 Aug 2012 15:28:07 +0100
In-Reply-To: <20120814090330.GC2423@redhat.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
	 <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
	 <20120814090330.GC2423@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tvQk/yDrVwtVdnzsQhpk"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tvQk/yDrVwtVdnzsQhpk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-14 at 11:03 +0200, Stanislaw Gruszka wrote:
> On Tue, Aug 14, 2012 at 04:20:39AM +0100, Ben Hutchings wrote:
> > On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> > > After commit 3f9a5aa ("floppy: Cleanup disk->queue before caling
> > > put_disk() if add_disk() was never called"), if something fails in th=
e
> > > add_disk loop, we unconditionally set disks[dr]->queue to NULL. But
> > > that's wrong, since we may have succesfully done an add_disk on some =
of
> > > the drives previously in the loop, and in this case we would end up w=
ith
> > > an extra reference to the disks[dr]->queue.
> > >=20
> > > Add a new global array to mark "registered" disks, and use that to ch=
eck
> > > if we did an add_disk on one of the disks already. Using an array to
> > > track added disks also will help to simplify/cleanup code later, as
> > > suggested by Vivek Goyal.
> > [...]
> >=20
> > It's totally ridiculous that a driver should have to do this.  Any
> > registered disk should have the GENHD_FL_UP flag set... so why can't
> > genhd check it?  It doesn't look like floppy is the only driver affecte=
d
> > by this problem, either.  So I suggest the following general fix
> > (untested):
> >=20
> > ---
> > Subject: genhd: Make put_disk() safe for disks that have not been regis=
tered
> >=20
> > Since commit 9f53d2f ('block: fix __blkdev_get and add_disk race
> > condition'), add_disk() adds a reference to disk->queue,
>=20
> I do not see this? Commit 9f53d2fe insert disk_alloc_events() to add_disk=
(),
> but disk_alloc_events() function does not get any reference to disk->queu=
e,
> I missed something?

Sorry, not sure why I pointed to that one.  The reference should of
course be to:

commit 523e1d399ce0e23bec562abe2b2f8d297af81161
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Oct 19 14:31:07 2011 +0200

    block: make gendisk hold a reference to its queue

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-tvQk/yDrVwtVdnzsQhpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCpgd+e/yOyVhhEJAQpUKhAAh4NHuv/YfC9euN9RNY3e1eh8NAkKaqUf
5t5ocC5xCp/M/N5WOCl3k5Frr+xp2zcfrTnVfy31U+b7R/ViQ6EcmBJoN34dhi9Y
Q2vw/MHesNNwTjQs8XqqMPW1th8vCket6Ibp7ZAWE4QrEVFFGERf1T1Jhfb7COTQ
COLSNbkmHrPgHfU3gCs2/9h10mA8sewQ6MlUutq/2P6i7XmKPIphLfwOVuBUZDwi
sPDFkLRO7QzAQkD6hs7v4tXNp0q8f8uGw4yamkIkI1LKOgS15Os7M/jjkFVuTOuQ
TF1s9aSnqas8aGkyrfGN/6MFl7POpz7XwWY5KunXRwi8EKs3kp1lfy8iWixxAcdO
oZQ7/1jA0EauGLE0sEpk6nOiyBLxaBIaci+dtVNtw2tkHgrSr7ORAEpLtQGHUZUF
FbSkAniiH68Tl5jnc2jYzmQ6aZveG1Z3GsolrOVwPCl33LKR86O6e7+7lgSYF4Ft
kqP9i0/I6uO9MCWq1Y3+NY1k0PENi3/Eg9SvWP46P7y9aiDWppLvgujZzBJquy8h
CAq0vc5DhaAHQaV9osjve/LymkVgAcMLK766D5pJ57MvJKOwKrQr3MzWExww20GL
FKMhMf9gaANF4zgXGn41sTPJJ+6T0F8hRloKhVwOq3YyRDrcaKSGwt7h8pJOOWfu
9jXRqr9zVPs=
=5I0e
-----END PGP SIGNATURE-----

--=-tvQk/yDrVwtVdnzsQhpk--
