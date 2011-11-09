Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1KIMT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:19:57 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37768 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab1KIMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:19:55 -0500
Date: Wed, 9 Nov 2011 14:19:52 +0200
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
Message-ID: <20111109121950.GB16315@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320826417.1160.8.camel@L-0761.kpit.com>
 <20111109082005.GH23337@legolas.emea.dhcp.ti.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9BF3F4@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1F9BF3F4@KCHJEXMB02.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2011 at 12:13:14PM +0000, Ashish Jangam wrote:
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Wednesday, November 09, 2011 1:50 PM
> > To: Ashish Jangam
> > Cc: linaro-dev@lists.linaro.org; linux-kernel@vger.kernel.org;
> > arnd@arndb.de; eric.miao@linaro.org; Mark Brown
> > Subject: Re: Adding USB charge current property in the Linux Battery co=
re
> >=20
> > Hi,
> >=20
> > On Wed, Nov 09, 2011 at 01:43:37PM +0530, ashishj3 wrote:
> > > For a better performance in USB charging operation, the DA9052/53
> > charging
> > > current can be configured in accordance with the USB host current
> > > delivering capacity (known through USB drivers negotiation).
> > >
> > > To implement this useful feature, a new writable property "USB charge
> > current"
> > > needs to be added in the Linux battery core.
> > >
> > > Let me know your views on it.
> >=20
> > that's the wrong way to do it. What we need is to use the transceiver
> > notifications to notify every time someone calls usb_gadget_vbus_draw()
> > and pass the mA parameter as argument to the event notification.
> >=20
>=20
> This means that we need to modify the function usb_gadget_vbus_draw()
> to add a call like blocking_notifier_call_chain() but will this be fine w=
ith
> the usb gadget driver maintainers?

I am the USB gadget driver maintainer and I have plans to do that
myself. First thing we need to do is convert the final UDC drivers to
the udc Class which I wrote and Sebastian helped brushing it up, then we
uninline the usb_gadget_* wrappers and move them to
drivers/usb/gadget/udc-core.c, then we can move the transceiver notifier
to the UDC as it makes more sense, and convert blocking into atomic
notifier.

After that we can add notifications to all gadget events/API/etc...

--=20
balbi

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOum/mAAoJEIaOsuA1yqREmI8P/j4dj0xPCLfNS/1YX8l09hy1
bdC/g01blAIy16gj08EmodXQ8vgAap6CCHbPA/lw+1yQxve1S5IB1C97qriadAyx
H2XE93IENroMaHGKRWZhtyyNPw3WKQmXFbIiW/2edCjiH/bATj+1US3XMqHA/G++
MObir+LocY4YYT/JrYEtYXi3PskBLrY3EXmZHMhW3Pox1ylOo8SaDXV/+CrGLhFu
UaHmoLy4n5rXx+h+MmCrRL4CGYC3wAV0bg9akDz2lOZLy6evgLxkrJUR83VdlERe
JJQmteKDecFmLUh+guFTc3M7So/+d5TA5/5LF9YffgQRyw2Bn6JcKp7sQTb55A8b
RSdiM3VifZvxZWH7fci+VyI1qeR2ZZqYHgorsVMb8pecaZHwubPMMmLIv4w11z1F
Ba9aCReNfEqgilsYP7SYEW1oCGuOo4jZLJ4e8idLuB3y2asr9u1vO8UbrKcUQyuq
yxApjjPAmgrW4qcquaIPAw3FUif35xjnMs8obL4GfrMqvaOMBm4v6lbf+NYYUtuS
RvjGJ2OV0onZ9iFA63Dz88u8L8LdRijG+lcG/evDEGKrloAx85foVcZI+mJDEBX1
3y8/xkgabw0xQNZXPL3T+ozBwYFlCZfNmGGIl8c7cj9Y88GjZ1Remn7WtHEcViSk
X6PjgxuuBybshG+/7NZZ
=xY+4
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
