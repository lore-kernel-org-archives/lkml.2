Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2EJJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:09:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56913 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756764Ab2EJJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:09:13 -0400
Date: Thu, 10 May 2012 10:09:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ola Lilja <ola.o.lilja@stericsson.com>, Liam Girdwood <lrg@ti.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120510090910.GD3908@opensource.wolfsonmicro.com>
References: <20120510143329.4cef3cd78ce5ea55416b1d93@canb.auug.org.au>
 <CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 10, 2012 at 10:30:50AM +0200, Linus Walleij wrote:

>  menuconfig SND_SOC_UX500
>         tristate "SoC Audio support for Ux500 platform"
>         depends on SND_SOC
> +       depends on MFD_DB8500_PRCMU
>         help
>                 Say Y if you want to enable ASoC-support for
>                 any of the Ux500 platforms (e.g. U8500).

I applied this (without your signoff as you didn't supply one so it'll
show up as my patch, I'm not sure if I'll have time to publish the
change later on today and want to get it into -next tomorrow).

> But it seems it has a wider dependency on some MOP500 board
> stuff being merged first, which is more of a problem I think, part
> of that is pending in the Ux500 tree.

If this has a dependency on a particular board the driver is badly
broken, this is the driver for the SoC I2S controller so it should work
with any board.

That said in terms of applying the change the arch/arm stuff shouldn't
be an issue - it was just registering devices and clocks.  The driver
won't load until the two trees are merged but that's not an issue, it's
not going to run anyway if we delay applying it.

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPq4WuAAoJEBus8iNuMP3doAAQAI+HRRldK099G/2NkiomEvOB
DiIexhRYKz0+bt3vU1K0KvSspG6/OziUx5w7tWNaIYvcQ1b5y5mqes2SMmLbxoU0
xw81L3x7uDPvEngHZUGVwQltyZg8YnG3LLmSw/Wi17PYYPzUakDGQRQf270z+v3W
8mW429EzrrnrIvc16YyZyDBNxpyL/4gGZ48AxGEIaWTJ/u1KDD9DjFIvi1LO4fYD
jKTDVQ/ltJ8Evky1j5uo+VcFRKGC+Es1oUjNUH0d9YF5jBhSh8asA1mkhEXeiFPm
3ZkYy3B2hSksurh1KOCp6sHdu8ST/Jwev+tHKw6BvAbjZuNxUg8e9BR5WC+9qJKy
CdQ6qCK2Yn+AEnfeH0UxcbUFEEDczkTE6It1U8lEZ0CJ3zJSpsYj6UNXzkdjjzmW
uBOnl8MpchBqO4lCTZUbYNRSRY6MEzD28j6RAmmH06Sn7YpaG915PWPXo0Jwr5oN
bkVfWe8SVmpO+gg0fBrW5fNSze/sTccnLsU92sgEYcF8X3eFo6rP84vlEl/okfH0
0TJ6CRmROemHkdu5zciooYJ3K8yXXLne3P/VDbRA4fG28x8Xuk6fSalXhALhxqUQ
dmN3cLy+v3x/XO4dz/SSgfPBaDLDCCDeX2Dsx+3cYr1EqnEqHbBuZrz0Py7WXYqD
v6dlu/M7Tqf1XTjMoj64
=nd72
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
