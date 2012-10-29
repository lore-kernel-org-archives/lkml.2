Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2J2TLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:11:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52876 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2J2TLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:11:50 -0400
Date: Mon, 29 Oct 2012 21:05:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <linux-input@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <b-cousson@ti.com>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20121029190516.GA29230@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351507129-10229-1-git-send-email-sourav.poddar@ti.com>
 <20121029162045.GK27566@arwen.pp.htv.fi>
 <20121029170633.GA11558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20121029170633.GA11558@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 29, 2012 at 10:06:33AM -0700, Dmitry Torokhov wrote:

[ big snip ]

> > > +static int __devexit smsc_remove(struct platform_device *pdev)
> > > +{
> >=20
> > shouldn't you unregister the input device here ??
>=20
> And that is why I do not like devm_* interface myself... But no, since
> input device was allocated with devm_input_allocate_device() it does not
> need to be explicitly freed or unregistered.

IMHO, that's a fragility on current devm implementation for input
devices, then.

devm_input_allocate_device() is *only* allocating the input device (at
least judging by the name). Looks like you should introduce
devm_input_register_device() ? What happens if I
devm_input_allocate_device() but don't go as far as
input_register_device() (some error happens in-between) ?

I'm sure you have some proper handling for it, but it's quite misleading
the way this was implemented.

--=20
balbi

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjtORAAoJEIaOsuA1yqRERcgQAIleHhFic5QAq+tLZLoguWGQ
eu71a9MhZomd/tgdKP2KxTNFBHX/XQZQfEZov+D/AV9i+ELNsT9cWppuoJ6w8P6/
7z2Gmp3QC9LHlr5G4yuIvneo1BmsyIFaRkukY3Jo/TpS2pyfAqgmzl51gzfvxq1p
458obuS6xrbUpKeWmFAuWUJavBxZuiNFMkcuWPnsYzk0arrOXus4qFUIZf78nJNa
To67IZm82qjQwCYDjykyeYU52uwNn71pN4PY270YFkbJy24BI8rkbnEYQwjpOVKq
l7qS1bMJ7PcC2JwRNL3EX3C2e4j7oYe1FKLajVnOJjGf3SfS6ThYDH/4Fqn5rxIM
DRHU5SsSEpD1DcU2m24VUW4HXob2yP+Ew1GcFR0h2Xl9F3rxDQr6PDhRPwjcbapb
iMZTL3qYayezUhaxpyWrhQ5o/bcnm3mD2qWrMSz5aAmEfcp6usaq6orDPCyh4KAP
7YJS9hrH5X5R0sl9/LKBkVPKd5VuXr346E2ZFhb9EvtS/D8dUPv9ZZNXCj2Qi60Y
LrW+en70U9qvqpUvTtfHr3fPafrdecUoEXfHhob1dta2cYAmMnWI/rdmxFQIFiX8
LFvOmLUqnyVNUr12XIBWoOlaXYIc4DE/TgKhNw1ZJMOd1fupCySSHQ+ryCYMeyk3
5hyECXY+eH9hRB/oS0JR
=BA/E
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
