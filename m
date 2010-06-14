Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab0FNMEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:04:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0FNMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:04:22 -0400
Date: Mon, 14 Jun 2010 14:04:10 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V2] mfd: add STMPE811 core support
Message-ID: <20100614120410.GA12027@pengutronix.de>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276511558-27121-2-git-send-email-l.fu@pengutronix.de> <20100614115032.GA14604@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20100614115032.GA14604@rakim.wolfsonmicro.main>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:02:27 up 7 days,  4:30, 53 users,  load average: 0.55, 0.37,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

thanks for the review.

On Mon, Jun 14, 2010 at 12:50:32PM +0100, Mark Brown wrote:
> On Mon, Jun 14, 2010 at 12:32:36PM +0200, Luotao Fu wrote:
>=20
> > +static void stmpe811_mask_work(struct work_struct *work)
> > +{
> > +	struct stmpe811 *stm =3D container_of(work, struct stmpe811, mask_wor=
k);
> > +
> > +	stmpe811_reg_write(stm, STMPE811_REG_INT_EN, stm->int_en_mask);
> > +
> > +	mutex_unlock(&stm->irq_mask_lock);
> > +}
>=20
> Why are you doing this in a workqueue?  You shouldn't need to do this -
> you should implement the bus_lock() and bus_unlock() callbacks instead.

Right, will replace the stuff with bus_lock/unlock

>=20
> > +	ret =3D request_threaded_irq(client->irq, NULL, stmpe811_irq,
> > +				   pdata->irq_flags, "stmpe811", stm);
> > +	if (ret) {
> > +		dev_err(&client->dev, "failed to request IRQ: %d\n", ret);
> > +		goto err_free;
> > +	}
>=20
> I suspect you should be unconditionally putting IRQF_ONESHOT here since
> the threaded IRQ requires it.

oh, oversaw this one, will fix.

Thanks

regards
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwWGroACgkQkLuxfMCkDTbz3QCdGZktlVcmOj7OYeYCzZo+xULK
rC4An0OhFk3t2VryWu01+8H0beSlsSRO
=+u+O
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
