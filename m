Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2BMWHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:07:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727Ab2BMWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:07:03 -0500
Date: Mon, 13 Feb 2012 14:06:57 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        dunlap@xenotime.net, lrg@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain
 configuration
Message-ID: <20120213220656.GA11931@opensource.wolfsonmicro.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
 <1329114588-15430-3-git-send-email-ldewangan@nvidia.com>
 <20120213211809.GI11077@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20120213211809.GI11077@ponder.secretlab.ca>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 02:18:09PM -0700, Grant Likely wrote:
> On Mon, Feb 13, 2012 at 11:59:47AM +0530, Laxman Dewangan wrote:
> > Adding details of open drain configuration of the gpio so that
> > client can set the pin as open drain at the time of gpio request.

> Implicitly, the gpio api already supports open-drain and several drivers
> make use of it.  Instead of being a separate flag; users who need open
> drain will set the pin to input.  For example, see the i2c-gpio driver.

> I'm not convinced this is needed; but my opinion could be swayed.

The actual idea is to provide support for doing the switch to input to
drivers that just want to set a logic level and don't (at their level)
care one way or another if it's a CMOS or open drain output but instead
leaves it up to board configuration which mode is used.  Laxman posted a
patch for doing this to a regulator driver but looking at it the code
for emulating open drain while also maintaining support for regular CMOS
is fiddly enough that it seemed like it should be factored out of the
individual drivers.

> Also, you should include a patch to make i2c-gpio.c use this new
> functionality as a proof-of-concept.  You may not be able to test it,
> but it will make it a lot easier to justify merging by showing how it
> cleans up a gpio user.

The regulator patch is one example - I think things that could be CMOS
are probably more interesting here than drivers that always want open
drain as they have more of a complexity hit from needing to decide if
they'll use the emulation or not.

We could also at some later point add support for hardware which can
implement open drain mode itself though I'm not sure if there's enough
problem with emulating to make it worth the effort.

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOYl5AAoJEBus8iNuMP3de9MP/j/7PumfKyRuR9LkeTN4A/t6
9q4YRm7GaSs/J6P7C/Qe/Ifm6NSNzb6BjHN2nO/o58EZ2OeGO3MRIT9vWtRAtD6K
M3MmvSCVVVL8B+9WJjbX1J9zq9nPGSc7UOrIV8YGYSz1e6c2OJof/2MNftRzHyo3
rcd7Ewlas3yq3FOYZNJMIh8N66JYsy4wnBZmhzoMZOorK2i2cQW6Tr8ZNMeykBRr
Ws1lF4oKD4/5D65ckuUUrFFRKeIBxxVaisQ6K9PyxagzhxOz/vKd9vSUVevJbObe
qwWVogZzmzwmukk4T3eGnZXznJDU2AJjoVe1xfOabtjnc/Ah/CgEfnF4aZ6pNCTC
/lsOipbV6mDFQo9/S3tuTdk51Ou2+xmxxDCCNlLIPHELDUp+Bg1NQJiyMkreN/uW
V4M1YNINGPY8megh/QniqcCbupTszqqRQFN/fxbsB0ZnO2IZpA381mJwh1Pcs7In
P8E/M7sjFXJe9C6N4aYBkXddlucGVe49wFnvf3HnGJtruuxH0KXwp4ozDdc5etKn
MCdx5ffQ3S6TVxU6qO7/Nh6RmJKyOOb2PBiOrN2IEvSeCB59knFhLvtcm/QaYnT5
pWWzmjiicT9M5mUaIH4Rp+nz3f1jGXOrgsYNjvqVUIfRzRPk+Hdj1sII+S0Zc03h
5sQnQw25ZyW7MhUUj9uL
=zQFX
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
