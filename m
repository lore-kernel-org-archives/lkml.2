Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2LRMiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:38:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44312 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490Ab2LRMiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:38:19 -0500
Message-ID: <1355834283.18807.227.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomas Hozza <thozza@redhat.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Date: Tue, 18 Dec 2012 12:38:03 +0000
In-Reply-To: <1628506728.5754343.1355817969825.JavaMail.root@redhat.com>
References: <1628506728.5754343.1355817969825.JavaMail.root@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gFli+UQD9C84G1uGc4h6"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gFli+UQD9C84G1uGc4h6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-12-18 at 03:06 -0500, Tomas Hozza wrote:
> ----- Original Message -----
> > > This is just for sanity. The value PATH_MAX was chosen after
> > > discussion
> > > with K. Y. Srinivasan and Olaf Hering instead of some "magic"
> > > number like
> > > 256 or 512.
> >=20
> > PATH_MAX is a magic name.
>=20
> It is defined in "limits.h". I would welcome some more constructive
> argumentation and critics.

It still bears no relation to any actual limit in the C library or Linux
kernel.  So it's no more valid than the previous number.

In the current context we're enumerating /sys/class/net and we know that
all the interface names in there are limited to IFNAMSIZ-1 =3D 15 (there
is also potentially "bonding_masters").  The longest path name we need
to use is definitely much shorter than even 256 bytes.

> > > > Using snprintf() is a good idea, but you need to check the return
> > > > value and handle the truncation case somehow.
> > >=20
> > > By using PATH_MAX sized buffer there is no need for handling the
> > > truncation
> > > case.
> > =20
> > You are claiming two contradictory things: sprintf() may overrun the
> > buffer, so we need the length check provided by snprintf(), but there
> > is no need to check for truncation because we know the length is
> > sufficient.
>=20
> So what do you propose? How should it be solved?

	if (snprintf(dev_id, sizeof(dev_id), ...) >=3D sizeof(dev_id))
		continue;

Possibly logging a warning.

Ben.

--=20
Ben Hutchings
Life is like a sewer:
what you get out of it depends on what you put into it.

--=-gFli+UQD9C84G1uGc4h6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNBjq+e/yOyVhhEJAQqmJA/+Kgh/fcMxqwO5KSDNL7eQ9+9JTRKJhZfH
V2uCziuxpuZYt9TqZwS0UheDcxbyG44B13bhcCFv3AVrFRPH1ckRstOxeiIdhk0Q
+EysHqKbcApcIzNEBbe5ysN7oEw7l/zzHsZqyfg0xDcB+g3mO5Vu8mG8o7VcwRK6
6vz8V+Np+QjGauI+xq4hWNrQHCq9sA6mXbmbypL3GXT7X6yquF8AMjjT4ZLs6VeL
YVbgCf0jozZvLOSfjHvDHFvaf6exBkykCyWwBW0uBoZS82/arUK2LtGF3u03/pYT
QRMS9yBOo4EIx8ZyjiLSUv+Bwr6xWiUQER95cJY2IhVziBlF9C/Wd62ntDadHINl
xN5YqcylXJALsYdSlYiwRt4YfOTkl3NTHauBebYZMSJPCmLwBHGNkNPAH7d+yD0i
m9Udj4P73Xi/RATm6kvAAcXh3r+o0sL/ukw/+DsI9cKhGt+PCu8P+Z96DHKv0Pw4
AQs7mUk6k8cKPDRJqA43Zni0OBzoVe5cAZM3sS7ntCEAdRXTpRhCZWs8xrrqwD+L
JrDaC2AHLCR7qhzZx3QpKveres1u3JXAQtK6gPDVUvgVzMbJopU2lgL6A4/vSgOl
Kti33JCHcKZfBzLDcVEDkUOBoFQ643taWUDzIspUVz/zwFb3sZuElIMMs0X6tu5o
CXBE+wbT8n8=
=KzQl
-----END PGP SIGNATURE-----

--=-gFli+UQD9C84G1uGc4h6--
