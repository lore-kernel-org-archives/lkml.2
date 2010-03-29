Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0C2WDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:03:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560Ab0C2WDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:03:12 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       michael.s.gilbert@gmail.com, davem@davemeloft.net, romieu@fr.zoreil.com,
       eric.dumazet@gmail.com
In-Reply-To: <20100329160356.GC22733@hmsreliant.think-freely.org>
References: <20100329160356.GC22733@hmsreliant.think-freely.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-utpa6senRceaDYxKXl54"
Date: Mon, 29 Mar 2010 23:01:45 +0100
Message-ID: <1269900105.8653.389.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] r8169: offical fix for CVE-2009-4537 (overlength frame
 DMAs)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-utpa6senRceaDYxKXl54
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 12:03 -0400, Neil Horman wrote:
> Official patch to fix the r8169 frame length check error.
>=20
> Based on this initial thread:
> http://marc.info/?l=3Dlinux-netdev&m=3D126202972828626&w=3D1
> This is the official patch to fix the frame length problems in the r8169
> driver.  As noted in the previous thread, while this patch incurs a perfo=
rmance
> hit on the driver, its possible to improve performance dynamically by upd=
ating
> the mtu and rx_copybreak values at runtime to return performance to what =
it was
> for those NICS which are unaffected by the ideosyncracy (if there are any=
).
[...]

I have to say that this compromise behaviour is highly non-obvious.
Further, there is now no way to set a non-standard MTU without enabling
the insecure behaviour.  (This is in part a flaw in the driver
interface, of course.  We should have an interface to get and set MRU
rather than making drivers decide an MRU based on the MTU,
inconsistently and without any visibility to the administrator.)

It also sucks that the secure but low-performance behaviour is enabled
for all variants, while AIUI only some suffer from the bug.  I realise
you probably don't have access to every variant (and neither does
Francois) but perhaps you could come up with a test case that could be
used to start whitelisting common variants that don't have the bug?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-utpa6senRceaDYxKXl54
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS7EjROe/yOyVhhEJAQJcZxAAlTcJ1T80v0YqM8uULEPQTJ5elRPF2HEr
QhvnyQNZvmVI74iJmXfUn59p/itWiwePlIfrCz2E6CKauKDom3TLsHC4nQsR9SXK
bLSGuv1ccmf9zNWAJjvhNvzhsnaaURv+UEsJc1t8tMZ1X0rwmgP6QR6KMGf9n3sA
h0rTSD8t855r49GlRxRhJBcUvaEp3WX9APAUxhWT4djZLOT01lfyd+2nCJp1OgyI
pAbpE4EgKJ06qR51IPy/HBEf8uUCoCVjZhz4G8stpuY8J/sVrPi6QCtd2ghnYtIQ
JrpaiQmFXsHLmZecHkOP0RPGh8qxYiPxXOXIRsyg560jLXqQToFnSqcelEfZZir3
80i0sgEC0CdHKR04Ac+Ema8Crha7S1Q6TnY9btoi0OYF7fZCQ4rTg6tWzh2XCobT
9ocUZzZavzl9RBx3DfrPt8jjzVsfisSWGhAWU4amIIIiNyjX1sQUIzqo5aH999zf
HEBSQ1OrAtDFWGV1tzNJxhlnhYVyYFwWoBrfhg6STzHlHppZ8pLg1ytjghZQUYlc
uOXW4eIgQhPwCuIuJ6cV+dfB075tIzvb3Rs6VFewzQY0SeSZA01WprRxaC1cu5KP
Qed0t787xdPA0k4y6ZsQmhFDOJwmbLSiRozdyogGSZivHKFD7CB86OLXm7a5Ieze
UYHlqM3O4UI=
=SJ8h
-----END PGP SIGNATURE-----

--=-utpa6senRceaDYxKXl54--
