Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423588Ab2KOGvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:51:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2KOGvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:51:46 -0500
Date: Thu, 15 Nov 2012 07:51:40 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Message-ID: <20121115065140.GA21208@avionic-0098.mockup.avionic-design.de>
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
 <004201cdc2d0$c1920210$44b60630$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <004201cdc2d0$c1920210$44b60630$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aTXWw5AtTPJVVu0aaN/AKH+YysOK7nwRpzbyQgU5OSe
 hHCqtqHU3+j9tJiRD1mSrRyzmeJroXfgpO1rMxJ2PbA2j47YdI
 re+2ip34qN6v5ISsBggdyjmePScRxrcfVUqNexymIYQNeW5PLd
 YQ7t39NUvTypHhnP7o3bPhtov4KccXkd5TVzFZE/RFLq3JIIQz
 JARHiGMRhpp/Bc8omLL7u0Io1vbrh7wwTNgjTSeg8b+kezJZaL
 PRfvH871a1hWob6a/FMOvlFNhGSX5Mu7rUT3TcZTMCURej3qA2
 /plpt8cN5mC3dyP1ny7LIdS9av5F/t6PdeqYd4MusphEJP/z9V
 qL7oho+cosjUa9HWDt5SnrShvCPJUbNLx36q+jilsQiqL8/s/0
 9glPrA+7Fq5t1REb53JUNk61uD031NkOhs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 10:30:11AM +0900, Jingoo Han wrote:
> On Friday, November 09, 2012 11:05 PM Thierry Reding wrote
> >=20
> > This function finds the struct backlight_device for a given device tree
> > node. A dummy function is provided so that it safely compiles out if OF
> > support is disabled.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> CC'ed Andrew Morton

Yes, the backlight subsystem isn't very well maintained, so I should
have added Andrew in the first place. Thanks.

>=20
> Hi Thierry Reding,
>=20
> The patch itself looks good.
> Could you explain when this API is used?
> Thank you.

I use this for the upcoming Tegra DRM driver in order to hook up the
backlight with the DRM driver via DT to allow switching off the
backlight when the corresponding DRM output is switched of using DPMS.
Basically what you have is something like this in the device tree:

	display {
		...

		backlight =3D <&backlight>;

		...
	}

Then you call something along these lines:

	np =3D of_parse_phandle(display, "backlight", 0);
	if (np) {
		backlight =3D of_find_backlight_by_node(np);
		of_node_put(np);
	}

And then use the standard backlight API on the returned pointer.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpJD8AAoJEN0jrNd/PrOha78QAKrmB5kcDGsvG3yUD2UzLQEN
ojO/wQfxoXtz1em03YT0QcPsQX+RL4PEx8VMLF+lHzwNEWqTaiJozeidhhi7LeHk
rKbQoDlwJWCGMW6zU/V09V/W/0hBxExl3NniA/LY5tmCyxnneRoWRMve8JpOmcWm
R6SVrmpr3AFupbcqsDnzSfDDQ/LpDgRA27vkI12LyVr9TCjgOZDvu+iJGlKbgwUQ
tlviqfkTCYsRHIYJiIZLf6Gsf0A08t0F4LTiSExRksHWqDSJU3urcNE39XAP/rk1
rmxKjzfXbzaXK7tyCqL/RyCJ++KFfk6951GT5bMxg6HThnROg9yyUU9zCzFjrV7J
KHLJrZ7b8IqOwNMEeSKDOXlhVkxUCIzkgxsQz8tTB0gWtZEVFI76MO3hv97Tn3Ua
u4crQ3cJSKZzziGCPlWB1Mx3KHAbHPnircLqKlaEUuqwN7ITxM3nlCra6NlyCoVy
hYj6KCI4cQuEOlWfyy1zpwVbCfFmTOkw/5Kahi7CrlccmXqUPrwYeiTTGGo2De1Y
8hGB3IUmxttGsLly4wtiGPPEN7QZrF3pyporlUu4mY2Eu16pGAYHq8S+O0IVqE0O
vPDtrfNatT9A5mgHykAy7k0GA5Gx+mh5aGsKGGj9iXhQLuzVogc4R/mpsmD+uCtR
8bQcShL4Zk/fIVTwOQNS
=11EW
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
