Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2FRQVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:21:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47827 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2FRQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:21:01 -0400
Date: Mon, 18 Jun 2012 17:20:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
Message-ID: <20120618162058.GT3974@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpUp1egui7PDlNtH"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lpUp1egui7PDlNtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 05:57:24PM +0200, Guennadi Liakhovetski wrote:
> Currently regulator_register_fixed() uses a constant name to register a
> fixed dummy regulator. This is sufficient in principle, since there is no
> reason to register multiple such regulators. The user can simply supply a=
ll
> consumers in one array and use it to initialise such a regulator. However,
> in some cases it can be convenient to register multiple such regulators.
> This is also easy to achieve by appending the device ID to the name. It is

None of this seems terribly obvious to me.  Once we're getting into
allowing the user to specify a voltage (and possibly other parameters)
for the regulator it's hopefully going to refer to an actual thing we
can point at on the board rather than a virtual thing we've got to
satisfy software so giving it a useful name seems more useful (like a
name correspoding to the relevant supply on the schematic). =20

There's also the fact that there shouldn't be any need for unique
regulator names internally so if it really doesn't matter we should be
able to give everything the same name happily enough.

> also consistent with the current behaviour of the code, that fixes a name
> itself without giving the user a possibility to provide a custom one.

This is done on the basis that it's an entirely virtual regulator which
doesn't have any meaningful mapping into the hardware.  If it's got a
voltage then that's no longer true.

--lpUp1egui7PDlNtH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP31VjAAoJEBus8iNuMP3dGoMP/32h9KvdwPy/NT6360tMnwNm
e5QODte14CRyvcV53xxxjAuDMZyIK+hYz3n7ONefe5mUpgKS48XHHKVdHMLLpJy8
ndxEL0zhlYbprNLNKEdBP8+skM+3apolwbjfB+4dOI9fZwUywKgqRoEL6wCID1Ci
X159+I899FYof8/E7TtzaK8siq5MrRAxbil0SQYmI0ADVWsy0e9wRAiQQi9dcGdx
ypFmUDhqJ7d87UeY79yI0hFBGTlLhvbMm8pVs9mcsj4/bFhVrnVMZ1ASaoQwac0Z
t9hYyXfW+y7i1dEBeFTCI+mcJv0OOIecp8FXQJlmefQud5oU7phsPJWGDmagTBQ+
0cEUee5owb7xazO9+0ylT45kW8szvG5/TOnbj1d2MxEEWPiPxaV4+Zpt3yvbtKb3
pupJdE9vZVNOrKvzOgl8gPa5Ft9wtOqh5qjZJb6yluFeCvGfXK6ILUzYb5dKE/Yq
IQpCJ10XoexSlvHYUFd4o72Kf7VMIA9Qj1SyjVSvigkv34s0adxWuK8SWtP/jnzj
IHDFcNla43EfuSOYfUrIZ8eNqjM8PYXX8kXy0iEbO+TP84Byq5QdNBI/CGqIbSSS
5lyxQTs1uU71XojjJ0ftsx2HPdvw3JKe1q88jDNdHXxTouT6omUCrjXitLcu6OSc
vU3KHKptzQcsbZ5kRXoY
=US29
-----END PGP SIGNATURE-----

--lpUp1egui7PDlNtH--
