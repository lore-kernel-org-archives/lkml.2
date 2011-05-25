Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1EYJUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:20:13 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:49762 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab1EYJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:20:10 -0400
Date: Wed, 25 May 2011 12:20:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, balbi@ti.com,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525091955.GH14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <011d01cc19ff$616055c0$24210140$@org>
 <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 24, 2011 at 10:20:37AM -0400, Alan Stern wrote:
> On Tue, 24 May 2011, Tanya Brokhman wrote:
>=20
> > Hi Felipe
> >=20
> > > > Yes :) The driver->speed is updated in usb_composite_probe() if
> > > > CONFIG_USB_GADGET_SUPERSPEED is defined.
> > > >
> > > > So, are we ok with this solution? The module parameter I mean?
> > > > Are you going to try the v13 in your branch? Please let me know how
> > > it
> > > > goes and of course if you have any comments.
> > >=20
> > > I think it still gives the possibility for failure. I would rather not
> > > take that until all gadget drivers are fixed. We can help you doing
> > > that and we only change driver->speed after all gadget drivers have
> > > their "sensible defaults" SuperSpeed descriptors.
> >=20
> > By "until all gadget drivers are fixed" you mean until all gadget drive=
rs
> > provide SS descriptors? This will take for ever...=20
> > I wasn't about to modify all gadget drivers and to add SS descriptors f=
or
> > them. I can add default values (as generate_ss_descriptors() did if you
> > remember) but I don't think this is the right approach because as you s=
aid -
> > different gadget drivers might have different SS descriptors and I don't
> > feel confident enough to set these values. Nor do I have the ability to=
 test
> > each of the gadget drivers the way I would like to after this change.
> > The only gadget driver I felt confident adding SS descriptors for is UA=
SP,
> > which I tested properly.
> >=20
> > Actually if the CONFIG_USB_GADGET_SUPERSPEED is turned off, which is the
> > default of it, the speed won't be updated and all these series won't be
> > functional so I don't see any possibilities for failure in such
> > configuration. Or am I missing something?
>=20
> dummy_hcd should work when CONFIG_USB_GADGET_SUPERSPEED is enabled,
> even if the usb_gadget_driver structure is initialized with the speed
> field set to USB_SPEED_HIGH.  This will be true for all the standalone
> gadget drivers until they are updated.
>=20
> Which leaves a question about the composite gadget framework.  Should
> it be updated with SS support?  Probably not until the various function
> drivers have all been updated.

We can add support for all the USB3 standard requests, just don't change
the driver->speed field until all gadget drivers are fixed.

--=20
balbi

--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3Mm7AAoJEAv8Txj19kN1Zh8IAJ94Ikr8VnO/eWskjEjVy4EP
ncIfobOBVbJcjuzfwA6SKgV64bjSC4Q3aOHByNkJT5Mbpl2Z1vl4BB+8H4vcuaIu
qAPuFssqcNG8Gne7dw4QsTnec6xbcTl4kAzc8Wmp5pW8hqzw3A9/ztBy2B5RkDkl
gi/X5dLm0Vm4lrPNMRvsL5WRog+vtBuLsM1Q2FLtXYkQ8kQOpIfW4nV8HtWF4edc
hhQAp4Vwh3eKXHyyQVURSGO7KwrU92HHeOI+og5Y+ShOBFy+reoOndcx4xudQORO
o6qS/9m33fT5Wu7Kasp/xdIZc/xpWG+BpDKlICVTCPxpWTDIqVlGvACBMmHfiTY=
=xyll
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
