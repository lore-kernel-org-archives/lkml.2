Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119Ab2JZQDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:03:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33113 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab2JZQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:03:19 -0400
Date: Fri, 26 Oct 2012 17:03:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121026160316.GY18814@opensource.wolfsonmicro.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yhqQ34TVR4fE8mPU"
Content-Disposition: inline
In-Reply-To: <20121026062008.GA21734@arwen.pp.htv.fi>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yhqQ34TVR4fE8mPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 26, 2012 at 09:20:36AM +0300, Felipe Balbi wrote:
> On Thu, Oct 25, 2012 at 09:59:01PM +0100, Mark Brown wrote:

> > I suspect that's not actually a big deal and that if we went down this
> > route we'd have the driver take over control from the core code during
> > probe() with the core still setting up the default state.

> > Personally I do think we want to be factoring bolierplate out of
> > drivers, if they're not doing anything constructive with pinctrl they
> > should be able to avoid having code for it.  There definitely are issues
> > to work through but it seems like we ought to be able to do something.

> IMHO this will come back to bite you in the *ss. Specially when the same
> driver is shared among multiple revisions of the same SoC or multiple
> different SoCs.

I'm not entirely sure you fully understood the proposal...

> Hypothetical situation: OMAP4 has keypad as the default pin mode and low
> power is handled by the HW, so keypad could have pinctlr "boilerplate"
> factored out. Then comes OMAP5 and low power mode has to be handled by
> SW for whatever reason (maybe there are more than one low power mode).
> Then we will need to patch omap4-keypad.c to remove "dont_touch_my_pins"
> flag and add pinctrl support.

This isn't going to make any practical difference at all, as soon as the
driver starts using pinctrl explicitly a flag gets set in the driver and
the default code does nothing more.  The only difference will be that we
may get a default configuration applied prior to probe.

You could have the driver explicitly set the flag, it would just be one
extra line, but it seems marginally nicer to just do it.

> When you think of the possibilities of every single driver going
> throught that it sounds a lot nicer to not make that decision IMHO and
> keep pinctrl explicit.

I'm just not seeing any impact on drivers that do something interesting
here.

--yhqQ34TVR4fE8mPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQirM9AAoJELSic+t+oim9c8UP/jleghlFW4jR1AwJdXkaEddQ
KYZ3Iw5kZ+4YyHOypGWP9inaMG22ru1Z4d5nvSAMbdUnLI+uQc/nK+mMlEKrKIz0
B4coXcssBZjN0BVOdfMLhdg03edhUZMB8hZfOl6uqj/YnOeUaMKMuOj+APW9qaAp
SmEvTG/cljfGx6iCZkNIUvXVNvYUaKQk8qXCH835ETtkX3Dh3GVF32imPATYXTWb
wTpqe30GJe9rD0Q+vS0ik+HfEU4ZunQdlkYCBW+TGLRgOQka1bN9N3GsP5yuzrmU
YmW4zpx2cuBL8vFPvZJBJF3lurgK+PhT7fx752qzPEkrDp9PV50jvn+ld0hM5rY9
q8xWo2+JR+anS1dYEzPG7LzSg7tIhPLmrlIBhmU7oUG0ux0VCJ+dfOLsB0uReC9B
xe48D7XAGOb+5D9Judn9llQ/mckTYSwiGGcr7VKzTGH+5sPDokrifoRvyqa1oQf7
cWb44IIw5TKMM33S6Qn2/fzq2Z0ntMHjbf5dK1q+xjAH5Vxp5aXcYOUQQh9LwsQN
1gsfWEwywDr4uegXkmis+0lsJjcwuOHq3vMevduRW8d3QQ24EjIFth530UtyP7Z9
BXwA4KcRrp8+NEuFKSKQLvZO5+co3A6l9nE7/PsFgmi4MBAHmTgDtjYzHSo+5jR2
N4dMrcPlO6jeuRqcBqwR
=f5GG
-----END PGP SIGNATURE-----

--yhqQ34TVR4fE8mPU--
