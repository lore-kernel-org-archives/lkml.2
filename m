Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2FTXfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:35:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758552Ab2FTXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:35:11 -0400
Date: Thu, 21 Jun 2012 00:35:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Laxman Dewangan <ldewangan@nvidia.com>,
        lrg@ti.com, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120620233507.GC4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <201206202040.52291.arnd@arndb.de>
 <4FE23A1B.2000809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <4FE23A1B.2000809@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 03:01:15PM -0600, Stephen Warren wrote:
> On 06/20/2012 02:40 PM, Arnd Bergmann wrote:

> > For a "compatible" property, I would expect two objects that have
> > the same register-level interface but are responsible for different
> > physical objects to have the same "compatible" values, but here
> > you specifically need distinct "regulator-compatible" values.

> I'd originally suggested "regulator-id" instead of
> "regulator-compatible" in order to avoid any association with the
> pre-existing "compatible" property. Mark didn't like that, although I
> don't think I quite understood why.

Like I said we already have names (and we have IDs inside the API as
well) and it also seems better to make the "which thing is this?"
property have the same name as the more generic "which thing is this?"
property.  I did mention the fact that drivers could read additional
properties to further identify the regulator if they were so moved.

Ideally we'd just be able to have either named nodes directly in the
parent or be able to have arrays function as a hash, really this is
trying to simulate a hash.

> The problem is that dtc has no named constants. Using raw integers
> instead of names would make the .dts file rather unreadable. The issue
> is much more accute for regulators than say GPIOs or IRQs because
> there's likely no relative order to the set of regulators defined by the
> documentation, unlike for GPIOs/IRQs where the integer (often) is the
> object's primary ID.

Well, there are actually a lot of chips which do provide useful indexes
- for example the wm831x devices just have a bunch of DCDCs and a bunch
of LDOs which can usefully be referred to as DCDCn or LDOn.  They will
hopefully not need to use this interface.  It's just that there's also a
large class of devices we need to cater for which don't have any such
regularity in their register map, this biding
mechanism is for them.

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4l4kAAoJEBus8iNuMP3dHu4P/2uxiFe4GwlkAr2LbaKjlj9S
49GAM7eeEH5rhltuQUSTxNRoERhpNols/9nR3JYRU1AWmX/upsPMCVZy01HHehzs
UxWSgQUTcsjKdQb3OEjzriqvAUPlgSCrrjFNArq52NAwTN/eNas8OspAUHgEt+as
5G2OUp9RmOIyPZQ0/meFtjRDuPuYgAcf+FHTwCd44gJBDEeDuXcAtJw3gZIv9iyb
Z88k4AGLn0tLYtxgrvLeD3cpNKYMWUQPse8txcwvcNaSmtWQXT4ir4z0ah2pGCwR
QUDLZKh84mVmW3lLzSoJidO3so8mMbr7vGzakCq6DiJsF/1kmj293A2I30T890fW
Ep9I2l5QaVpyPSVR+DyHVO0DL6ZECpjAbERLmgcKG7iveeHYNrJ358P7BKhJbyuV
0mVS/B78Dz+znh8BAO6RlUwdVyU/709FLA5SWqqMk+vMkfSM9XdWasfQu4+HhjCC
dCk7XxjjerjLBAUxrqm1a0bHKgZlA43g0FtRbNIuxLCnQfuoAi9ejbtEjoWQDi2k
UczsxJNWjwT0mKCem7MtZM81EBpRLZ7BzGbJUurGIpHqgWz8XLqjRVb0P2Azv+F6
MbLilxG5MZl9dUR9m2Yh7RYTsmMgF6dJ8MhN4rI0mPwBYbEqdEWFJfNuonJ9M+UT
6e3G2nDScBtHssxu2Xd1
=QdQn
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
