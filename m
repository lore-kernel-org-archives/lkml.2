Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2DIKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:16:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab2DIKQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:16:27 -0400
Message-ID: <4F82B6ED.2010500@nod.at>
Date: Mon, 09 Apr 2012 12:16:13 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: swapoff() runs forever
References: <4F81F564.3020904@nod.at> <4F82752A.6020206@openvz.org>
In-Reply-To: <4F82752A.6020206@openvz.org>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBD799693CD890BDBE013638D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBD799693CD890BDBE013638D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 09.04.2012 07:35, schrieb Konstantin Khlebnikov:
> Richard Weinberger wrote:
>> Hi!
>>
>> I'm observing a strange issue (at least on UML) on recent Linux kernel=
s.
>> If swap is being used the swapoff() system call never terminates.
>> To be precise "while ((i =3D find_next_to_unuse(si, i)) !=3D 0)" in tr=
y_to_unuse()
>> never terminates.
>>
>> The affected machine has 256MiB ram and 256MiB swap.
>> If an application uses more than 256MiB memory swap is being used.
>> But after the application terminates the free command still reports th=
at a few
>> MiB are on my swap device and swappoff never terminates.
>=20
> After last tmpfs changes swapoff can take minutes.
> Or this time it really never terminates?

I've never waited forever. ;-)
Once I've waited for >30 minutes.

I don't think that it's related to tmpfs because it happens
also while shutting down the system after all filesystems have been unmou=
nted.

Thanks,
//richard




--------------enigBD799693CD890BDBE013638D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPgrbyAAoJEN9758yqZn9eyBMIALDoheg9bfPAurW+ARIpQMtf
Q72AuH3im8tSn265fHkMGbU+PCgENM0dshhwiVjuORHYNitS/jJbUarlXBvmaT1p
bnWAjP+NGaziIpXB/eNFv8o7EAzJZ70c0uSuHyKK1pAxCl/ULaa1DjwghlW2sQub
RRebyrT2LDTG+DlncPgbEkUppjz6A22KAMPjHftRGaLhHT40AAls/zdhHav1bzRe
Ho65Q0H/Q40Kvop25NcuDZyX4LeybAFdGSV/HfJYWVuUOSW2MB1AzkxLW8M9Amt4
/L4Prwk4PVIZNcjtkU2IT294dOS0CZ6JsJioMMxQxByqhCkJVz8sV+OcnKBw+kc=
=3lPR
-----END PGP SIGNATURE-----

--------------enigBD799693CD890BDBE013638D--
