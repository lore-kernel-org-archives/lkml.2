Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0HJNlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:41:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52790 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab0HJNk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:40:56 -0400
Date: Tue, 10 Aug 2010 15:40:55 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: rtc-linux@googlegroups.com,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Wells <wellsk40@gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
 for the LPC32XX SoC
Message-ID: <20100810134055.GC4268@pengutronix.de>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
 <1281370650-29520-2-git-send-email-wellsk40@gmail.com>
 <20100810102507.GB4268@pengutronix.de>
 <20100810120055.GD11268@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20100810120055.GD11268@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2010 at 02:00:55PM +0200, Uwe Kleine-K=F6nig wrote:
> Hi Wolfram,
>=20
> > > +	retval =3D request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> > > +		IRQF_DISABLED, "rtcalarm", rtc);
> > > +	if (retval < 0) {
> > > +		dev_err(&pdev->dev, "Can't request interrupt\n");
> > > +		goto err_free_irq;
> > > +	}
> >=20
> > I saw that a number of rtc-drivers register their irq after they
> > register the device. I wonder if this is OK here? Couldn't it happen
> > that after rtc_device_register() there is a preemption and another
> > process could set the alarm? Then there is a race between interrupts
> > already enabled and no handler available, no?
> If you do it the other way around the irq might trigger and the handler
> reports an irq for a device that doesn't exist yet.

Well, I was assuming that you initially have all interrupts disabled...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxhVucACgkQD27XaX1/VRtA+wCdFo5kt1wYy+mo2V8gtjqjplJP
uSoAoJt5wUWWXsxyLDfLSv0x7lSaOCB3
=JhqS
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
