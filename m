Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1HGSWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 14:22:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59032 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab1HGSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 14:22:37 -0400
Subject: Re: [Stable-review] [07/55] SUNRPC: Fix a race between work-queue
 and rpc_killall_tasks
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110806000249.573906795@clark.kroah.org>
References: <20110806000249.573906795@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-hDw9Yow7oUKyxYXNZnRQ"
Date: Sun, 07 Aug 2011 18:38:01 +0100
Message-ID: <1312738681.2591.1024.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hDw9Yow7oUKyxYXNZnRQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>=20
> commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 upstream.
>=20
> Since rpc_killall_tasks may modify the rpc_task's tk_action field
> without any locking, we need to be careful when dereferencing it.
[...]

This isn't nearly careful enough to avoid races.  You must at least use
the ACCESS_ONCE macro, otherwise the compiler can just optimise away the
local variable this introduces.

Ben.


--=-hDw9Yow7oUKyxYXNZnRQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATj7NeOe/yOyVhhEJAQo7Fg/+Pul3rkBiO3WzsIW/Q0vKVcUNNwirMVzQ
VSAqWVm6rNP9G3cF/xnMnglWuJL/Gzyy/KuDjKK5hHBWh6IUdwYFVvCOtRB6iyYd
DoRQy1IXDyzcgtdJK/2uq0MC0aaebxSCiZ6k18JoLBDcD0CJK/4n4PeQEfOb5Ym6
H3YRRx2gPCwsdo4+dbN/jWKAZdwGVJ2BZOC9Waq2mEDe7EKG8/q8FHbCF+DJE2YW
529ZQq5joObWvKd+PR5Ab7m0yVkuSPqfjeVTjhxg1nlJ3L65KHMtEiGt0eVgQEr3
rdgNxQ75C0zzZyfsMUqLViZBY+tf8lm9Vs8epNwpUv/7xoooU0K2F9UPQCuBv1vm
5EhNQoGOLKLCUMihypovjeQ0bencTw7+6q54oofAgGTuRP1VTICmeOwswarPi2UE
q9fOlVWidBStNPgtaBLHV3O4serX0eao2ZawnQOgOw1/Qomnnj3cdhUbbmzNpsue
hnthjBN8uLcd6cONBukORMtfcTdtUWu9LdR95qtZiXk1kHHOYH65eIUZqz6gq1Ap
KlIJn9v+JBx5JaZPPzpExkPMrgkfgkXiGCFiu/0jc2bvknpVnFr/4CGkwTuOvGaj
Xwh9cjZi4wWfxWCQViIxS4Zfg7A4Rji2jewGWekTTf8wiiwrvf1024UvbOhgvfxu
Agnyx4IoT+0=
=3pvt
-----END PGP SIGNATURE-----

--=-hDw9Yow7oUKyxYXNZnRQ--
