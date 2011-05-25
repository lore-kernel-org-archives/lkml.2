Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1EYLX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:23:58 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:53584 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448Ab1EYLX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:23:56 -0400
Date: Wed, 25 May 2011 14:23:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525112350.GP14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
 <013201cc1a96$bdda7910$398f6b30$@org>
 <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
 <015801cc1abd$ca534e20$5ef9ea60$@org>
 <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
 <018e01cc1ac0$2b09b040$811d10c0$@org>
 <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
 <01a601cc1ac2$f0041a00$d00c4e00$@org>
 <20110525102945.GN14556@legolas.emea.dhcp.ti.com>
 <01b401cc1ac9$d1c57870$75506950$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
Content-Disposition: inline
In-Reply-To: <01b401cc1ac9$d1c57870$75506950$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 01:52:15PM +0300, Tanya Brokhman wrote:
> > > > > following:
> > > > > 1. if CONFIG_USB_GADGET_SUPERSPEED=3Dtrue, existing gadget drivers
> > > > > are still functional with dummy_hcd since as I already mentioned,
> > > > > they will be enumerated through HS root hub and thus the
> > > > > gadget.speed will
> > > > be set to HS.
> > > > > This is true for all gadget drivers, including the once that
> > don't
> > > > > define SS descriptors.
> > > >
> > > > only due the module parameter, right ?
> > >
> > > Due to the module parameter default value being FALSE, yes.
> >=20
> > Ok, so let's take your approach but change the speed in the gadget
> > driver structure, put your ifdef somewhere like here:
> >=20
> > diff --git a/drivers/usb/gadget/composite.c
> > b/drivers/usb/gadget/composite.c index 1ba4bef..d02d6e8 100644
> > --- a/drivers/usb/gadget/composite.c
> > +++ b/drivers/usb/gadget/composite.c
> > @@ -1224,7 +1224,11 @@ composite_resume(struct usb_gadget *gadget)  /*-
> > -----------------------------------------------------------------------
> > -*/
> >=20
> >  static struct usb_gadget_driver composite_driver =3D {
> > +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> > +       .speed          =3D USB_SPEE_SUPER,
> > +#else
> >         .speed          =3D USB_SPEED_HIGH,
> > +#endif
> >=20
> >         .unbind         =3D composite_unbind,
> >=20
>=20
> I have no problem updating static struct usb_gadget_driver composite_driv=
er
> as you suggested but it seems the same as updating it @
> usb_composite_probe()...

still, you will have two places poking at the same field. It's better to
keep it at once, update only that and we will take your approach.

--=20
balbi

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3ObGAAoJEAv8Txj19kN1U8AIAJxZnS3UiSSMRAhW8Vvpt1Kr
aiODqQEq/lQQ4tbrOJkWJzzUDrwLLKM5C222SqfgL/pGwqfuZ2HB5Ge3Ri/9pVtT
t9i0RLd9mtGwNld/xOQF61ZSRHoxAJCeDtRERnDMAHaYj569ESmjsu06ZxGR5yNg
UiMfv7t47yuUqVJCEVVWDxp3Y0RCOIB5QTcP14x1gPTYly0IILwOXQXmQV4ZqVUE
azLjTFvgdU8swYI6mEAhkZGdc02k2mslLAvHxiSgnwYENQPswfwE4ltshEkM8mTQ
Nep2h+rpWIREXOMu9IXH5E3gbmUtS06Gk7yzvfCClEChsVhcWvp+xr0WUX9dcN4=
=qtmj
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
