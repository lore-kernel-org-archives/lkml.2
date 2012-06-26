Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2FZJI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:08:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab2FZJI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:08:28 -0400
Date: Tue, 26 Jun 2012 10:08:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: arizona-micsupp: Fix choosing selector in
 arizona_micsupp_map_voltage
Message-ID: <20120626090825.GI30406@opensource.wolfsonmicro.com>
References: <1340697707.12992.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZY5CS28jBCfb727c"
Content-Disposition: inline
In-Reply-To: <1340697707.12992.1.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZY5CS28jBCfb727c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2012 at 04:01:47PM +0800, Axel Lin wrote:

> +	if (min_uV > 3300000)
> +		return -EINVAL;
> +

This is OK but I think we want to factor this out into the caller as
we're implementing this limits check in a lot of places.

> -	if (min_uV >= 3300000)
> +	if (min_uV > 3200000)
>  		selector = ARIZONA_MICSUPP_MAX_SELECTOR;
>  	else
>  		selector = DIV_ROUND_UP(min_uV - 1700000, 50000);

This doesn't change anything; with version of the if statement will give
3.3V for a voltage between 3.2V and 3.3V as there's no gaps in the
selector space so if we're over 3.2V we'll round up to 3.3V.

--ZY5CS28jBCfb727c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6Xv/AAoJEBus8iNuMP3dZMgP/RITumKP6rgMuLLxGwsiKkKF
YvtRjL9zuUnYK5hkfjuh/Gmkz2rVLO6zF/Gh4eyxqqXNllWyrEhvjMCB7BreFjm9
5gdr6QWpvputJNOGoqHrS+TuuPomPB+s9nmj0zsGL112rI8+FtfbLye4R+vxyaBw
CARQGj7OgD1YQl0wxTYjCnJ2+966xVL6OkTU3A9g33g29pWUVSA7bSY1eWFIHcx5
fZ2ElF7UEoup96mGS8RSwFBXIrnZJRSDkTHGGL78fjBZgMPqYur0qpUNOgaZNT9J
6DJOwGsylQGkPsFL2hJ4eG26Li/YcELyHG/OZ823rqTlwtxwn5Oz4HQEyazTgYbp
7q/jehlKTpt6EGtLDPvp8JBuDFPpXbNMraaQFkPpqmORlpccymh3dViJw0K4APoH
erNyt8CqYZg0FPijVDcdBy4tNH+srJXkq5YtJVdbozz89/4EDodOs085WmnDKn2F
TjqSwADy/1/R4CEN+pkYiIpUouW4zR3O/QrELR0TjKev/ObfT1Es233S6Fp4DuMl
+CdepyvaWDPQCfgJOVaWfhS+YxD3JPOdHJQOJ/qxA2uoQxHfNSRAITryaG0zJLLk
lUfHr4jTo05lyvtDofEPkkTMMqGmc2Mv2RyStEbiL6FSIMsdzzKVCt3CiFIMgmuQ
/Y5FqlPbVh7hTJ7m4A2A
=aCc5
-----END PGP SIGNATURE-----

--ZY5CS28jBCfb727c--
