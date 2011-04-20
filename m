Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1DTBlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:41:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53286 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab1DTBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:41:04 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <20110419204117.979118654@clark.kroah.org>
References: <20110419204117.979118654@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-GakxzpHyiyAAN5QmupdC"
Date: Wed, 20 Apr 2011 02:40:53 +0100
Message-ID: <1303263653.3464.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GakxzpHyiyAAN5QmupdC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Hans Rosenfeld <hans.rosenfeld@amd.com>
>=20
> commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
>=20
> Remove check_c1e_idle() and use the new AMD errata checking framework
> instead.

Clean-up patches are generally not candidates for longterm updates.

However, I notice that the range of procesors considered to have erratum
400 was also changed:

[...]
> +const int amd_erratum_400[] =3D
> +	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
> +			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
[...]
> -	/* Family 0x0f models < rev F do not have C1E */
> -	if (c->x86 =3D=3D 0x0F && c->x86_model >=3D 0x40)
> -		return 1;
> -
> -	if (c->x86 =3D=3D 0x10) {
> -		/*
> -		 * check OSVW bit for CPUs that are not affected
> -		 * by erratum #400
> -		 */
> -		if (cpu_has(c, X86_FEATURE_OSVW)) {
[...]
> -		}
> -		return 1;
[...]

Family 0x0f model 0x40 and model 0x41 stepping 0 and 1 are excluded.
Family 0x10 model 0x00, 0x01 and model 0x02 stepping 0 are excluded.
Is that the real fix here?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-GakxzpHyiyAAN5QmupdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa45pee/yOyVhhEJAQqtrBAAkpuXyu13HmvQ7zrsVC9F/FRVwBkZ2DsT
ZeHq1cW7JH12rlnUF/b1z6vIcLNPyqkwcIotG0XfymBBrHN4aPzDKsDzlcI9Veu0
3aRhXcsUcC+QCLV97qdYSq2w8RLJ8CsysTJqpwp+adANZ8LFsoRxiNG/6MaLxXAJ
sCI0Dg76VuT9SRyZntjztqDxOCuTnW8BAjQiowNPkcRBx/B0uL0FeE5A24/hOjTO
9wOD1hcJw4CGA9+Jos/5P5R49wxezeDp77C1m+Y/g+Nt2hazyotr2N0SJF/LTv2e
/JAEy3CsuwSOeTh8lQF1OWe3aEloyFON+Nunj3PWMtRRm+dYZdn3vJafrD8Voik+
2KJ4o67vi4uuJRPhcsjsuPKWHn7/3x8BWfHBQFvKsgwnJm5hJ1BaBrxveqOoJDaC
VQTJXbCk4zd0xsKrsxZSvxoJBGQ9SnY2AmeACS2QXry1KZViI8CbCB3IR3oBd81s
rCajHNQUf9fPPF1yecxYqgeVV5izQAiRpnAg3rNASh8Mkg8gJD/7oAy7dswODn7K
ag61Y1EP+3qgmJ/vRnnWZ/UjVwpo3RYBnZ8zBM2n3tJ8aLhfyOfs64Bd6ZeXlTp9
AzEb4vPd5/wIS8o2jFglddx14PHw2IvOSvcRafSavRM5NkH8hEqkwr3Q6Wgjfd+x
achyOAo4om4=
=NI2M
-----END PGP SIGNATURE-----

--=-GakxzpHyiyAAN5QmupdC--
