Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1D0NVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:21:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62047 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab1D0NU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:20:59 -0400
Date: Wed, 27 Apr 2011 09:20:54 -0400
From: Eric B Munson <emunson@mgebm.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH V4] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110427132053.GD2936@mgebm.net>
References: <20110427130822.GC2936@mgebm.net>
 <AE90C24D6B3A694183C094C60CF0A2F6D8AD06@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD06@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Apr 2011, David Laight wrote:

> =20
> > prev and val are both 64 bit variables holding 32 bit numbers, we do
> not
> > accumulate in either, they are both replaced by values directly from
> the
> > registers.
> > So prev > val will not always be true.
>=20
> The code seems to be:
>     prev =3D local64_read(&event->hw.prev_count);
>     val =3D read_pmc(event->hw.idx);
>     delta =3D check_and_compute_delta(prev, val);
>     local64_add(delta, &event->count);
> Which looks very much like 'prev' being a 64bit counter generated
> from the 32bit pmc register.
>=20

Which implies that it will only ever be 32 bits wide, just stored in 64.

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNuBg1AAoJEH65iIruGRnNzGYIAJIsoYp0R/dJvlfUncOh3B6e
FGoYP9TL6so1Wa//AYLYgWG7ERPn6XAfIOQx99XzqEhf4sQhJ066c+pz9jnNu6JY
9Gl7r8haQ81bxzkNNIPws45il40/wyTJNtBajWuAz/AH+Vh/BkEyjTtzLupawOeQ
AvOPZmVL2Rn+i/zc+3blf5yfeFwX90m2Nqzfj2qGLJcMQ+KN3tH3sLnoXyT+8dn1
JRcXFPo2AnoD7f43UBiuHq3WsIpnGlly1NN8HOR6zBxI8crrj+l57h/+F5fOzZIm
KcdqQlPkBXLowV24Zd48V0j/goEacK5ZoXQUWygFnpCq+l+T4wvE/jNwteHGi1o=
=QRrD
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
