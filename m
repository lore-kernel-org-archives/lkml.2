Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2DQQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:54:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37251 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab2DQQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:54:54 -0400
Date: Tue, 17 Apr 2012 17:54:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add Wolfson Microelectronics WM8766 codec ALSA driver
Message-ID: <20120417165451.GS6652@opensource.wolfsonmicro.com>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <1334611118-10301-3-git-send-email-linux@rainbow-software.org>
 <20120417145929.GA22575@sirena.org.uk>
 <201204171835.38252.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YvpO9wCO44Ze8QQC"
Content-Disposition: inline
In-Reply-To: <201204171835.38252.linux@rainbow-software.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YvpO9wCO44Ze8QQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 06:35:32PM +0200, Ondrej Zary wrote:
> On Tuesday 17 April 2012 16:59:29 Mark Brown wrote:

> > No, this should be supported in ASoC - anything adding new code in
> > sound/i2c is *deeply* suspicious.

> I agree that sound/i2c is wrong. I worked on tea575x-tuner before which l=
ives=20
> in this directory too - but it's neither an I2C device nor a sound chip...
> There should probably be something like sound/codecs instead that could b=
e=20
> used by any sound card drivers.

That's what sound/soc/codecs is - anything with sufficiently split up
hardware to have distinct CODECs ought to be within that framework.
"soc" in this case to a large extent just means "mix and match CODEC and
CPU interface".

> > > +struct snd_wm8766_ops {
> > > +	void (*write)(struct snd_wm8766 *wm, u16 addr, u16 data);
> > > +};

> > You should in general use regmap rather than open coding register I/O
> > for I2C devices.

> regmap seems like an overkill here. It requires the i2c bus to be registe=
red=20
> in the kernel i2c subsystem (which is not in the case of ice1712).

Oh, that's fail.  I did notice that patch 4 looked to be open coding
rather generic stuff - I guess this is why.

> > I've not yet looked at the rest of the code but this looks awfully like
> > you've just invented a minimal version of the ASoC interfaces...

> The _set functions are just simple register writes - the caller needs to =
know=20
> what to write there (only _set_if is used by psc724).

You can obviously do stuff as hard coded register write sequences, many
of which will be very short.

--YvpO9wCO44Ze8QQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjaBRAAoJEBus8iNuMP3dE7gP+wWqaepuJQV10rrTXQQAySKG
cPoYCFFkKk5CuD75/2PRwOsgSDG++XhW3pMdCnAQXIlZuRgJM4pSauhIFBFZScYR
5pWXvu5/2Cki02RsG3p9JonV4IxSu4bEIvTg1t8gpiD7Ixahge+RKAsABlDZ0lBK
x7HgDtU/GPm4PKJE8trJxTdQKzxGc1KRay9di7fovu+VPjfptHDf0t/52nQZw7rB
vOrZgHsUldkiCgbUWwX8fhBIprg6gG4q6cwL6+sr0VLb9sIpipaMNueLdcvoSUM9
awOT8g5+s0SUYXANV9zFjvGXCoy+t+Q/OGYdP/viCLNYkuZvi8aStQ25qi25rMrD
MhtH2VCy8+QsnhMjLu9hTNy3yVFNAflcEkfDzsQEwg8/PI4n8xabugH/wTkPJPqH
x3xYpJ52Yr63bZ15BAycGNS8UbXys1N9dYkUTuDfS8+kMp3AFP3rHsvUJF4jWDQe
pEMy7R3LYIIzhjR4/TB/FYolIr+LkCXOoU3N5B4TpFeQOK9lx7OG6IPBL3M8geIK
KLKp4XoJMkski9m6wwZSyKhUufD2Czbn9ojnQY4gxyDrG+UV+3fsQ6h5+3J8g6Lw
94yc6SlM7SrS+tA+r0pN4gl1c9BUu4igvVxGMj52S5R1X8dV5+EwJNk0NaGsoFHq
Z96wvSwc3+cEFATON/ox
=Nq70
-----END PGP SIGNATURE-----

--YvpO9wCO44Ze8QQC--
