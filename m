Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1KNCRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 21:17:44 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49997 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1KNCRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 21:17:43 -0500
Date: Mon, 14 Nov 2011 13:17:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, Tejun Heo <tj@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: linux-next: build failure after merge of the pm tree (and warning)
Message-Id: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_13_17_30_+1100_Hot8hA3DDEbwFGV2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_13_17_30_+1100_Hot8hA3DDEbwFGV2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/dma/dmatest.c: In function 'dmatest_func':
drivers/dma/dmatest.c:255:2: error: implicit declaration of function 'set_f=
reezable_with_signal' [-Werror=3Dimplicit-function-declaration]

Caused by commit cd3bc8fbc2d5 ("freezer: kill unused
set_freezable_with_signal()") interacting with commit 981ed70d8e4f
("dmatest: make dmatest threads freezable") from Linus' tree (merged into
v3.2-rc1).

I reverted the pm tree commit for today.

I also noticed this warning:

drivers/dma/dmatest.c: In function 'dmatest_add_channel':
drivers/dma/dmatest.c:594:28: warning: the omitted middle operand in ?: wil=
l always be 'true', suggest explicit middle operand [-Wparentheses]

Which has been there since 2009 ... I think points out an error in the
code (looking at the lines above there).  The two occurrences above were
fixed in commit f1aef8b6e6ab ("dmaengine: dmatest: correct thread_count
while using multiple thread per channel") but the third came in via a
different branch (commit 58691d64c44a "dmatest: add pq support") and was
not corrected.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Nov_2011_13_17_30_+1100_Hot8hA3DDEbwFGV2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwHo6AAoJEECxmPOUX5FEW44P/A2ERJmKCS6N00Y3JTovtnlH
ixloiIABW6N6p29zLTFQoIt3B9n8MJ6xzWoycrTJtAaKekO0ydKUd6ktmOyRTZZj
Tnm6XDTKq9cnELAdqiHLU7ZhGAcR5MPK0WWYyEPmG8SC0asVONkd0I5BR1i7kZmL
vektjHbhpH3O2ixb3iLMfmuJ+nXbbGzFfKyP9ziL0745vTk0DrMcnWXgPYcEImq1
exNx5hJ3wE7B36A4jNIzQuHiNgmXgGRGZlgNIsW9LXlT9vnl6Rx1JBrDcnYag3fW
5TPnseTwbT2Q7aS0b9qU4HdUfh3FfuCkpRts0V3ugPCcd1/PHkbpSLF/FxVnbETg
CnLsJ8rAhVveu6N0aRBl45MYBkq5qGeq53ATWsZF6H/eNjwpU9lOOZ6TqRHIAXVC
bMvy6pothtqd3eKM73IZnAM27BHcl6MNz72k9JKd7JUD/D9zPF5Y4BD8An9QV/58
dsWbu3Bea+rgmxYkFaBDIECmW58yfJKj0RjkGgTr8KaVWhw6x1+IeJK2KXyBYBGR
qKCnvuMGy+klk6SxsYzusZ2lHgDTqqfv+Koe98ItAo5vv5+9//wicQJKTrGOqilr
05mAgk4e9qWAHI2Q4/JFQceODflHpU9raz/5NGLbSQtw70S3L6x5v9UrISJXH0FW
oiGRVN2mrgt76Nzvz2Z7
=EDod
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_13_17_30_+1100_Hot8hA3DDEbwFGV2--
