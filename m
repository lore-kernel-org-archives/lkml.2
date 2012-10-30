Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab2J3LYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:24:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54870 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab2J3LYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:24:13 -0400
Date: Tue, 30 Oct 2012 11:24:10 +0000
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
Message-ID: <20121030112410.GM4511@opensource.wolfsonmicro.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWmFpGZayiNrn4FL"
Content-Disposition: inline
In-Reply-To: <20121029194901.GA30152@arwen.pp.htv.fi>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWmFpGZayiNrn4FL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 09:49:01PM +0200, Felipe Balbi wrote:
> On Fri, Oct 26, 2012 at 05:03:16PM +0100, Mark Brown wrote:

> > You could have the driver explicitly set the flag, it would just be one
> > extra line, but it seems marginally nicer to just do it.

> You didn't get the whole picture I'm afraid. Consider the situation
> where the same e.g. keypad driver is being used on OMAP4 and OMAP5 and
> those have different requirements towards pinctrl.

No, I'm pretty certain that I do.

> Now, we need to add OMAP5 support *to the same keypad driver*.
> Unfortunately, OMAP5 needs to handle pinctrl explicitly for whatever
> reason (SW-controlled sleep mode, errata fix, whatever).

> This will mean that we will have to remove the flag from the keypad
> driver because that's not valid anymore for OMAP5.

This isn't a problem; either the pinctrl code for OMAP5 will do
something sensible for OMAP4 in which case there's no difference to the
resulting code or you're going to have to have conditional code for the
two devices anyway and you're no worse off.

> This is why I think hiding things from drivers makes no sense. Also
> consider the situations Linus W exposed on another subthread. If you
> change ordering of certain calls, you will really break the
> functionality of the IP. Because we can't make sure this won't work
> automagically in all cases (just like we can't make sure $size memory
> allocation is enough for all drivers) we don't hide that from the
> driver. We require driver to manage its resources properly.

We need some place to put the SoC integration; power domains seem like
the obvious place to me but YMMV.  Nothing about having this out of the
drivers requires that this be done by individual subsystems in isolation
=66rom each other.  Half the point here is that for the reusable IPs this
stuff often isn't driver specific at all, it's often more about the SoC
integration than it is about the driver and so you'll get a consistent
pattern for most IPs on the SoC.

> How can you make sure that this will work for at least 50% of the
> drivers ? You just can't. We don't know the implementation details of
> every arch/soc/platform supported by Linux today to make that decision.

Well, we've managed to get along for rather a long time with essentially
all architectures implementing this stuff by doing static setup for the
pins on boot.  That does suggest we can get a reasonably long way with
something simple, and it does seem to match up with how things usually
look at an electrical level too.

It seems fairly obvious that if we need to add identical bolier plate
code to lots of drivers we're doing something wrong, it's just churn for
little practical gain and a problem if we ever decide to change how this
stuff works in the future.

--eWmFpGZayiNrn4FL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj7jQAAoJELSic+t+oim9WhwP/2CnMJ92z7eKpVpMjMMZa+yo
5/P4MYtQFjHlOnsorDey5yLsO1YPbVyGzrHnAElsb0U38wIMQqqH7Z7p5ge00DTM
fq/8oL8/FDGjZFW9wbsI/GOZyH4e0zAuKIu3G5hIBjZu8kIbmDXcu+tq+Mm1C4nL
Rv+PZLnCGXQDTbQDrW7d/dip+IHj9y6N1955yLg6J+GEj/Pdr3Ym/p8xl0ul8/SU
EMh3TfPar73HouozUERH+h20aHF5fMs0EiAGpmRdrflfxAMfN4AgPRT5LxZ6vJOR
/HZoyJ8nQnlRExOhc0BTGV9PlcO9M/cQvI3P+3l78OFIGlmFaFiWZfgT+ELtp0sk
DbvsaaW4ilhQDRyqQ8QSkt7GLRlWpiNXY64IDbtVigp5eqwXO5BRI+OpZWGc6W38
/yXWmol6ewi7Qy8xEWzHV26J5kTWDY1hzbrm+WZr0rT++o4vI0zC1zCod+4yBEqQ
f5SzJu0kdwDfqrujBiFQUV0tIkJptPmP12o8YRZxbRiIb3J7cFowhyB6gY6L5RCf
kuFMV/VyoyqaQSX1+rb2EdzufMRdfHeZKTb3Jejkbj95SA+EBucJ7ASiTxbkxuC4
wYKM/AJePPoFVJHXKmWkBgOk51MKgInrC/r+kId1x3IA3wB0yj8JWEtSvfVhSNiP
rIeQvDw7ZClCyAB6gV8i
=9wtN
-----END PGP SIGNATURE-----

--eWmFpGZayiNrn4FL--
