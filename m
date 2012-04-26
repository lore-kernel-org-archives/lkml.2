Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2DZFVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:21:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38225 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068Ab2DZFVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:21:22 -0400
Subject: Re: [PATCH v3.4-rc3] MTD: NAND: ams-delta: Fix request_mem_region()
 failure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org
Date: Thu, 26 Apr 2012 08:20:59 +0300
In-Reply-To: <1587089.0XMyH6e1Ic@acer>
References: <1334670557-25640-1-git-send-email-jkrzyszt@tis.icnet.pl>
	 <1335366823.6356.11.camel@koala> <1587089.0XMyH6e1Ic@acer>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-k3oOwJ4TKv7W1YSv5ADX"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1335417678.2290.7.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k3oOwJ4TKv7W1YSv5ADX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-25 at 19:01 +0200, Janusz Krzysztofik wrote:
> Both drivers use separate subsets of registers that belong to the OMAP1=
=20
> MPU I/O device, but are used for controlling different sets of I/O pins.=
=20
> The NAND driver reads/writes the folowing registers:
> - OMAP_MPUIO_INPUT_LATCH,
> - OMAP_MPUIO_OUTPUT,
> - OMAP_MPUIO_IO_CNTL,
> while the keypad driver - the following:
> - OMAP_MPUIO_KBR_LATCH,
> - OMAP_MPUIO_KBC,
> - OMAP_MPUIO_KBD_MASKIT
> - OMAP_MPUIO_GPIO_DEBOUNCING.
> Both subsets are non-overlapping, and we rely on the drivers being free=
=20
> of bugs and doing their job correctly, not stepping on each others'=20
> feet, I guess.

First of all, I think this information should be in the commit message.
Also, some sort of comment in the driver code would be nice.

If locking the memory region is too coarse approach, the should have a
small separate omap-specific MPUIO subsystem which will be used by
drivers to access MPUIO?

Another question - should request_mem_region() be also removed from the
omap-gpio driver then? I think it is more sensible to put a comment
there that it is sharing MPIO with other drivers,  instead of having an
illusion of exclusive memory region ownership.

But this is up to the OMAP community - I can take this patch to my
l2-mtd tree if you get an ack from Tony or other OMAP guys.

--=20
Best Regards,
Artem Bityutskiy

--=-k3oOwJ4TKv7W1YSv5ADX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPmNs7AAoJEJtuLFy+q7feVqkH/2jV+1NPSyd5LOmEm6tnNVsg
eRPO7kv6aJvmDGZToda24f+mOLKSHWsqx8E7HTZ7xmWc9KFwvaFsUBifXCDlBJFt
euwFu+kK7gGZlbt8hLZfZ18yzhs6ULGMZFGxdY1sRIDn/VY8MdPfwO98aoun/rvD
d2iYLd12nhb/dnbHWc5jxix0GvQZfyFUPy9kJkZzaR/j80V3qsQ9qEYR3rdv/bKS
lkj54UI1iPDJWFguxMwiQiHGf0Y97HBD5M95mEaCfdplqbuM4xlY9dgCl6NU97Om
YFBnlY0xHdldDuQM29g4+VCqRh94VVOUzl/E+NnOpm2bNdTgsCO3WyI/KnumjgU=
=+TrI
-----END PGP SIGNATURE-----

--=-k3oOwJ4TKv7W1YSv5ADX--

