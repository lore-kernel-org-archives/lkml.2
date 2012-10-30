Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2J3PWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:22:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51480 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2J3PWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:22:50 -0400
Date: Tue, 30 Oct 2012 17:16:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030151642.GE29159@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline
In-Reply-To: <20121030140714.GO4511@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 02:07:15PM +0000, Mark Brown wrote:
> On Tue, Oct 30, 2012 at 01:49:49PM +0200, Felipe Balbi wrote:
> > On Tue, Oct 30, 2012 at 11:24:10AM +0000, Mark Brown wrote:
>=20
> > > We need some place to put the SoC integration; power domains seem like
> > > the obvious place to me but YMMV.  Nothing about having this out of t=
he
>=20
> > except that pin muxing has nothing to do with power domain. To me that
> > sounds like an abuse of the API.
>=20
> Well, we can call the API Archibald if we like...  what I mean is

I'm sure you know it's not at all about the name and much more about the
semantics ;-)

> something that sits in the system below the device in pretty much
> exactly the way that power domains do.
>=20
> > > drivers requires that this be done by individual subsystems in isolat=
ion
> > > from each other.  Half the point here is that for the reusable IPs th=
is
> > > stuff often isn't driver specific at all, it's often more about the S=
oC
> > > integration than it is about the driver and so you'll get a consistent
> > > pattern for most IPs on the SoC.
>=20
> > and all of that SoC-specific detail is already hidden behind power
> > domains, runtime PM, pinctrl, clk API, regulator framework, etc.
>=20
> That's all getting rather open coded, especially if you're going to get
> down to a situation where you have varying ordering constraints between
> the different APIs on different SoCs.

however we need to consider those cases right ? Otherwise we will endup
pushing something to mainline which will have to be reverted couple
weeks later after a big rant from Linus ;-)

> > > > How can you make sure that this will work for at least 50% of the
> > > > drivers ? You just can't. We don't know the implementation details =
of
> > > > every arch/soc/platform supported by Linux today to make that decis=
ion.
>=20
> > > Well, we've managed to get along for rather a long time with essentia=
lly
> > > all architectures implementing this stuff by doing static setup for t=
he
> > > pins on boot.  That does suggest we can get a reasonably long way with
>=20
> > and this is one of the issues we're all trying to solve today so we have
> > single zImage approach for the ARM port.
>=20
> I don't see the relevance of single zImage here; device tree is supposed
> to solve that one.

DT is part of the deal. DT alone will solve nothing.

> > > something simple, and it does seem to match up with how things usually
> > > look at an electrical level too.
>=20
> > simple ? I really doubt it. Just look at the amount of code duplication
> > the ARM port had (still has in some places) to handle platform-specific
> > details.
>=20
> What I'm saying here is that I'm concerned about us ending up with more
> code duplication...

a fair concern.

> > It turned out that drivers weren't very portable when they had to do
> > platform-specific initialization, we were all abusing platform_data to
> > pass strings and/or function pointers down to drivers and so on.
>=20
> > I'm concerned if we hide pinctrl under e.g. power domains (as said
> > above, it sounds like an abuse of the API to me) we will end up with a
> > situation like above. Maybe not as bad, but still weird-looking.
>=20
> Well, nothing's going to stop that happening if people are determined
> enough - one could equally see that there'll be flags getting passed to
> control the ordering of calls if things are open coded.  I would expect
> that with a power domain style approach any data would be being passed
> directly and bypassing the driver completely.

situations like that would be a lot more rare in open coded case, don't
you think ? Also a lot more local, since they will show up on a driver
source code which is used in a small set of use cases, instead of being
part of the pm domain implementation for the entire platform.

> > > It seems fairly obvious that if we need to add identical bolier plate
> > > code to lots of drivers we're doing something wrong, it's just churn =
for
> > > little practical gain and a problem if we ever decide to change how t=
his
> > > stuff works in the future.
>=20
> > I wouldn't consider it boilerplate if you remember that each driver
> > might have different requirements regarding how all of those details
> > need to be handled.
>=20
> Essentially all the patches I'm seeing adding pinctrl are totally
> mindless, most of them are just doing the initial setup on boot and not
> doing any active management at runtime at all.

have you considered that might be just a first step ? I have mentioned
this before. We first add the bare minimum and work on PM optimizations
later. You can be sure most likely those mindless patches you're seeing
are probably building blocks for upcoming patches adding sleep/idle
modes.

> > We have to consider power consumption, ordering of calls, proper IP
> > setup, IP reuse on multiple platforms (even multiple ARCHes), etc etc,
> > and to get that right outside of the driver - who's the only class that
> > actually knows what it needs to do with its resources - will just be too
> > complex and error-prone.
>=20
> A big part of my point here is that it's not at all clear to me that it
> is the driver which knows what's going on.  For SoC-specific IPs you can
> be confident about how the SoC integration looks but for IPs that get
> reused widely this becomes less true. =20

I don't think so. As long as we keep the meaning of the 'default'
pinctrl state to mean that this is the working state for the IP,
underlying pinctrl-$arch implementation should know how to set muxing up
properly, no ?

> > I would strongly suggest starting with explicit calls to pinctrl, clk
> > API, etc and if we can really prove later that 95% of the users are
> > "standard", then we can factor code out, but making that assumption now
> > is quite risky IMHO.
>=20
> Like I say I think we're already seeing a pattern here, the code going
> into most drivers looks *very* similar with lots of the drivers simply
> calling get_select_default().

might be true, but we don't really know if those aren't building blocks
for upcoming PM optimizations IMO.

--=20
balbi

--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj+9aAAoJEIaOsuA1yqREEDgQAIo/VUICCQpLqiWUmNHO19XH
QldLE57rZCOH4h8gJ7jzckM/2lpHjNpbSg+dSi4kTAgTmwEQVfPw7slIgalkJ6M2
XhpCX2CgoPeNiO/a2JlNPxhkfz/2D5wY+DtcPtlRymwvWOBalFB6sdV8W2W3fBsq
O5mgHw56ISgSa//FsO6wPCSBaJstJALsjfp+hd70+Ioyy73oHUv76eJg6acrjzXR
d1IudEhmeL04AEOKdNjSbso8NjlEg8ABOrtzNa+ZumzvniEosn6aXxTqI5NTM0xu
XQP47IJqhQbwXzaddHx+lQXZhuilxZeqtsLz0s+CLaEm+0o+tM8pXL1LHIs5rhY4
eiJR3eUTr6oxTRNvox5wFCVfdBCBMmCQ3Nlot0Q/QMbPlbpUfrAF4pzo1EwSvjxX
aj8Ljfydc34m0SRT6cOywEaOK+peGdKYNzkyDyvCM48gQWRunfNowt8s0qckcYBI
QCd1QkeKZoDWfCc/AFPaJtDj2aTvL4TpPDbsbxywruXi9z3cWJl5FtS8ALFOqkuj
3ExSew3CPwI6EMfZzsCnb+tyxvOXbxxvBGAZr3SxqS7dUH6NqELz7mbzSd0qFxOu
lBgmx37enkdS5a/zHGomLAUji5b3aoksmZJC4gdZRh3fD09f0/ThwagHkrNSsMG4
5brKfCXeV3rLJT2o8YX4
=E1PO
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
