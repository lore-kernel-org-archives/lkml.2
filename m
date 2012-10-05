Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2JEWVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:21:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36745 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2JEWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:21:21 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
In-Reply-To: Your message of "Wed, 03 Oct 2012 09:23:36 +0200."
             <1349249016.1414.55.camel@x61.thuisdomein>
From: Valdis.Kletnieks@vt.edu
References: <1349000155.1553.27.camel@x61.thuisdomein> <20121001100321.GB4360@opensource.wolfsonmicro.com> <64681.1349223065@turing-police.cc.vt.edu>
            <1349249016.1414.55.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349475644_2935P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Oct 2012 18:20:44 -0400
Message-ID: <59004.1349475644@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.506F5D3F.003E,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349475644_2935P
Content-Type: text/plain; charset=us-ascii

On Wed, 03 Oct 2012 09:23:36 +0200, Paul Bolle said:

> By the way, GCC doesn't warn if I add an early check whether 'val_count'
> is non-zero:
>
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index c241ae2..d41527b 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1171,6 +1171,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>         unsigned int v;
>         int ret, i;
>
> +       if (!val_count)
> +               return -EINVAL;

> That is another way to silence GCC here.

That's probably a preferable approach - that way, if a bogus val_count gets
passed in, the caller will be informed of the fact.  Which is a lot better than
just papering over the warning.

--==_Exmh_1349475644_2935P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUG9dPAdmEQWDXROgAQIb8w/9HLCLQ/Vlqdc0uK5Qjs5MQxDUKGrvWjNz
gwOXcCIRvxIKRk24EfhBJvg5dVqxVKluiXK6+rT51dRfKoqXKsVkzd4oSP2x7OSs
Ep5wGgJsqQdvDNEHK4+riC8t70yV1gjcMFfF8pEvxkyzxHvxGMdP8aAHzEFVpCRw
6zPsNuNtui5gqLKkiQVwTZJM6pvGpSEYTNxw0Yo3uUesP7wo/oDAnGs1yJXDFoVS
xMUpo1ZJrGPvosWrqniaw/CJv+HLWzxDONGVN6wB63Iv/bEVCWdtePseQqcSqO1q
KE4/xGlP9L3TT37F5hp4aA4CwHiUL938ivuNQfpzAU+M5K52mHzdBz1e9VSkOlNX
7ZMgOPActZCnTnDcEUaXIKwNDPzBhG2emM36YPxmpKYPyDGkGBu4o9ae0UUgGK1T
getn02U1zGNMARpMDz8oEXwbG7cfDBu2CTkNBNfetfYItY0EGywxPKsyoXrzzQ8m
ho3vgtk/E0XEQs6hSyroz++ZRgZaz2lnwj52BNHxRYP99UFrXHdYJLbHm+5AGbB1
cG7nDBDPx+cHz8vUM1xmweN+daQnN5NHM5iXzCrkI1GQEh/cXZJW6UyBYSlHdtgN
yFU2K6UVHwG24wq7HkQAYEGsntJhpYXQhFWdlS1IL6gzs3PISlNBoNQNRjBjzath
vAnpCoEt3ps=
=uroW
-----END PGP SIGNATURE-----

--==_Exmh_1349475644_2935P--

