Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2ISQJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:09:52 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58504 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2ISQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:09:48 -0400
Date: Wed, 19 Sep 2012 19:04:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Sonasath, Moiz" <m-sonasath@ti.com>
Cc: balbi@ti.com, Kishon Vijay Abraham I <kishon@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] usb: dwc3: Fix gadget pullup in SS mode
Message-ID: <20120919160450.GA7510@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-3-git-send-email-kishon@ti.com>
 <20120919115306.GG3772@arwen.pp.htv.fi>
 <CAEgRx2zOVn0zV39-cuPuj4n4HRgQmywy_NY4KTe0qEgeC+NEkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <CAEgRx2zOVn0zV39-cuPuj4n4HRgQmywy_NY4KTe0qEgeC+NEkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 19, 2012 at 10:02:48AM -0500, Sonasath, Moiz wrote:
> Felipe,
>=20
> On Wed, Sep 19, 2012 at 6:53 AM, Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >
> > On Wed, Sep 19, 2012 at 05:00:27PM +0530, Kishon Vijay Abraham I wrote:
> > > From: Moiz Sonasath <m-sonasath@ti.com>
> > >
> > > For the gadget pullup functionality to work in
> > > SS mode it requires a particular sequence of
> > > toggling the run-stop bit. Here is the required
> > > sequence:
> > >
> > > - Set DCTL[31]
> > > - Clear DCTL[31]
> > > - Clear OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]
> > > - Clear DCTL[8:5] =3D 0x00
> > > - Set DCTL[8:5] =3D 0x05
> > > - Wait 25 Ms
> > > - Set DCTL[31]
> > > - Set OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]
> > >
> > > Tested rigourously the gadget pull-up functionality
> > > in bot HS and SS modes.
> > >
> > > Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> > this needs to split into three patches:
> >
> > add new poweron field, implement it on omap-usb3, use it on
> > dwc3/gadget.c
> >
> > btw, I don't think the changes to run_stop bit are necessary and if they
> > are, that'd either be a silicon errata or it would've been mentioned on
> > the databook. I don't remember seeing that on the databook so I'm
> > assuming that this is caused by a bad use of the PHY.
> >
> > Why that mdelay(25) ? why 25 ms ? That's quite a long time, actually.
> >
>=20
> Felipe, This is infact a HW bug that the Si-Val team did accept and gave =
us
> this workaround sequence with the precise delay :-)
>=20
> Supposedly this will be fixed in ES 2.0.

in that case this doesn't have to go to mainline since we're not
supporting ES1.0 in mainline :-)

at minimum this should've come with a proper revision check anyway.

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWe0hAAoJEIaOsuA1yqREqsQP+gPUL8QStXPar56/8uNG0VBt
DnGifpxsON4gVPJgO88OVU1Firm8z55Ds1nesDd4m+J7sctIbLE/gTV70p6Zj4F8
vRxSp7tIvCdB/UHP4hXK1xKCZOgiBi5821vIyGh4YVBH+MhvSA23NGDk+mbvj4lY
8ZtzIjRcBCFJpwxwDJ3Il6OrefvrrbZkpWJ1/2egte6ghXJgFAZBDRRAn+ltH1Q6
E9I2q09I9Zc+gkz3vXg/619zZ7hHl24FAeIrF63nA3rN2weEUS7WNIu0QuFmZZ8v
HZ1SLJd7Q3LwdSOUoJK8Gkom55tmgbbWW7I/Zs1vS6Bkfgb0diIIm4WgA2ixzAAo
RtZkSK/enboQMORHYivPLFkobcmbOHOyKXgBDr27X2ou7HGmVqq9fv8XYWqbJeo4
nLPi0TFx55CtVjyH9DJw24spGVfdAqa0Uv8ZRuqljAIYdT3kQUtwK3pble5/esmF
gCEchr57CvvLc9mFOZzG0f6gbgXdcluFVRwh8bIllXvbgkJW24t0Y2Ttl+9eEjAk
U2wzo7EeNaCBQ3h+UArMqVAA7vkADJZTNk0nXt3zDsRIJFgYoT2eqRai2rBUgNQG
K/FV07nu3/I/DtVsNtwJw0d/NqORcfZF0U/VYnzkWEen1epSBP2RGxnIeLaj646P
GwhJbPEulTnNL7/54UiL
=gF5U
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
