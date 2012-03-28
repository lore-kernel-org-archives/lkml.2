Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2C1Jqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:46:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43467 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842Ab2C1Jqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:46:38 -0400
Date: Wed, 28 Mar 2012 10:46:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
Message-ID: <20120328094609.GA3232@opensource.wolfsonmicro.com>
References: <1332869030.2213.46.camel@joe2Laptop>
 <4F72BD4F.9020305@ladisch.de>
 <1332919803.16535.22.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1332919803.16535.22.camel@joe2Laptop>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 12:30:03AM -0700, Joe Perches wrote:
> On Wed, 2012-03-28 at 09:27 +0200, Clemens Ladisch wrote:
> > Joe Perches wrote:

> > > +regulator-y := core.o dummy.o fixed-helper.o
> > > +regulator-objs := $(regulator-y)

> > > -obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
> > > +obj-$(CONFIG_REGULATOR) += regulator.o

> > > Any objections or other suggestions/improvements?

This seems an incredibly obscure approach.

> > Instead of doing a Makefile change that has no _obvious_ connection with
> > printk, wouldn't it be better to just define pr_fmt with "regulator: "?

This seems like a much better idea if we're going to do anything; it
means that we don't end up embedding module names in things (which are
after all a bit of an implementation detail) and get to pick the name so
we can do something like get the prefix which is used for the symbols in
the code even if things are split over multiple modules.

> Maybe, maybe not.

> Bundling objects in a Makefile like this is pretty common
> and can also produce better module names.

In the case above we don't support modular build in the first place.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPct3ZAAoJEBus8iNuMP3dH8QQAITURuf81brjvEXvwHY7bAe/
VWem88lHXGKSW8MpFVZD99UbiYjV7OSIiiT4FaEa6Da0b1YFgH8f861PriyJzjNX
yfn5nnU5TF/pnsaeNekKzcF1S6QqT+hp2qLuVJyEn/Sq2ixcI5IzOouLISvVqNEV
kR4imKfrXOyXHmq15Pst2hbN5IHFdCxKf7fJpLG2fFrcqxnAje+Clwoj0Cf66L4q
kaY//vLyFWbDtX7Tpe+3Pcg3t86wdI8mUANrv8tW7MCaT1K4okmK6wABcHlf+HFm
ychi7qC6nGYzy4ObPWOZveMWC+5Ls9Q6gGM08jivvj6HKgP0lh7nWKJwAj/HaAtk
FUBmLGGSi7RhlftsVftPl4QtayAl774Bplp8soT4+NsFnDtFWHqYach/SxB3gkjJ
kvYhM3IUaQ9LY334ddGBnJ059ZeVt1LQaxLvwJYolBFnF/sbWZGMKyRCAjtAxffm
gBt+C4CCdtthQfGFMR+OmJWBwGND4tKRerUf2Ts5Q3nbjeQipJ9t4dDJdZ+3omLS
dJ0iD/uD6p447nLzvibBFW53vdpxQzCRl4yaaxzqSOVTZ5C0EiLWB3Q72ixwDEh9
b4EdAeDvQ2vsbNb9dZdWx/gYK6O4xi6kxyhuvPOXho3eeskN4c9AdelHCQ9w/4+x
d69i/G1G6j3GpHkfnBq0
=4ahX
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
