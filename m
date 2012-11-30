Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2K3LEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:04:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2K3LEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:04:10 -0500
Date: Fri, 30 Nov 2012 12:04:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
Message-ID: <20121130110400.GA9400@avionic-0098.adnet.avionic-design.de>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
 <20121123075537.A14713E0A91@localhost>
 <50AF3E21.4000009@ti.com>
 <50AF4584.7020604@ti.com>
 <20121126154600.765E03E1AFD@localhost>
 <50B5D161.6010200@ti.com>
 <20121129161024.EEA803E0912@localhost>
 <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de>
 <20121130102039.0267E3E129E@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20121130102039.0267E3E129E@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bBHy6GnMTx23E1oeEGMp7W83ldzR1i+WatLnB3uqcnM
 4XKqgOh5wVV/y+LWGZV/Bu0fp+tcBNBeKWiAmvccjPNNRp6Q1C
 D85hHzTa9SULDPcxb2tgGC7H5c5qSF84/P413pZu86vvebunx+
 lESUov/Gp2aIvpRMLqTHHK51gQqYK3OfLjT0AKiQiYbH/uvB+K
 Uq4viuXsrXsgWjdl3rerisj/pVLW77PfvP8XS7QpMDL/lJ43nL
 m2lqp4pdIi6Omus4P1z+qpy2an4YamjWt0ptgwgRf+gyFuzE/m
 C5GLR1oc1Ss9MhXu/xQoEyzw+bHWYFJcColKS5s/ckxHQp8mA0
 kt4fjiUUeHWznU47BYNm2FMX/kEMKMAT2PLyQnZGQqK8XgN2eL
 /i6aNcYCYXrlfWM5wSv7juONNK4saTKQKU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2012 at 10:20:38AM +0000, Grant Likely wrote:
> On Fri, 30 Nov 2012 07:47:52 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > On Thu, Nov 29, 2012 at 04:10:24PM +0000, Grant Likely wrote:
> > > On Wed, 28 Nov 2012 09:54:57 +0100, Peter Ujfalusi <peter.ujfalusi@ti=
=2Ecom> wrote:
> > > > Hi Grant, Lars, Thierry,
> > > >=20
> > > > On 11/26/2012 04:46 PM, Grant Likely wrote:
> > > > > You're effectively asking the pwm layer to behave like a gpio (wh=
ich
> > > > > is completely reasonable). Having a completely separate translati=
on node
> > > > > really doesn't make sense because it is entirely a software const=
ruct.
> > > > > In fact, the way your using it is *entirely* to make the Linux dr=
iver
> > > > > model instantiate the translation code. It has *nothing* to do wi=
th the
> > > > > structure of the hardware. It makes complete sense that if a PWM =
is
> > > > > going to be used as a GPIO, then the PWM node should conform to t=
he GPIO
> > > > > binding.
> > > >=20
> > > > I understand your point around this. I might say I agree with it as=
 well...
