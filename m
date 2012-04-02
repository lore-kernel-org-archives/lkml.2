Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2DBReQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:34:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33693 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652Ab2DBReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:34:15 -0400
Date: Mon, 2 Apr 2012 18:34:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120402172954.GH15197@opensource.wolfsonmicro.com>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120402170442.GF24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fd5uyaI9j6xoeUBo"
Content-Disposition: inline
In-Reply-To: <20120402170442.GF24211@n2100.arm.linux.org.uk>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 06:04:43PM +0100, Russell King - ARM Linux wrote:
> On Sun, Apr 01, 2012 at 12:32:40PM +0100, Mark Brown wrote:
> > Allow clk API users to simplify their cleanup paths by providing a
> > managed version of clk_get().

> > Due to the lack of a standard struct clk to look up the device from a
> > managed clk_put() is not provided, it would be very unusual to use this
> > function so it's not a big loss.

> Err, why?  The contents of struct clk has nothing to do with clk_put().
> You're doing something really wrong here.

It does for a devm_clk_put().  Normally this would end up being:

	void devm_clk_put(struct clk *clk);

but the devres stuff needs us to have a struct device to get the
underlying allocation/mapping and undo it.

> Remember, there is not going to _ever_ be the situation where a struct clk
> is specific to any particular struct device - it's a 1:N mapping between
> clks and devices.

Right, absolutely - to do it as above struct clk would be allocated per
user and indirect to the actual clock implementation (which some people
were muttering about for other reasons, though I can't remember what
those were off the top of my head).  Probably what would actually end up
happening is that we'd instead have a signature like:

	devm_clk_put(struct device *dev, struct clk *clk);

but I didn't particularly feel like making that decision right now,
especially if we do end up going with per user allocations and can use
the more idiomatic signature.

> So, until you sort out your misunderstanding, NAK.

I think I understand just fine, thanks.

In any case, we'd only really need a devm_clk_put() if someone wants one
which is a bit of a corner case in the first place so just ignoring the
issue until that happens should be fine.

--fd5uyaI9j6xoeUBo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeeIMAAoJEBus8iNuMP3dsQoP/ift8j4KSY+r9XjuDHvfWIVe
u7pInrQRT6o5ir8pamiKLqa/8uwMBvUanPeee73MXX7zSnaOHUccdqG8a7JO1zjR
MIty8MP1p8VRVj1y+w05YXs6VK6iBEt/9j5td67d4QksRkpIg1hXZXT6KTpvty7D
2uTCCOy4Ao9tPC3lgcqEbo6s5xGTsf8nqF9HlBmN8rTXqzzrSm75J85Hk1SqW9Ue
Vka+R5etnrvLKgKuQTUateGMuexMdc9vP6uD0hNGpaPt1hVsjfTf6RivCCQAoBk8
VC7ntrUQuq9ldq9aHAQS6x49pYv47tJK+jjjxeOVD/QgqT1e31DtaG7ERHW/Msgq
5sOLP18aTA+5UPuCMmmXSasxVDqbpgsRGY1gZVJzaxy0UI1WqRnEd9356amsRFgu
kT+4oT2PE9LlFPf7pxUFrshu/s1W/6ju12kQd6qgheEMuOKhEsOGNXMcwMBUNGI3
FGTsydHz9alFlVYiE4DT+DYPm8YP0GF47WtC357bf/ZxWACBeD2tyneijJMzQffL
/ffT2aMneMRMLCP+GbQyU58+THCcmgLc3znYr6qcqgRpvJSkd0zN5lLozwW3AHx6
tj0RrCchsb3z63LXl0Dknd916Gt7IOTpB0MylesD/1Tnfa4JNjI2NqjM9Mm+Tw8A
1zgo+IxOtgZGJohbUlV1
=iSaB
-----END PGP SIGNATURE-----

--fd5uyaI9j6xoeUBo--
