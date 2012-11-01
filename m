Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2KANWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:22:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53951 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab2KANWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:22:07 -0400
Date: Thu, 1 Nov 2012 15:16:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <balbi@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101131609.GC12489@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
 <20121031221402.GA29490@arwen.pp.htv.fi>
 <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi>
 <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi>
 <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 01, 2012 at 02:57:26PM +0200, Pantelis Antoniou wrote:
> >>>>> Each cape will have their own DTS and based on some board id you
> >>>>> will fix the DT dynamically.
> >>>>>=20
> >>>>> My point is that the issue you are facing is a real limitation of
> >>>>> DT, so you should fix the DT core and not workaround it by creating
> >>>>> artificial bindings / drivers.
> >>>>>=20
> >>>>=20
> >>>> You still haven't described any mechanism to deal with all the use
> >>>> cases I described.
> >>>>=20
> >>>> DT can't and will not deal with the complexity that we're facing rig=
ht
> >>>> now.
> >>>=20
> >>> and DT-itself shouldn't. I agree with Benoit that this should be built
> >>> at bootloader level, perhaps. Whatever you're doing in capebus, you
> >>> could do at kernel space, build your DT bindings in runtime, and pass
> >>> that DT blob to kernel.
> >>=20
> >> We're just passing the buck someplace else. We're not fixing the probl=
em.
> >> What makes you think that dealing with this in the bootloader is going
> >> to be simpler?
> >=20
> > I never said it was supposed to be simpler, it just doesn't sound like
> > something the kernel should care about. Kernel cares about the
>=20
> I just disagree here. The kernel should provide services that make the li=
fe
> of users easier, not the lives of the kernel developers easier.

and it's already doing that isn't it ? we have i2c framework for i2c
clients. From a userland point of view, you have input layer, iio,
hwmon, chardev and a whole bunch of other interfaces which standardize
device accesses.

Look at your sentence again: "kernel should make life of users easier,
not that of kernel developers"; IMHO capebus is just making it easier
for the kernel developers who have to maintain a bunch of drivers for
different devices on different capes ;-)

At the end of the day, capebus will just be creating devices which will
be handled by the same I2C framework, iio, input, hwmon, and so on. So
what was the great benefit from capebus other than decreasing the
amount of changes to .dts files ?

> >>> One question though, what do you mean by "some capes are full blown
> >>> devices with their own drivers" ? Do you mean you have capes running
> >>> some other (RT)OS and communicating with linux somehow ? How does it
> >>> communicate to the bone ?
> >>=20
> >> Some have FPGAs.
> >> https://specialcomp.com/beaglebone/BeagleBone_FPGA.html
> >=20
> > how does linux communicate with those ? What they are matters very
> > little ;-) All we need is an interface to load binaries to the FPGA.
> >=20
>=20
> We can not know what people will come up with. It might have a few GPIOs
> to load the bitfile to the FPGA, but after that, no-one can tell.
> I might not interface to Linux at all; it might interface via I2C, or RS2=
32.

which means that whoever writes RTL for the FPGA needs to do so with
bone's I/O choices in mind.

Let's assume the use UART to send bitfile to FPGA and bitfile is a model
of an I2C Sensor, they'll have to use /dev/ttyOn to pass bitfile to FPGA
and later an i2c-client driver (possibly using iio, since it's a sensor)
will be loaded. Right ?

> Chances are, it won't fit in any kind of known drivers of linux.=20
> Some guy is using an FPGA for SDR, another is making a radar cape.

awesome. That means we need to take care of those :-) Even with capebus,
they will still have to write those drivers won't they ? So instead of
writing some capebus driver, why can't the guy write a driver for his
radar instead ? That way, if he ever turns that into an ASIC and decides
to sell it as a chip, he doesn't have to write another driver just to
strip the capebus away.

> These guys don't give a damn frankly about Linux. What they do care
> about is having a cheap/easy to develop platform for their own little
> widget.  If you are going to ask from the to hunt down their own dts
> and assemble from various dtsi's they'll just move to something else.

I never asked that :-) What I'm claiming is that capebus doesn't sound
like the best solution for the problem exposed.

> Which is a shame, cause we do have a nice platform here.

I agree with you, the bone is quite awesome ;-)

> >> Some capes have their own MCUs.
> >> A recent one has an 6502 communicating with uio_pruss.
> >> https://github.com/ohporter/b6502
> >=20
> > that uses remoteproc, so I assume it's using OMAP's mailbox ?
> >=20
> > Again I say that this is not a 'capebus', it's just another device
> > which we use another interface to talk to.
> >=20
> > i2c devices will be children of the omap i2c controller, spi devices
> > will be children of the omap mcspi, GPMC devices will need the GPMC
> > controller and so on, but none of this looks like argument to introduce
> > a fake bus into the kernel.
> >=20
>=20
> I'll let the users of said bus to do the talking. You're just flat out
> wrong IMO.

fair enough, I feel the same way about your capebus ;-)

--=20
balbi

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQknYZAAoJEIaOsuA1yqREAKYP/1SYigOl4rvDKE1YWZiziaKB
+4lKlLiQSLKXeEFF6iJZmsCbExuzWoGbLoXQ6A2XfFFRVXVhUpqBXyOTeDOUslns
uWOXMJCaNNRMddO5fkBhGO4nXYOkiJ0k9uzl602iqs+42auCtcLB25qfNFWS6Vxn
VfaFX1t2nC96h58jcl/AWx5Ub2BHPSYTOTJQJxzex0pP7r/3UH7Lm9YRZQ6Osfzl
Qq+n+Fhm1DQCndCZOnp+AQO3XH2DDw5PcpQ9sw2u4DA/589VUfPHGEA8hRkMfJVU
rbkyRZx0K5fwfBlOS3rfD/a7sUFyZW4sDjF9nVywcvRGGf7hnUALdHFdlphyMGs6
kDwan+1+8ijLIRCZShLhnN7P2HvgWtbUani2JMAoC/YForPaL1h6vwi0vR76VPqM
nU/ZigRjUFJqjRoLDtr57EgXqSvsjqFlNP78hSOeb22LUUoQfb08WEh9ZMr+Yeyz
nX52grKrafPF9NQQlsBLHuwO/UomPRLBfPKK6G3Q64HxhFa3YL2doEMBRt81O2ri
6Yc2Cr188yuKJvEAY6bF02YGHr4nCNZq+H+8lVYog9Ej3xSKo0EnNylOD/W9k6bG
EUlsE1sUdOdRiHEftF3c7AyJ2lB9oeBcM/n+Lc2DPbFlM/Da57uvhMltVhthWqTm
+L0dJOkJkKf88DRndOEZ
=7qPP
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
