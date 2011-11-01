Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1KAGA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:00:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55193 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1KAGAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:00:23 -0400
Date: Tue, 1 Nov 2011 16:37:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the watchdog tree
Message-Id: <20111101163748.26d5f1264b56961e36ff0ced@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_16_37_48_+1100_QyHcbMa1e1qTCjx8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_16_37_48_+1100_QyHcbMa1e1qTCjx8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

After merging the watchdog tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_start':
drivers/watchdog/wm831x_wdt.c:56:40: error: 'struct watchdog_device' has no=
 member named 'priv'
drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_stop':
drivers/watchdog/wm831x_wdt.c:79:40: error: 'struct watchdog_device' has no=
 member named 'priv'
drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_ping':
drivers/watchdog/wm831x_wdt.c:102:40: error: 'struct watchdog_device' has n=
o member named 'priv'
drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_set_timeout':
drivers/watchdog/wm831x_wdt.c:144:40: error: 'struct watchdog_device' has n=
o member named 'priv'
drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_probe':
drivers/watchdog/wm831x_wdt.c:215:12: error: 'struct watchdog_device' has n=
o member named 'parent'
drivers/watchdog/wm831x_wdt.c:216:12: error: 'struct watchdog_device' has n=
o member named 'priv'

Caused by commit 5b04099edc42 ("watchdog: Convert wm831x driver to
watchdog core").

I have used the version of the watchdog tree from next-20111025 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_16_37_48_+1100_QyHcbMa1e1qTCjx8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr4WsAAoJEECxmPOUX5FE45kP/ji2AdhaiQ7D7xMl6PmxOEP6
oU+56F17RV75+z7pl8B6FzowZSG4x7mcwgtlRAEgeKXKWjwMxxK0vDoQgu9Xd6Q0
pdYU0guGJg6vsF4riHtT9kvznQEbueyeRkeSAwskH2dckw/sVjYFZs6D+vuv9SJt
nbhuoD9iOxLfRfIAooOMFLBE6k3rhNTK5yDMJuAJvmWr/YAkqDq1lKOvqCx5YFCm
uo7385bCX8GNsO94l8h2gt+2qdRRaYcG8VKqWpPJXosPRaXVm88JYgWtLb6NkhUi
znsgWxqe0bwKM+CcMnWEnWnpDRCl77MtTNH2p1iGC19jxODsTQdTOfAjWpaH8rLW
h1l1JbsFaxEFju6V3vRTuo4xfy8eobHNMO3mgMviA1mY3VYJcQRCUqRmC7d3QmCP
0JkijkfdVbYvAgUWuZxgzJzcbip1xCOxJJXrl2ei6VQTVcGEn5E8ZsIy9+qvFoA1
2d5AiMLK/xwHaj6vdgnt7LMgP7NSSJ/th96PV0ueArJWVS37axDIY76uN/jnVjv/
xNkiRVGZEPRcENuXfHtsYwh+393kgKmyHkrW6swwgm2kJ5OPWdjESJ/E8b+gvExJ
epxK5j//tXGD3D5tizY1OBNxECd+HgpZhdpORl9UpKnxt7LCJordLqsh8vL/qdW6
SyI2iuA4VhSIKPwof6Ab
=k834
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_16_37_48_+1100_QyHcbMa1e1qTCjx8--
