Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1KIMeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:34:09 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43089 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126Ab1KIMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:33:51 -0500
Date: Wed, 9 Nov 2011 14:33:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "eric.miao@linaro.org" <eric.miao@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "david-b@pacbell.net" <david-b@pacbell.net>
Subject: Re: Adding USB charge current property in the Linux Battery core
Message-ID: <20111109123339.GC16315@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320826417.1160.8.camel@L-0761.kpit.com>
 <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9BF3F4@KCHJEXMB02.kpit.com>
 <20111109121950.GB16315@legolas.emea.dhcp.ti.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9BF409@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1F9BF409@KCHJEXMB02.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 09, 2011 at 12:30:19PM +0000, Ashish Jangam wrote:
> > > > On Wed, Nov 09, 2011 at 01:43:37PM +0530, ashishj3 wrote:
> > > > > For a better performance in USB charging operation, the DA9052/53
> > > > charging
> > > > > current can be configured in accordance with the USB host current
> > > > > delivering capacity (known through USB drivers negotiation).
> > > > >
> > > > > To implement this useful feature, a new writable property "USB ch=
arge
> > > > current"
> > > > > needs to be added in the Linux battery core.
> > > > >
> > > > > Let me know your views on it.
> > > >
> > > > that's the wrong way to do it. What we need is to use the transceiv=
er
> > > > notifications to notify every time someone calls usb_gadget_vbus_dr=
aw()
> > > > and pass the mA parameter as argument to the event notification.
> > > >
> > >
> > > This means that we need to modify the function usb_gadget_vbus_draw()
> > > to add a call like blocking_notifier_call_chain() but will this be fi=
ne
> > with
> > > the usb gadget driver maintainers?
> >=20
> > I am the USB gadget driver maintainer and I have plans to do that
> > myself. First thing we need to do is convert the final UDC drivers to
> > the udc Class which I wrote and Sebastian helped brushing it up, then we
> > uninline the usb_gadget_* wrappers and move them to
> > drivers/usb/gadget/udc-core.c, then we can move the transceiver notifier
> > to the UDC as it makes more sense, and convert blocking into atomic
> > notifier.
>=20
> This sounds good but since most PMICs have I2C bus connectivity using ato=
mic
> notifier can introduce problems.=20

we can't use blocking on atomic, right ? usb_gadget_vbus_draw() and most
of the others (usb_gadget_connect/disconnect, usb_gadget_frame_number,
and so on) are called from atomic context...

What i2c transceivers will have to do, is that they will need to defer
handling of the notification, which isn't all that big of a deal. If it
takes 300 miliseconds more to start charging, users won't even notice.

--=20
balbi

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOunMjAAoJEIaOsuA1yqRED3wQAK4e5VI5J/cQ+N9hlsLUlFnn
uXBUUyOrzhnO1g6dg8fDAz1UKPDvmhJvZB9VlbwIlQbHt5SKhEzmpvEUw+wY9SEP
R27mCeC8jAJBS70loh+dZk13d7eIBve3PqJCsZMrDcGcTqkbfap0YvZCADCGljH0
C2HjcK0gjWXaUYwy1z35G8kClUhC5nxdR/RM053vLsbXNQ//UL/zquJE+GR98mj4
kH914h3nN56ig6xu4KkAngmd8Yb/8HJLerl2qcyplc1fT1KouxC2QJvw3pARqitd
LTQs3kKuF1oFzKPnWTqAbBkgPhXv6js2sJZFie2NOp/tzSA9ZaFSAFDArSmFd/5X
SmEDiUoevHI7Zy6n/oUEF8A8j86VQh+hY6aTmgdw5qZxjiWr4lszDEyWKZoQKz3r
60ZoLGXiCshbtCSn7y7Zi6ozjna7L2BUPZUunIgPW6A99UaqDM3HhQ8MtMEIj0xg
vkwKtbmp1gWzH0RtA/fqRSR5XNDwSUdmKWj1OJlB2qDkm8+9ISqtwLX1FlFoX9sx
bVJTbLp5AzotSsa5rTaxdeXWtt5QXs/rIFshwSXrI7hXQl38svkeHDctinYazXb9
JODA30dWfxcOuz8MeYDPK4gIvZkD9x2vL8b5bMSAOZ4tRppjyKNJi7SYTy5Xmoi/
XC5oa6paNhHV1QXD46r/
=2YpB
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
