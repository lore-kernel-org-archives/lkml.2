Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab2C3KgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:36:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38853 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201Ab2C3KgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:36:12 -0400
Date: Fri, 30 Mar 2012 11:36:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120330103602.GE21950@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
 <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
 <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
 <20120328193341.GD3232@opensource.wolfsonmicro.com>
 <4F73A798.6030607@codeaurora.org>
 <20120329111159.GJ3668@opensource.wolfsonmicro.com>
 <4F7509F4.6010303@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Content-Disposition: inline
In-Reply-To: <4F7509F4.6010303@codeaurora.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 06:18:44PM -0700, Michael Bohan wrote:
> On 3/29/2012 4:11 AM, Mark Brown wrote:
> >On Wed, Mar 28, 2012 at 05:06:48PM -0700, Michael Bohan wrote:

> >>Are you aware of any other examples of submitted drivers with Device
> >>Tree support that implement regulator devices that optionally have
> >>an upstream supply? I looked at your tree recently and couldn't see
> >>any such cases.

> >No, pretty much any drivers which optionally have an upstream supply
> >would be buggy and should therefore run into trouble during review.

> Can you please elaborate on why this is a bad design? We have always
> used this model in the past, and the regulator framework is happy to
> support it.

The support for regulator-regulator supplies has always been problematic
and infrequently used -

> We have identical hardware blocks that can be positioned to take a
> supply or not. So are you proposing we copy / paste our driver so
> that in one case rdesc->supply_name is NULL and the other case a
> valid supply name? I'm guessing you aren't implying this, but what
> alternatives do you suggest to support such a model?

Please be more specific about what you're actually trying to physically
accomplish here.  It would be *extremely* unusual to see a regulator
which was able to do something useful without any input power and if you
genuinely have this need whatever you're doing probably needs the
framework to actually be aware of what's going on.  However...

> I was hoping that we could continue to treat regulator supplies as
> normal supplies, but somehow allow the framework to determine
> whether a regulator supply exists or not in the Device Tree
> configuration so the driver doesn't have to.

...this doesn't really make any sense - the new scheme makes regulator
supplies *more* like normal supplies, not less, since they're now
specified in exactly the same way as other supplies and are just assumed
to be provided by the leaf driver.

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdYwqAAoJEBus8iNuMP3d0lgP/R2UJVyTEy0TAcSAo8tJTYa/
pYO4h1ObVEDhidKyXtkdZFaJcGb1X/R2vvLdmkUAQLThFXCnd2Hem5IzP0mIGcNB
harVUTVJBWvqrpJXG1x+u4ZZqPhBHpEnKJ38GspbVkSeiTntxaXACy2qvIgVkMms
CmK4/IaK+X5hvlfvcoe1/QDnZ5j+eo79JX85ZCo1lLaghTP1SqnU/0dmLeDPK/Df
TmMr+eeTC43qnjuVm36+DI/5YDXWs071Q39Zi+/4S2PX0TlfjiAHpPc2ICGUrA7i
npzrJ3R7fEmn20FjSHoL9WGJwZYv8ugWt5jSwxisX6dOjDeaN2mA/fDgQhuqscqX
nofGiGDZhqgqSaLLjdWKdU3OgkhUvluYya38RJCnz6lsP4dAeebthDGa4Shzn5Bh
pf4INRm2UDPMLRgpJffra30DLumVqzX/1/p5D6n4fbLe6fp3todz8KWpEwunGFtw
JBuxEgGYYO5vWDOeFPw1Fq2IuEEG9xBZXFRqIchHKAAISiaC/w119GUvIoZfnnDX
07QW2qo6Y9W0/BR2QhHv9VygZeTQvQFQhlOF9//k0Yf/mD7zUgeygelntFL2OCos
YYmWscxC36cByARYhQZ+Rc4CL5lJNSmNQ7ntuTcs9Zwjw65tWTYUQuDOY15LHbJd
j3Ljyz5mIK7IN02D3ZJE
=8hY8
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
