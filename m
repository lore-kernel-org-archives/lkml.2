Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2HFFMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:12:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2HFFL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:11:58 -0400
Date: Mon, 6 Aug 2012 07:11:44 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120806051144.GA12642@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
 <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
 <CACRpkdbrdWw_HR91r72aB_S2+vxiaSBKHwW+Tsmi8pKk9VsgFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <CACRpkdbrdWw_HR91r72aB_S2+vxiaSBKHwW+Tsmi8pKk9VsgFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3zNjJXJb1b3s2F0gNRHXxGOVisRFKD9czOA0l7zoGna
 hvszG9N6aCwF/DrPvrTSPprLmYfuf3VxozK28859Wciw+av5T/
 KVjHF9/TdOEv65vybaVhMQwnMASij7sm7Ax0w/JlrYXtHH3Acl
 NJrNxbNqjFAR1chOCyQ8OtZFfdo52JymvwUAvbxZ1kUrvl882B
 2p6cKQWldc2BtnIA8P1m3ljw0dWpelvL/S6HP7xMNaMcNP395N
 2G329y0aykRa+Mk1azn/9RkUptehhb8svRxm3ZglLOJaT+k9xW
 XmSxGGpJxDwXEMpvjjtPOi6ppbIDKJAQR1a9eWtLqH7EIvNAMD
 jF1AK8OTpHyaXf++ipBbtOaQ61keSUvRw62+ENitwyRoRUP78+
 eA4d/wa782UyahphinK5VwlE+0IsluZyiK5ELBXJ00R05Cw52g
 I5Ytp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 05, 2012 at 12:50:54PM +0200, Linus Walleij wrote:
> On Mon, Jul 30, 2012 at 9:47 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
> >> On Mon, Jul 23, 2012 at 1:59 PM, Thierry Reding
> >> <thierry.reding@avionic-design.de> wrote:
>=20
> >> > +- interrupt-controller: Marks the device as an interrupt controller.
> >> > +- nr-gpios: The number of pins supported by the controller.
> >>
> >> These two last things look very generic, like something every GPIO
> >> driver could want to expose.
> >
> > As Arnd mentioned, interrupt-controller is a generic property required
> > by all interrupt controller nodes. Perhaps it shouldn't be listed in the
> > DT binding for this driver.
>=20
> After reading Rob's etc comments I think nr-gpios should be in this
> binding, but interrupt-controller seems like it should go into
> Documentation/devicetree/bindings/gpio/gpio.txt
> can you take care of this?
>=20
> (Anyone agains, beat me up...)

Yes, that makes sense. The interrupt-controller property is not
explicitly mentioned in Documentation/devicetree at all. Perhaps the
reason is that it is in fact a standard property and, I think, is
already defined by IEEE 1275. I don't think it would hurt to repeat it
explicitly for GPIO bindings in general, though.

> >> > +config GPIO_ADNP
> >> > +       tristate "Avionic Design N-bit GPIO expander"
> >> > +       depends on I2C && OF
> >> > +       help
> >> > +         This option enables support for N GPIOs found on Avionic D=
esign
> >> > +         I2C GPIO expanders. The register space will be extended by=
 powers
> >> > +         of two, so the controller will need to accomodate for that=
=2E For
> >> > +         example: if a controller provides 48 pins, 6 registers wil=
l be
> >> > +         enough to represent all pins, but the driver will assume a
> >> > +         register layout for 64 pins (8 registers).
> >> > +
> >> > +config GPIO_ADNP_IRQ
> >> > +       tristate "Interrupt controller support"
> >> > +       depends on GPIO_ADNP
> >> > +       help
> >> > +         Say yes here to enable the Avionic Design N-bit GPIO expan=
der to
> >> > +         be used as an interrupt controller.
> >>
> >> First: please describe the usecase where the Avionic driver is used
> >> without making use of the IRQ, and *why* it should be possible
> >> to configure this out. E.g. is there a hardware which isn't using the
> >> IRQ portions? If there is no non-irq usecase just drop this
> >> config option.
> >
> > This expander is used in a number of Tegra-based boards and handles
> > things like enabling or disabling power to a given IC but on other
> > boards it is also used to handle interrupts from input devices or
> > card-detect for example.
> >
> > The controller is synthesized in a CPLD, which is one of the reasons for
> > the nr-gpios DT property. There is at least one platform that currently
> > doesn't use the interrupt functionality. Mainly I allowed this to be
> > configured out in order to reduce the number of interrupts required for
> > a platform. Another reason was that at the time I first wrote this, IRQ
> > domains hadn't been available, so the driver couldn't be built as a
> > module if interrupt support was required. This also no longer applies.
> >
> > I'm actually fine either way, but I thought it'd be most flexible by
> > keeping the IRQ support optional for the above reasons.
>=20
> We're working on a goal of a "single zImage" (one unified ARM
> kernel) which means your platform must be able to handle the
> case where this is turned on anyway, so I would suggest you
> drop the optional compile-time IRQ support, just make it
> optional at runtime instead.

I don't quite understand. Do you want me to add a module parameter to
make it optional at runtime? Since the driver is now OF only I suppose I
could make it optional on the interrupt-controller property as well.

