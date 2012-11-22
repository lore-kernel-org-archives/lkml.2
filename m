Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2KVThG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:37:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993Ab2KVTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:32:26 -0500
Date: Thu, 22 Nov 2012 10:18:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add an AS3711 PMIC MFD driver
Message-ID: <20121122011835.GD4371@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 07:21:02PM +0100, Guennadi Liakhovetski wrote:

> +	regmap_read(as3711->regmap, AS3711_ASIC_ID_1, &id1);
> +	regmap_read(as3711->regmap, AS3711_ASIC_ID_2, &id2);
> +	dev_info(as3711->dev, "AS3711 detected: %x:%x\n", id1, id2);
> +	if (id1 != 0x8b)
> +		return -ENODEV;

This looks odd - you're printing the "AS3711 detected" message prior to
checking the device ID which will be a bit confusing if there's a
problem.  Should probably do this after the ID check (and ideally also
check the return value of regmap_read(), it's especially important
during device identification where someone might've typoed the address).

Otherwise this looks good.

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrX1dAAoJELSic+t+oim9268P/2zkPRJh/OBdom9tIQmYAVTr
JTnDjK7GDfpJn3cSRGx5mW+uAhvpF/QhVaGnIfygH/67ST94uDfmH+tugTYG7C8q
q5pS9TQkRrnaRjAa4y4g4EGnMxGTEfyYUDBUZVb7ka0KqZacdqYxuL1NcbqTA5oG
CbAqsTSwJsGCfpi2o82ExbfsrJlXATdGpOXEgHmiZV3i2bYTfMokTW6HZzbqyHU5
zzY3OSKZKaNR/JgeoQVQO7hlYs59eTBlJuHcyhSgc9PvlPQiHBRpd4xjaUOvJI7U
mnKH4aw0NuCZUYcxbyLf3jkmilBg7Vg3HoRDN849E3eV3uFNw9lXZpKDBNdG4m61
MuItU+Aa/xfaEun/M7ltCu8ri4A5PgmjHyV8taRoFYppmu5C/5TKUvDDJ/yWwd/T
5kjJcTn7vZBLBJNu7BQBuBOF0HQIkIso/3xHbj79SgVChzCZ0yH/KIaBmBuOvUJr
DNoy5yEubSroyUkRk55n683WArz1DKgGiQW/u45pNiy9cB5v5LSxnAIGDs1P6RYi
PG0dwxc7mK0kRNc6kBcnMpBKFPYv1NrNDnKgT3+uR47n+4IGOxeq2miBckg/lBQY
D4rwgve8+CFb4MYgjeW9Wch/UpiELPx7wy+iSVQ18spe+Av+kHjsuwL2DYTXPcq5
ZcVzXBXZzOeZQ5HB05uI
=qs9B
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
