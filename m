Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab2EEADQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:03:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45107 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758280Ab2EEADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:03:13 -0400
Date: Sat, 5 May 2012 01:03:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120505000308.GX14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <20120504225514.GM897@n2100.arm.linux.org.uk>
 <20120504234056.GV14230@opensource.wolfsonmicro.com>
 <20120504235225.GN897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YHHegWJYV76VGRm9"
Content-Disposition: inline
In-Reply-To: <20120504235225.GN897@n2100.arm.linux.org.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YHHegWJYV76VGRm9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 05, 2012 at 12:52:25AM +0100, Russell King - ARM Linux wrote:

> How about this - we have struct platform_device_info, which is used to
> create platform devices.  We can use this as an array to describe what
> platform devices to create in the sub-driver, including what the resources
> should be etc.

We (well, I at least) need to handle devices on other buses like I2C and
SPI too but yes, that's the sort of thing I was looking for.

> However, there's a problem with this - what if you need to do some board
> level init before hand?  That needs to be handled somehow before these
> devices are instantiated.  That could be done via a callback through
> platform data.

> But... this all seems wrong, because rather than having a driver which
> knows about the details of the board, we now have all the details of the
> board in question back in platform code which originally declared the
> board device.  That's wrong, because a daughter board may be shared
> between different platforms, and we don't want multiple copies of that
> data all around the place.

> I don't think there's an easy or generic solution to this.

I think that's OK - if there's any init stuff that needs to be done on a
prior to identification of the board then presumably it's a generic
thing for the motherboard which will apply to any plugin module on that
board and can be done as part of the normal board init.  If the init
needs to be done after identification of the board then probably it
applies to any motherboard the board might be plugged in to so we can
just define callbacks for the plugin module that can be part of the
plugin module description.

Cases that depend on a specific combination will doubtless exist and do
have the problems you describe but are probably less frequent but I
think we can go a long way on the first two.

--YHHegWJYV76VGRm9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpG40AAoJEBus8iNuMP3ds7EP/0SaZ91v2MredasgbcnS5zuX
CbdV2e5crct//Lt9Y3YmbJZivr/yrT8Eryh2ubsIIHvyKQPX5QZ5yJx6U8JLJgal
rV19uaZ1TjtzTa7xG6EXzKfVE9hQfqz0sa+3vXsJws3xixWMDEMN2JJNo6jTIA76
lu9NndWxY7+sdqwJSmfkQeQeyRH2GyIP0PbniL0O/4oY6kPH1is+bv+GlneR1LJm
LYFDO+It6tn3OERPx/ZFiXHJIi6CVEA2HWYizXPrPGtYAJfyKQGsDn3/bsS0ocTV
BGSx1GCxWYmKo9ywkMNuFrT97u2WgNppzSgmx7OxU8bwYGrlYFGbz5j3Db5uqeP3
iV1oKDTf3xHQIceWQM387MmkatymbgzZFXWWH++uLJKU5N/fKI1toCpbYMx2a0Uh
IfclrJkYDXzT7EvnNRzlqBD/G0LVJt2awWVoW9Ix8JAzb9LbAjAmJsTiIRI6GlFJ
6KDgPnAxtlicFSNYinv72Z3bvRFVYhlLj43l/Y27nZI7tsZEtgPuhs5FOWMpbwAw
/lNdT3dHcbQmIjz1VY1EnnZ0WrLVw6KdDT4Ih1JvciN4sPvOkSmgbgPf/2VsWi1V
xoBSPGWVIsmGy5lS7gx2kuVyZh9zIt2xGhx6eEFvIrarVsEBYMCdSEy5a7NQKBHZ
l0YaeIQ9WFFjklyTR4PT
=AZJd
-----END PGP SIGNATURE-----

--YHHegWJYV76VGRm9--
