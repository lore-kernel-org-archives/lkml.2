Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2DTNBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:01:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48605 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab2DTNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:01:38 -0400
Date: Fri, 20 Apr 2012 14:01:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120420130134.GA5957@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
 <20120419124204.GE3046@opensource.wolfsonmicro.com>
 <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
 <20120419162905.GA3084@opensource.wolfsonmicro.com>
 <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
 <20120420114602.GB3259@opensource.wolfsonmicro.com>
 <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 05:59:42PM +0530, Jassi Brar wrote:

> That's what I have been trying to fix. My example might be fictitious but
> I have a real scenario with omap_hsmmc (I was avoiding getting into that).

> The dummy not just provide a place holder data structure for missing definition
> of an available supply, but it also masks the fact that there might indeed be no
> supply at all on the given machine.

> As I said, atm the only option for a consumer is to know it via PD/DT.

No.  You're failing to understand what dummy regulators are for.  To
repeat yet again you're not supposed to actually use dummy regulators,
you're supposed to fully specify the regulators on your platform.  As
I've said several times now dummy regulators are just a crutch to hold
systems together, if they're not working out the solution is to turn
them off and even if they are working out turning them off is still the
best thing to do.  The problems you are seeing are exactly why this is
the case.

> The benefit is magnified by the fact that, for a given circuit, at
> least theoretically,
> there is no limit to the number/combination of supplies that could be controlled
> by inserting a regulator. And that could lead to a very noisy PD/DT.

No, any given circuit is going to have a very clear set of things that
can be controlled by a regulator, and most chips have a fixed set of
supplies they always need so it's very simple from their point of view.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkV4mAAoJEBus8iNuMP3dQJYP+QGes/U12MsBcOkSkrMJ8Whf
tgn6cpPD7dC9U5se/O2wCh4/MT9aGlSw3irflGbianF18sFLfhWzcGy0a+0TcYLw
nnNhy6lUgZRgCnW23ImJks/3hat5krXibmpayQ8ZjyTJQHWyOrY8UGn18Dlks4wM
cTwMnUajLAiy1tmv0oOZMrf1bSdV/i35Z5o3iqzfRpojRocOM/dTBZU6SAD5wNkB
Ckb+NrU/9oMZVBOhRg31JlZj6K84z6rrH0EMvwuY6cQsZWgufx306wIbD3cPRRID
t3Qj/jXCHXgX3LVupqSXPUg4xtm7AWEgjcDXwYDXi41v5oSlmksMMODQqdR6kIRH
dMjSe1u+d8kDG/TzvVJ7OFOXqT9a9gbvxaOjo8v5YsyelOEdsjZ6cYd+a9JlNh9x
G9UmUsMRFnp8Fc5uQVdZn6JyUrn4GHTw2b8N7YNPGZUQ2dYYMIDtGN4nw6uu/wH7
M7t/XSJNLnw3jsikOEs3b33VddLFG0eInHV2YOBpBhcpSnk+IONcl99dScVsDGwX
QSFhmgpFs4NEnBZAmGRHN8XnWUyecl9PvPC5TWvhUypCzHFJg3nos9L2BeLW7SPm
vDIERmHDuUXV6XFiV39wgcQkmbH9w5RAGMgjtsO3SacElLzuRMZ7KJk6DGz5UsUD
qfD/tM+EY7aR4KmPiVKr
=Q9CA
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
