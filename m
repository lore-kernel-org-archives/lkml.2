Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2ETMGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:06:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38982 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab2ETMGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:06:30 -0400
Date: Sun, 20 May 2012 13:06:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120520120626.GD20652@opensource.wolfsonmicro.com>
References: <20120519174052.GX4039@opensource.wolfsonmicro.com>
 <4FB7DEB0.3040001@nvidia.com>
 <20120519182658.GB4039@opensource.wolfsonmicro.com>
 <4FB7EE84.7090704@nvidia.com>
 <20120519205055.GA16590@opensource.wolfsonmicro.com>
 <4FB80CEE.4050201@nvidia.com>
 <20120519231347.GD16590@opensource.wolfsonmicro.com>
 <4FB89E6D.7000206@nvidia.com>
 <20120520090112.GE16590@opensource.wolfsonmicro.com>
 <4FB8C9EF.7010400@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <4FB8C9EF.7010400@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 04:09:43PM +0530, Laxman Dewangan wrote:
> On Sunday 20 May 2012 02:31 PM, Mark Brown wrote:

> >No.  This is happening because the device tree doesn't have any supplies
> >mapped for the regulators.  This is nothing at all to do with where the
> >code looks for the supplies, no matter where it looks there's nothing to
> >find.

> No, we should not put the regulator mapping under parent, need to
> have under "regulator" otherwise we need to fix the issue in dt
> parsing where first it looks for "regulator" and then parse the rail
> mapping.

What is this issue and why should we not fix it?

> Now when compare to driver mc13892-regulator.c, the
> tps65910-regulator is almost same like this.
> The driver mc13892-regulator.c have following code in probe:

...

> I want to have similar fix in my tps65910-regulator.c.

So why can't you do what mc13892 is doing?

> I am sorry that I am not able to explain the issue correctly. I think
> I will take help from Stephen Warren here to first explain him  and
> then I will come back for core changes.

OK, I guess.  I think a key thing here is that these shouldn't be any
different to any other supply.  Adding something that is specific to
regulator-regulator supplies doesn't do that so is a clear sign that
something has been missed.

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuN4oAAoJEBus8iNuMP3diXAP/A8ZD7bhMzAqsp5Wu9z888ZD
GpefO9yw3NYprZ76OlHVOfPYSsfkCcpZj1qDYQ/buiYZ7uRuzKYZlukoT9zcR64u
QNsvGiit4bVkowy+ZstE0w7UtEDI9AiuoPsfXy0qlbLZkR+vpdYBTemW1phDtbdu
8IEiIE7QQcLYVcQ6P5XCFTxCZ8nIv3c2/2PlIPcBmrL2MTLQGbWBswG4RjpTPxhN
Mw5b332EG4YrIlJuZa4oSTVYzvuiK3nFVQ11gnSaXLR0ckkFuDav09c3/RmiKR+v
SU5WaPB4pSL3WKsunp7nszPLkPwdEdJT52oXUjJwHfUpvbe8I16nGqdJIuXNXwpi
QWbAMc7Jkh7wW1lvqybJR1kbzjf4n20Q2kd8/BuYjzM9TIqcKWQjONiuJdWTnP5g
dhchAsUeIZ2O/AbeJX53ROqyqvWUWhYqLFmM6CIXRlOyYDECcfblo5tcX5eFQbNv
6y+Mq9Tshev5Db1cnxxJCUOZ8b30fztSvvDQJ1lbNMRkuBqhrgrZ77RsE2HrePFE
lpJCcl5x3RHHrQ8MBNq5qBGcrLc4UkVfFZNKD8DKiks6cGo+WU4Etmtad3LJ5ZuY
fWjOJZtFKbaGdIIHz1SKOaUDV2zn6lgoaHj35sOrTGCddK35xeb/fxiTBmEvr5qq
TDDO2jSntopEn9BxTH33
=+V52
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
