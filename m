Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab0DVENn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:13:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0DVENm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:13:42 -0400
Date: Thu, 22 Apr 2010 06:13:38 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Gustavo Silva <silvagustavosilva@gmail.com>, gregkh@suse.de,
       abbotti@mev.co.uk, devel@driverdev.osuosl.org,
       fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       silvagustavo@users.sourceforge.net
Subject: Re: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in
	dt2801.c
Message-ID: <20100422041338.GE24384@pengutronix.de>
References: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net> <1271908811.1730.613.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <1271908811.1730.613.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2010 at 09:00:11PM -0700, Joe Perches wrote:

> > @@ -374,8 +362,8 @@ static int dt2801_writecmd(struct comedi_device *de=
v, int command)
> > =20
> >  	stat =3D inb_p(dev->iobase + DT2801_STATUS);
> >  	if (stat & DT_S_COMPOSITE_ERROR) {
> > -		printk
> > -		    ("dt2801: composite-error in dt2801_writecmd(), ignoring\n");
> > +		printk(KERN_INFO "dt2801: composite-error in dt2801_writecmd()"
> > +								", ignoring\n");
>=20
> It's good to preface with KERN_, but better might be to use
> 	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> and strip the "dt2801: " intro and use
> 	pr_<level>("%s(): composite-error, ignoring\n", __func__)
>=20
> It's a bit shorter, always gets the appropriate prefix, and
> would emit the proper function name if ever refactored.

What about dev_* in case there are more than one of those devices?
Also, KERN_INFO doesn't look right, KERN_WARN?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvPzPIACgkQD27XaX1/VRsE6QCgtItaJeEb6ct/PgTMIbmHmod/
g1sAoJIjo6ZcKD3/UG06JN6AZAFjRz/5
=RRnX
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
