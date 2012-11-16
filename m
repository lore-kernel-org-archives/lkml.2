Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2KPBUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:20:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2KPBUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:20:01 -0500
Date: Fri, 16 Nov 2012 10:19:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ciminaghi@gnudd.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] regmap: introduce tables for
 readable/writeable/volatile/precious checks
Message-ID: <20121116011904.GH4387@opensource.wolfsonmicro.com>
References: <1352983612-3474-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Content-Disposition: inline
In-Reply-To: <1352983612-3474-1-git-send-email-ciminaghi@gnudd.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 15, 2012 at 01:46:52PM +0100, ciminaghi@gnudd.com wrote:

> I haven't seen any reply up to now, so I'm just resending the original patch
> (see https://lkml.org/lkml/2012/10/25/224).
> I just applied it to today's next and did a quick re-test.

The fact that you don't send a real name in your patch submission mails
might be an issue here - I suspect you've fallen foul of spam filtering,
either automatic or human, there's no sign of this in my pending queue.

> +static inline bool _reg_in_ranges(unsigned int reg,
> +				  const struct regmap_range *ranges,
> +				  unsigned int nranges)
> +{
> +	const struct regmap_range *r;
> +	int i;
> +
> +	for (i = 0, r = ranges; i < nranges; i++, r++)
> +		if (_reg_in_range(reg, r))
> +			return true;
> +	return false;
> +}

It would be better to make this an externally visible function (perhaps
just move it into the header with a regmap on the front of the name) so
that drivers can use this as part of the implementation of more complex
checks.  Otherwise this looks fine.

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpZSBAAoJELSic+t+oim9gawQAJ3K04kSaP8t4nR2/EP3AZIp
XoIp9ytUngCb3iiLVM5dotR8lgxj2W3qCqhpbdRJlQVJzuI0trmT/ZZRGg2bP9+H
LfWbF/pK7lMb3eJwdXv8/4inv7P3Ww5mCmU6wcCA06NpkSR5mCOuU6DcsvyAZUOR
Jq2MgrnxwrNwjoE7NVubufmDtawmYHBo9DsYqhgHsyxUdSB+g3yjjU3zAcmo0V2c
QgGsfy+C001js1a0S4iw7t4dQPfpsvRz2/MLyXrXihFSkbraUxmzK8zB17UVrPxc
rzTRvsXJ1xo5XA64mUVrn+exHobL0mV0KJ9R6vCkEs+e0B1Xaj5Udc72gxSxYIBH
OBP+BSl/EPkI9gHbuZIYBEJosopaoqkp/c5YjAeKSEEvKfG3SC1HG8g97w6K/T8d
Y/HhvOv/xlsEtBLqrO/jkAxWEKWUQ3VAgRiz8zadf03scLyeFSjjQ71eJ36b3X3D
OnrmV4tC5tcUV/V76hylwQ1aPFVrCQEEHZ7sf0dUtbbrd/s7fvzImh8/wvqtr7Ze
oX1LAmBWjVUnOc/qYu/fKv+n7J4/YU8qHKfmToD5/Zaf92eNeF75atxVrxuItGO1
QsvhneWqxIzh8pJdMjTt9Q7Q/RlDPLnirsa6Uekl/TYZf7aHVTNH/shZ9wBT54qz
m+Vp9cSbzDaupTWOLQVp
=O60I
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
