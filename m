Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GHCGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 22:06:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab2GHCGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 22:06:46 -0400
Message-ID: <1341713191.25597.207.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 07/12] random: use the arch-specific rng in
 xfer_secondary_pool
From: Ben Hutchings <ben@decadent.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, stable@vger.kernel.org
Date: Sun, 08 Jul 2012 03:06:31 +0100
In-Reply-To: <20120708014124.GA3809@thunk.org>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
	 <1341614704-24965-8-git-send-email-tytso@mit.edu>
	 <1341709606.25597.182.camel@deadeye.wl.decadent.org.uk>
	 <20120708014124.GA3809@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-guYlRJT20lrZF53RFjFh"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-guYlRJT20lrZF53RFjFh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-07-07 at 21:41 -0400, Theodore Ts'o wrote:
> On Sun, Jul 08, 2012 at 02:06:46AM +0100, Ben Hutchings wrote:
> >=20
> > Surely the number of random bytes being added is i * sizeof(long), not
> > sizeof(u.hwrand)?
> >=20
>=20
> Meh; Kees Cook has made the same observation.  Basically, in the
> unlikely case where RDRAND fails, we'll end up mixing in stack
> garbage.  It's not a security vulnerability, since the contents of the
> entropy pool never gets exposed.  In fact, one could argue that mixing
> in some unknown garbage from the kernel stack might actually help a
> little; but it can't hurt.

Sorry, I realised after reading further that there's no entropy being
credited.  However, I expect that kmemcheck will complain unless you
limit the used length or call kmemcheck_mark_initialized().

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-guYlRJT20lrZF53RFjFh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/jrJ+e/yOyVhhEJAQoCFw//RELed9kJe17JEPTd7u6Pl82UhX78XtoM
edKxfzApXz36qxuJCxfPTd63q6pQncF5/OBfzipoYq381juKYDywPR2NODrPIlW9
PFRfxSnYK2K3bnu4mTI0sUBR+SZvPdsgvdgjJGMVBPNjPEWugmzz4WmUSUrIf+v5
Y9Zfn/feBfUZM0t2oqY9NqGGy/KM6e5qSaJubuYnCFsm34jibx6/nQ6xTG1i8/hd
dqtL5LAprr3W3tmRQXg3MxJ+Rp/bnUHRSwtxhrOo3TR5xl1++zbVrR4D5IyO+Er+
FIdwRjdMEwlh0D7cs8bIPUhsB2NCZXzroxv9Gfx9n1b1rsiP3IV/+V0LZ3JI5skr
xNzX9KzApigsM6HuMQS42xxjWIQzBR4jrhr30VnaI91WKfrCRdNh6B9E9LSCmdjd
JrMZnk3waAwJ4e95sWB3olr0yc8EmCrspsT5/G7aWuuOSBA5u+pmQrTgE/tkvi8X
zsIoKum/yL4wWWBqjVOMvqThlBrBdTIp6w6Bck5GuUgsJA59ntqvZpZEgDLZsMTG
sytVjk0xkOiDkm2PnJ/oPhjHiKBtkbR8ynPcsHf70kXDEYvI3AEDX61rnq6MQGxV
PdQwKxDpbNx7JEQ38E7ihu/tjmdaS8LYzxU0yqgC3aHH+L8SVo/yb7lKWBmolQqU
oqc6eb8HQTQ=
=pPLs
-----END PGP SIGNATURE-----

--=-guYlRJT20lrZF53RFjFh--
