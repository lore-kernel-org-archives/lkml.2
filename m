Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2I0L3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:29:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2I0L3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:29:16 -0400
Date: Thu, 27 Sep 2012 13:29:11 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org
Subject: CMA broken in next-20120926
Message-ID: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tvmnC9JzNV73/q+gyDCcIPVN5fKDHRn2h31FwB5um2f
 LCrh+pMyzSpTW/TRoM8mJ6iGON6fAe2FJrNk1QPcrcKBObonvC
 YM59/jvkP49DGjeete7yqCR9GcbhucP5ZFoTCzDHu1WxzJj/W8
 cggryahvUXvayanHe3q7rMWeZpIwxNXC1nP8ZbAlxufTU1FuCz
 uscjvRP+iVkAa7XnYcqkBZ5M6rb7HxXqKIMBPmEjNz7Z+zhlDJ
 US3ddljpMOnexICrFED7AU438nSjydlNLXv2/ypcQstwsUa7Zs
 LdDd+sFPJahI0zGwkV6K1fLLYTv8WPK858r7Ef0jdYr5g5K88Y
 eWgL7+bzO1tv4yDZ+KcYKfbnDftroc9LoSwAIScyPN8IfcN9SS
 CdkL1mHsjh9ZsO9TZeSMN2ZB4mI65/qw6qoPqbaHT9mxmDMV6K
 CiaNN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

any idea why CMA might be broken in next-20120926. I see that there
haven't been any major changes to CMA itself, but there's been quite a
bit of restructuring of various memory allocation bits lately. I wasn't
able to track the problem down, though.

What I see is this during boot (with CMA_DEBUG enabled):

[    0.266904] cma: dma_alloc_from_contiguous(cma db474f80, count 64, align 6)
[    0.284469] cma: dma_alloc_from_contiguous(): memory range at c09d7000 is busy, retrying
[    0.293648] cma: dma_alloc_from_contiguous(): memory range at c09d7800 is busy, retrying
...
[    2.648619] DMA: failed to allocate 256 KiB pool for atomic coherent allocation
...
[    4.196193] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/arch/arm/mm/dma-mapping.c:485 __alloc_from_pool+0xdc/0x110()
[    4.207988] coherent pool not initialised!

So the pool isn't getting initialized properly because CMA can't get at
the memory. Do you have any hints as to what might be going on? If it's
any help, I started seeing this with next-20120926 and it is in today's
next as well.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZDiHAAoJEN0jrNd/PrOhsVUQAKLGabYy5yGw6glae+q6hIG/
XoPKR3WQW/UDBOX0rJo2PW9z6I+jeAydqQ2Z1nEN1C9JiyhdZv6oMAk7NXBd56F+
GjQSeGhlFKrjqtEGidoaExm5c0VOKb+FFTFXI5kYpqmawYIqevUsi8GQKSJTRToE
Ozl39Lzk6FFiYii0bjgm7KHMiWW0TydvcIGBiUrN9A68NJpb6nPuTP9Q2Kbjs0ej
SxRlKkk/xQu7fnFnV2nppVUVauR2Gv3+tWIqXrfPbIWtvzBpnj9dkI+FI+wmB9dP
avK7dsYV5MIoMPRIG93bdfjvujg5m4sKbrvkwwfGnNkioMBQJF99bdIxZdB8o++9
NR6ns/+jIV0JnaLem0lc8E0/VN5rPYfVDZNirfVwqD9vQxl62OlKVzlfCGBGstWd
il0N0D2lD0/G1mPDgsDiVCzmTQPHQkeDWmClxhnPnBM6FshOiyFJ7Aq7rW8f5HUM
oc/0lQSUkqu9+L++I/smTqVuPhtfaZ3zHpg4Fmwkr2xJ5M/2RT8Dg6BPzgLQa5Qy
ddR4rpsFPm3g0GUkzhDBoMjpe1xJSeSymzNOHCVigxYfzMW4xBnxTAgnoLF6JVcJ
bI9K6zV7nD7s0vFgfbyEFoUKEPnaabc5vRvRgWQROCfGkdurqo8KtUlOKLv+j/wZ
61WEuc+MegPL7StZyr6e
=xCJK
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
