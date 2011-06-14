Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1FNMAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:00:08 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34894 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756083Ab1FNMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:00:05 -0400
Date: Tue, 14 Jun 2011 15:00:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Message-ID: <20110614115959.GI2353@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <201106070316.41099.jkrzyszt@tis.icnet.pl>
 <20110614114848.GS3352@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ohWw6IXhY39HKnGA"
Content-Disposition: inline
In-Reply-To: <20110614114848.GS3352@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ohWw6IXhY39HKnGA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 14, 2011 at 04:48:48AM -0700, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [110606 18:15]:
> >=20
> > Removing __initdata tags, introduced by commit=20
> > bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a bunch of=
=20
> > section mismatches", from corresponding platform_device structures=20
> > declared in arch/arm/mach-omap1/board-ams-delta.c, corrects the problem=
=20
> > for me, which may indicate that their members (.name ?) are still=20
> > referred to during runtime so they shouldn't be freed after boot.
>=20
> Sounds like this needs a bit more research where this initdata
> gets used?

to me it sounds like missing __init/__exit annotations on the driver.
See ams-delta-leds for instance:

static int ams_delta_led_probe(struct platform_device *pdev)
static int ams_delta_led_remove(struct platform_device *pdev)

which means those drivers will have probe sitting outside or .init.text
and trying to reference name which sits in .init.text ??? Could that be
the case here ?

But it could also be that the platform_device shouldn't be marked
__initdata.

--=20
balbi

--ohWw6IXhY39HKnGA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN900/AAoJEAv8Txj19kN1cI0IAISQ2qtLJsHKq09MTnyItiQM
xrhVcVwQvUBeMbkfTiUGAzSF3kvT15m7GvrEvHg3kqimvretlvjrOtPCJodzgDoG
LAOHPvC+TwvT1N4aD5tQxcjtBJlfhDZSRMz1cJeMSrh93iBQbc2kr6J9hMtx8HBU
XDhSsmW20ImnMb/G+Kyakw9WJFr+4f6K5TRokpKrkjxO7uhVStZfFIny7sT6fk+o
wvK4gT1ZVCRvWPvAAul9rQvqQqPzLKXLBkDM9c2zBRZtn9VIBp8/ZUhNM5372paz
3zAN2/fX+4kM+KgjdWYHfiJXcvgjkYGm4lAC9UI48n6bl8bF7IWC9u+Pkn7+0UE=
=G5K5
-----END PGP SIGNATURE-----

--ohWw6IXhY39HKnGA--
