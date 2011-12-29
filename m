Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1L2QAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:00:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40788 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab1L2QAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:00:38 -0500
Message-ID: <1325174416.13595.34.camel@deadeye>
Subject: Underflow in system time reported by getrusage()
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: 652732@bugs.debian.org, Vincent Lefevre <vincent@vinc17.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 29 Dec 2011 17:00:16 +0100
In-Reply-To: <20111220121401.GA11097@ypig.lip.ens-lyon.fr>
References: <20111220121401.GA11097@ypig.lip.ens-lyon.fr>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5ZwAs40bPsr4V6I1DXfu"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 176.99.123.158
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5ZwAs40bPsr4V6I1DXfu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-20 at 13:14 +0100, Vincent Lefevre wrote:
> Package: linux-2.6
> Version: 3.1.5-1
> Severity: minor
>=20
> I've had the following problem (under zsh-beta):
>=20
> ypig:~> time ./a.out 0.999
> ./a.out 0.999  2.87s user 18446744073.71s system -2147483648% cpu 2.902 t=
otal
>=20
> Of course, I can't reproduce it. I suppose this problem is quite rare
> and occurs under some particular conditions.

The value reported for system time looks close to the maximum possible
64-bit number of microseconds, presumably resulting from an underflow.

Looking at the Debian source package zsh-beta, version
4.3.15-dev-0+20111220-1, it appears to use getrusage() where available,
and doesn't appear to do any calculations that might cause such
underflow.

Ben.

> I've search on Google and could only find:
>=20
>   http://ftp.zcu.cz/mirrors/linux/kernel/v2.6/snapshots/old/patch-2.6.25-=
git4.log
>=20
> which mentions a "very huge system time" problem on IA64 due to
> interrupts. This is unrelated, but could give an idea about a
> possible cause...
[...]

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

--=-5ZwAs40bPsr4V6I1DXfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATvyOkOe/yOyVhhEJAQqIeQ/+IEgHYly0pOhyUa8xouM+9hUl8PLC5ZNA
KkBZRr5FFPsJ+nuWeTlW8mukIzEGqIGWUaKlfsGdJ4XJz1s+FwSnt9+M+VU2U0KS
LMTiwiLTD57ATs0bxE9gEA5bzR2lgR73saBqSdBNY4+N5Jx5kbz4BgB50Nhxaskj
Rh3C/PSOYQlmVxeRxTtyrd9zDLS/Aa/1daQjTDzkzWjde+PMuWpvGmued2iCo7Xl
7VOR1gdKxS0HvcaAmkGMxrlyrz2UUFVxido944BiVeUP7rAHYFxkFPlxNksaU/Mj
qGvZNhMImBgArta5hJoEJeVhlGO8QNeV0bCBKt6AFDsPHqAfsLrbmR7fLs19107x
l7MNTdr0FXmhJMhcOq58HBIVr2YVHVs0lUGM22ltn57HTSdQDW5aTE95+QpVl4yA
muPSEDrNbC2SeUF5ecOuAOPgPxGuu/zYR9gI7nZ/DLzX4W7W8W+Ii9py8NO4xOyd
xBeJtgYoXFmTH6YAV0CnZ9pMP5QtHkRrP+ny9GQ+ehCGr5UjRmwfMPgPv0FRCpVu
/bq6u1fEGjOWS21LLB2CmY8iy3paPgpfGI0pmC2N4MNokDJQo5Cf7q1lgObVTH7+
o3O4piuAigFo2xEteJgnj1Y9ZtaZkZy/d/X8qJ8qE7lz/njUc4dPYg7wno2DKCHH
UoIFR2zG69Y=
=LGPu
-----END PGP SIGNATURE-----

--=-5ZwAs40bPsr4V6I1DXfu--
