Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0EZOi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:38:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0EZOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:38:27 -0400
Date: Wed, 26 May 2010 16:38:25 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] matrix_keypad: add support for clustered irq
Message-ID: <20100526143825.GB2255@pengutronix.de>
Mail-Followup-To: Eric Miao <eric.y.miao@gmail.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
References: <1274882226-19778-1-git-send-email-l.fu@pengutronix.de> <AANLkTimYG1kQBSmp2CPgLoPt-S4mNsJY2QV-cPJgV5lT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <AANLkTimYG1kQBSmp2CPgLoPt-S4mNsJY2QV-cPJgV5lT@mail.gmail.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:33:12 up 30 days,  7:59, 69 users,  load average: 0.19, 0.16,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

thankf for the review.

On Wed, May 26, 2010 at 10:29:53PM +0800, Eric Miao wrote:
> On Wed, May 26, 2010 at 9:57 PM, Luotao Fu <l.fu@pengutronix.de> wrote:
> > This one adds support of a combined irq source for the whole matrix key=
pad.
> > This can be useful all rows and columns of the keypad is e.g. connected=
 to
> > a GPIO expander, which only has one interrupt line for all events on ev=
ery
> > single GPIO.
> >
> > Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> > ---
> > =A0drivers/input/keyboard/matrix_keypad.c | =A0 80 ++++++++++++++++++++=
++++++------
> > =A0include/linux/input/matrix_keypad.h =A0 =A0| =A0 =A05 ++
> > =A02 files changed, 70 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/key=
board/matrix_keypad.c
> > index b443e08..260dcb0 100644
> > --- a/drivers/input/keyboard/matrix_keypad.c
> > +++ b/drivers/input/keyboard/matrix_keypad.c
> > @@ -87,8 +87,12 @@ static void enable_row_irqs(struct matrix_keypad *ke=
ypad)
> > =A0 =A0 =A0 =A0const struct matrix_keypad_platform_data *pdata =3D keyp=
ad->pdata;
> > =A0 =A0 =A0 =A0int i;
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i++)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 enable_irq(gpio_to_irq(pdata->row_gpios[i=
]));
> > + =A0 =A0 =A0 if (pdata->clustered_irq > 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 enable_irq(pdata->clustered_irq);
> > + =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i=
++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enable_irq(gpio_to_irq(pd=
ata->row_gpios[i]));
> > + =A0 =A0 =A0 }
> > =A0}
> >
> > =A0static void disable_row_irqs(struct matrix_keypad *keypad)
> > @@ -96,8 +100,12 @@ static void disable_row_irqs(struct matrix_keypad *=
keypad)
> > =A0 =A0 =A0 =A0const struct matrix_keypad_platform_data *pdata =3D keyp=
ad->pdata;
> > =A0 =A0 =A0 =A0int i;
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i++)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 disable_irq_nosync(gpio_to_irq(pdata->row=
_gpios[i]));
> > + =A0 =A0 =A0 if (pdata->clustered_irq > 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disable_irq_nosync(pdata->clustered_irq);
> > + =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i=
++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 disable_irq_nosync(gpio_t=
o_irq(pdata->row_gpios[i]));
> > + =A0 =A0 =A0 }
> > =A0}
> >
> > =A0/*
> > @@ -226,6 +234,17 @@ static int matrix_keypad_suspend(struct device *de=
v)
> > =A0 =A0 =A0 =A0matrix_keypad_stop(keypad->input_dev);
> >
> > =A0 =A0 =A0 =A0if (device_may_wakeup(&pdev->dev)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdata->clustered_irq > 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int cirq =3D pda=
ta->clustered_irq;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (enable_irq_wake(cirq)=
 =3D=3D 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =
=3D 0; i < pdata->num_row_gpios; i++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 __set_bit(i, keypad->disabled_gpios);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > +
>=20
> This might deserve a separate function, and what is the usage of disabled=
_gpios,
> I seem to find nowhere (except in the resume routine).

indeed, will fix. The disable_gpios flag seems to be used to flag an
asleep/awake row/column. It's introduced by the original code. I think
that for the case with single irq I might better use another flag
instead since we have the situaiton "all or none" here and don't have to
mark every single lines.

>=20
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < pdata->num_row_gpios; =
i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!test_bit(i, keypad-=
>disabled_gpios)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned=
 int gpio =3D pdata->row_gpios[i];
> > @@ -235,7 +254,7 @@ static int matrix_keypad_suspend(struct device *dev)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0}
> > -
> > +out:
> > =A0 =A0 =A0 =A0return 0;
> > =A0}
> >
> > @@ -247,6 +266,17 @@ static int matrix_keypad_resume(struct device *dev)
> > =A0 =A0 =A0 =A0int i;
> >
> > =A0 =A0 =A0 =A0if (device_may_wakeup(&pdev->dev)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdata->clustered_irq > 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int cirq =3D pda=
ta->clustered_irq;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (disable_irq_wake(cirq=
) =3D=3D 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =
=3D 0; i < pdata->num_row_gpios; i++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 clear_bit(i, keypad->disabled_gpios);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > +
>=20
> Better a separate routine.
>=20
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < pdata->num_row_gpios; =
i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (test_and_clear_bit(i=
, keypad->disabled_gpios)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned=
 int gpio =3D pdata->row_gpios[i];
> > @@ -256,6 +286,7 @@ static int matrix_keypad_resume(struct device *dev)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0}
> >
> > +out:
> > =A0 =A0 =A0 =A0matrix_keypad_start(keypad->input_dev);
> >
> > =A0 =A0 =A0 =A0return 0;
> > @@ -296,17 +327,31 @@ static int __devinit init_matrix_gpio(struct plat=
form_device *pdev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gpio_direction_input(pdata->row_gpios[i]=
);
> > =A0 =A0 =A0 =A0}
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i++) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D request_irq(gpio_to_irq(pdata->ro=
w_gpios[i]),
> > + =A0 =A0 =A0 if (pdata->clustered_irq > 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D request_irq(pdata->clustered_irq,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0matrix_k=
eypad_interrupt,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IRQF_DISA=
BLED |
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IRQF_TRIG=
GER_RISING | IRQF_TRIGGER_FALLING,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdata->cl=
ustered_irq_flags,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"matrix-=
keypad", keypad);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_err(&pdev->dev,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Unable t=
o acquire interrupt for GPIO line %i\n",
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdata->ro=
w_gpios[i]);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_free_irqs;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Unable t=
o acquire clustered interrupt\n");
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_free_rows;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 } else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i=
++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D request_irq(gpio_=
to_irq(pdata->row_gpios[i]),
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 matrix_keypad_interrupt,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 IRQF_DISABLED |
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 IRQF_TRIGGER_RISING |
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 IRQF_TRIGGER_FALLING,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 "matrix-keypad", keypad);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&=
pdev->dev,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 "Unable to acquire interrupt "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 "for GPIO line %i\n",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 pdata->row_gpios[i]);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_=
free_irqs;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>=20
> Ditto.
>=20
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0}
> >
> > @@ -418,11 +463,16 @@ static int __devexit matrix_keypad_remove(struct =
platform_device *pdev)
> >
> > =A0 =A0 =A0 =A0device_init_wakeup(&pdev->dev, 0);
> >
> > - =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i++) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_irq(gpio_to_irq(pdata->row_gpios[i])=
, keypad);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 gpio_free(pdata->row_gpios[i]);
> > + =A0 =A0 =A0 if (pdata->clustered_irq > 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_irq(pdata->clustered_irq, keypad);
> > + =A0 =A0 =A0 } else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i=
++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_irq(gpio_to_irq(pdat=
a->row_gpios[i]), keypad);
> > =A0 =A0 =A0 =A0}
> >
> > + =A0 =A0 =A0 for (i =3D 0; i < pdata->num_row_gpios; i++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 gpio_free(pdata->row_gpios[i]);
> > +
> > =A0 =A0 =A0 =A0for (i =3D 0; i < pdata->num_col_gpios; i++)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gpio_free(pdata->col_gpios[i]);
> >
> > diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/=
matrix_keypad.h
> > index c964cd7..8e8dc2e 100644
> > --- a/include/linux/input/matrix_keypad.h
> > +++ b/include/linux/input/matrix_keypad.h
> > @@ -63,6 +63,11 @@ struct matrix_keypad_platform_data {
> > =A0 =A0 =A0 =A0/* key debounce interval in milli-second */
> > =A0 =A0 =A0 =A0unsigned int =A0 =A0debounce_ms;
> >
> > + =A0 =A0 =A0 /* used if interrupts of all row/column GPIOs are bundled=
 to one single
> > + =A0 =A0 =A0 =A0* irq */
> > + =A0 =A0 =A0 unsigned int =A0 =A0clustered_irq;
> > + =A0 =A0 =A0 unsigned int =A0 =A0clustered_irq_flags;
> > +
> > =A0 =A0 =A0 =A0bool =A0 =A0 =A0 =A0 =A0 =A0active_low;
> > =A0 =A0 =A0 =A0bool =A0 =A0 =A0 =A0 =A0 =A0wakeup;
> > =A0 =A0 =A0 =A0bool =A0 =A0 =A0 =A0 =A0 =A0no_autorepeat;
> > --
> > 1.7.0
> >
> >
>=20
> Otherwise looks OK to me.

Thanks

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv9MmEACgkQkLuxfMCkDTZRqQCfdp0e9RfALLwYU5sYoyvaUj1c
4roAn34x+KFmB+8BXodfzrw1kmBS/foG
=L0JG
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