> > > > I spent yesterday with prototyping and I'm not really convinced tha=
t it is a
> > > > good approach from C code point of view. I got it working, yes.
> > > > In essence this is what I have on top of the slightly modified gpio=
-pwm.c
> > > > driver I have submitted:
> > > >=20
> > > > DTS files:
> > > > twl_pwm: pwm {
> > > > 	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> > > > 	compatible =3D "ti,twl6030-pwm";
> > > > 	#pwm-cells =3D <2>;
> > > >=20
> > > > 	/* Enable GPIO us of the PWMs */
> > > > 	gpio-controller =3D <1>;
> > >=20
> > > This line should be simply (the property shouldn't have any data):
> > > 	gpio-controller;
> > >=20
> > > > 	#gpio-cells =3D <2>;
> > > > 	pwm,period_ns =3D <7812500>;
> > >=20
> > > Nit: property names should use '-' instead of '_'.
> > >=20
> > > > };
> > > >=20
> > > > leds {
> > > > 	compatible =3D "gpio-leds";
> > > > 	backlight {
> > > > 		label =3D "omap4::backlight";
> > > > 		gpios =3D <&twl_pwm 1 0>; /* PWM1 of twl6030 */
> > > > 	};
> > > >=20
> > > > 	keypad {
> > > > 		label =3D "omap4::keypad";
> > > > 		gpios =3D <&twl_pwm 0 0>; /* PWM0 of twl6030 */
> > > > 	};
> > > > };
> > > >=20
> > > > The bulk of the code in drivers/pwm/core.c to create the pwm-gpo de=
vice when
> > > > it is requested going to look something like this. I have removed t=
he error
> > > > checks for now and I still don't have the code to clean up the allo=
cated
> > > > memory for the created device on error, or in case the module is un=
loaded. We
> > > > should also prevent the pwm core from removal when the pwm-gpo driv=
er is loaded.
> > > > We need to create the platform device for gpo-pwm, create the pdata=
 structure
> > > > for it and fill it in. We also need to hand craft the pwm_lookup ta=
ble so we
> > > > can use pwm_get() to request the PWM. I have other minor changes ar=
ound this
> > > > to get things working when we booted with DT.
> > > > So the function to do the heavy lifting is something like this:
> > > > static void of_pwmchip_as_gpio(struct pwm_chip *chip)
> > > > {
> > > > 	struct platform_device *pdev;
> > > > 	struct gpio_pwm *gpos;
> > > > 	struct gpio_pwm_pdata *pdata;
> > > > 	struct pwm_lookup *lookup;
> > > > 	char gpodev_name[15];
> > > > 	int i;
> > > > 	u32 gpio_mode =3D 0;
> > > > 	u32 period_ns =3D 0;
> > > >=20
> > > > 	of_property_read_u32(chip->dev->of_node, "gpio-controller",
> > > > 			     &gpio_mode);
> > > > 	if (!gpio_mode)
> > > > 		return;
> > > >=20
> > > > 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_=
ns);
> > > > 	if (!period_ns) {
> > > > 		dev_err(chip->dev,
> > > > 			"period_ns is not specified for GPIO use\n");
> > > > 		return;
> > > > 	}
> > >=20
> > > This property name seems ambiguous. What do you need to encode here? =
It
> > > looks like there is a specific PWM period used for the 'on' state. Wh=
at
> > > about the 'off' state? Would different pwm outputs have different
> > > frequencies required for GPIO usage.
> > >=20
> > > Actually, I'm a bit surprised here that a period value is needed at a=
ll.
> > > I would expect if a PWM is used as a GPIO then the driver would alrea=
dy
> > > know how to set it up that way.
> >=20
> > Just to make sure we're talking about the same thing here: if a PWM is
> > used as GPIO the assumption is that it would be set to 0% duty-cycle
> > when the GPIO value is set to 0 and 100% duty-cycle when set to the 1.
> > The period will still need to be set here, otherwise how would the PWM
> > core know what the hardware even supports?
>=20
> Umm, I agree with you on duty cycle, but that's got nothing to do with
> period. 100% duty cycle looks exactly the same whether the period is
> 10ns or 100s.

Yes, that's true. My concern was more that any value for period that we
choose more or less arbitrarily as the default for GPIO operation would
end up not being supported by some hardware.

> > Unless you're proposing to not include that in the PWM core but rather
> > in individual drivers. Then I suppose the driver could choose some
> > sensible default.
>=20
> Mostly I'm asking questions because I'm not familiar with the subsystem.
> If the property is needed then I have no objections, but at the moment
> it doesn't make any sense to me.
>=20
> > One other problem is that some PWM devices cannot be setup to achieve a
> > 0% or 100% duty-cycle but instead will toggle for at least one period.
> > This would be another argument in favour of moving the functionality to
> > the individual drivers, perhaps with some functionality provided by the
> > core to do the gpio_chip registration (a period could be passed to that
> > function at registration time), which will likely be the same for all
> > hardware that can and wants to support this feature.
>=20
> It is a bit of an oddball case where if the hardware engineer wires up a
> PWM to use as a GPIO, then he better be sure that it is actually fit for
> the purpose.

Yes, I agree. So what we really want is to make this configurable in
some way. For DT this could just be controlled by the gpio-controller
property. The PWM core could easily setup the gpio_chip in the presence
of that property.

For non-DT it could probably be done via a flag that is passed to the
driver via platform data, in which case the driver would have to call
the helper explicitly based on the setting of this flag.

> That doesn't prevent the PWM core having some gpio-emulation helper
> functionality, but do need to be careful about it.

On the other hand, if we turn that support into a helper maybe it is
easier to leave it up to the driver whether to call it or not. A big
advantage of this would be that the driver could pass a period along
that it can choose sensibly according to the chip's capabilities.

Something as simple as:

	int pwmchip_emulate_gpio(struct pwm_chip *chip, unsigned long period);

could do. Cleanup could be done automatically in pwmchip_remove().

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuJKgAAoJEN0jrNd/PrOhqE0P/jGTE3MR3oU9g7lGsnUBqjIV
xL+QUXPS3aAg5sM11m8KUhZACplR0l+ToVfiL7FAi9Z7hS1Bk/LCnQ08ki/h0hV1
C47romjUi3S/47LcUVYd8DrkChDz+QeM+8vbuLz83rI51CJ/LvVgJMT2tnHeUqDg
MaOfWark35HidbqBKuIe9TLBXfNco6/+Rs1t5y7Y9pCGnHt12jxa7I2lQRk3sez6
MUwtgy2lEAg9ZsfHIl+BsvjZmlfbnIS0QmjVqngAP1z6KkybOdw7zJUa3izSMaDm
6+f5pAZxXmuTggDe6MdqHjVxO311Ja9u2rcuA6+3tDiw0HvlRc9ZLRQTHfPyZmls
1jkKksBh84xBlfy3en1y1ThDeFhGjfbMqeTyskbl2oq5XRH4Aka9h8BVVG0psPus
TqZmXYXevZX2+uaDems/lkpjSwzK0rCGCPn+4/4w/KFHwn2h/Obn1aNqfjKb+zXo
gJl9UK6OgK9mHOYP/L4kCHGjOj6uPGY0gXtG3dbVQxf/kiC745yUCh9vSLytpbnq
9k+JaWSjHL+6Fl2iSC8A57pqfN3JsZJ1LTWjbvfnRLXLsCvFFzsnjE7sxFWoBh7g
jHXmSdVtHVTh95bilTYD/ilgZNBmd0ubBzt2VxWjjm1s+Vw8guY+xPjZFP1rwsKh
Bgf/Fd/95opKlmW62PRY
=FexT
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
