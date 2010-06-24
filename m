Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0FXMqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:46:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42976 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab0FXMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:46:19 -0400
Date: Thu, 24 Jun 2010 14:46:16 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/6 V2] mfd/stmpexxx: fix stmpe811 enable hook
Message-ID: <20100624124616.GD3988@pengutronix.de>
Mail-Followup-To: Rabin VINCENT <rabin.vincent@stericsson.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
References: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
 <1277382466-23603-1-git-send-email-l.fu@pengutronix.de>
 <20100624123542.GC26189@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <20100624123542.GC26189@bnru02.bnr.st.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:42:33 up  6:24, 12 users,  load average: 0.01, 0.02, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 24, 2010 at 06:05:42PM +0530, Rabin VINCENT wrote:
> On Thu, Jun 24, 2010 at 14:27:46 +0200, Luotao Fu wrote:
> > diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> > index 3e21c26..ded9dcb 100644
> > --- a/drivers/mfd/stmpe-devices.c
> > +++ b/drivers/mfd/stmpe-devices.c
> > @@ -117,8 +117,8 @@ static int stmpe811_enable(struct stmpe *stmpe, uns=
igned int blocks,
> >  	if (blocks & STMPE_BLOCK_ADC)
> >  		mask |=3D STMPE811_SYS_CTRL2_ADC_OFF;
> > =20
> > -	if (blocks & STMPE_BLOCK_KEYPAD)
> > -		mask |=3D STMPE811_SYS_CTRL2_TSC_OFF;
> > +	if (blocks & STMPE_BLOCK_TOUCHSCREEN)
> > +		mask |=3D STMPE811_SYS_CTRL2_ADC_OFF;
> > =20
>=20
> You shouldn't be changing TSC_OFF to ADC_OFF, since you're making this
> for the touchscreen.
>=20

doh! I need more coffee. This is truly embarassing. :-) Proper fix in
following.

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwjU5gACgkQkLuxfMCkDTYUWQCaA9nM779/kDgde+gatHBMZr4o
N6YAniZ0ci/UEhSBhjQYCJM1kUQaiSbF
=Lugm
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
