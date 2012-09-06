Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2IFRWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:22:31 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:54040 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932454Ab2IFRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:22:29 -0400
Date: Thu, 6 Sep 2012 20:18:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Message-ID: <20120906171803.GA30717@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com>
 <5048C2A2.2020104@ti.com>
 <20120906171301.GC17754@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20120906171301.GC17754@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 06, 2012 at 08:13:03PM +0300, Felipe Balbi wrote:
> Hi,
>=20
> On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
> >=20
> >=20
> > On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> > > The mailbox register for usb otg in omap is present in control module.
> > > On detection of any events VBUS or ID, this register should be written
> > > to send the notification to musb core.
> > >=20
> > > Till we have a separate control module driver to write to control mod=
ule,
> > > omap2430 will handle the register writes to control module by itself.=
 So
> > > a new address space to represent this control module register is added
> > > to usb_otg_hs.
> > >=20
> > > Cc: Benoit Cousson <b-cousson@ti.com>
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > ---
> > >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > >=20
> > > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/ma=
ch-omap2/omap_hwmod_44xx_data.c
> > > index 242aee4..02341bc 100644
> > > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_u=
sb_otg_hs_addrs[] =3D {
> > >  		.pa_end		=3D 0x4a0ab003,
> > >  		.flags		=3D ADDR_TYPE_RT
> > >  	},
> > > +	{
> > > +		.pa_start	=3D 0x4a00233c,
> > > +		.pa_end		=3D 0x4a00233f,
> > > +		.flags		=3D ADDR_TYPE_RT
> > > +	},
> >=20
> > I do not have any objection/comment here, but I believe this is control
> > module address space required for USB module, right?
> > I am not sure this is right way of accessing control module space.
> > Actually Control Module Access required for drivers is one of the
> > blocking issue we have currently.
> >=20
> > Also there was some effort put up by 'Konstantine' to convert Control
> > module to MFD driver, I haven't seen any further update on it. But it
> > would be good to check with him.
>=20
> this was an agreement with Benoit since we already lost a couple merge
> windows for this patchset. We agreed to wait until -rc4 for SCM driver
> and if it wasn't ready, we'd go ahead with this and SCM author would fix
> it up on a patch converting users to new SCM driver.

Tony, can I get your Acked-by to this patch so I can take it together
with the rest of the series ? Thanks

ps: I'll apply this to my 'musb' branch which is immutable, so it's safe
to merge it into your tree once I apply.

--=20
balbi

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSNrLAAoJEIaOsuA1yqREio4P/jm0JnIJsEG5DOXcLssY70fz
AFx+JqIt73yQxGsUa/nC5YWavXGgxyfnKSA/ibPbG1LcAU39HeP5vqPG+uaVmq7D
YEIpejFkTbHInOBTgUj+tmCkl6kPKmAo9qcC4cbN9Fo0bALJyKiKZohyhIxfe11Z
uvNEAuy7vqyHAkT9PjcZBzrrInG2ViJoHAHrjZyylMLfmm7jZQmpLuwtNsfNBJg0
Sr6xx1DmcxYgzEqcbYYvIAWWdXKu2Jx75zdZBq/UMBeEO3x4GvOE69lhZn9xGWT5
LTQe9zYvZJbATITV+SPDJLs17uYJKq5aG6aUvGU1/LH8aPY6z59ReBVF9WT7L65A
8UMoLnajsYg7/4R6D8NYMua05Ix+agwnKnKf1nymV+RGwORGr5hurWEe0WyYiuB1
d5NwJf+31Z36aeYWODGmIdZuroMs+TibK3ITznz7Qo77e1ROKlvAwctVCbSu4Q9g
nC9ITylYZNqtE8u1hqZKF40HkgUgsv/bOtbzplDQqTSKNKsW3aorOHxCaKK3ObVV
z7jhDVvhJhfg+M2RLhlEQpCc0C19AU5MQVzJMMV3of2xRck2XvgIylaiCKzJ85/4
wZ3qkK4RW4u2cR1qi3klturKmKHOZrrye+Pw0f7jPLpC3pDlhIh+mmtap/De3/jj
OLczqZxaUkX3oYoUpXsV
=a6Mq
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
