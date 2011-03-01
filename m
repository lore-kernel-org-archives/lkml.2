Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1CAV5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:57:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:25333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab1CAV5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,249,1297065600"; 
   d="asc'?scan'208";a="662794912"
Subject: Re: [Stable-review] [22/68] ixgbe: prevent speculative processing
 of descriptors before ready
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Greg KH <gregkh@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        Milton Miller <miltonm@bga.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20110301204612.GA16194@suse.de>
References: <20110228162407.878045010@clark.kroah.org>
	 <1298945674.3069.188.camel@localhost>  <20110301204612.GA16194@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lm46BwAT4FUXJS5kh1sq"
Organization: Intel Corporation
Date: Tue, 01 Mar 2011 13:56:20 -0800
Message-ID: <1299016580.3187.98.camel@jtkirshe-MOBL1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lm46BwAT4FUXJS5kh1sq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-03-01 at 12:46 -0800, Greg KH wrote:
> On Tue, Mar 01, 2011 at 02:14:33AM +0000, Ben Hutchings wrote:
> > On Mon, 2011-02-28 at 08:22 -0800, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please l=
et us know.
> > >=20
> > > ------------------
> > >=20
> > > From: Milton Miller <miltonm@bga.com>
> > >=20
> > > commit 3c945e5b3719bcc18c6ddd31bbcae8ef94f3d19a upstream.
> > >=20
> > > The PowerPC architecture does not require loads to independent bytes =
to be
> > > ordered without adding an explicit barrier.
> > >=20
> > > In ixgbe_clean_rx_irq we load the status bit then load the packet dat=
a.
> > > With packet split disabled if these loads go out of order we get a
> > > stale packet, but we will notice the bad sequence numbers and drop it=
.
> > >=20
> > > The problem occurs with packet split enabled where the TCP/IP header =
and data
> > > are in different descriptors. If the reads go out of order we may hav=
e data
> > > that doesn't match the TCP/IP header. Since we use hardware checksumm=
ing this
> > > bad data is never verified and it makes it all the way to the applica=
tion.
> > [...]
> >=20
> > Packet splitting should be completely disabled on the 82599, anyway.
> > Greg, what happened to this patch:
> >=20
> > commit a124339ad28389093ed15eca990d39c51c5736cc
> > Author: Don Skidmore <donald.c.skidmore@intel.com>
> > Date:   Tue Jan 18 22:53:47 2011 +0000
> >=20
> >     ixgbe: fix for 82599 erratum on Header Splitting
> >    =20
> >     We have found a hardware erratum on 82599 hardware that can lead to
> >     unpredictable behavior when Header Splitting mode is enabled.  So
> >     we are no longer enabling this feature on affected hardware.
> >    =20
> >     Please see the 82599 Specification Update for more information.
> >    =20
> >     CC: stable@kernel.org
> >     Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
> >     Tested-by: Stephen Ko <stephen.s.ko@intel.com>
> >     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
> It does not apply to the .32 kernel.
>=20
> Care to provide a backport if you feel it should be there?
>=20
> thanks,
>=20
> greg k-h

Don is working on patch for .32 kernel, I hope to send it out no later
than tomorrow.

--=-lm46BwAT4FUXJS5kh1sq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJNbWuEAAoJECTsCADr/EWUR0UH/iPqGU6aYOvowq90sMAIqeoI
X2K5SDgxkV1F+USWv3K68nsJ1DiTWJrBcnguW03CcZxFeQFyWE0tE7cSVAZhPTW/
m6eMuZFS6KY9aa73MlNTuwR5PQ1ms+F5RVLWSxHac9G+8fooFZtfHc/l8wrkAWOX
8QG8O5nDbbPwTXDMqhVZvnRlkexPb9c+6FliaEpKlhZ2CpIcnPvKCw+YOttFMkrw
e5LO7ISBEF8fBoKfVHGO3DfNTPyNRCLUDqhWBu6RyH8berKjM/0+S49FZN+Wn8Wq
Fn18qSqz0v2XdggnAqSE8Gui9+vU6G3lYMiVYI71GQapOT2EQogHmwXKggk5oEY=
=cOdO
-----END PGP SIGNATURE-----

--=-lm46BwAT4FUXJS5kh1sq--

