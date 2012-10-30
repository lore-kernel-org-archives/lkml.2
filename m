Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab2J3OhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:37:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2J3OhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:37:18 -0400
Date: Tue, 30 Oct 2012 14:37:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030143715.GP4511@opensource.wolfsonmicro.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
 <20121030113407.GA24335@sirena.org.uk>
 <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zecZT88ylESpiZX"
Content-Disposition: inline
In-Reply-To: <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zecZT88ylESpiZX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 03:02:23PM +0100, Linus Walleij wrote:

> I worry that we will end up with power/resource domain
> code that start to look like this:

> suspend()
> switch (device.id) {
> case DEV_FOO:
>   clk_disable();
>   pinctrl_set_state();
>   power_domain_off();
> case DEV_BAR:

Well, if we're doing that then either we'd presumably either get the
same result if we open code it in the drivers or whoever wrote the
resource domain code for the platform should be creating multiple
domains.

> Another effect is that moving all resource handling to
> power domains is that if we do that for a widely shared
> device driver like the PL011 that mandates that power
> domains need to be implemented for U300, Ux500,
> Nomadik, SPEAr 13xx, 3xx, 6xx, Versatile, Versatile
> Express, Integrator (AP & CP) and BCM2835. Probably
> more.

> Basically power (resource) domains have the side-effect
> of in this light not doing one thing (power domains) but
> instead imposing all-or-nothing imperialistic characteristics.

For me that's happening anyway with explicit control, just in different
places - for example the Freescale guys have had issues with IPs shared
between m68k and i.MX requiring that stub clocks be provided on m68k for
things that are always on there and similarly with all the platforms
that get affected when some widely used chip acquires regulator support.

It seems easier to organise things if the platform has responsibility
for coordinating this stuff than if we add stuff in the drivers.

> I worry that the per-SoC power domain implementation
> which will live in arch/arm/mach-* as of today will become
> the new board file problem, overburdening the arch/* tree.
> Maybe I'm mistaken as to the size of these things,
> but just doing ls arch/arm/mach-omap2/powerdomain*
> makes me start worrying.

One thing to remember is that OMAP has some of the most featureful
hardware out there in terms of software control for power so it's
unlikely to ever get much more complex than that.  IME most SoCs
are very much simpler than that and should be able to punt lots of
stuff to device tree data.

--9zecZT88ylESpiZX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj+XzAAoJELSic+t+oim9EFkP/1d40L0OYQ8Z9QHLeu5cbNoz
D0KQtlQOuRA0v5s0ONEWprg+X3kY16breTyNEEANA1p4rpNDBtOS17LHB0th/Muq
JyI8wxQqm16101sEv6IpB3MWwvi0X8N7iSO6fKAzlRFAnLIc+BGE0oDeQeRYhCN7
ccx8/wTOQfxgnNGSAeqg/uC6GpjzFuV8zwA/6wxDgHlxoeP/XXP8KkPumD1QXb4w
IxXnCS9aAzpAaKE8z3yMi25jU6cL7XNwAF7eYFBFawA/90qls/QY4vXjvtqwI7QC
W3GBcGmW4sekYxhZzTHJIuv+z0BMtSPKgCMTBh5Fzgzvoseg+FpToQ32YeTtt3Lq
lDbagBM801FI0HaCgffjRHxxm8vf+6URVl/6BRYXgku8O4dRurMXfGpVIdhO75m0
L2B09Pq5T9ixNXVg2sW7zcK0wtRnBXx0TslCgbFwzZJ4yQzNZrEdcUZHhUBqFxoL
br3gbr3oFXouLPEskrAg2QVWmotNsuUZgNqLBy9n6tL8F+N8id5Tc9xLLOchVW11
gHZ6QWFksxx6YTSQsEkRyVn7L6h2m/vse6qbphTNtGp/lZWEqEbh1QYLahA8wWvD
Ur6OPFXHFiUd9/Ew5ZSG82xLwjdCnz8nvyTQoD3C6q6wxkZmskHiAF1pMPvHi4gf
eRPGeIdAHg7sxKsY1QI6
=3pZ7
-----END PGP SIGNATURE-----

--9zecZT88ylESpiZX--
