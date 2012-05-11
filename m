Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2EKTIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52344 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215Ab2EKTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:08:50 -0400
Date: Fri, 11 May 2012 20:08:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] gpio: tps65910: move this as platform driver
Message-ID: <20120511190844.GA29835@opensource.wolfsonmicro.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
 <1336569057-3890-5-git-send-email-ldewangan@nvidia.com>
 <20120511174011.3160B3E0791@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20120511174011.3160B3E0791@localhost>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 11:40:11AM -0600, Grant Likely wrote:
> > +static int __init tps65910_gpio_init(void)
> > +{
> > +	return platform_driver_register(&tps65910_gpio_driver);
> > +}
> > +subsys_initcall(tps65910_gpio_init);

> module_platform_driver()

This seems a little premature when we've not got many (any?) drivers
implementing -EPROBE_DEFER.  If we got the change I posted to make
gpio_request() return -EPROBE_DEFER if there was no GPIO registered
that'd get most cases covered though, the drivers would hopefully pass
the error through.

I've not done this for regulators since the cpufreq drivers are still
deviceless so couldn't cope.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrWO2AAoJEBus8iNuMP3doNcQAIWTV8JPExMJJ8ZYtWiAzNFW
MXjvswE39/z3J14FvhdK3fkKHbm6iW6PRFZayZxXSMbld8abSYWWypTOJfaOHPed
h7b9tjKqGlvH00NnNl1cn58Os3GmE3dP40WXVTsRL9ug+jqCOe9UzKdNqiOAw94/
zARH4SkQpLCrYu3LMKZo/NYVWhYQkuVrBnDxr16PrNPwt6tHyd04zlVTg12SUt0I
XkxB6/o+FGOd2LkPq/6W8U0am4S8IkIHr7PprJJ/plT5vXJxAt3KWJafFXF4R6IS
qG1MNzOMnSSRw0Rwg42bWX5jRmJSujtZuIPzeSlJ1HYRN7kVd9Q0HpkI41xJdYa8
O9EuP4e1xY1lXGRJR7ZRyHwmlq5htu2WAm4N8zsajWKvsqJlsGt9JQxFNLeNBd/n
BS5+iNu6UX8K2/GGo/57eHE4nB5th/0q//0sNDSlUQ+cs6m6A2+tJJxEgoZ3ESyN
y6ur62w7tsmvLye7Gm7i7EpGPYGCM/D/4nMo4C8Q8xOF4jkIim6NjBAfUuM9+jo3
5/Kl+eA2rf6BD/HTLu5kPDNkg3Ul/2ZP4vHNQ/FFWW4+ZGZq0p5vFhUq367UOJ+/
laAM4+9/mH20aIeOvjfkUK2aX1zyMabLZNTx57/g4xxd6AdUy0zoF2BMbLbDlnEV
8tWFMtlX5KGjKNpR9emA
=JESA
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
