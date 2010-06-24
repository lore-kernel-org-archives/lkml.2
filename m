Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0FXNRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:17:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0FXNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:17:38 -0400
Date: Thu, 24 Jun 2010 15:17:33 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 4/6] mfd/stmpexxx: change touchscreen irq
Message-ID: <20100624131733.GF3988@pengutronix.de>
Mail-Followup-To: Rabin VINCENT <rabin.vincent@stericsson.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-5-git-send-email-l.fu@pengutronix.de>
 <20100624130942.GG26189@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <20100624130942.GG26189@bnru02.bnr.st.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:13:13 up  6:54, 12 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 24, 2010 at 06:39:43PM +0530, Rabin VINCENT wrote:
> On Thu, Jun 24, 2010 at 13:13:39 +0200, Luotao Fu wrote:
> > the stmpe touchscreen driver uses fifo threshold irq to trigger data fe=
tching.
> > The touch_det irq bit is only used while polling for release. Change the
> > platform resource and the irq definition in the variant block.
> > ---
> >  drivers/mfd/stmpe-devices.c |   12 +++---------
> >  1 files changed, 3 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> > index fa6934d..3e21c26 100644
> > --- a/drivers/mfd/stmpe-devices.c
> > +++ b/drivers/mfd/stmpe-devices.c
> > @@ -59,17 +59,11 @@ static struct mfd_cell stmpe_keypad_cell =3D {
> > =20
> >  static struct resource stmpe_ts_resources[] =3D {
> >  	{
> > -		.name	=3D "TOUCH_DET",
> > +		.name	=3D "FIFO_TH",
> >  		.start	=3D 0,
> >  		.end	=3D 0,
> >  		.flags	=3D IORESOURCE_IRQ,
> > -	},
> > -	{
> > -		.name	=3D "FIFO_TH",
> > -		.start	=3D 1,
> > -		.end	=3D 1,
> > -		.flags	=3D IORESOURCE_IRQ,
> > -	},
> > +	}
> >  };
> > =20
> >  static struct mfd_cell stmpe_ts_cell =3D {
> > @@ -107,7 +101,7 @@ static struct stmpe_variant_block stmpe811_blocks[]=
 =3D {
> >  	},
> >  	{
> >  		.cell	=3D &stmpe_ts_cell,
> > -		.irq	=3D STMPE811_IRQ_TOUCH_DET,
> > +		.irq	=3D STMPE811_IRQ_FIFO_TH,
> >  		.block	=3D STMPE_BLOCK_TOUCHSCREEN,
> >  	},
> >  };
>=20
> Would it be clearer if you leave this as-is, and instead use
> platform_get_irq_byname("FIFO_TH") in the stmpe-ts driver, since I think
> the TSC block has a whole bunch of irqs?

most of them belong to the ADC/FIFO and are actually of less use for the
touch driver as it is now. However, I agree with you on this. This way
the core can leave the driver to pick irqs as it wants and we are more
flexible if we want to change the algrorithmus later. You
can drop this patch than. I'll add the needed change to the ts driver
together with the register settings into V6 of the ts driver.

thanks

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwjWu0ACgkQkLuxfMCkDTb2dACcDCf6hzo7xTMkxZ86ZQRbTbUz
SuoAnR/pBf7pvuV/p0t6cPvKordolfUD
=XU2Y
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
