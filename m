Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2KYNMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:12:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51416 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab2KYNMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:12:03 -0500
Message-ID: <1353849115.4424.6.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/66] GFS2: Test bufdata with buffer locked and
 gfs2_log_lock held
From: Ben Hutchings <ben@decadent.org.uk>
To: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 25 Nov 2012 14:11:55 +0100
In-Reply-To: <20121115040943.748338602@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
	 <20121115040943.748338602@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bL5JcY0JHiTIFz/dsSKX"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 163.5.223.200
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bL5JcY0JHiTIFz/dsSKX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-14 at 20:11 -0800, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.
>=20
> In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to =
the
> buffer without having the gfs2_log_lock held. It was then assuming it wou=
ld
> stay attached for the rest of the function. However, without either the l=
og
> lock being held of the buffer locked, __gfs2_ail_flush() could detach bd =
at any
> time.  This patch moves the locking before the test.  If there isn't a bd
> already attached, gfs2 can safely allocate one and attach it before locki=
ng.
> There is no way that the newly allocated bd could be on the ail list,
> and thus no way for __gfs2_ail_flush() to detach it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

Is this needed for any earlier versions?  It looks applicable to 3.2
(with minor changes).

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-bL5JcY0JHiTIFz/dsSKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULIZG+e/yOyVhhEJAQpFcxAAlY2zxyE49ggI1yyccaPbeikZ0CBOFFCS
LK22rMsY/PPtsFNMxsD1wn8snSAGlcYoYaBBWCHarxTT7SO/riATxPNzOxXXstsS
Nsk/6jRpHiBoGbNnZj+KK/xy2VHmyEX6kZQDN+fnpvwRMga/N3X/vpCrY9ZHAf5e
AMVL7BsdWnZZGC4AIJoR5lxR32pK48a4EnlBhLs72mBF0YvunjuTP6B3l59/dILE
LM3LIsm2j6fi0341L13EwkCQPhQTAKyTdFulwXOd7XEzvSieP2AtJZCvVffDlTQq
gOkT1RzEaKADPiKuc5J5AcegcUdsOLNkInXjSnykNsMFaGYyDHuXRHDS8tK1/2AO
s2xSHywfdXx+jeD312JQZrFPlHeC30vNROIq6Kmt8Nv2ICLMOV+lqcashlidu6qo
rfa9+qfSrxdK3PN5SwR/wqeDINtRB9jIK7fb3kqCvMcgADK08f64atVjoPxphzb7
n4AYkBTIMTKF10AKP3hIHgJrJeVvDH7h0nPS31ruJkmMC3BJFOWzyGkpCKqU7Stz
0CxoenYHR5e51T24htBXODUkXaP8pmvx4w6iG6oUQBK2+1BpatqyynFKFo6eLhGV
pjMKAC3BVjGEOw109jdR6jUCCraGUxijVGwvnaVcLeGGplbZpXWMdDESOFIYJI5D
TjTEqc38A8c=
=euRV
-----END PGP SIGNATURE-----

--=-bL5JcY0JHiTIFz/dsSKX--
