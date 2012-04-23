Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2DWKSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:18:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36894 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619Ab2DWKSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:18:09 -0400
Date: Mon, 23 Apr 2012 11:18:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120423101804.GA8318@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2012 at 11:37:53AM +0200, Ulf Hansson wrote:

> Regulators which has boot_on constraints set, will now remain
> powered after regulator_init_complete is done.

This would be a bug.  All boot_on means is that the regulator was turned
on during boot, the regulator is free to vary after that.

> In this case we leave the enable->disable operation to be
> handled by the regulator consumer instead.

Which would be a bug if the consumer wasn't the thing that took the
reference to the regulator in the first place.  Remember, regulators can
be shared so the consumer can't disable a regulator it didn't enable in
the first place (unless it used regulator_get_exclusive() but the use
cases for that are a little suspicious so it'd be worth taking a careful
look before using it).  A consumer can't tell if the regulator was left
enabled by the firmware on boot or if it has been enabled by another
consumer.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlSxTAAoJEBus8iNuMP3domkP/1LlZmh3V+NPnsCfxEE5AhkI
IWXvBl9l5YEmZhBZ5FQNhq9QEvIcdMkHw/hYDAx8w8Gni3bmSS7ot5hcBEUFCN54
er5qxzj7ZUeLkKp278iKJAC7iOOP2mYLg81dxFfMOMU9G5iv/t5CM0PATa6qZxae
3NmNFZyfYs/LnynLQHKb38FrrRTmMtbITCHdbrZOgCeQV9Ffw9H1yRNgDug6KETw
HBT9lyemjZzQU0RxGvBxbpYW9hcTWOJC8c+5rp3+vHrWxcpLAltpr56MYRoXgLxb
7JLrNrZhI3yDNAFgg6+N4qqff5ExmgshgcBBrXi3u9uMFZKjoyb3BFOL8x0KEmOY
9b1NPFlqvDiH9JKfiR35eANrGqWkU9VPbTlL9gmzhAN7ItHraepgp4/Mc0GNiER/
iP7+pOcFY4O/f4WF4vpRtH6tAPJyzIBI7NHWlhhJRcpqmS9zmqvGkMAFnB9QG4g8
l1glowu81iztNeIw4FYlTJ8H0klbwWCsmw6sjzz5b7RJehwKUM5eRWkk4CDWla5A
fvhF/qDgEBhVReR77zLFPsJ5lui/xdYFmbfq4J91xs50QzJsCHT1oddMGnzl+ZwD
ir3QwQxQ5tWGoqB+i3tdTmzME6f415UtJrzNy+SrGwnAGi5Dmsh+/7azLoGEqn2w
mEwUcsv81kHqb17nIFuQ
=5lNx
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
