Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100Ab2JaI0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:26:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935029Ab2JaI0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:26:14 -0400
Date: Wed, 31 Oct 2012 09:26:07 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: platform: Don't initialize driver-private data
Message-ID: <20121031082607.GA1835@avionic-0098.mockup.avionic-design.de>
References: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de>
 <15899660.S8avMzQBpd@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <15899660.S8avMzQBpd@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DBus+R/ur9MTgzf4GNNhSdFe6HhAtQWjesiPryKumix
 f1uwlFMHCfplCnujBYTeL/nfHc4i7GCVIeBmzAX+0zmhDBlJUs
 JCTD1kofts0Q+zw4ry0V+avoEcWr0WHoMJGtEp/JYZ6ogV5YAh
 g+H4E3nWY9KQ+GsM8ldFvrxUdEmuf2w/WMfrdC4bLtsdlwzofo
 e2tD11VYRuXsZTa2ncyRvNBIIPMJNEr5O5C25hTCdXv3ys3nPi
 +myw33TXdxIZ2HKqvxsIYnNKV1yKeo8JdkOlEo+d4bYJ6IPjYE
 MqUG6MRw3Gyarc3I8h/GRUiJnhj0V9d4//o7jScoEQWkNlLt7W
 fwXJ06OYey0WQrspcod+p2LetfLhTh7jdbMUE3cPTMKxGI3Ght
 1ojxC4c2SBvN1VpZB6wGc4g7cFOwOaV6VA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2012 at 04:06:27PM +0200, Laurent Pinchart wrote:
> Hi Thierry,
>=20
> Thank you for the patch, and sorry for the late reply.
>=20
> On Monday 15 October 2012 20:03:42 Thierry Reding wrote:
> > Platform device drivers usually use the driver-private data for their
> > own purposes. Having it overwritten by drm_platform_init() is confusing
> > and error-prone.
>=20
> If you want to push drivers that way, you should get rid of the=20
> pci_set_drvdata() call in core DRM as well. This would push device driver=
 data=20
> handling down to all drivers, so I'm not convinced it would actually make=
=20
> things simpler.

I think the problem doesn't exist for PCI-based DRM drivers, so I didn't
look at it. The issue only arises once the DRM needs to glue together
multiple devices, as is usual with the drivers for embedded devices,
where the drivers are based on platform devices.

I agree, though, that for consistency it would be nicer not to do this
for the PCI-based DRM drivers either. If David agrees I can take a look
at converting the other drivers along with the change to the DRM core.

Pushing the handling of the driver-private data down to the drivers may
not make things easier, but at least it would be consistent with other
drivers. I didn't mention this in the patch description but it actually
took me a day to track down why the driver kept crashing until I figured
out that drm_platform_init() actually modified the pointer.

Thierry

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkOCfAAoJEN0jrNd/PrOhWJcP+QEsyjAvvYMggjAqO5VHApri
B8lqwPLxl/LM/NnawwiEowkFXiLg8uX9/AsLYYxozfSeTeVPaEMYsGd7tW4hssPh
bbmBzgT86yYJnG74qo+9DsCBUdBWPSQw0/1WZCIL0qceJSDfrIFfcebGVtf9ujnB
p32dtwmcKs1emFjrTsYPyAdfsCcoJsVWvTjUSDU9QJOrSSe6DH5Ye70Zt3Vy5vAG
Cc9pwGlgp2Wmcwlg4lbOX1xFQmISvxIP+PaMceqGzdnkR70dSEb2q5mv08kv6Hrt
/p0oI/ybhEAjMLnO2fBcngoBOVjBSoPHb1CEfdiQ5zsBucMhOh5dRAhWsHA1XAtJ
hRWf4A16KS981eRPmE3zG8Yt4/gely8vFRaPRKwipr5w/hHlAE4RX/UWYxOccU30
CZbnT1jzPffhqCi9/VU9GgkJe5mg7yIzRGkMelrkTo6o9/K2etbZIHAcUnYkjR1P
dhouaalqzFI+w9Z3YHePu6cQyRxyME3V444jJnga6YPFtBRIczn23WJL4x4WDB0Z
mAP0BOsyp8/FHUq9OnbA7KDmmWmmZYE4FYri6E2SZkpSZ9t5EVmIvk+l760BIUy0
5NTk8AirXiFxB48E26f9rTOCm5V0Wr/7NJrfkSBKWVLZRl98If20qrWiPLbU0GCv
1H81bhU02tfCzKN/eSPz
=X9sL
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
