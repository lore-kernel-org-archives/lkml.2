Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2GZVB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:01:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39237 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab2GZVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:01:55 -0400
Date: Thu, 26 Jul 2012 22:01:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulators: creating a regulator device for the
 AC/USB/BAT/charge component of a PMIC?
Message-ID: <20120726210115.GF4560@opensource.wolfsonmicro.com>
References: <50118637.9060205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Content-Disposition: inline
In-Reply-To: <50118637.9060205@wwwdotorg.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 12:02:31PM -0600, Stephen Warren wrote:

> A couple of the regulators I'm looking at (I guess many/most in fact)
> are structured as:

> Battery, AC, USB, ... -> PMIC -> main output (unregulated?)

Yes, that's very normal.

> Should this "main output" be represented as a regulator itself?

It can be if you like - most things will be depending on it, often what
people call the battery supply is actually the main power rail in the
schematic.  Having it there certainly won't do any harm and may be
useful.

> However, some of the regulators in the TPS6586x at least are fed
> directly from the SYS output by an internal connection within the PMIC
> (e.g. LDO5). Currently, the driver sets up these regulators as having no
> supply, which seems wrong too. Presumably the PMIC driver should
> internally hook up its SYS as LDO5's supply without needing any platform
> data or DT ldo5-supply property to do this?

Yes, I think if we're going to represent such supplies the driver should
just do it and not force everyone to cut'n'paste.  Though to be honest
if it's a supply that's purely internal to the primary PMIC there's no
real need, if the system core rail gets turned off software really isn't
an issue any more.

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEbAVAAoJEBus8iNuMP3dxL8P/RUQ5awiSVGgG/Tnsyilx2q5
wMvrrh+lqvIjLxzcob5s765HNLA+Ams9MFWDVjFK4VaWv0IBNmy/Rb8KqLIDqBPo
Cf9aE3spASiL2xf2RlF59xpd3tGOt7B9W80R+43Ku+UqEoX0WpdHFgkRlbSeR29d
XWV2WysfYQshDRyleP9VBoCSNXlrBj3g7WEnwQtJP/4ieeUtiINd7k4KNJu2DA77
AZWUFQS8mWXqw2T3vVHn6h/jGUnk9t0LUmUolds8lLZ1r1iW1IUZoa76m5pewgb+
H38+dywEN0j2GXw3+qdQGUOuoZQlI+K00KHXxUD6YgUp7MuVm1HptVUeSfcy1C8r
RXxBNmGRVVTR2sJAd7TS542t3hqsE332MeIopR86ce9+xvS3O5alL5C2gAVLubrA
fenHAtVVt3XnU8wQ0d/US00K+Gx4wzPbOpB2lb6WegI183NkBkmoTWnsNMAZN8oY
MLSY2bAuWK4IsRz8RvmmU51cGgnr9hQ/YAoU44u92oMhrkPH045+GboQkROLIFGU
lUeXVaO9WKlH7nbWfbalnQzqrpZKzB9Tiqw9AGdLy+4/Epz4K/n67/D4aXh4hnDk
6hypJZVDGBNia3KzLQfCy4ipO6T/5DgjhfGQ66SkyEaQDkfQt2GMNm5Ex83uKjuf
LI7ceqO8f6FoVRgymLNR
=p9L/
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
