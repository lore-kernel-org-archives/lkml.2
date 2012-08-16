Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HPMFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:05:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab2HPMFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:05:49 -0400
Date: Thu, 16 Aug 2012 14:05:41 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
 <20120816111044.GA12029@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20120816111044.GA12029@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ks7I6WUSkwn8kxX6BrVbwXkDjCzPiQm+3omh0dKDxIG
 XtBAvddtVxbJq24dD5AdfyOH2U6IcXFJ7euAJXI+HxZWESXBEs
 T5H1M2lKyimSszYZ5a8TM6H4K5SdXrWpSVocKCFewazLscc9S4
 FyXAEJQBI9qL2NS/Q1T6rGEtWrOrTFKlHOKb7MzeqYHt6t5uY+
 5bNxcBc6PdatQi8NhKI4lv4NSmHppDyOBnbgY4QpjUO/YLartn
 ZYVbSLRyK92J3MNtUOGqXQ6oYpKbm6h+J+gGnG2hSnK8fef1rD
 u9AL4M4toKJsBZtg8BaDTT2y898L821zn+lHqvvvKyixGnyBW/
 JicVOGdvcAftfMyslXhd2zW6J8WLhc8dcx0VpMyzRkDF23EInc
 X73/Aq1ReWCwTzHb3xBGg8Wzm0mqCFduHY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 01:10:44PM +0200, Borislav Petkov wrote:
> On Thu, Aug 16, 2012 at 11:54:39AM +0200, Thierry Reding wrote:
> > How does the attached patch look?
> >=20
> > Thierry
>=20
> > From cd3199b94e697cccd38766b4a60d2e91474d0539 Mon Sep 17 00:00:00 2001
> > From: Thierry Reding <thierry.reding@avionic-design.de>
> > Date: Thu, 16 Aug 2012 08:01:21 +0200
> > Subject: [PATCH] pwm: Improve Kconfig help text
> >=20
> > The Kconfig help text should help the user understand what functionality
> > is provided by an option. This is especially true for new subsystems. An
> > improved help text is provided by this commit in the hopes of clarifying
> > the usefulness of the PWM framework.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  drivers/pwm/Kconfig | 24 ++++++++++++++++++------
> >  1 file changed, 18 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 8fc3808..88ddb9e 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -1,12 +1,24 @@
> >  menuconfig PWM
> > -	bool "PWM Support"
> > +	bool "Pulse-Width Modulation (PWM) Support"
> >  	depends on !MACH_JZ4740 && !PUV3_PWM
> >  	help
> > -	  This enables PWM support through the generic PWM framework.
> > -	  You only need to enable this, if you also want to enable
> > -	  one or more of the PWM drivers below.
> > -
> > -	  If unsure, say N.
> > +	  Generic Pulse-Width Modulation (PWM) support.
> > +
> > +	  This framework provides a generic interface to PWM devices
> > +	  within the Linux kernel. On the driver side it provides an API
> > +	  to register and unregister a PWM chip, an abstraction of a PWM
> > +	  controller, that supports one or more PWM devices. Client
> > +	  drivers can request PWM devices and use the generic framework
> > +	  to configure as well as enable and disable them.
> > +
> > +	  The new generic framework replaces the legacy PWM framework
> > +	  which allows only a single driver implementing the required
> > +	  API. Not all legacy implementations have been ported to the
> > +	  new framework yet. The new framework provides an API that is
> > +	  backward compatible with the legacy framework so that existing
> > +	  client drivers continue to work as expected.
> > +
> > +	  If unsure, say no.
>=20
> Yes, this is much better than what we had before. I'd suggest though,
> that instead of describing the high-level software design of the PWM
> subsystem, the text should be more addressed to the simple user like me
> who would like to know what this thing is and why do I want to enable
> it. Basically summarize what PWN devices are and what they're used for.
> I.e., https://en.wikipedia.org/wiki/Pulse-width_modulation#Applications
> but in 4-5 lines of text.
>=20
> IMHO, of course.

Okay, I'll add something along those lines in addition to the above.
That way everybody should find something useful in it.

Thanks,
Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLOIVAAoJEN0jrNd/PrOhhooQAK2z1N0laLt2GOE6AU6TDmDJ
7Z1QN1Sjyo/pfpNJg/l9fN1PRvpWW0BSbYBfRSY3RTEmBvFMl5QYrnet+NrneGGH
pHhWdAdWdIqlcfaJ45tjmQlI3HEWE/xFnw2Z5lKFB7Co0G4QLFUQx+Bc5KPGgRqR
XuVm1ATNtQwz9fN64Kf8T19PMM+LQyVXBNDq+aHUkRSSXxfXTlAZsvQtR43OlD+Y
3sIsgQBrtD72iypXtTpVxpygX5DTWRLTCsIu+gqkhiUMh91d8eXTEjaICNAoIc17
q+eIypeEGbbQfiqWBfLm4D17PpZUeoOdILTuHc32llpb89TpamLvm1xrlXzyGy9W
knQs59Df8TGfHP2O+bCuRS838xCxgKX8FAnP7qrQTyI1Jtpj0bWgLGHfeaPehcDV
DscPpze/msO+BQ216Ubo15tAPXu/Hx6Gohkq7zBNclyMDu6XqHpI62EorIwZp1AY
30LHsTbGts/mY5SmjgzNWQGTmDri5MQlZX5UF6KAhI75ACZTvDXt7Oi98UAHvCjA
RvW5/uziTosCV4se4DSSMhfL80fWm1Aymom8MkVrVKOoIEDcbXotdEFtWXzJtSGF
pFqsa0T/5cgaiKsqDfT47XCkIHOSTRoZnMRZJ8Yr/0BFCNemNUqlC1R8Ig3TbKMZ
2ZT1zzFrB35GHaqVPx3O
=Ndpy
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
