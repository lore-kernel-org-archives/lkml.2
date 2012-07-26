Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2GZLmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:42:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57214 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2GZLmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:42:18 -0400
Date: Thu, 26 Jul 2012 12:42:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
Message-ID: <20120726114215.GB3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
 <20120726113204.GY3099@opensource.wolfsonmicro.com>
 <50112C29.6020606@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBii9oQw/U9UOygZ"
Content-Disposition: inline
In-Reply-To: <50112C29.6020606@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBii9oQw/U9UOygZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 12:38:17PM +0100, Lee Jones wrote:
> On 26/07/12 12:32, Mark Brown wrote:

> >Again, this makes no sense.  If we're explicitly being asked to use
> >regmap then we should be using regmap or just failing to set up I/O
> >(which is obviously a catastrophic failure).

> How much work is there involved in regmap:ing a device, so that
> dev_get_regmap() doesn't fail?

Trivial if it's on a supported bus, otherwise you just need to write the
bus.  But why do you care if dev_get_regmap() fails?  We only try to use
regmap if the driver asked for regmap I/O (or doesn't have registers at
all in which case it doesn't matter since we never do any I/O).  What
you appear to be saying here is that you're using regmap on a device
which doesn't have a regmap set up which is clearly never going to work
terribly well...

--gBii9oQw/U9UOygZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQES0RAAoJEBus8iNuMP3dSg4QAJ2ocPDpFHYd6AY/mvZkS8Sx
BCu8gVyz1n9ePZIlu3TBJsLQafCEE0cENsUbNj6N860LODszFbNPn5t0MrAjSudD
rQplEmLOwVCLfqoyyaCOg63pvlNRj9MVxNZuqR32G6KAkZBWTXYjVDA3kb3hn6YF
JPAn4sBb0ITDrnljrjpYhWVypDSHQWSjnUYrMX5EXk173drS8dzLdMuC2lc0+Hme
9/2QnDqyZd4qNAN5x6axBT8g1136HEAHCFm6mgrtcYz0e6qKaGUTUkAAdQ8KEMDW
M0nEEmQ2SVm746+8jw3XsQefgJffG5JRmf6CGH9J/B8yV6sJC3vxZy6lQDe12R72
X/aXrHkLD7BNvia8yLV85gKKG5knIXld/tIqdCRHhYyplTqVksj7X+3LJJQYcTQi
zDx7GncIY7ygS/GHygf910RhDNGhWio9XV6h6kVY8s/fNJvP53LfRmH2MllHweLm
GMpfrOZ+M7UVkdcIJX7tZWc2jMuh4r6ZJsPLIQkwK2tA2Vbc5GyIRfhBkh3zkW68
g0UZ21ZuiyH+NzppBwlc5JE779zYPkPxll+SrXSe1mJxakm46N6O1Uw7MDlZaZvf
wTMxui4Xgo4uhzHURq4vIvprcUpw3gdgQp4cY7Cipdzu+k+tCntOGx1wm/4ypFbK
QQBB+fZv5Msj3w6CkF1c
=MKMM
-----END PGP SIGNATURE-----

--gBii9oQw/U9UOygZ--
