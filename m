Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0HDO2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:28:33 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:56214 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757105Ab0HDO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:28:31 -0400
Message-ID: <4C59790C.4010809@archlinux.org>
Date: Wed, 04 Aug 2010 16:28:28 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.7) Gecko/20100720 Lanikai/3.1.1
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: WARNING at net/wireless/reg.c when wireless network is disconnected
References: <4C5950B7.4000802@archlinux.org> <20100804134908.GB17666@tuxdriver.com>
In-Reply-To: <20100804134908.GB17666@tuxdriver.com>
X-Enigmail-Version: 1.1
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig210063A1CEA420DB1A047490"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig210063A1CEA420DB1A047490
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 04.08.2010 15:49, schrieb John W. Linville:
> On Wed, Aug 04, 2010 at 01:36:23PM +0200, Thomas B=E4chler wrote:
>> Hello,
>>
>> this warning has been around ever since I switched to 2.6.34, has
>> accompanied me through the 2.6.35-rc* phase and is still there with
>> 2.6.35. I didn't bother to report it so far, as there seems to be no h=
arm.
>>
>> Whenever I disconnect/get disconnected from the wireless, I receive th=
e
>> below warning:
>>
>> ------------[ cut here ]------------
>> WARNING: at net/wireless/reg.c:272
>> regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]()
>> Hardware name: TECRA A11
>> Unexpected user alpha2: de
>=20
> Perhaps you need to set the regdomain as "DE" rather than "de"?
>=20
> John

You are actually right. I did set it to "DE" with iw, but wpa_supplicant
had a setting country=3D"de". I just fixed that and will soon see if the
problem disappears.

Still, the warning shouldn't look like a bad kernel bug, but rather an
advisory to the user to set something sane. What confuses me even more
is that this has been set to DE afterwards:

$ dmesg | grep cfg80211:\ Calling\ CRDA
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: de
cfg80211: Calling CRDA for country: DE
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE

The AP has been playing with the regdom as well, I lost track of what
has been set where in this mess.


--------------enig210063A1CEA420DB1A047490
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAkxZeQwACgkQEda5KzHP/VBFVwCfUxrcxooArhF7+NjsD5rztYmV
yjsAnAt0SWlyX5apmvrAaDgTfr8m1msY
=LbFW
-----END PGP SIGNATURE-----

--------------enig210063A1CEA420DB1A047490--
