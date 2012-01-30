Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2A3NVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:21:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34746 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab2A3NVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:21:37 -0500
Date: Mon, 30 Jan 2012 13:21:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120130132134.GB4882@opensource.wolfsonmicro.com>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
 <20120127162837.GB18572@opensource.wolfsonmicro.com>
 <20120128011403.GA6669@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20120128011403.GA6669@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2012 at 02:14:03AM +0100, Wolfram Sang wrote:

> I wondered if you'd save reg_bits and val_bits there (converting to *_bytes
> when needed), you could replace all the format_x_y-functions with a few generic
> functions doing (reg << y) | val. Unsure if it is worth it...

Clearly we *can* but there's other bits (chiefly the cache code once we
acquire the ability to do block operations from cache) which really want
stuff to be 8 bit aligned.  I deliberately chose to make things byte
aligned so we have to think about this stuff before we do things that
make byte aligned stuff hard, it felt like if we were going to take a
complexity hit we probably want it to be on the odd register formats as
pretty much all of the more demanding modern devices seem to be going
for multiples of 8 bits.

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJpjHAAoJEBus8iNuMP3djwQP/i0IM21+bujNLinqA/of3T9l
pNcTb7YjfCvjv+5RGzw2NXuffRp9i1cFZemTC1y+am+eVPvt+k1y4C8YbQXrqFli
1K38LOjOxTXI5y6oNtg2/Te3sq4OY5OCgRayLZ/wW7I/CcYsf3U/I3BApowLzOJl
mvrDlPSRXYypPfnE53u41S3W+fOdgf5AxHTjP48Bi2ssD1aLbGgSF+IeDpAaDjEM
2IarJnTNVap2FlcLSLT7QeIp8opYoSu/C24y3BbVLwjph8hIaECaEHsQZs+UwPu4
hCx5H3JI8WtgoBCB5ACeBDZY2DAJJJiOGXTajW59JG1qgwiYD2QDctot+gptnSQJ
C22WzOCh5PMZqbyU5uOvD8m4cw23B8M0xrtlK6e6KBHx98F1y82899L7JogX82AE
8QmmYw6hZqBGQ2z4mWNJIkSUvpaXHJ1St9vvC4gpf+SapSRoz0npuE0fJezfd4xI
Hhn6wlNP2EMWoGCEsLNfM5m2zYJQNcTblOEHRR3pz0iH3b8JCBzauWa8yJEhpr5U
Do8pS3SHoL0IPFGtOVswYAmIprN0KmEsKeLzoxFInJWi2iYqg9mpqI9vOyzJK8RG
QFHdXDnL2I3JMrH6zknCu+OfZwMBvVgH7Youz4en3sZLN1US0kX5mTgrdRhYhgaD
K+0SX4Aq1a3CKpR7Ld92
=SDPn
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
