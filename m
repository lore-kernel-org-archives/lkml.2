Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2F3LtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 07:49:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab2F3LtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 07:49:00 -0400
Date: Sat, 30 Jun 2012 12:48:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: fixed: support deferred probe for DT GPIOs
Message-ID: <20120630114857.GW28922@opensource.wolfsonmicro.com>
References: <1340922692-24092-1-git-send-email-swarren@wwwdotorg.org>
 <20120629012507.GL28922@opensource.wolfsonmicro.com>
 <4FEDCA2B.3060204@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSsVBZHIO2Q9XETc"
Content-Disposition: inline
In-Reply-To: <4FEDCA2B.3060204@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hSsVBZHIO2Q9XETc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 09:30:51AM -0600, Stephen Warren wrote:

> I did consider making of_get_fixed_voltage_config() return a result
> code, but then it needs some other way of returning the pointer, so
> that seemed just as convoluted. Oh, I suppose it could use ERR_PTR()
> to do that; that'd be nice and simple. Would that do?

Meh, or just have the caller pass in the platform data rather than
allocate it in the function.

> Re: gpiolib doing it: How is that possible? of_get_named_gpio()
> certainly can return -EPROBE_DEFER, but the caller would still need to
> check it. The ideal case might be to just do:

> ret = gpio_request(of_get_named_gpio(...));
> if (ret)
>     return ret;

> and have gpio_request pass -EPROBE_DEFER from input to output.

Even better just have gpio_request() just return -EPROBE_DEFER instead
of -ENODEV.  There is no sane case where you'd request a GPIO you didn't
have a reasonable idea was going to be registered at some point (or
could be with appropriate system configuration) so we should just assume
that might happen.

--hSsVBZHIO2Q9XETc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7ueYAAoJEBus8iNuMP3dSzIP/3C8mCJVtNH739AedGbU6bdp
X5EL6/ibfl6YvAHrQ2AHUdavAunD20CG4dF36/GUORnjYML/8GCaTwiZAJjapLBU
uw43g8DgMeHxtYZij8zuiSStlB6yYvZErRcUbobV6EwJZ27w1k+GzVBf7tMMkmaU
6UNSKHmrXEVhOldp6b3uP7mpK8V92WlQUtrdgD00ECivd1PSV0BnGiYX3+t8N2pZ
Bzkykc0pbM6auax7mZyiE2owSCZHLUzcNw5VccLXU+cN4Z6simsJ5WzfXayppEd5
LwWaQfHMky2XDazYpCbVjWJ1Y70KEyUnzY/qms2xQt+lyccuTD1amYITyS/0y3VL
sR6BFe2DXo+F0yYRh7fSLjgjybgC7+AJPtoYc1uFdxRaWSzXlSvJ6lfS3ZJEeLLa
jAROsYKQEJIZOeLWKAR72HZpa0vzLP6ns4y6oK6wOV+PBszv6i0Jxtxtp87/beXG
tjMPlSmYJMYZkhdYbbJEuQyke6lIai9apItlr7r7d9ON4YLQuZRKlc3oh5lf1tI4
c9GwFnzgO3b3W808s/yR4BL7blAS7AG/P7vH5OhDHabFoDdhh+rPAC8XysYBIvcj
3rSNWzGYyBFtyWtgu1HekXJg4ZGQPSHQSBdAKoQZf0Tt9RuMRZqy6OSFWMiaNLqn
usfHZkZoFIXBibvF7dbv
=ApzA
-----END PGP SIGNATURE-----

--hSsVBZHIO2Q9XETc--