> > On that note, provided there is special additional circuitry, the GPIO
> > controller is able to detect tristate on an input. I'm not aware that
> > the pinctrl subsystem provides for that functionality yet, right?
>=20
> pinctrl is usually about *setting* things into tristate, but I'm all
> for adding support for getting it as well. But that depends on
> the generic pin configurations being adopted first (still most
> controllers have their own way of doing pin config, so this
> cannot be represented in a generic way).

As I mentioned, the only hardware where this was ever used is already
EOL and I don't expect this functionality to be required anytime soon
for another project.

> >> > +       base =3D kzalloc(regs * 5, GFP_KERNEL);
> >>
> >> Why kzalloc()/kfree() when you can just use a
> >>
> >> static u8 base[N];
> >>
> >> where N is the max number of registers on any HW instead?
> >
> > As I explained above, the number of pins is configurable, so it'd be
> > quite a waste to always assume a maximum of, say, 256 pins if the
> > hardware actually only uses 8.
>=20
> OK but atleast find a way to move this to the probe() function,
> what happens if the debugfs file is browsed and you run out
> of memory? Not nice, and you were using this to debug as
> well...

Alright, I can do that. Alternatively I could probably drop the
allocations altogether and use local variables within the second loop to
store the variables:

	for (i =3D 0; i < num_regs; i++) {
		u8 ddr, plr, ier, isr, ptr;

		err =3D adnp_read(gpio, GPIO_DDR(gpio) + i, &ddr);
		if (err < 0)
			goto out;

		...
	}

With the proper locking this shouldn't be a problem. The reason why I
used the block-wise approach in the first place was that the register
accesses were more "atomic". Of course without locking this is non-
sense.

> >> > +       gpio->irq_mask =3D devm_kzalloc(chip->dev, regs * 7, GFP_KER=
NEL);
> >> > +       if (!gpio->irq_mask)
> >> > +               return -ENOMEM;
> >> > +
> >> > +       gpio->irq_mask_cur =3D gpio->irq_mask + (regs * 1);
> >> > +       gpio->irq_level =3D gpio->irq_mask + (regs * 2);
> >> > +       gpio->irq_rise =3D gpio->irq_mask + (regs * 3);
> >> > +       gpio->irq_fall =3D gpio->irq_mask + (regs * 4);
> >> > +       gpio->irq_high =3D gpio->irq_mask + (regs * 5);
> >> > +       gpio->irq_low =3D gpio->irq_mask + (regs * 6);
> >>
> >> I'm not following this regs * 1, regs * 2 ... regs *7 stuff. What are =
you doing
> >> here? Explain with some comment atleast.
> >
> > Basically I need at least irq_level, irq_rise, irq_fall, irq_high and
> > irq_low to keep track of the current level and trigger modes for each
> > interrupt. Instead of allocating small chunks for each of these I
> > allocate one chunk and just make the others point into that.
>=20
> Maybe you said this would go away in this case not comments
> of course.

irq_mask and irq_mask_cur can go away I think.

> But I wasn't getting the multiplication part. I understand the
> allocation, 7 registers time the number of registers (hm, there
> is something about the naming too....)

You're right, regs should probably be called num_regs.

> You're storing the things in such an awkward way: all
> current masks for all registers sets, then all levels for
> all register etc.
>=20
> Instead could you store all the flags for *one* instance
> then the next set of registers etc.

I was following the register layout of the controller to keep things
consistent.

Thierry

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQH1IQAAoJEN0jrNd/PrOhpEoQAMEabYmr67MANtCXDh1BmxSC
gfI9F6FN60CISre8p+0cq/guu3YQnh3uOepD2+SLOwQ6MUGCl/81R3DX3qpNHjjS
Rvk3u/c/vFF4qL8aGxljTVqobk3qZ505BU9Dwgh7uqa85ImkPQlQlvIKshU4h7ac
HBqNEufuct2ChiEHjqRPfbM8RRpKSuHreRmEVnfuiS8jFR87wtRjCt9xT6zFJHI+
21rum+MzXAmp/au2WfPDsyXBlelWaiWzaHAX+JQalgozqutHz/H9iIKlhWCk4q4a
zjeBmYSCTS4duKLGIiY12cK9Stq1+iG+EBgNXzh7RmiT4bAD4yW97HWD26oJZR/4
ytRe8o9o7mpzXPNBtpSBNDHtZM1T5cfJLEaGKATPXab2N+IMJbYI6hneZFCglucL
RhCmFyo+gvv1SwJIdS/xq03nuZ+babeEN/HZPgRM8nFkEeSWmgWSywkinLHN2XWW
eIWR9yo8TxndbeeOOURkaIRI0XFPELZBTxgEsZDaTCwmgyqGzHsSxX+m4DMWZL+e
7PrydGPzE7VDEiPq/Zl6CH89GvO0LQsRVj6P/CK/h/whHdgWniSbtfRK9asRtLVX
6XfwsQic8cuhoeV4y8eWL3O2aL+GH8b1n+Rd9NqlJKYX233L0+t5hB8qGPxBCuVm
1dSLST4JilRtwcRAXeyq
=YHgI
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
