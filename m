Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1KWREJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:04:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1KWREG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:04:06 -0500
Date: Wed, 23 Nov 2011 11:03:59 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Halcrow <mhalcrow@google.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, thieule@google.com
Subject: Re: [PATCH] eCryptfs: Check array bounds for filename characters
Message-ID: <20111123170350.GA24836@boyd>
References: <20111121233258.GA18466@google.com>
 <CA+55aFw1XMbJTBifw1sSUN-7cC2BdeeZwPrqkxsboAo6SFSoNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <CA+55aFw1XMbJTBifw1sSUN-7cC2BdeeZwPrqkxsboAo6SFSoNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-21 16:49:07, Linus Torvalds wrote:
> On Mon, Nov 21, 2011 at 3:32 PM, Michael Halcrow <mhalcrow@google.com> wr=
ote:
> > Characters with ASCII values greater than the size of
> > filename_rev_map[] are valid filename
> > characters. ecryptfs_decode_from_filename() will access kernel memory
> > beyond that array, and ecryptfs_parse_tag_70_packet() will then
> > decrypt those characters.
>=20
> Ugh. I really don't like the patch.
>=20
> Why isn't the patch just this one-liner:
>=20
>   diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
>   index 58609bde3b9f..7c50715c05d6 100644
>   --- a/fs/ecryptfs/crypto.c
>   +++ b/fs/ecryptfs/crypto.c
>   @@ -1943,7 +1943,7 @@ static unsigned char *portable_filename_chars
> =3D ("-.0123456789ABCD"
>=20
>    /* We could either offset on every reverse map or just pad some 0x00's
>     * at the front here */
>   -static const unsigned char filename_rev_map[] =3D {
>   +static const unsigned char filename_rev_map[256] =3D {
>           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
>           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
>           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
>=20
> instead?
>=20
> Making invalid characters over \x50 be somehow magically different
> from invalid characters elsewhere seems just totally bogus. There are
> lots of characters that aren't valid, and they have the
> filename_rev_map[] value of 0 elsewhere.
>=20
> So the simpler one-liner is not only simpler, but gives much saner
> semantics, I think - now invalid character '\x05' gets exactly the
> same result as invalid character '\xf5'.

Good point - I'll get this in proper patch form and send a pull request
your way, along with a couple of other fixes.

Tyler

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOzSd2AAoJENaSAD2qAscK7WIP/1sZIbZrRKx1JlSRpbQNmC7z
nEVEPteoRamYNRsrW/uJL5w2tKKNVHhzvPfEvMfF7gAeZWmAeTTn71OBAUwQ7nP9
4tY9QlNfbhBv/Mbgb+0YLjNqRIAs30kssEYYE1v8rlyEft1s0xI4gU4bwoczUs8w
OE1fyIuoQIewmnACqkYhIPKzAZyR0N1oHVtkdu7rcoBP5zDvA53yupp5Advh42eE
L1a7/xxIOaUQINUTUfozK3CalJDioh8ETqMUlo+i/Tp0Owps+VWmb977ZLS1Yu98
sB6ZA0aeC+XLU7e1ZSh8Izs5UXMQyVIz5QAcUWZe5eWTp4jxrp/mXk8sHWDui+Fa
mLqymZl/o7PmaHUNB9tiCFX8tWj84sMy+OJJn/POHa2c+UGFTEIMX0XRNW34LVqN
Z+V9Jx7g4agI7s/Wpgb1WP+Qyvvtlv55OAsWEyLCnFcaCiHLh2SgNgK1o4Emw0qb
xsCZnDS60WdX3j7G/3bOmdMTEM5PuSXfHx852Vr1h+gZYNKF3k7JJm32cu7LXfJS
omzBeLcHIBrQtUYdlyDkhbHHa3Wd9MKyU12/rJ8y5A5M6WcaTZtJXcxorlmC78AF
NE7kAUuhpPz67V6AUx3rjsamVMkY+EmuPvOCMlZGD0vXBsCnrAFonES3LG3FnkRX
3l//FyvcX9adCm96WAIR
=4RGB
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
