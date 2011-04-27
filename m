Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1D0NI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:08:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55641 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1D0NI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:08:27 -0400
Date: Wed, 27 Apr 2011 09:08:22 -0400
From: Eric B Munson <emunson@mgebm.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH V4] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110427130822.GC2936@mgebm.net>
References: <20110427121902.GA2936@mgebm.net>
 <AE90C24D6B3A694183C094C60CF0A2F6D8AD04@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD04@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Apr 2011, David Laight wrote:

> =20
> > +	if (prev > val && (prev - val) < 256)
> > +		delta =3D 0;
> > +
> > +	return delta;
>=20
> Also, 'prev' is a true 64bit value, but 'val' is only ever 32bits.
> So once the 64bit 'prev' exceeds 2^32+256 both 'prev > val'
> and 'prev - val' are true regardless of the value of 'val'.
> This will lead to jumps in the value ....

prev and val are both 64 bit variables holding 32 bit numbers, we do not
accumulate in either, they are both replaced by values directly from the
registers.  So prev > val will not always be true.

Eric

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNuBVGAAoJEH65iIruGRnNuqYH/ibWoBdbN/59Q0KgkLPb2M1k
/9WNZIuerrVdLB/wwhFBT82fiqCLeWXLJ+MLaH38pKKVvdCCYTgvvzj2KhQyymhC
wPkf/aBlyl3dhtz8xl4c9ZmeZN34xTr/LQSbafRXTu3d++sn2T3uHGXWpUDCJzKo
s0uYPl8ByMgk0yIKqKGp94FZ2p1W6RpiEEV5lUwt1VKA7Q4WG98SY2umWZBqvnJP
nmuouW3CS2GaVKF9wfOk1erZbKZ3FbgOjxPpnuDyXCbBtPF+UZQXstNhgnM1fpoP
2joy+fIhcelDJ9tHMDNMsBI08mZHLFeayfDnKEHUU1/GFgZaHY9bVgYeXIv64X8=
=YjqT
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
