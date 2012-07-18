Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2GRKGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:06:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39050 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2GRKGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:06:17 -0400
Date: Wed, 18 Jul 2012 11:06:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: Fix calculating selector in
 palmas_map_voltage_ldo
Message-ID: <20120718100615.GD22739@opensource.wolfsonmicro.com>
References: <1342582211.12515.2.camel@phoenix>
 <50066BF2.7050507@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <50066BF2.7050507@slimlogic.co.uk>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 08:55:30AM +0100, Graeme Gregory wrote:
> On 18/07/12 04:30, Axel Lin wrote:
> > This patch fixes below issues when choosing selector:

> > 1. Current code returns negative selector if min_uV < 900000 which is wrong.
> >    For example, it is possible to satisfy the request with selector = 1 if
> >    the requested min_uV is 850000.

> Isnt this defending against bugs in the regulator core? I am normally
> against repeating the same checks at multiple levels in a stack.

This isn't a bug in the core, a negative selector is an error code (and
in general whatever selector is returned by the driver ought to agree
with selectors the driver actually supports).  It's probably at least a
questionable decision in the machine constraints to allow a request for
less than the regulator can deliver to get through though.

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBoqBAAoJEBus8iNuMP3dJ3kP/2pNr2mQJcM7BqElsC/XP/2S
GrjFpxPl3xZUYR37cpD4DblIUjcu3mkHr4vjL/qjA+5UZhdfBfnXYcIa9iy+2l5h
0GITAINoVDnj+4Duy0S0xlyVQNU/KLwiePjeifE9zElfte18m8R9U+9oYh+oxvZa
ezWuIyXNRlDDFPkO6KZIXjzro+KshwGrYBMswd5PtMd6rGLDOEGXLkUbyrsJzxl+
sKMNP5iILkvCx7/yulUGsSZ2ebri+M9pPGLWqhWnUjr7G5keESXEwo/U8PxgbnkO
Ury6MObibcccvGQaxUuj3LOtBNebQ23SoAdyzISo8R7VNRAWp99vOyiAu7KxZe9J
mwMvTCxu/dAVNbDYlOujE1/vWLcU1r/ns23EGNgmU6WZnPdPKkZktWq8tTAG1z4K
lUrKaSCCWZI4Ae7Ur3N2kac5VArg8/zQpqbdvcP2mq5eHSSBG23NXAoFkno6z+So
VRPQ2hQqP1u4IToDt958+ebSfQ4I0/DErkNP2nCW/ZNTJjqKUmj9L6WnGu8A3z65
cNDHARxYUMfQ3c6/7ZFrWcIPaLXD0I3YQjNk/yuR7o9UXG4TnRnoAu6Y6Qk4K8s/
raQMcXSZ84bxEumM8lrXCCaF9dLo1v0UXVbVwNdpy4xXcIdEwXI4k0si6kM8uqel
U93RcyZokclcW4rnMdOM
=PPSu
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
