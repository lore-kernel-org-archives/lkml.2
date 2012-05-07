Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2EGLNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:13:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab2EGLNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:13:32 -0400
Date: Mon, 7 May 2012 12:13:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/4] regulator: tps62360: enable register cache
Message-ID: <20120507111327.GH4415@opensource.wolfsonmicro.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
 <1336376139-1048-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVHblb/y9DPlgkHs"
Content-Disposition: inline
In-Reply-To: <1336376139-1048-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVHblb/y9DPlgkHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 01:05:37PM +0530, Laxman Dewangan wrote:

>  static const struct regmap_config tps62360_regmap_config = {
> -	.reg_bits = 8,
> -	.val_bits = 8,
> +	.reg_bits		= 8,
> +	.val_bits		= 8,
> +	.max_register		= REG_CHIPID,
> +	.num_reg_defaults_raw	= REG_CHIPID + 1,
> +	.cache_type		= REGCACHE_RBTREE,
>  };

Since you're using the rbtree cache which can fill itself gradually it's
better to not set num_reg_defaults_raw, especially not without providing
the defaults.  Doing this may lead to bugs later as the framework thinks
it has the chip defaults when it doesn't really.  If you omit this we'll
just cache gradually as we access the registers.

The ability to read the default values from the chip is intended for use
with caches which must have defaults, and should only be used when doing
a hard reset of the device during startup.

--qVHblb/y9DPlgkHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp65IAAoJEBus8iNuMP3dbDwP/R8eQZ7Ik96jmNNbcsrD8haP
P0k44HvW8TXV169r2GjKfRdkTZLgrnwwt5apgyfRknUH4BV8uy1GaTryi4dWBHGV
uQ7TkguaKapAMfahneCbHgmPRRy4wr7LwPXjumDrTaqEAGyWCMSYvtXGhV40IAfH
l/SFnYW4wSVJemkZVmZwtf5vUzGuNFgfSxKh7rjQmHbW4PQymXBWUqGu9s0GJlRl
+8lULTMn9r4cqabGPg5Di1BveV5qFKjD0ITy8t67kFvsik8ROyliqDrNed21OQNS
DNjhuw2dZMWGKV92hTp7GmwSKkgyGW2JmfhfzdDzXiJQVDYj0foAap4sEm6tRdtu
7l7g1Z4NuAB9qHWVeIOZatPYWIj1Oqy5un3+w4phzDozLjoQiPzPT8iB1ZFpKFX/
ZZeVX7lEkkxdMf9L2rChqvQ0wLIwGyZZOK6VvJKo4iM8A4mriisAKkXr0LY0ButZ
8v3d9VWMpQCGkk5N0vobVjqd3YytdPJT6TTWdJVVN2D6mnFq3YLlLbr/SLN0J2at
1ToKy0U6FkqajpJVeATWn/LVkN7elppY2LA6gX4Co2UCnCrwRiUB3BWcsBg+G71B
3x5Bv5rlvGj0fqwgYHQ+s+mS1F7c3wz86KXbsDQTWwQozb+NiFfDxbL6LFVjWXcq
pwgI4JSY4EL3IYPj1SkS
=vGhM
-----END PGP SIGNATURE-----

--qVHblb/y9DPlgkHs--
