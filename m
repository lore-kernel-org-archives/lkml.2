Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2IJQDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:03:32 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:44546 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757539Ab2IJQDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:03:30 -0400
Date: Mon, 10 Sep 2012 18:58:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Balbi <balbi@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, b-cousson@ti.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Message-ID: <20120910155855.GE7464@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com>
 <5048C2A2.2020104@ti.com>
 <20120906171301.GC17754@arwen.pp.htv.fi>
 <20120906171803.GA30717@arwen.pp.htv.fi>
 <20120906195607.GB1303@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <20120906195607.GB1303@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 06, 2012 at 12:56:07PM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [120906 10:23]:
> > Hi,
> >=20
> > On Thu, Sep 06, 2012 at 08:13:03PM +0300, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
> > > >=20
> > > >=20
> > > > On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> > > > > The mailbox register for usb otg in omap is present in control mo=
dule.
> > > > > On detection of any events VBUS or ID, this register should be wr=
itten
> > > > > to send the notification to musb core.
> > > > >=20
> > > > > Till we have a separate control module driver to write to control=
 module,
> > > > > omap2430 will handle the register writes to control module by its=
elf. So
> > > > > a new address space to represent this control module register is =
added
> > > > > to usb_otg_hs.
> > > > >=20
> > > > > Cc: Benoit Cousson <b-cousson@ti.com>
> > > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > > ---
> > > > >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> > > > >  1 file changed, 5 insertions(+)
> > > > >=20
> > > > > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/ar=
m/mach-omap2/omap_hwmod_44xx_data.c
> > > > > index 242aee4..02341bc 100644
> > > > > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > > > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > > > @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44=
xx_usb_otg_hs_addrs[] =3D {
> > > > >  		.pa_end		=3D 0x4a0ab003,
> > > > >  		.flags		=3D ADDR_TYPE_RT
> > > > >  	},
> > > > > +	{
> > > > > +		.pa_start	=3D 0x4a00233c,
> > > > > +		.pa_end		=3D 0x4a00233f,
> > > > > +		.flags		=3D ADDR_TYPE_RT
> > > > > +	},
> > > >=20
> > > > I do not have any objection/comment here, but I believe this is con=
trol
> > > > module address space required for USB module, right?
> > > > I am not sure this is right way of accessing control module space.
> > > > Actually Control Module Access required for drivers is one of the
> > > > blocking issue we have currently.
> > > >=20
> > > > Also there was some effort put up by 'Konstantine' to convert Contr=
ol
> > > > module to MFD driver, I haven't seen any further update on it. But =
it
> > > > would be good to check with him.
> > >=20
> > > this was an agreement with Benoit since we already lost a couple merge
> > > windows for this patchset. We agreed to wait until -rc4 for SCM driver
> > > and if it wasn't ready, we'd go ahead with this and SCM author would =
fix
> > > it up on a patch converting users to new SCM driver.
> >=20
> > Tony, can I get your Acked-by to this patch so I can take it together
> > with the rest of the series ? Thanks
> >=20
> > ps: I'll apply this to my 'musb' branch which is immutable, so it's safe
> > to merge it into your tree once I apply.
>=20
> It would be best if this got acked by Benoit and Paul as they may
> have some other patches queued up. I'll ack if they ack ;)

Benoit, care to ack this patch ???

--=20
balbi

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTg4/AAoJEIaOsuA1yqRE7zAP/RO0b4XBvSmE8x5gLybuuBBr
roR9MNm8mQQFSPY3ZtyRBeIp8DeUUDsyUnNx30mtdSZ0k+hcWCknxhpApcJCGxy0
TrSEvhTZUJuClmj9uw8l01yTQhgyp2xiwln46NSqGwa/TyOewMDD4SoyiWFED3Xu
mHGQXcc+GeVRJqlZwqKCu26YiVrWem5kK1hTBIL+bInhwOTEaL7CluToHT0ckMk3
/GBnDh7UHPPdMajP/VkcTth3F0+DO5nhK8b57AOJmwrUu4aPvxeEqwSvIB65efEl
rz0AaHkgyu0GaHPpnZflYcy2O4N3ce4/839j/W16wyxAHNjQJuixvFw9UBQnKUvo
m3d7WR1ENLFJpCmouIdHnOYjzlZ3JGtMaFurco0KH8iy0vncKfGh/nLQrxm0XoGD
yyCZ2NWwGj9oV9VoicVyX5Mm+8wQu6FEArF4zdSxUT2US4EOhtB5PatmaDvdNn8o
FX96lQHqCCvMbPWcHbJXN+0/IL3LKsPuEpjI/T7VRQTGUEcylnczZlNEjalJShwQ
ALRiEpHA7kFhBGdep6mGWpYoGMxYjZzF/nsgNT3XxzKfDrGf2uHnR/UyorcEjlnC
bEbzKYXsc/7FraPhct6fW0g361FqAdAIS0MWIUj5MbZ79NNgwJdVLaJ3j65B2wPX
DcYlQew45jmaJO8KwbTL
=z0wz
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
