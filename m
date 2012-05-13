Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2EMRQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:16:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36237 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab2EMRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:16:39 -0400
Date: Sun, 13 May 2012 18:16:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
Message-ID: <20120513171634.GC6381@opensource.wolfsonmicro.com>
References: <4FAB15DB.5050702@googlemail.com>
 <20120513122946.GD706@sirena.org.uk>
 <4FAFE1BF.9050805@googlemail.com>
 <20120513164304.GB6381@opensource.wolfsonmicro.com>
 <4FAFEB2D.5010009@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <4FAFEB2D.5010009@googlemail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 13, 2012 at 07:11:09PM +0200, Sebastian Hesselbarh wrote:

> One more thing I thought about: The platform I currently use needs
> to pass the external clocks to the platform devices that can use
> them
> later. IMHO the correct way of creating clocks would be:

> - register i2c clock driver and let it register its clocks with names
>   like e.g. si5351, clkout0. The clock driver itself cannot and should
>   not know who uses it later on.
> - let drivers look for e.g. kirkwood-i2s.1, extclk because the i2s
>   driver cannot know where the external clock comes from.
> - have a board-specific function that configures clock hierarchy and
>   create suitable clk_aliases e.g.
>   si5351,clkout0 = kirkwood-i2s.1,extclk.

> Currently I added a callback function pointer to the platform data
> passed to the i2c clock driver that is called at the end of clock
> driver probe. I doubt it will be accepted that way but can't think
> of any other way..

This is what clkdev is for - it provides such a layer of indirection.
The only trick right now is that it needs the struct clk to add the
lookup but some platform data for your driver would probably do the
trick in the short term, I don't know what the plan is long term with
that stuff.

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPr+uxAAoJEBus8iNuMP3dizYP/32aVF92/FPI08fz/XIpKmwd
zDTBYkyDvrAQ+DBCxGx7FtHfYi1ng+Dg/xSl8NwEVcUjCILQ8VwmL+h8CUukrjBD
s3fT0qP9zKiH0R7RNMnH7W7iVmMYZpMxYe/AopKiAemErmBcb0vp5hPaz+zZoE1j
BtA1FpcHyXep05LAlrVbpjWqHyvlcaYLoEtPu5ItCs73TT61QQ9YcZTwr+xGrKWz
RM0cJEBiK/Z/hvWzlwE9z/25FAfkZnC4XsXcF4gxuFz4ls00LPIZVf18G5SpSE/e
Ds92AHlmSxjUSkmu5wbFX2VFgje7/Wcn7DVf5QvHOLXFrhe1tmvzR7SOVtROHmxy
jjG6/FC055zyHOFNy2vSYv02tN0DI6MNM3jeN25S8pnOVJUPubA6vekHGf97sWqN
Bq6HCaGx3eW6uDTxdry5qvP1IrX4CjeRHwscZxpjxOjIutwqz0Rv5cPpXDD6izU0
L7TbB33UM57IAaeFASfQbbMJso+4QSWG7reQ5QquQYvHsT3febUBZgB6MAhkyWvY
iahMtrPPm0sOOOd91LKAkuc0PRziIrSPxiJ0O3zTj24ItAESNx76aiw9lMpPh7P7
u7SIB6GvgTlWHvUAv8ssaSJ2Tjvbj8Mhp/lJskBzchDhuZcAh+steZCB6kViCWbo
1ldVQNTcOmEB8aIXaPWG
=Xb8q
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
