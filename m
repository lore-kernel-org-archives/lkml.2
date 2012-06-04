Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2FDKmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:42:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab2FDKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:42:36 -0400
Date: Mon, 4 Jun 2012 11:42:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        gclemson@audience.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120604104233.GG7538@opensource.wolfsonmicro.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
 <20120601001617.GA16311@plastictigers.com>
 <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
 <20120604102747.GC7538@opensource.wolfsonmicro.com>
 <69926c6ce4b1e004069662fb13287e9b.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5L6AZ1aJH5mDrqCQ"
Content-Disposition: inline
In-Reply-To: <69926c6ce4b1e004069662fb13287e9b.squirrel@www.codeaurora.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5L6AZ1aJH5mDrqCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 03:36:55AM -0700, Sagar Dharia wrote:

> I would expect that the slim_device's driver will only power-on the device
> during probe (and use wait_for_completion during 1st transfer to get LA).
> Typically transfers are not done as part of probe. Even if transfers need

I'd really expect that we'll have devices that we want to interact with
during probe, for example to determine the device variant.  I'd also
expect that it'd be useful to defer things like registering the device
with higher level APIs until we've actually got it up and running, it
tends to make life simpler.

> to be done as part of probe, I expect wait_for_completion (with timeout to
> avoid potential HW problems causing linux probe to wait forever) will be
> better than polling for get_logical_addr.

I agree that a completion is better if we have to block in the device
driver, but the idea someone suggested of having the framework generate
a second callback when it's assigned a logical address seems even
better.

--5L6AZ1aJH5mDrqCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzJESAAoJEBus8iNuMP3dToEP/3uAq5mU2+un6Js3xjkPr+gu
+hNf6/YtRqfFufFYf5v7Y37g0EB2226f9zfiWvsl0Am6VGZV5qWYdOqMqpZS4+Cd
mky0GFYk8Afd96kADQMm+mKLcGOkfHgRX7e5H0KrYwrZjfPXhsYa9+aRAlRcaznU
jI7fF4+l676dTbr1YTj+vG0GfKUXkyWbrqvLp++p0citcGZp3Mhjh7XFn3U4YUS9
5hjXCGSHWgJAD79Q376SX0wSuePOM/9dBQxc/RE1DDhw62oK6kl8HAKxXPGxk0Pn
2K6BP2BfnAhptQK3hadSSkHmhKr7FzrgZzhWySNGOcu3zcsZzJScNstP4ASQQ/u/
PJfou9TwHhbsgs0VQWLAbHBAkebPLjfANzbiBM6XuI189M9bm8z7DztgYYS5IlVn
NHBa0ad0uG9YhEkfZQQ3AHvirk/u4TLKoqjviVC9LqAkGOwQlH5XK+sVWwlqI7Er
OoLTsv+nVmAYhHF40JmlI4D/0Dgtst5qYYFSyCRLm2LUTFTr23GEjErvT64Zfgq6
AeEImMH57qoygRNxiBW18NM/P+5WeETar70oo3262omILQDJIHXJJFYIiCYAJViw
1q+UB7jIlJ3ud/RaejWgpBZMCNvjd14p5WdHe3vurvg13h2yDPMx54qqT7O3VdEi
zPnWlBkyOtLUNhiazkXE
=Nk4v
-----END PGP SIGNATURE-----

--5L6AZ1aJH5mDrqCQ--
