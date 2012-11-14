Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2KNCBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:01:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139Ab2KNCBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:01:32 -0500
Date: Wed, 14 Nov 2012 11:01:25 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v3] regulator: treat regulators with constant volatage as
 fixed
Message-ID: <20121114020124.GH4415@opensource.wolfsonmicro.com>
References: <20121113094255.GW18224@opensource.wolfsonmicro.com>
 <1352800177-16139-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82evfD9Ogz2JrdWZ"
Content-Disposition: inline
In-Reply-To: <1352800177-16139-1-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82evfD9Ogz2JrdWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 10:49:37AM +0100, Marek Szyprowski wrote:

> +	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
> +		if (rdev->desc->n_voltages)
> +			return rdev->desc->n_voltages;
> +		else
> +			return -EINVAL;
> +	} else {
> +		return 1;
> +	}

Hrm, now I can read the logic I'm not convinced this is a good idea.
This will report that we have an available voltage for devices which
don't know their voltage (things like battery supplies often do this as
the voltage is unregulated) and it will mean that we are doing something=20
different for the case where there's only one voltage (reporting the
restricted count instead of the physically supported count).

I think we want a regulator_can_change_voltage() or possibly a count
function (though I can't see any use cases except this) which answers
the question directly instead of layering on top of this function.

--82evfD9Ogz2JrdWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovtnAAoJELSic+t+oim9I6IP/1Oa1xhT7Tqmxt2WKaZdJt38
Qhzidhi14/mfYlfje0ryY+uf3Vaqi3m9i+1lbfF9sliZrLW4lnINHdjbLWC6arwL
CTpG159zB8mz68nU8U4B65ezJvgS1RXyS6s0vQYl73Lq6xVPALM+i7mEkXrbbDtU
Rao/3MMn26LpGpPjojH+bAsp+5ahr3I3VRhFnz+ANgTxBFFRg89e1q5MVo8gFfc6
K8XkXnTIIclh2LrBcxfiXrxVTz1Q11ZEVcJsrfah6gMmdrrX3Xlo/ZNGdd3uJIb8
cpYBUQaPBA+toQgBJcHXvuARaSc1bW+wvlPV5gRz5avbgq3LXtb8PKjpiBcQjXdc
iKD76FRwVePaPMzrRX6Z7kG/37K2luqBriROFLHfrqMK3oOJdtN1QMjVr4gCxg4t
ZvoReTXvLhptxhA/SeP06Yn20L1fkk318bE+EORaY+jtK5PAB87oK7LIyGIOnakd
ml+jp0i7Hxmmzzw9JrE08HEbVKx7lVH93G3Sz94pdhOpGRvjzoqf686KdQ7HmPfD
NESi3lMORFGdSS2WYnurhpcuYcVtvDFby54mUAG3apo42wOUzP2zBUH4LhNqKlh/
EZDaNvNdPbgCrXgamipBMjwxSKnVZ2B38x7KfkjffiBb+x2dHI8997BN5vUL5by+
laklvDPGw1/ZON9SC0oo
=uxOk
-----END PGP SIGNATURE-----

--82evfD9Ogz2JrdWZ--
