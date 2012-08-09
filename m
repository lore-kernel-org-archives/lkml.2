Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2HIJlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:41:04 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41012 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998Ab2HIJlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:41:02 -0400
Date: Thu, 9 Aug 2012 12:37:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: otg: twl4030-usb: spin_unlock_irq in interrupt
 handler
Message-ID: <20120809093706.GM12174@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1342856418-1451-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t5NgoZwlhlUmGr82"
Content-Disposition: inline
In-Reply-To: <1342856418-1451-1-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t5NgoZwlhlUmGr82
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jul 21, 2012 at 11:40:18AM +0400, Denis Efremov wrote:
> The replacement of spin_lock_irq/spin_unlock_irq pair in
> twl4030_usb_linkstat function by
> spin_lock_irqsave/spin_lock_irqrestore pair.
> The twl4030_usb_linkstat function is called from twl4030_usb_irq
> interrupt handler. Therefore reenabling of handler interrupt line
> should be avoided.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

I have pushed a patch which I think solves this issue. Can you test ?

commit 6b03b13336ee5d8da7bda8799c9ed990e3daedcc
Author: Felipe Balbi <balbi@ti.com>
Date:   Thu Jun 14 13:24:42 2012 +0300

    usb: otg: twl: add missing IRQF_ONESHOT
   =20
    this patch fixes the following warning:
   =20
    [    2.825378] genirq: Threaded irq requested \
    	with handler=3DNULL and !ONESHOT for irq 363
   =20
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index c4a86da..0297930 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -651,8 +651,8 @@ static int __devinit twl4030_usb_probe(struct platform_=
device *pdev)
 	 */
 	twl->irq_enabled =3D true;
 	status =3D request_threaded_irq(twl->irq, NULL, twl4030_usb_irq,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
-			"twl4030_usb", twl);
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+			IRQF_ONESHOT, "twl4030_usb", twl);
 	if (status < 0) {
 		dev_dbg(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq, status);

--=20
balbi

--t5NgoZwlhlUmGr82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQI4TCAAoJEIaOsuA1yqREcasP/3CRqhc6KaKaBLEKm7qIGtLG
kiX7or6JQSXSZSf3ZjhoXOGar/vQo6kKrrq0wgirB+nyROJSH0Zvg8bzD6C73vLr
zDKlWD3TByNtbSOffjldBjjwYT/lPWxf68ct6CAFMw3WfZZ5PagsB+trJ+z46czn
MUJx6ruws0tP9ATo/oqU09MBMFe/qIriku6oOWp5gM+Lg9nnnfPgL8BmxDNGTPQ+
7kMSWvy6Z6fC4fK9FHpggLsa/Bn3H1E0ubyZ4zLygSiuSWmHiLizXgC4gclfiUog
EvvgL5hLrcSWfJCQgQ9mkT/0o1mUCnc3QHX50NGh8tyhvZcKPCNG/a9HdY0ZdqBx
LfzdjbtcgbP7wId7+6KKL+ovw4y9ojszEIYi4/lWaWjLgK26Dl0c/sORopvOmJSD
jxWfuN2Wpzrwf/0n4oJx8jldJe/RTUc5AGdOgn1QYgkOyo4LUDFrvvi/UnElzqUi
WTlsGw5RBmqxoYdh3w0kT/7B5qpoRicBsHRdSg4+YgdbSNiKZkXGe+gDUK4d1F4i
NOho7yWWiWW2kEqRc+nYMOt4OxxyZRlp4XMCV0QuoM90qvpTQsVIjrorNsVBO7hl
aVUDT5k3l8WPD9p1BlJzSuWikLYRjkMLj67wqmwViJ91WiqgafFaxIv3eBOUWw01
okmpf4sTqAXVF1GuMeQW
=sxQt
-----END PGP SIGNATURE-----

--t5NgoZwlhlUmGr82--
