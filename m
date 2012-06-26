Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2FZJwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:52:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52498 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab2FZJwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:52:54 -0400
Date: Tue, 26 Jun 2012 10:52:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: arizona-micsupp: Fix choosing selector in
 arizona_micsupp_map_voltage
Message-ID: <20120626095247.GK30406@opensource.wolfsonmicro.com>
References: <1340697707.12992.1.camel@phoenix>
 <20120626090825.GI30406@opensource.wolfsonmicro.com>
 <CAF+7xWnJo3VrZ+iH4BJHkTmo5+D9ttZ1n1Tm0KMPQqK1sKD7wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jITzwD3HDGXid3BE"
Content-Disposition: inline
In-Reply-To: <CAF+7xWnJo3VrZ+iH4BJHkTmo5+D9ttZ1n1Tm0KMPQqK1sKD7wQ@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jITzwD3HDGXid3BE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2012 at 05:27:26PM +0800, Axel Lin wrote:

Your mailer is doing something *really* odd with word wrapping, please
fix it.  It looks like it's just randomly wrapping lines rather than
flowing paragraphs.

> 2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > This is OK but I think we want to factor this out into the caller as
> > we're implementing this limits check in a lot of places.

> It seems most of the new code are calling list_voltage() in
> map_voltage to ensure
> the selected voltage are still in bound.
> for this case looks wrong to me.
> But in this  case, current actually set selector to
> ARIZONA_MICSUPP_MAX_SELECTOR in map_voltage() if
> min_uV >= 3300000. calling list_voltage() still returns valid voltage

Which we then immediately check against min_uV so as far as I can tell
we're fine here even with no code modifications.

> If min_uV is in the range of: 3250001~3269999,
> current code uses the equation: selector = DIV_ROUND_UP(min_uV -
> 1700000, 50000);
> Then selector will be 32.
> Then arizona_micsupp_list_voltage returns -EINVAL for this case.

OK, please submit a separate change for this.  It would sometimes help
if your changelog entries were clearer, while you do normally provide a
lot of detail but you often don't highlight which are the important
details or miss critical ones about why your change is important.  Your
original changelog for this makes it look like this is just a change
being made for taste reasons since it doesn't mention the error case.

--jITzwD3HDGXid3BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6YZcAAoJEBus8iNuMP3d8aMP/3qscgLCfkNFkpCbuM4brO+9
UHW6TYMkl/tOqiKAVxz3FHtfxw9GBxJe+52dRckFKAjFPLz5qbF4mas5SHnfRnPP
RcYyDVFTekts1+igz42zik0fOMVlDpU1LSkbRS5h7R387KlT+guX3KAj3nV2b1LC
lztrB9MuEQguqg1Nr54LUgwTTtf2h4Uh6NvQZTI4e/UUNb9WOlyRKnv/cGGLkb9B
QjxR45JlfBaOW4UzdmJpvGC4Vv6lRiIiIMPDZYJ07+OLxGqzopoKmn2HrReZzVpD
kxcHbWs3GjMidguNmFUwzkSNPfYhuYC3tFdVrN91Y4BDxoPFgROotL/BH25B+IBr
x3KSivo/1266XFKWmwkr3uTRr0zN5uSQ6zyotoBj/0vZyYEK4xoLM+d2a3uaG2RY
m1/fXHle/sFdwR3ZUsVHQNhTuESOChedjisYKctRd4Q+mZAMNo4d234EshUJl87A
ZIkYFwEv4IwCyTdKabwfs48tNFZYFCEP5AMR0KfGcOQr8Qy8fVbAZBvSxDVl01sI
sAx4NhXXmKJrIEodYk/XxzfnFC6XpJGcFGf8Yo1SpIx9KFCqKFfJPfUQvhKflgpu
JJ7yinb3H+n4UIpOvXEJ0Vftznfnf+bbu9KjLuKzOLgr6n5HtOhDJCGRPAUbLyC6
k0yb8B7x4QZBKjG3/2k4
=WRbg
-----END PGP SIGNATURE-----

--jITzwD3HDGXid3BE--
