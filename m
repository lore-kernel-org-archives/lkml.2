Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2EGK4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:56:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45849 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab2EGK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:56:04 -0400
Date: Mon, 7 May 2012 11:55:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/4] regmap: add function for set/clear bits
Message-ID: <20120507105558.GG4415@opensource.wolfsonmicro.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
 <1336376139-1048-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Content-Disposition: inline
In-Reply-To: <1336376139-1048-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 01:05:36PM +0530, Laxman Dewangan wrote:
> Add regmap_set_bits() and regmap_clear_bits() for
> setting/clearing bits.
> Although this can be achieve by regmap_update_bits() but
> having these functions gives good readability in driver
> code which uses regmap apis.

I'm not convinced about these for readability in the first place but...

> +int regmap_set_bits(struct regmap *map, unsigned int reg, unsigned int bits)
> +{
> +	bool change;
> +	return _regmap_update_bits(map, reg, bits, bits, &change);
> +}
> +EXPORT_SYMBOL_GPL(regmap_set_bits);

...clearly they should just be static inlines in the header file,
there's nothing in the actual function.

For readability I find moving the operation being done to the register
value into the function name tends to make it less obvious when scanning
the code what the actual change is (since with a bunch of operations
there's a lot of repeated text on the line and a fairly small amount of
text for the actual change) and can lead to the two operations following
one after another.

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp6o2AAoJEBus8iNuMP3dn8QQAImDZMvrNv5lHFEoU082tEKc
SMDxdZsx7IXY3x/gWNvvev1PpOj4XnmiOk3/xkJIWTnacwNIrJygvZH19ct3wneS
RKjVsntHwNbUzMWNVW5YA1gXXM7Frtjg42HgV+yKea1HdAEv+DFWMPPNjgcNRxcA
CjfItdgaos6A+Mt2aKhHflCuN9uC/BnC8xPKoc9ppE3WAUzkgeMgHUCMsZwnqVhe
+BdpOt5Tk8brAJqJkN9lGzYGGdA0v7X38caqySXDBnmEK31j5bVU6k1I3Sg79SC6
Up80q6j+flSvhLyvSQ35jol3it7tLZu2SJtK1ptUIvUOA3c3QWYf5w1336aZ49cE
e9YOJkyaxzVnRHf2l+tGFvtHYDSSKvcAUh8YeUmuRVukMJ9NSqHqIYtqIej5vVFd
CrTkcntFojeCL3ouNlMza78n/+Vs5OSP59u7sE1525fHzQ1mz8f24Gb4/mG5OXqp
7ovU6oC2LX3yuhe2ITK8A4mgkxtI4Jwsz0l1diGCQxwNaEi2IEJcpah4RGwLn09m
u1Mbg4RYoHD1yd3WUm0FNo9oolBYXWZi9qHyzO6mZZw7FgcyfFpjySO8JJ0E6JXs
BO/zx+o3cnkiQit4xsjkdKakBOXmBefed8FCbth3HdbIlZSWoCOn3CJ1xnaM4+ib
xvIIG0RAHwaA/l3qjF6Q
=6478
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
