Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab2GBLf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:35:59 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:53222 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab2GBLf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:35:57 -0400
Date: Mon, 2 Jul 2012 14:33:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de
Subject: Re: [PATCH v2 05/17] i2c: omap: split out [XR]DR and [XR]RDY
Message-ID: <20120702113314.GA2730@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339691067-919-1-git-send-email-balbi@ti.com>
 <1339691067-919-6-git-send-email-balbi@ti.com>
 <4FE991DA.5070301@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <4FE991DA.5070301@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 04:11:30PM +0530, Shubhrajyoti wrote:
> Hi Felipe,
> On Thursday 14 June 2012 09:54 PM, Felipe Balbi wrote:
> >  			return IRQ_HANDLED;
> >  		}
> > =20
> > -		if (stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR)) {
> > +		if (stat & OMAP_I2C_STAT_RDR) {
> >  			u8 num_bytes =3D 1;
> > =20
> > +			if (dev->fifo_size)
> > +				num_bytes =3D dev->fifo_size;
> In case of a draining interrupt. The byte count may not be the fifo size.
> Do you agree?

hmm... indeed, that should be dev->buf_len... can you fix that up or
want me to resend ?

--=20
balbi

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8Yb6AAoJEIaOsuA1yqREgQ8P/2uYGAV//NbxcQQbWazMAa82
npbVy5wChQu/jZyxgn9ExN0Br+tg+anMN7bWLX8ScjqLdOZVJArjEFN258I7xaPV
Pg19Vm0Bd4xvEQOfAY2k1557WzJcSIfefpcvo/WCv2VTdbKqd6sUdAZDfc1dzmN5
Hi29hdglFHbUQqGYaLqBla7nANdzjaUviwFj6i8tXHXAx7l/nvbCxBxYCjfvWY++
n586CVZmB5mmgl1tHXyu7cVSZad43BfoK2Jmann2WcIQjf2ac/TUp6/4WB3zHnIs
ZA0XtHzcMiXx+W/X+xiXFiieax1YDFY7XlruWeLjEP19pzdekyFxMmgAVzDn8PcC
CQ65+n0C3kSDSSbFco6uO9sDFYotWOWAvTPZ6YdaD2vS73PVLAB0IDnKdl218D21
JJer7c+kSnGD020MmzWTs9aR8spOtvYyxuvO5rsNmps2zl8AJ/z99ofKBB2LWgOz
OrECMZd2QzXaPbNBimqYQ8zloAvjZ2yGXZd9IE4ymTGhrGlPXPBdqxY2k3RCL+dt
rAsw+XBdE1W2r8rC71w0x+vQ7gpCiaXVtSe3rQuBixZijvBcIMs8xEG/TipsRlX5
jQP1f36zfrJo6FxyCEyHCQ7mott4t90/6qQrOHZcc3caQj3B78SechUbYfz0OK2/
WdZ7YAHDEJlkC5EBD1oY
=heGU
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
