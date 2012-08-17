Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030991Ab2HQKzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:55:04 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:55732 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777Ab2HQKy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:54:58 -0400
Date: Fri, 17 Aug 2012 13:51:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop
 interface
Message-ID: <20120817105103.GE4651@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345131276-28982-1-git-send-email-stigge@antcom.de>
 <502D1A49.20603@linutronix.de>
 <502D1CC2.9020901@antcom.de>
 <502E0A7B.1040607@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Content-Disposition: inline
In-Reply-To: <502E0A7B.1040607@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 11:10:19AM +0200, Roland Stigge wrote:
> Hi,
>=20
> On 08/16/2012 06:16 PM, Roland Stigge wrote:
> > On 08/16/2012 06:05 PM, Sebastian Andrzej Siewior wrote:
> >>> --- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
> >>> +++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
> >>> @@ -2987,14 +2986,14 @@ static irqreturn_t lpc32xx_usb_vbus_irq(
> >>>       return IRQ_HANDLED;
> >>>   }
> >>>
> >>> -static int lpc32xx_start(struct usb_gadget_driver *driver,
> >>> -             int (*bind)(struct usb_gadget *))
> >>> +static int lpc32xx_start(struct usb_gadget *gadget,
> >>> +             struct usb_gadget_driver *driver)
> >>>   {
> >>> -    struct lpc32xx_udc *udc =3D&controller;
> >>
> >> I assume controller is a global var created at probe time and could be
> >> removed now, right?
> >=20
> > Yes!
>=20
> Well ;-) looking more closely into it, I'd like to keep it for now: It
> is a more complex statically pre-initialized struct, finally being used
> in probe() for more dynamic initialization, and it ends up being used by
> many other functions, including lpc32xx_start() where accessing it now
> via container_of() is just a bit more elegant than a direct &controller
> of the global variable.
>=20
> Also, since this device is a single controller in the LPC32xx SoC, I
> would keep it until some other silicon uses several of this IP core
> (which I doubt), at which point we would probably still keep the (global
> static) controller and memcpy it to a dynamically allocated struct.
>=20
> Sounds reasonable?

no it doesn't. Please remove that static global. Sorry but one of the
goals with udc_start/udc_stop was really to get rid of all those
nonsensical static globals.

--=20
balbi

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLiIXAAoJEIaOsuA1yqREtoUP/REGPE7wuUNfxXN3a0g/glfR
WHaSRn7kEI2tJzEVRgGGo1vO+cZwFhD1FHQke2H+6SGqPc10J10Luf/2FS8cQnHt
8VN9X2iCvTtG/6LRn0dDN4N6Q7eHypBJ1CLSOaiMVxrzpfb2rVWAAoOwGWb1YOXz
FaI7IShMp03VIb8pYFaxi+lSb2IPgnhQQcoQA3YiT/f6WJjSChYKKzN5N6Aompb2
DWisqv3Oeo6nr0p8Kl0a1tF6fz9n1h+I4JckqLwU2KVPwodf1nDeoPBN8HC5SOfL
qwYutASrfpEwFe6Y2fpO5ZMV6523Ti5hCzw2qUiovdtdN6XeRIo6mhuBx0hzYHUb
0uY7qnTZ1se8/nSkAXo/KeRBjQR8rccQuvJ3gNiPwoOg3vNZaQPs748w6EwIX9r7
wRYEimvITeJTCBJxrl1KHUuQQxtBhahtU1OH9jZA39nnIynteVcu11t1jasUKsac
18nGpCoa278ryFyHntLjHDFxQMWzz3IiolyOLH5H0uuXhgsI9EuNnONStWl1LD0L
wcFqU/HM3Sg7N+MXY/5UKwlaLNWSiJMyqOOzHfc3yXUFKC2l24IqVwc4CvY7fQXe
D5kxUPWzqKT0jZND6/iuozPzcwaDs4jV6ciP+XlHhDBmQby4uGgAyxhLE5nvYc/c
HunWDdCQcI0iVTatiSE8
=5PiD
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
