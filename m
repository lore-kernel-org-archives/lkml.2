Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0KXKXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:23:51 -0500
Received: from ozlabs.org ([203.10.76.45]:32783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab0KXKXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:23:50 -0500
Subject: Re: How do I choose an arbitrary minor number for my tty device?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Scott Wood <scottwood@freescale.com>
Cc: Timur Tabi <timur@freescale.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
In-Reply-To: <20101118121356.3491da72@udp111988uds.am.freescale.net>
References: <4CE44B1B.9040709@freescale.com>
	 <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com>
	 <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com>
	 <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com>
	 <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com>
	 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
	 <4CE5657D.8060105@freescale.com>
	 <20101118121356.3491da72@udp111988uds.am.freescale.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N4RP0bbdnn6bv+SchMpR"
Date: Wed, 24 Nov 2010 21:23:47 +1100
Message-ID: <1290594227.4446.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N4RP0bbdnn6bv+SchMpR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-18 at 12:13 -0600, Scott Wood wrote:
> On Thu, 18 Nov 2010 11:42:21 -0600
> Timur Tabi <timur@freescale.com> wrote:
>=20
> > Scott Wood wrote:

> > > We should add a proper bus for the "handles" node.  Then sysfs should
> > > show the link between the tty device and a device tree node -- which =
is
> > > really what we're after, the handle is just a means to that end.
> >=20
> > How exactly do I do that?
>=20
> Pass the platform device pointer to tty_register_device.
>=20
> Then, in the sysfs node, "driver" should be a symlink to
> another sysfs node whose path looks lind of like an OF path.
>=20
> Unfortunately, it's not an exact match, and the fact that reg doesn't
> translate to a physical address means that AFAICT you'll currently get
> something like "byte-channel.nnn", where "nnn" is an arbitrary
> kernel-assigned number.

Can you not use device_rename() ?

> It would be nice if platform devices that are created from device tree
> nodes included a link to the corresponding /proc/device-tree node in
> their sysfs node.

It's not a link, but the OF path is in devspec, so you can work it out
fairly easily.

cheers






--=-N4RP0bbdnn6bv+SchMpR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzs57MACgkQdSjSd0sB4dIH8ACgkvLkxQfig/lb2LUj9U9nzgPf
6OoAnj0MQDKDrEqSe84QdPiKV4mYQj29
=uXHB
-----END PGP SIGNATURE-----

--=-N4RP0bbdnn6bv+SchMpR--

