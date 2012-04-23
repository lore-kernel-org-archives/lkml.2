Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2DWLJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:09:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57493 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab2DWLJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:09:20 -0400
Date: Mon, 23 Apr 2012 12:09:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] leds: lm3530: fix handling of already enabled regulators
Message-ID: <20120423110912.GC8318@opensource.wolfsonmicro.com>
References: <1335107508.6261.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <1335107508.6261.3.camel@phoenix>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 22, 2012 at 11:11:48PM +0800, Axel Lin wrote:

>  		drvdata->regulator =3D NULL;
>  		goto err_regulator_get;
>  	}
> +	drvdata->enable =3D regulator_is_enabled(drvdata->regulator);
> =20

This isn't sufficient for what the driver is doing - it also needs to
enable the regulator.  Regulator enables are reference counted (since
the regulator can be shared by many device supplies) so if this driver
doesn't reference the regulator when it's needed then it could get
powered off.

If this regulator is the actual LED then the current default of assuming
the regulator is off on boot isn't ideal either as it means that if the
regulator is enabled on boot then the LED may be left on even though the
driver thinks it's off.

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlThSAAoJEBus8iNuMP3dkKcP/1MLihvyLBwYw944NwuK1q5S
p/VioYkkjrvAJZrvP/J5/X0DEXEWj8V8GFnFO+58DkgLDl8HbSRqkNn39M+PconA
t1h9BV8NPPNpG/hWXOR8GYCmJew8iaosSfpz5t9YySxACox+P0sgqTLtw2rwlrw6
cw5X1LTcGZIYLr+cP8esru5U33q4WvAJAF+CU5PlcYwrsZml0nn+QDu52MhyTbCH
RvKIzwuCzeSHwwx/EBf25Ycala10fQr9+B1SxAHJmZICItgu6NtINZ+zSBSp7gNm
TpW+6uE/uu0Uvr88RnbWX+rsPGQU6CkyZXyYw1rgrfe6MhzLeDt/pUwO2JxiVPgo
YmQivoxmIUFJrTGlcB1ljs+o9llv9OjBN6XNgSEPiljbJAAwjobKs6CgFFD9N4Fn
oKobzrGXhDJaBueXzQnJsPo5WVhqNle/wmgQFz+h7YLOTWNp9XSUiaGQ3Qah9sKo
ei4UDIVTYUIQBaKv1SyENRNBTTckgDYXN7lLio0Dh8Nn0q7tLTF0t1sCIzN+MIva
Zw0dgDpegc0LjiwzBbeDnUkMX0QO02EvVbFSLjNcVGO5dY4tx2eyW2yvO3Ue8D5/
RsRC4nfUkSXuXGiT9SLB6TUUogQ30+apolg0uQpJmh5uwYVh8RhiOQ028eTdZ9td
716hnIXE3Tndbw28EC85
=6kUH
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
