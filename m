Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2BFLhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:37:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52170 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589Ab2BFLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:37:22 -0500
Date: Mon, 6 Feb 2012 11:37:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Message-ID: <20120206113720.GG3070@opensource.wolfsonmicro.com>
References: <1328370879-18523-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120204170632.GA3615@merkur.ravnborg.org>
 <20120204174115.GX889@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpAOPzA3dXsRhoo+"
Content-Disposition: inline
In-Reply-To: <20120204174115.GX889@n2100.arm.linux.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PpAOPzA3dXsRhoo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 04, 2012 at 05:41:15PM +0000, Russell King - ARM Linux wrote:

> What's platform specific about asm/gpio.h is the number of GPIOs in
> the system, and whether it wants to intercept the gpio_xxx() functions
> to provide fast access to on-chip GPIOs.

Plus the fact that it might be a completely non-standard API, and might
totally override the gpiolib implementation.

> What I'd suggest is moving asm-generic/gpio.h to linux/gpiolib.h, and
> making asm-generic/gpio.h include that as a patch until stuff is fixed
> for its new location.  That should result in a proper asm-generic/gpio.h
> being:

> Alternatively, instead of linux/gpiolib.h, put it in linux/gpio.h instead,
> but that gets more icky because of the mess of asm/gpio.h includes (which
> I've been banging on for years about in ARM patches and they're _still_
> coming.)

Yeah, though it is a bit neater if it's all in gpio.h and everyone is
using gpiolib.  Perhaps something like the warnings I added on inclusion
of asm/gpio.h without linux/gpio.h would help, though I certainly
wouldn't expect it to solve anything.

--PpAOPzA3dXsRhoo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPL7tpAAoJEBus8iNuMP3d12YQAJa6Z9EArDWj12yuaVLeGewd
3nUgd+GTaayJJo+I47NOMHevebKyErQd/y68c3YWmVXZdOi0kKZCLEupFGh1jf5B
V5EphiOXY06SsHqrQXy67US1Mpf4ms2MQozBkvCEkZoF2LkwdOoZj9TCutnwquQs
UD7SkQ0QQaIRehc5Y4+XM7KseFcCmyvK/mqEnRGfE9xNIln2JeStF3yifdjXeOzj
+6cHi9pN5Tw25mVARelZZmx7vCA9rAoNC8tVNWet9GtOWNRiEVbBlGoNeukeMdUT
iYgPCeX/IOYBivJiULQijvOMAG0FfNr3DmrAGVgeSGPRPRILX53RaqsVDXT74zme
CFFuz3BhtGpE8WkjiLAPNd84I8IGsvKgQKX/KQhatUbxjf7HvfAauJ2YxFEpjNps
5UDmO5MfgsEAZ0zZXPfi67/kXjuhkPJ4PzYiwIE9MvWjLlWdEhEqmrPYVVjRwge8
nZR2P9oJRMj5k5pQ1gwe37fgabFwXe09JR1K4yKT5rpaiihiEX2HfU9I8Gm5kJGY
+TQv44fnozuKj+i6SSgiDK2ljrnlZMAO8XCSemKOHtSoi67Wx40QOzw87QBMGw6H
p5MDrmcw6Z1J65uXiJJTzf+FSkVc99RogMEL8nhIROIVv91TxR17/m1QPRMiVzvM
WyCUwqMjTqqMAqum/gOz
=ZpPo
-----END PGP SIGNATURE-----

--PpAOPzA3dXsRhoo+--
