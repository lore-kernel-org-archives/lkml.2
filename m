Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420Ab0COOAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:00:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57225 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936360Ab0COOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:00:04 -0400
Date: Mon, 15 Mar 2010 14:59:45 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Luotao Fu <l.fu@pengutronix.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@debian.org>,
       Alessandro Rubini <rubini@unipv.it>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Wells <wellsk40@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amba-clcd: add RGB444 support
Message-ID: <20100315135945.GA4584@pengutronix.de>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Luotao Fu <l.fu@pengutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andres Salomon <dilinger@debian.org>,
	Alessandro Rubini <rubini@unipv.it>,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Kevin Wells <wellsk40@gmail.com>, linux-kernel@vger.kernel.org
References: <1268659809-3609-1-git-send-email-l.fu@pengutronix.de>
 <20100315133810.GE700@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20100315133810.GE700@n2100.arm.linux.org.uk>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137 Hildesheim,
 Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-5555 Inhaber:
 Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:46:00 up  6:27,  2 users,  load average: 0.00, 0.03, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Mon, Mar 15, 2010 at 01:38:10PM +0000, Russell King - ARM Linux wrote:
> On Mon, Mar 15, 2010 at 02:30:09PM +0100, Luotao Fu wrote:
> > This one adds RGB444 (bpp=3D12) support to amba clcd drivers. Tested on=
 a lpc3250
> > based platform.
>=20
> No - this is wrong.  You have a 16bpp display.  bpp is the number of bits
> in the framebuffer between two successive pixels.  It is not the number of
> bits used for the pixel information.
>=20

> The only case where you have a 12bpp display is if you have two pixels
> packed into three bytes.
>
For 12bpp actually 16bits/pixel is used. I'm aware of that. That's the
reason why the fb.var.bits_per_pixel is set to 16 in clcdfb_decode if
it is originally set to 12 from the platform file to make usage of 16bpp
display. omapfb driver does quite the same.

On my framebuffer controller (here on a lpc3250) there is hardware RGB444
support. Switching to this mode will spare some pins. What I intend to
do with this patch is to make use of this feature. Similar RGB444
Support can be found in omapfb.

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuePVEACgkQkLuxfMCkDTYxAgCfU/uIrzq1Cap4QD9jqONGTeNN
dMMAn1cn8ahp2prpftIhfU/SGFXCv/DN
=kHC2
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
