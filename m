Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2KBJDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:03:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2KBJD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:03:26 -0400
Date: Fri, 2 Nov 2012 10:57:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russ Dill <Russ.Dill@ti.com>
CC: <balbi@ti.com>, Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121102085718.GF17063@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121101110418.GF410@arwen.pp.htv.fi>
 <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi>
 <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi>
 <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk>
 <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
 <20121101220518.GE14982@arwen.pp.htv.fi>
 <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Content-Disposition: inline
In-Reply-To: <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 01, 2012 at 04:49:23PM -0700, Russ Dill wrote:
> On Thu, Nov 1, 2012 at 3:05 PM, Felipe Balbi <balbi@ti.com> wrote:
> > HI,
> >
> > On Thu, Nov 01, 2012 at 03:59:50PM +0200, Pantelis Antoniou wrote:
> >> Hi Alan,
> >>
> >> On Nov 1, 2012, at 3:51 PM, Alan Cox wrote:
> >>
> >> >> What they want, and what every user wants, is I plug this board in,=
 and
> >> >> the driver make sure everything is loaded and ready. No, the end us=
ers
> >> >> don't want to see any of the implementation details of how the bitf=
ile
> >> >> is transported; the driver can handle it.
> >> >
> >> > That doesn't necessarily make it a bus merely some kind of hotplug
> >> > enumeration of devices. That should all work properly both for devic=
es
> >> > and busses with spi and i=B2c as the final bits needed for it got fi=
xed
> >> > some time ago.
> >> >
> >> > In an ideal world you don't want to be writing custom drivers for st=
uff.
> >> > If your cape routes an i=B2c serial device to the existing system i=
=B2c
> >> > busses then you want to just create an instance of any existing driv=
er on
> >> > the existing i=B2c bus not create a whole new layer of goop.
> >> >
> >> > It does need to do the plumbing and resource management for the plum=
bing
> >> > but thats not the same as being a bus.
> >> >
> >> > Alan
> >>
> >>
> >> Fair enough. But there's no such thing a 'hotplug enumeration
> >> construct' in Linux yet, and a bus is the closest thing to it. It does
> >> take advantage of the nice way device code matches drivers and devices
> >> though.
> >>
> >> I'm afraid that having the I2C/SPI drivers doing the detection won't
> >> work.  The capes can have arbitrary I2C/SPI devices (and even more
> >> weird components).  There is no way to assure for example that the I2C
> >> device responding to address 'foo' in cape A is the same I2C device
> >> responding to the same address in cape B.
> >
> > your ->detect() method should take care of that.
>=20
> There isn't some magical serial number in I=B2C devices that a
> ->detect() method can read and the implementation of I=B2C is somewhat
> flexible. One devices read may be another devices write. A detect

look at what other drivers do. You can read a revision register, you can
write a command and see if the device responds as expected, it doesn't
matter.

> method that only performs reads could easily toggle a gpio that resets
> the board, rewrite and eeprom, or set the printer on fire. If you

how ? It's just a read.

> browse through various detect functions, yes, some of them key off an
> ID, but a lot of them just check various registers to see if certain
> bits are zero, or certain bits are one. A lot of I=B2C devices I've
> dealt with have no good way of probing them, especially GPIO chips
> (you'll notice none of the I=B2C GPIO expanders have detect functions)

it doesn't mean it can't be done.

> On top of all this the detect routine does not tell you if the alert
> pin is connected to some IRQ, or in the case of a GPIO expander, what
> those GPIOs are connected to, etc, etc.

so what ? All you want to do with detect is figure out if the far end is
who you think it is, not what it's doing.

--=20
balbi

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQk4ruAAoJEIaOsuA1yqRE/oYP/RrMH4OT/KP6qBKpCh2IP8oj
TUUTewsWGmGmhtWqjM+/1Ck1oJTtdbaYN/M+JI15J44/aLXwvFLQWN2h5SKF2piQ
CcxF8lNckdrsL/33qpsTEwbaAsD3UqNbnlZpfAKS8cOTVOmbqWmVlBL0T5ZWT1lL
J1y+0DH5A52sact2PXmdZJOkgdOOAUqdrBLYVQ+h56YerSxCBfh2a1qyTCzpYu6Z
dx0We+7fcLubz69fbb84jg0AAqiMhjLD6JfE/bTElhQdPF3EkzJc7+9AqIcHdFbn
8I2vVX/k8UlcAiJLu3TvS60aGsVrKGjJeLVi4IxCVL0tLdKDEk9Ubd2xYuqrfxva
/dvil8+N439/TDj+0SFQOLhJbe+zZ3WFPzzVqS5mbpyjRS8wd64s4hpWYDNjEpAw
k8EKL0IC8h/HG7i0VsNV83ZBvWM3z6uve4M666L0+kDKPA+nGbVOCTzhV16zdCxO
77Xiiu3oSN/yXQFsO7iEQPPkOy07yEDvqPqJn4z28fHZ72HpwoVJwQ4wu0ZZIEpX
jj5iFwcgSqP7+1wjff560/puupo9377HsI/BthXSQV0O9C1bowmZBE+YJNhHSYGp
zWswCgjnPEEVypdiX7dmMTT+J5GU8kamNMeCCRjo78kPPwQBuyD7OFzQfbZ2MRIS
cxJ2OTRGtD1A1xKhI0b0
=znTI
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
