Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2EJIeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:34:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab2EJIeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:34:01 -0400
Message-ID: <4FAB7D70.1040704@nod.at>
Date: Thu, 10 May 2012 10:33:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tim.bird@am.sony.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de
Subject: Re: [RFC v2] UBI: UBIVIS (aka checkpointing) support
References: <1336585125-127220-1-git-send-email-richard@nod.at> <1336624000.1936.22.camel@brekeke>
In-Reply-To: <1336624000.1936.22.camel@brekeke>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A472D14821CF0BDA8640FA7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A472D14821CF0BDA8640FA7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Artem!

Am 10.05.2012 06:26, schrieb Artem Bityutskiy:
> Hi Richard, I would like to complain about the names again. I though I
> better give this feed back as soon as possible...

No problem. :)

> Firs of all, thanks for doing this, I will look closer, and I am very
> keen of merging this stuff once we are sure its design is good, allows
> for future extensions and is backward-compatible.
>=20

Yeah.
First of all, yes it's fully backward-compatible. It uses two new interna=
l volume IDs
with compat =3D UBI_COMPAT_DELETE.
Old UBI implementations will delete the checkpoint and continue with scan=
ning...

Regarding design, ubi_wl_get_peb() currently offers three types of data t=
ypes.
UBI_LONGTERM, UBI_SHORTTERM and UBI_UNKNOWN. Do we really need them?
Checkpointing has a pool of unknown PEBs. This PEBs have to be scanned wh=
ile attaching.
For now I had to create three pools (for UBI_LONGTERM, UBI_SHORTTERM and =
UBI_UNKNOWN).
This makes the whole thing complexer than needed.
It introduces also some nasty corner cases.

To make the review easier for you:
The most critical code path is scan_pool() -> process_pool_seb() -> updat=
e_vol().
It searches within a pool for PEBs which are no longer empty and scans th=
em.
After that it updates the corresponding volume.

ubi_update_checkpoint() is also very important because it has to find
unused PEBs at the beginning of the MTD to place the super block.

> So may be just naming your stuff UBI2, having terms like "UBI2 format",=

> would be the easiest? Then someone could make this to be UBI3. A
> documentation section could describe what UBI2 is and how it is
> different from UBI1 or just UBI.

Okay, got your point.
I think "fastmap" is a good name because I can also use it within the cod=
e.
So, while reviewing the code please keep s/checkpoint/fastmap/g and s/cp/=
fm/g in mind. ;-)

I like the UBI2 idea. UBI2 =3D UBI + fastmap.
After the UBI2/fastmap design is stable I will happily write a detailed d=
esign paper
for http://www.linux-mtd.infradead.org/doc/ubi.html.

Thanks,
//richard


--------------enig4A472D14821CF0BDA8640FA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPq310AAoJEN9758yqZn9eJnUH/iPEVCRsCCbajySwTx1bc8Sq
/m1474PrumjB9LzCePlAWlixsQkBf9YsSvDInexHuQWQFc9YS8LbVG/E51qVZM+y
nX6aoS9aVkmKSxtLxm9VAYDJ2VPOP3EO7a0Tlsf7qaA74RdCz8TISUEXdUjCiKRK
YpfylfuZE3bKTRHHp79/8KyotfiUv1QefDLGl9AsjBhka9kbB/4X0EY3t9YZan/N
anqMGbDss8I1ckPXp1Y1MBPZ3pOO+qqi7zMPrGNMciEFHIHMitxry+COzj5slX2+
ZPKM7HL5Wtyz590yePaLjIjYNfdLRqrYFD46BZNK/0TmEaOw/9T2hX3ruOYrmHE=
=7lwM
-----END PGP SIGNATURE-----

--------------enig4A472D14821CF0BDA8640FA7--
