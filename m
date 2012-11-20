Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2KTLIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:08:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab2KTLIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:08:53 -0500
Date: Tue, 20 Nov 2012 20:08:47 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] regmap: Add no-"bus" configuration possibility
Message-ID: <20121120110845.GI10560@opensource.wolfsonmicro.com>
References: <1351988297-16145-1-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mtfogggI1YmpIpmy"
Content-Disposition: inline
In-Reply-To: <1351988297-16145-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mtfogggI1YmpIpmy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 03, 2012 at 05:18:17PM -0700, Andrey Smirnov wrote:

Sorry about the delay - like I say the patch was unfortunately sent
during ELC-E.

> This patch adds two callbacks to the 'regmap' configuration which user
> is expected to set with their implementation of read and write
> functionality for the device.

So, this is where I think we want to end up but a couple of high level
issues I'm seeing, both fairly easy to deal with I suspect.

> +	int (*nbstr_read)(void *context, unsigned int reg, unsigned int *val);
> +	int (*nbstr_write)(void *context, unsigned int reg, unsigned int val);

One issue is that I find the 'nbstr' name totally unparasable.  It looks
like some sort of string or something.  Just call the ops reg_ and have
done with it I think...

The other is that rather than have special cases for this I think what
we should be doing is refactoring the code so that the existing bus
based I/O fills in these ops.  That will keep the code more maintainable
in the long run since there won't be magic special cases that don't get
much testing or can be missed when doing updates.

--mtfogggI1YmpIpmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQq2SwAAoJELSic+t+oim92GoP/1kqz59S6oGQdDqYjWQksU6O
H1GlvhgB7kV/M58Sn7/SeBUlbyBE8Ztevfx/YP4/f5x7EGoZRE4OLiPHX07ynz56
5NLlTwC8quCuV0mrIAqyeuuYEXsqPJwNWVKd+xsb1hWS+14xaqFg4NR1KmMJCONB
vukK2cHkJgUdQ56/EKJaU19vX51JjLeUCMWn7/DHfO8qc22iDcW5Ml79kaWLOESz
/iewBeL44bKGnlDLerUBcyK6gwRjRDg5WnHSrYT3kB/Qq5toQ1pUDseZ4/AVv8t1
48Q9+ihS7jYQgFw1DvPtacyZRZQlUlwqEhxnjimQuxiaKWz0BGmhE0tsEO0cGDaD
BB3LQ2HD3p0Iov3Aq1k7npmaInA5Froc7bb6PO5XNJZIi0Z8YU/X5YdA0HlKDdZg
pO0jqDm0qcbp/N7eqDqbxZu89mAuJfIsn0hAC9DEt94CBUcNeGYT2LQX350Wc8V1
pdx6KYDSJu0a2yIbUaTkqi4eKe89aC1VaauF3Y4OeZ0crGDECXs3z/0VpCgQS68e
bE0YXq7hbSiUHuivmCyePJHVrgFqG2yaijCiomfAJjLC3zreATY/9fGmxOmfKuwe
+hO4E3yR8yEAsFZcxmCoh3IEkyHpmCbhriGCIbxzkbMPc/NnEZDJQMoY3EE5u4Fm
XcEfUrTbLlvaMJFnLaEm
=he0B
-----END PGP SIGNATURE-----

--mtfogggI1YmpIpmy--
