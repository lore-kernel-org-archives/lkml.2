Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab2EOPNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:13:08 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56542 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758137Ab2EOPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:13:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicMAPJxsk9bdWOb/2dsb2JhbABEhXulVogogQeCFgEFI1YQC0ICAlcGMYd0qAqTBJAEgRgEn1WGaIJr
X-IronPort-AV: E=Sophos;i="4.75,595,1330902000"; 
   d="asc'?scan'208";a="515157258"
Message-ID: <1337094784.3472.69.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 2/5] Staging: ipack: add proper device model into
 ipack_bus_register.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 17:13:04 +0200
In-Reply-To: <1337091098.3472.58.camel@fourier.local.igalia.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
	 <1336992089-2733-3-git-send-email-siglesias@igalia.com>
	 <20120514204654.GA8723@kroah.com>
	 <1337091098.3472.58.camel@fourier.local.igalia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZYbl6npoH9XcUG9BcQeJ"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZYbl6npoH9XcUG9BcQeJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 16:11 +0200, Samuel Iglesias Gons=C3=A1lvez wrote:
[snip]
>=20
> A third option is use bus devices like VME bridges in the vme bus
> driver, i.e, they are not devices, just an abstraction that provides
> some functionality to the mezzanine devices.
>=20
> I prefer the first option because it reuses the code of the probe/match
> functions inside the ipack bus driver and it shows the hierarchy through
> sysfs as everything is a registered device.
>=20
> What do you think?

Thinking again about it, I think I don't win anything interesting
registering a new device in case of an ipack bus device.

It is just needed to establish the parent of the ipack device to the
"real" device of the bus (i.e, the PCI, USB device...), like the
aforementioned VME bridge in the drivers/staging/vme driver.

So, I will rewrite the patch keeping it simple: maintaining the change
in ipack_device_release function and ipack_device_register with some
little modifications. This is actually the important stuff.

And delaying the change in ipack_bus_register to whenever it is really
necessary, if it is.

Sorry for the inconveniences,

Sam

--=-ZYbl6npoH9XcUG9BcQeJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+ycoAACgkQWrfbyfmd9eIxygCfSeMJhI/4BNmo+XBYuSekI9dB
2rgAnRHV6IJ2HLedaEK1aQfmGRMyCrVb
=W0La
-----END PGP SIGNATURE-----

--=-ZYbl6npoH9XcUG9BcQeJ--

