Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2I1Xht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:37:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59740 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133Ab2I1Xgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:36:53 -0400
Message-ID: <1348875393.6858.15.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 043/218] ARM: 7527/1: uaccess: explicitly check __user
 pointer when !CPU_USE_DOMAINS
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Date: Sat, 29 Sep 2012 01:36:33 +0200
In-Reply-To: <20120928201506.414909935@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
	 <20120928201506.414909935@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ZM03IFB++FOMK/22HzXD"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZM03IFB++FOMK/22HzXD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:14 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Russell King <rmk+kernel@arm.linux.org.uk>
>=20
> commit 8404663f81d212918ff85f493649a7991209fa04 upstream.
>=20
> The {get,put}_user macros don't perform range checking on the provided
> __user address when !CPU_HAS_DOMAINS.
>=20
> This patch reworks the out-of-line assembly accessors to check the user
> address against a specified limit, returning -EFAULT if is is out of
> range.
>=20
> [will: changed get_user register allocation to match put_user]
> [rmk: fixed building on older ARM architectures]
[...]

It looks like this is needed for at least some older kernel versions,
but a backported version will be needed for 3.2 and earlier.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-ZM03IFB++FOMK/22HzXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGY0gee/yOyVhhEJAQrOPxAAufAnrNgyOhql9WYw1SZ97E2E1yU09N97
TNM6BPhgf8CoaeP9Ep5W6o21hw+c9RkSKsTuedaXgOCWSWl9lxpbshYCJfLlKxAj
938mYVjSQfGg/E2hxSqshGQibDjCn4bvEnrLGmHA43tez4Ndv6tIey6f0yMlfI73
UVV3sg1Mdu0TKM/Il53KRBcfj7O0tD0Dj4H+T016xZ/Vp8JzG5c5XLUVjzBl8gUH
fhPZYrGYfYkOhr50x7CkZmmfLaC62YsKQI+NtY+hb/cj8U+FO8wK9y9brV/cpNoO
CrQmDBlVMRbN8TIjRpIPtbijhfesDwIbUMKJW7yTqpwVQZjGUCqi+VTb4+I33gOM
64YI0WpHLq4IgL93NzSckpPiD66M4bB+aqMdzYCmKRJlk08Sto4G5kuhTtCLMVZR
oitWs6wfUEh3PlAwmQokmRI5cB8vAYQvfB2+4j8LjNYieOW+bXuX7YqiISUeEhoT
27bqbsdAG6wdfmYh9UJ8rTenaJk0hr3ez8jNn2JvMiSfwCtQCgJLjWSyyC/Vh8la
kMoTbWylSr9Kpl/USWdoIpduq033c1PiMKT9nLZ9k/TyNPK8KZWrziJjl0WYP5/3
U3y1aEobGQC2hs4aJuO8bnuDsQBa4BYWTgaqXwXX5FTKg3N9Vq8N5iw4fInwHPz9
83iNAxei9wU=
=hmKg
-----END PGP SIGNATURE-----

--=-ZM03IFB++FOMK/22HzXD--
