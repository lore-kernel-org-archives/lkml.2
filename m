Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2EXBT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:19:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40143 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab2EXBT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:19:56 -0400
Date: Thu, 24 May 2012 02:19:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
Message-ID: <20120524011950.GD5361@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net>
 <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
 <20120523093208.GB4085@opensource.wolfsonmicro.com>
 <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
 <20120523173342.GB4064@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 23, 2012 at 05:36:38PM -0700, David Rientjes wrote:

> What's fragile is going around and adding "select IRQ_DOMAIN" to=20
> everything that does "select REGMAP_IRQ".  So I removed that and just mad=
e=20
> IRQ_DOMAIN select REGMAP_IRQ itself.

It's a different kind of fragility, things break immediately when you
add something new which is reasonably obvous as opposed to happening
at some other time due to a tooling issue and what I'm concerned about
avoiding.  In any case...

> So can this be merged or what's the issue?

=2E..Linus already merged my alternative patch which does this with a
select..if which never seems to have these issues.

Your patch *should* work but due to past issues and the fact that I can
understand why they might occur (the semantic of select is "just enable
this" which doesn't pay too much attention to the target) I'd rather go
with this different approach.

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvYyuAAoJEBus8iNuMP3d5ssP/0pzUPPKUV7GJ1S37Z2hE3r/
OK8Wq9HHNZEh1BM4OsSZTYnEWKbhM+Be2a4pjVFGk8BuhLymjJ8Ltf0yQfoRr48U
Vlwdge9OpMcG5xi3bvnx/fbBbDHvuJuiRO+vKiYQIMIdO2tfKdRv/9mZ4+RdodU9
nPMMl1XHKiY6POLmGU/G/F38SfOEcWfzcteaUvJEknig9xxxhHKTtsGTIItSsiaR
5XHsMOI7PFahmuB+M2ujiAeaW83ThsMlbw+ho1nbxw2GgHmKNaHfS25EXzF2c0mB
wV43e3eP/+f7vNgCeDRoRu7kJHtB+++EkhfTWmOirydrX9P/B3FpJJVZ3/yFJWbo
bJ4Fqn14fDbKBnt2I6nUXqJP0Pak5cXjclRvFuYK4j+1RyPNYjUmz1TbsyoEUpzh
sjULD3ZUmkFRwtuAHjLKsVCBe25/kCZVMH8gU0FIEs3DPAYk4X9+jZJFQC701klx
kkexJY8zfd72qcwTCfKA9OZ/53QKOal8MM14lWpj7AtX5pgUEe+MIFtXMGs1EqTN
gepkGKjBbFSLSuLPBBjgHWlD7AQ987kDOEE7r8pAbYDlhqRcgL84c5WJu+CVg1+M
rRcTHvRLpWaGayk6taM8Ne5yaKqTeEePoOXPrVhBv9WYI4k09MzMUuwd6DrECFYU
pilqhHCdkXFChxoUeMzn
=GrZZ
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--
