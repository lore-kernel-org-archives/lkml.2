Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1I3He7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:34:59 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57132 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756873Ab1I3He5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:34:57 -0400
Date: Fri, 30 Sep 2011 10:34:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 3/5 v12] arm: omap: usb: register hwmods of usbhs
Message-ID: <20110930073449.GA13825@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317361318-28295-1-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1109300113200.32653@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109300113200.32653@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 30, 2011 at 01:15:55AM -0600, Paul Walmsley wrote:
> > The hwmod structure of usb_host_hs  and usb_tll are
> > retrieved and registered with omap device
> >=20
> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> > Reviewed-by: Partha Basak <parthab@india.ti.com>
> > ---
> >  arch/arm/mach-omap2/usb-host.c |  100 ++++++++++++++------------------=
--------
> >  1 files changed, 34 insertions(+), 66 deletions(-)
> >=20
> > diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-h=
ost.c
> > index 89ae298..771dc78 100644
> > --- a/arch/arm/mach-omap2/usb-host.c
> > +++ b/arch/arm/mach-omap2/usb-host.c
> > @@ -28,51 +28,28 @@
>=20
> > +	oh[0] =3D omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
> > +	if (!oh[0]) {
> > +		pr_err("Could not look up %s\n", USBHS_UHH_HWMODNAME);
> > +		return;
> >  	}
> > =20
> > -	if (platform_device_register(&usbhs_device) < 0)
> > -		printk(KERN_ERR "USBHS platform_device_register failed\n");
> > +	oh[1] =3D omap_hwmod_lookup(USBHS_TLL_HWMODNAME);
> > +	if (!oh[1]) {
> > +		pr_err("Could not look up %s\n", USBHS_TLL_HWMODNAME);
> > +		return;
> > +	}
> > =20
> > -init_end:
> > -	return;
> > +	od =3D omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
> > +				(void *)&usbhs_data, sizeof(usbhs_data),
> > +				omap_uhhtll_latency,
> > +				ARRAY_SIZE(omap_uhhtll_latency), false);
>=20
> Usually there's something wrong with omap_devices that contain=20
> multiple hwmods.  Is there some reason why there isn't a separate driver=
=20
> for the TLL?  Judging by a brief look at drivers/mfd/omap_usb_host.c, the=
=20
> TLL handling looks logically distinct?

Yes, I have the same feeling. To my understanding, USB Host Subsystem on
OMAP is composed of the Transceiver-less link (TLL) and USB Host (UHH).
Aparently, they could be handled by separate drivers.

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhXEZAAoJEAv8Txj19kN14JYIAKH2zh/FfT8VLgYfiEj5+Cq7
9UavmVR3MJBpN06W196nz2BkrwUi2wWszW1hWuMoW3RKM1wRJ7PhK6ZVzTC3r0ak
exhD6CMx5RRtb98A7oTRVZmflcbcI0n2W15eV7Oahne0kBC8s7ElsWFiD7NrYJaq
n1eibBzdEXzJtlVag977x5CnvpyqQnG18ZZKQM7+vh6S8MCf5LXP4Cv5TZdP9cxW
I2JRwB5hj6oNwv5Uvk3nlPPTdUUiinJK/5QaJ4bSt0BkNwzZ5gR+7zOFBdkAIFT6
C6XBajgMgfrmBXdY6ZgnoWj6g6eC7CIkjbQiVFAr8VnotjSGRt+9GNmCPQPuAAk=
=6//R
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
