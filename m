Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0FXNLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:11:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60308 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0FXNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:11:44 -0400
Date: Thu, 24 Jun 2010 15:11:41 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 6/6 V4] input: STMPE touch controller support
Message-ID: <20100624131141.GE3988@pengutronix.de>
Mail-Followup-To: Rabin VINCENT <rabin.vincent@stericsson.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
 <20100624123153.GB26189@bnru02.bnr.st.com>
 <20100624124210.GC3988@pengutronix.de>
 <20100624130108.GE26189@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <20100624130108.GE26189@bnru02.bnr.st.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:06:19 up  6:47, 12 users,  load average: 0.00, 0.02, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 24, 2010 at 06:31:09PM +0530, Rabin VINCENT wrote:
> On Thu, Jun 24, 2010 at 14:42:10 +0200, Luotao Fu wrote:
> > On Thu, Jun 24, 2010 at 06:01:53PM +0530, Rabin VINCENT wrote:
> > > On Thu, Jun 24, 2010 at 13:13:41 +0200, Luotao Fu wrote:
> > > > +       ret =3D stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
> > > > +                       FRACTION_Z(ts->fraction_z),
> > > > +                       FRACTION_Z(ts->fraction_z));
> > >=20
> > > I think your earlier revisions had this same behaviour, but this only
> > > writes the bits you are trying to set, and it may be a problem if the=
re
> > > are other bits already set in this field.  I don't know if this is a
> > > concern with this block, but if it is, you can do something like the
> > > following to clear out the field before writing:
> > >=20
> >=20
> > This is done intentionally to leave the bits alone which I don't want.
> > Most of the registers here are used exclusively for the touchscreen.
> > Some others are shared with the ADC. The ADC however doesn't have any
> > own configuration and has to go with the configuration of the touch
> > screen. Hence it's OK, even probably better not to touch the bits we
> > don't need.
>=20
> I meant something like: let's say you want to change the "count of the
> fractional part" (I quote from your platdata).  It (the FRACTION_Z
> field, I assume) has a default value of (say) 2.  Say you want to change
> the count to 1.  The above write will change it to 3 instead.  If this
> is really the behaviour you need, it should be OK then.

hmm, good catch. I didn't think about this. Actually nobody else should
touch these registers and they are only written while doing probe,
directly after the chip get resetted. However, it is still theoretically
troublesome, if one of them get written previously by accident. I'll
fix it. Thanks for the catch.

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwjWY0ACgkQkLuxfMCkDTbXfwCfWcUn92yi76J8y/rg1PLtnggf
lgwAn0VIRL1Bbmg/+HAiMS/+XmRQP8XX
=V1Gr
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
