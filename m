Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2EKKtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:49:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758328Ab2EKKtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:49:17 -0400
Message-ID: <4FACEEA1.9020400@nod.at>
Date: Fri, 11 May 2012 12:49:05 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tim.bird@am.sony.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de
Subject: Re: [RFC v2] UBI: UBIVIS (aka checkpointing) support
References: <1336585125-127220-1-git-send-email-richard@nod.at>  <1336624000.1936.22.camel@brekeke> <4FAB7D70.1040704@nod.at> <1336733182.2625.17.camel@sauron.fi.intel.com>
In-Reply-To: <1336733182.2625.17.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4331553F95E0AAFE1602F32"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4331553F95E0AAFE1602F32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 11.05.2012 12:46, schrieb Artem Bityutskiy:
> On Thu, 2012-05-10 at 10:33 +0200, Richard Weinberger wrote:
>> First of all, yes it's fully backward-compatible. It uses two new inte=
rnal volume IDs
>> with compat =3D UBI_COMPAT_DELETE.
>> Old UBI implementations will delete the checkpoint and continue with s=
canning...
>=20
> OK. BTW, these patches do not compile when the fastmap is disabled. I
> hope you'll just kill the ifdefs in the next revision and this problem
> will go away.

It builds fine here with CONFIG_MTD_UBI_CHECKPOINT=3Dn.
What error do you get?

>> Regarding design, ubi_wl_get_peb() currently offers three types of dat=
a types.
>> UBI_LONGTERM, UBI_SHORTTERM and UBI_UNKNOWN. Do we really need them?
>> Checkpointing has a pool of unknown PEBs. This PEBs have to be scanned=
 while attaching.
>> For now I had to create three pools (for UBI_LONGTERM, UBI_SHORTTERM a=
nd UBI_UNKNOWN).
>> This makes the whole thing complexer than needed.
>> It introduces also some nasty corner cases.
>=20
> But AFAIR we already agreed that we kill these, no? I thought you'll
> send a separate patch for this. We do not need this feature and to our
> shame it even was not working and there was a bug found very recently.

Perfect!
I was confused and thought that this feature will be removed later...

Thanks,
//richard


--------------enigD4331553F95E0AAFE1602F32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPrO6oAAoJEN9758yqZn9eKB0IAINa5vvj6Wdo9zI9NQtZr5RC
OLUL7rs9GlZUPhNM3YuA4CNOCv2cY7uDhRGayg1MYTe5o3Gr+p50sK43RUMxLguj
S5JieWvEL/gGBtRgE8+Qs6nI2dmJq5JxZdNcVRPdy8UFW0DCtnnTW5gavqKe12lQ
RDGHV1Dh9/S/y9N0VQ5bRyB+P0jmi0+Pad0Xl7aAuy7d7sdCkGW/jn+7EQKPZUg/
Kz3/uY0VzPU9OyrpRDF/t1bQtAwAnp4Rt5h4pS4w/lnO7G2x8i3HUaee776oeYbz
xURb4MOYYwokK/5XYkhYcUSknPTGk77Jes2/08tAeDvS43OwxhQBH8nGpazgUv4=
=Mbaq
-----END PGP SIGNATURE-----

--------------enigD4331553F95E0AAFE1602F32--
