Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2EGQY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:24:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43881 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263Ab2EGQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:24:24 -0400
Date: Mon, 7 May 2012 17:24:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open
 drain flag
Message-ID: <20120507162419.GK17002@opensource.wolfsonmicro.com>
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
 <4FA7E4A3.6050004@wwwdotorg.org>
 <4FA7E57B.30804@nvidia.com>
 <4FA7E841.7020100@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3D7yMlnunRPwJqC7"
Content-Disposition: inline
In-Reply-To: <4FA7E841.7020100@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3D7yMlnunRPwJqC7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 09:20:33AM -0600, Stephen Warren wrote:

> My point is that there's clear intent for of_gpio_simple_xlate() to
> return the GPIO flags from a field in the GPIO specifier in device tree,
> irrespective of whether some GPIO bindings don't allow this, or whether
> this is fully documented.

It's really not idiomatic for drivers using GPIOs to allow configuration
of their flags in the first place.  Or, quite frankly, to use flags.
Honestly I'd not expect any bindings that the GPIO driver provides to
have any attention at all paid to them most of the time, looking at the
code seems to support that (though there's surprisingly few bindings
using GPIOs at all it seems).

Before we start doing stuff to improve this it feels like we should do
things like get devm_ versions of gpiolib APIs in there (since most
conversions would really benefit from that too) - I've been sending a
patch for that but my backlog of unmerged patches for it keeps getting
bigger rather than smaller.

> We shouldn't have two different mechanisms to represent this
> information. How do we resolve the situation where a particular SoC's
> GPIO binding allows the flags to be specified, and this patch allows the
> open-drain flag to be specified, and the two values are different?

> Either we should force all bindings to have some way of specifying the
> flags, or we should remove the flags from all bindings and rely on
> separate properties.

There's also the case where the bindings probably should be ignored
because the device driver knows what the connection has to be anyway and
there's no point in forcing people to encode it in the binding.

It's a real shame all these bindings are driver specific, it's just like
interrupts :(

--3D7yMlnunRPwJqC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp/ctAAoJEBus8iNuMP3d2PsP/Ajv0ha4ZMhDNv+xdeAySaCT
5E6XdxEg0r9HC1g3YjckSPH/eXQbTG8r4Q4cfxwR6UG0A3JexBShvY42R9nbbwdX
rHHhpVa7/T0AIwWloS747O0GNay29om5fu5aOmtGi29JwSKYCIXnT54qOvraSBxL
pvltea6+MW9JjV7sVHpobNcHr4i/v90gJIbT4QzOJMOE467tIMA+u5M2aM0x7JPU
Lp9koMitfeXfTtPLKMmXj5GZqab74uo41ZdMJk+xTv8XYVZaPsNKerIdDUGTNKPG
mlnVed6IuJt8wlNxLApwEwLnoDo0gKCeQvWjY3HIkQDJt6pNccuiQg3VL3ncTVQZ
hHRvQCXlzH3Cq1Tv5Jx+d+KV0Zv6MRZW7c1Zyx8oZrPm8cHxz2+0sPYsmZMmz7AI
VZ40mBdE3qRDktQyZK+jO4bImnj8+511oxdYni3bsZZTr9W06T37gUBhidkXOPwj
fl5XL9IElVWoprTpHXhMjXjlUJ16G1+z9h9hOg48wNUSd3Wgyr70YzTUib0ttmnq
EuA3fBELcqxUgmJpNyZmL1cVNHUG0clRwU0nm/Nax95q+lPI5vKe0mAbsPcoqwwB
OTUrYV4owzqtROYpphWGzQ06es+jr5PdFIH4AO/9AivUtoTMql7kfw6glV9uTzlD
PtsTGmIamicx2pMJnPCl
=DM2l
-----END PGP SIGNATURE-----

--3D7yMlnunRPwJqC7--
