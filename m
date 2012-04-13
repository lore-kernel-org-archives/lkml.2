Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab2DMKkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:40:36 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35484 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab2DMKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:40:34 -0400
Date: Fri, 13 Apr 2012 13:39:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hubert Feurstein <h.feurstein@gmail.com>
Cc: Nikolaus Voss <n.voss@weinmann.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        nicolas.ferre@atmel.com, ben-linux@fluff.org, balbi@ti.com,
        rmallon@gmail.com
Subject: Re: [PATCH v9 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20120413103937.GH7154@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1322479017a.git.n.voss@weinmann.de>
 <201203191534.q2JFYl1b012744@gatekeeper.vosshq.de>
 <CAFfN3gWCu5RnKb6dK4YMCAhpkfLncYdk1Cwqxb3wxMVznSiSFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qM81t570OJUP5TU/"
Content-Disposition: inline
In-Reply-To: <CAFfN3gWCu5RnKb6dK4YMCAhpkfLncYdk1Cwqxb3wxMVznSiSFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qM81t570OJUP5TU/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 13, 2012 at 12:17:59PM +0200, Hubert Feurstein wrote:
> Hi Niko,
>=20
> I'm using this driver since a while a now in my system
> (soc:at91sam9m10; kernel:v3.2.14) and it works quite well. But
> occasionally it happens that wrong data is read from my devices. I've
> traced down the issue to the way how you do the interrupt handling. In
> your code you do not consider that both status-flags (TXCOMP and
> RXRDY) may be pending at the same time. So you handle the TXCOMP but
> NOT the RXRDY which will cause a data-loss on the current transfer. As
> a consequence also the next transfer will be corrupt, because you
> start with old data in RHR. So I would suggest the following changes:
>=20
> static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
> {
> 	struct at91_twi_dev *dev =3D dev_id;
> 	const unsigned status =3D at91_twi_read(dev, AT91_TWI_SR);
> 	unsigned irqstatus =3D status & at91_twi_read(dev, AT91_TWI_IMR);
>=20
> 	if (irqstatus & AT91_TWI_RXRDY) {
> 		at91_twi_read_next_byte(dev);
> 		irqstatus &=3D ~AT91_TWI_RXRDY;
> 	}
>=20
> 	if (irqstatus & AT91_TWI_TXRDY) {
> 		at91_twi_write_next_byte(dev);
> 		irqstatus &=3D ~AT91_TWI_TXRDY;
> 	}
>=20
> 	if (irqstatus & AT91_TWI_TXCOMP) {
> 		at91_disable_twi_interrupts(dev);
> 		dev->transfer_status =3D status;
> 		complete(&dev->cmd_complete);
> 		irqstatus &=3D ~AT91_TWI_TXCOMP;
> 	}
> =09
> 	if (irqstatus) {
> 		/* There should be no pending interrupt anymore. *)
> 		return IRQ_NONE;
> 	}

Dude, I remember asking the exact same thing when he first posted this
driver. That whole if...else if... else if ... else didn't look right.

Can you send this in patch format Hubert ? Take a look at
Documentation/SumittingPatches if you have never done it before.

--=20
balbi

--qM81t570OJUP5TU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPiAJpAAoJEIaOsuA1yqREWcQQAKXiKzLPUHdoBrX7+Tl1LRJR
EM1NRqmOtonC6Y8aktDTeVJDIMWSPDQ2jIVe93zZbkh3bG9nbkKKzT7I9SFP6h/m
kcuDAOBUe8ZKXCvWF0PiraxgooYM4ecFFTVc+9BGxauUoA03c7aD/TV7I1TpLeL8
q/eu/paT3bp0H3Tkfpv+ei3pZ4zQE9hp+harG0jjywOhe+9va00D9T/q5ubOrmVg
H595oQd7B95VbNtVX+i6tf24A0+6Nco2A3rrTX35OCmp4FAu/FeOaqa0/0Q7lA1G
ceVXRjiwRlHMDuXBJIv2jTPlMlz45sO9ruPOXneAmXF7zWtFUpV4wU65K4O3I76/
jsgqOAplAvIXXyPzgsXvYGDtulqleF9nvHVLY0fdCLgekUe0yTmLyqio6wAp+p0y
XgE2BxICo0xWkA5KfkKfjYhfFeORK6oQbgtasNGnOYiVdKXmPd/Ur3zYuM+tkwf1
H50Wh1eYOE0aJ+b1Hu3KOUHUnTnZJf0JXRK2o39hsR5UdrDk0aKMkdbJBgD/JD3b
X+y60u2rJlocetRw43BAngDa96foMN0H3qh8ohT6jq67MbFtOIZOklXfjIyk7DJh
QxAstqFT8VTmuGRpqTPjSK3/zad76Fa9ze/3rhy8dlAgUrpAlBi0LNI4uR2G6Hq9
l/0f0yn9rK+JSA7eCTGs
=KPi4
-----END PGP SIGNATURE-----

--qM81t570OJUP5TU/--
