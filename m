Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1I3JUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:20:06 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58565 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab1I3JUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:20:03 -0400
Date: Fri, 30 Sep 2011 12:19:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: balbi@ti.com, Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 3/5 v12] arm: omap: usb: register hwmods of usbhs
Message-ID: <20110930091957.GC3458@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317361318-28295-1-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1109300113200.32653@utopia.booyaka.com>
 <20110930073449.GA13825@legolas.emea.dhcp.ti.com>
 <CAP05o4L1iR++BhYmYYEc-uV6pGfjBeSPPcFqhRizdBeV7Ko26g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Content-Disposition: inline
In-Reply-To: <CAP05o4L1iR++BhYmYYEc-uV6pGfjBeSPPcFqhRizdBeV7Ko26g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 30, 2011 at 02:45:32PM +0530, Munegowda, Keshava wrote:
> On Fri, Sep 30, 2011 at 1:04 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Sep 30, 2011 at 01:15:55AM -0600, Paul Walmsley wrote:
> >> > The hwmod structure of usb_host_hs =A0and usb_tll are
> >> > retrieved and registered with omap device
> >> >
> >> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> >> > Reviewed-by: Partha Basak <parthab@india.ti.com>
> >> > ---
> >> > =A0arch/arm/mach-omap2/usb-host.c | =A0100 ++++++++++++++-----------=
---------------
> >> > =A01 files changed, 34 insertions(+), 66 deletions(-)
> >> >
> >> > diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/us=
b-host.c
> >> > index 89ae298..771dc78 100644
> >> > --- a/arch/arm/mach-omap2/usb-host.c
> >> > +++ b/arch/arm/mach-omap2/usb-host.c
> >> > @@ -28,51 +28,28 @@
> >>
> >> > + =A0 oh[0] =3D omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
> >> > + =A0 if (!oh[0]) {
> >> > + =A0 =A0 =A0 =A0 =A0 pr_err("Could not look up %s\n", USBHS_UHH_HWM=
ODNAME);
> >> > + =A0 =A0 =A0 =A0 =A0 return;
> >> > =A0 =A0 }
> >> >
> >> > - =A0 if (platform_device_register(&usbhs_device) < 0)
> >> > - =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "USBHS platform_device_registe=
r failed\n");
> >> > + =A0 oh[1] =3D omap_hwmod_lookup(USBHS_TLL_HWMODNAME);
> >> > + =A0 if (!oh[1]) {
> >> > + =A0 =A0 =A0 =A0 =A0 pr_err("Could not look up %s\n", USBHS_TLL_HWM=
ODNAME);
> >> > + =A0 =A0 =A0 =A0 =A0 return;
> >> > + =A0 }
> >> >
> >> > -init_end:
> >> > - =A0 return;
> >> > + =A0 od =3D omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void *)&usbhs=
_data, sizeof(usbhs_data),
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 omap_uhhtll_la=
tency,
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ARRAY_SIZE(oma=
p_uhhtll_latency), false);
> >>
> >> Usually there's something wrong with omap_devices that contain
> >> multiple hwmods. =A0Is there some reason why there isn't a separate dr=
iver
> >> for the TLL? =A0Judging by a brief look at drivers/mfd/omap_usb_host.c=
, the
> >> TLL handling looks logically distinct?
> >
> > Yes, I have the same feeling. To my understanding, USB Host Subsystem on
> > OMAP is composed of the Transceiver-less link (TLL) and USB Host (UHH).
> > Aparently, they could be handled by separate drivers.
> >
> > --
> > balbi
>=20
> yes, it can be as two separate drivers for uhh and tll;  But i don't
> think driver can be used effectively.
> Now ehci and ohci gets the clocks , config reg and port settings
> through usb host which is sufficient.
> If you make them as two different drivers; then ehci and ohci has to
> interact with both the drivers separately.
> which will be an unnecessary complications. I feel not divided this
> driver into two

Come again, EHCI/OHCI need clocks from UHH and TLL ?? If that's the
case, then there's really no easy way to handle this as a device can
have only one parent.

--=20
balbi

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhYm9AAoJEAv8Txj19kN1b/EH+wWbm2Z6aasNdcl6fWgwW2Xt
7J/llmWIMAPEun7cGYNLLyi9GSM2Oj5mqANwy+NpxItJ/vcMzwzCJ0Aki6DtB2y8
XTOOE+XVwu9hE/Ye3FHQujHJUUWtPM5KLDivGFHMPG4NIMi+WbKTfLVSBegBhzmE
30xAyMCrfupvym0o52e05BGLR9Ny7u0bqstIAurQWVDGt3g4H5+SG6+ZT0ffQQhX
U+BstvtiQm3SKKx53TbnVJoQNWqcmDhydx6ZYjr8El+lAw1CWGAoPtEmKs2Gea71
+fC1l98HKfx1kjE8+uBH1O5BFvaPFa6wiP9SftPnQlDRaqtwhWnfYFkDLh+5Ojo=
=83iw
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
