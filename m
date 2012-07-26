Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2GZLKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:10:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47665 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab2GZLKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:10:33 -0400
Date: Thu, 26 Jul 2012 12:10:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lrg@ti.com, balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: regulator: add error checks for exported
 APIs
Message-ID: <20120726111030.GU3099@opensource.wolfsonmicro.com>
References: <1343298603-25442-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qKhyKP9HH88saeqA"
Content-Disposition: inline
In-Reply-To: <1343298603-25442-1-git-send-email-kishon@ti.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qKhyKP9HH88saeqA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:00:03PM +0530, Kishon Vijay Abraham I wrote:

> Added error checks for exported APIs in regulator framework so that
> incorrect use of these APIs does not result in a crash.

The commit (especially the subject) should be more descriptive, it's not
that we're missing error checks it's that you're handling garbage passed
in from the user a bit more gracefully.

I'm not sure how useful this is as-is -  if you're not checking your
errors you're not checking your errors so it's probably just pushing the
robustness failures around, especially since...

> +	if (IS_ERR_OR_NULL(regulator))
> +		return -ENODEV;

...this is too quiet, this should at the very least be generating a loud
warning so people can see there's a problem (probably with WARN_ON so we
can see what called it).  Can you respin with something noisier please?

Also NULL is a valid regulator (though we don't use it right now).

--qKhyKP9HH88saeqA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQESWcAAoJEBus8iNuMP3dOe8P/0afMkWWPp0VUGGlkDjLTH8l
y6oE+nrim4YNy+bzX+ZMRdww+5HAiYk4B9xIDnCuXtmvbU5PL99jr0+dXFMFbRpC
XvfcmrYltXenGy3njhcyhT4hsLR/mLZNAixb/fCUHghouTvSjA8oyyKuwc6F6QkF
+9pm7DANhBkKhqgMGjXqRJYqcgAXlnpFFgq9TkliHEWXzm5PKebtq9iUVD/zfowv
1Yo2AEW8PqwDjZE3sgq86XdKxk4my6HPSi7W44OrhyzJ70GZNEJ+543UyR+yr2UN
kgiJfj6C+O29Ke+4t0lyYEgSzBqqJ2/NqrblAx1jkaCXnCilzZRVYTq4PQ2ZprF6
sNQ6bDfRj6OlyQA17BYJbLUiI699sbiWRMpHVpi3ZisSkyrHbhzj2YptShnpdVNS
qMXBcQXaxE74ShXScuSdvbnN/Xp+eeM2TKsTFBlZE1AMddpvtPsLiNuxQqs1ZGUD
WhauEKkKcE58BSfiBn7Pad3y1yRne8JHabvPLGlnyJnQCINGMYUWDDCjKqMMolAH
I6RWdKnpGMRDYm9k5eLpv5cTYI1/a7GDGQxb8Ed289ebfpvRiJhP+bP8WDfIjcMq
Ucgm4pfCV7Luz0n0TthzPUsHrX498SnOXiwq2sItTkgMS0+rWp6MeRumm9jXMF8c
OiklbL5L2uSlVsH/wnYA
=gX2l
-----END PGP SIGNATURE-----

--qKhyKP9HH88saeqA--
