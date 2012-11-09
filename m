Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2KILDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:03:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54679 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115Ab2KILDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:03:31 -0500
Date: Fri, 9 Nov 2012 11:03:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: helight <helight@126.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] fix build waring: =?utf-8?Q?dr?=
 =?utf-8?B?aXZlcnMvcmVndWxhdG9yL2NvcmUuYzogd2FybmluZzog4oCYdmFs4oCZIG1h?=
 =?utf-8?Q?y?= be used uninitialized in this function [-Wuninitialized]
Message-ID: <20121109110329.GA23807@opensource.wolfsonmicro.com>
References: <73729ce5.abaa.13ae480da6d.Coremail.helight@126.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <73729ce5.abaa.13ae480da6d.Coremail.helight@126.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 05:29:40PM +0800, helight wrote:

> -   unsigned int val;
>     int ret;
> +   unsigned int val = 0;

This sort of change is really not at all helpful, we should be making
sure that whatever path should be initialising the value but isn't does
so, just initialising at declaration means that if the compiler has
spotted a genuine error we won't fix it.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnOLkAAoJELSic+t+oim9Ar8QAIeyg1TPSUeZiLVub9q5xP5n
QdmrIdqNjM+LbSfzh2NJxv6A05KA9pO7xjW4Mv8+JSDSweRFGB8TQHR7t3KL2fLj
nLPjD4E13pPA4gVFV1oCN6pxJKGsMlupiLJXMiRcklak2L3CNCRFqOkvt8qwF5ov
XuC7FuuVwq45fHF5iqnjTQ7YRvo91OoJ3Y5s9VyuRGmVo6Ef22bGKYNYIDvG3tQJ
th5RKHkeAgI2PuPI96c+P9TvArFPYjh9SMHBMVlOeS4jaISY/RKebv0ckmyYeilB
XKuqINrfcEieSxUQMYc1p13IvxVI08HbB1pywzOb4Wmnc6c8HKYnEhDoMKFJLTLV
ph/lpwHbdXq9ei5EWnizjsRWXkgTVlenvHHQoWvl3B/EdbIrd7TkDPZm3IkXpkYf
tBZV7CxfGxD1hWmlQOM3+O4WTJG1mupehCjw0oEzx8N7jYvR0fjtvDpKfALrM17Q
kFxNO6YPn34+p+T/GVJABEyYfo3e5zOGZhQp+Gzvyfs/S3m5XfpFl8jqjaxS5Y1O
ODvbMR7C68IMcN5tVv191I+0HqRbrnkOj+Jnup+iKeITLE2ugCw77kuiyDFjZBzD
2IrAAY2K4awaUwluW/KVCuLCDDsFiARwqGTKRq6PF9EPakh50d5nF1VCt3efoNvz
5ZVjjJoQ3fgZa/xnOLwQ
=9YG3
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
