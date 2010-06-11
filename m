Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab0FKLiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:38:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37942 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0FKLiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:38:15 -0400
Date: Fri, 11 Jun 2010 13:38:11 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: add STMPE811 core support
Message-ID: <20100611113811.GB4078@pengutronix.de>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
 <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
 <20100611111326.GD12436@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20100611111326.GD12436@sirena.org.uk>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:33:46 up  5:30, 12 users,  load average: 0.04, 0.01, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 11, 2010 at 12:13:26PM +0100, Mark Brown wrote:
> On Fri, Jun 11, 2010 at 12:13:13PM +0200, Luotao Fu wrote:
>=20
> > +	for_each_set_bit(bit, (unsigned long *)&int_stat, STMPE811_NUM_IRQ) {
> > +		handler =3D stm->irqhandler[bit];
> > +		data =3D stm->irqdata[bit];
> > +		if (handler) {
>=20
> You should be using genirq here - just call handle_nested_irq() if the
> IRQ is asserted and let genirq manage the handler for you.
>=20

ah OK, I did think about using nested irq, was however too lazy to find
out how it works. ;-). Will fix in V2.

> > +static irqreturn_t stmpe811_irq(int irq, void *data)
> > +{
> > +	struct stmpe811 *stm =3D data;
> > +
> > +	get_device(stm->dev);
> > +	disable_irq_nosync(stm->irq);
> > +	queue_work(stm->work_queue, &stm->irq_work);
> > +
> > +	return IRQ_HANDLED;
> > +}
>=20
> You should use request_threaded_irq() for the main IRQ - it will take
> care of all this for you.
>=20
>=20
> > +static struct i2c_device_id stmpe811_id_table[] =3D {
> > +	{"stmpe811", 0x88},
>=20
> Any reason for the 0x88 - you don't seem to use it anywhere?
>=20

doh, this is bogus. will fix in the next round.

> > +int stmpe811_register_irq(struct stmpe811 *stm, int irq,
> > +			  irq_handler_t handler, void *data);
> > +int stmpe811_free_irq(struct stmpe811 *stm, int irq);
>=20
> If you use genirq these can be dropped - this will also mean that
> existing generic drivers using the standard GPIO and IRQ frameworks will
> be able to use the chip without modification.

all right.

Thanks

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwSICMACgkQkLuxfMCkDTZgYQCfcTsEQPfDWkPYtDVLv1bn/l/n
M+YAnjxe7vSkgDh1yYU7rS84UGYMBMLC
=DNAQ
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
