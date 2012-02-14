Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2BNF63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:58:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab2BNF61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:58:27 -0500
Date: Mon, 13 Feb 2012 21:58:15 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi or
 simliar devices
Message-ID: <20120214055814.GA13456@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-6-git-send-email-myungjoo.ham@samsung.com>
 <20120210162512.GF6472@opensource.wolfsonmicro.com>
 <CAJ0PZbQNBFT0WS6o_NokXhtif0K8KBez+asDgP=0RDeizfGokg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbQNBFT0WS6o_NokXhtif0K8KBez+asDgP=0RDeizfGokg@mail.gmail.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 14, 2012 at 11:22:14AM +0900, MyungJoo Ham wrote:
> On Sat, Feb 11, 2012 at 1:25 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Fri, Feb 10, 2012 at 03:40:38PM +0900, MyungJoo Ham wrote:
> >> External connector devices that decides connection information based on
> >> ADC values may use adc-jack device driver. The user simply needs to
> >> provide a table of adc range and connection states. Then, extcon
> >> framework will automatically notify others.

> > This really should be done in terms of the IIO in-kernel framework.

> The ADC part may be done in IIO. However, the intention of this device
> driver is to provide extcon interface to any ADC drivers, not
> providing an ADC device driver. If we are going to implement this in

Right, exactly.

> the ADC driver in IIO, we will need to write the given code in every
> ADC driver used for analog ports.

No, that's not what I'm suggesting - what I'm suggesting is that rather
than having a callback for implementing the ADC read functionality this
should work as an in-kernel IIO driver so it'll just automatically work
with any ADC without needing code to hook things up.  Unless I've not
understood your comment fully.

> >> + =A0 =A0 /* Check the length of array and set num_cables */
> >> + =A0 =A0 for (i =3D 0; data->edev.supported_cable[i]; i++)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ;
> >> + =A0 =A0 if (i =3D=3D 0 || i > SUPPORTED_CABLE_MAX) {

> > Can we not avoid the hard limit?

> Without that limit, we won't be able to easily express binary cable
> status (u32) with the extcon framework. At least, we will need to
> forget about setting the status with u32 values.

> Anyway, I can remove the checking SUPPORT_CABLE_MAX part at probe.

It might be clearer to make the limit more obviously associated with
the bitmask - it looks like it's an array thing the way the code is
written but a limit due to using a bitmask seems reasonable.

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOffwAAoJEBus8iNuMP3dzRUP/23XZi+yD+I8pk0LyB0kC9bL
WJza8Wi9Xmum+Nr7bid1JOaksQXpZhsWGZ04FMFJPx1YOz+mnaOWSI4sl9PcuCpU
vSxWrSvJwg/fY3FmyVjLTpwFQGm94hh+DvcqumQ3hSFMEY1XbHguJ6kKhX9QxTrw
XTh7MW6jqOpd8PJmaeFCALoJBGCRQ5NEIwqvKCIimQVkg960cNBKtZonHqILWn3k
AOAjM0rqlVIxIgNBjn9lTld9pGVnXcuRjq9BiavWUkkqlOJmMSjAC2u69XyyB6mc
DTaPONCLQQDypgvFCBCoo6LQ0ledcX8FpK3qIPiyGh530zSIYv/bsAA9+jVeO5ZS
v93q/c8HwHScyd41jP6ABNqsXhkAR/BKkhb4JsrnoyzcLUIEvVXaJwVConqk5p/8
joEJC1nq55m4gfqxivHWrGEpQI2amEb4Jmvwygel8g588/fRSqYWJliKAyNzUGwQ
VEC9R6H72SLEcT5muxf/GZg0qAm+W3AALlTri7OIM8IrktAvFvGzNWV2JcQPVdYd
GRU3SrM/Lhq8FZJMUl+bbQDPYpg5KJPSy1cRJmpYMXcPfiAfQvqsTMdBgwPee7vm
ZzJtrlaAylj1HtUEz1wdKBqV8GFhRFG2UCcqrX1l0VCMAZc0On5pJLG+TNwggh6D
Rv2c4enaI72dLe3fIHw7
=cHAs
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
