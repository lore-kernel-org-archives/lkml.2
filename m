Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2EHHAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:00:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:34337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab2EHHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="141274423"
Message-ID: <1336460605.23308.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 3.4-rc6] MTD: NAND: ams-delta: fix
 request_mem_region() failure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        linux-mtd@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:03:25 +0300
In-Reply-To: <1336423897-31729-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <20120504171125.GD5613@atomide.com>
	 <1336423897-31729-1-git-send-email-jkrzyszt@tis.icnet.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-e6v+0eKZGKcV0XmYP3Qw"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e6v+0eKZGKcV0XmYP3Qw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-07 at 22:51 +0200, Janusz Krzysztofik wrote:
> A call to request_mem_region() has been introduced in the omap-gpio
> driver recently (commit 96751fcbe5438e95514b025e9cee7a6d38038f40,
> "gpio/omap: Use devm_ API and add request_mem_region"). This change
> prevented the Amstrad Delta NAND driver, which was doing the same in
> order to take control over OMAP MPU I/O lines that the NAND device hangs
> off, from loading successfully.

Aiaiai found out that your patch adds this gcc warning:

---------------------------------------------------------------------------=
-----

Successfully built configuration "l2_omap1_defconfig,arm,arm-unknown-linux-=
gnueabi-", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/nand/ams-delta.c: In function 'ams_delta_cleanup':
+drivers/mtd/nand/ams-delta.c:285:19: warning: unused variable 'res' [-Wunu=
sed-variable]

---------------------------------------------------------------------------=
-----


--=20
Best Regards,
Artem Bityutskiy

--=-e6v+0eKZGKcV0XmYP3Qw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqMU9AAoJECmIfjd9wqK0sB4QAIH5VWPQ7iL0ZgpR3BwS1R8w
B3HSyXrvrIJjdmsDDzmi7Ajf8AncDMJMeXjbf/har/UsunS2K76ADhSeMmFWgGmC
K8daNbkve+Mu3qcrsy2mS2Mn5CrqcW9CT6Ih0/1K3JoddlirpjnpnOTI0RcmwFlA
5tOngtIlgA2ESHoxJiYtsykkbnsr/wGqzCkuagl7fUSUtKb9eoU/qshIbrx4dOuo
/Bi/+wQsAz3zPP1HOHaQbHn3HgVPUB82A/026850uM9yfH552nRLTAp80Pj+DLPX
w2IuGou/vZSrd3mYAMscM33/G9MUMn+33FVqs/sRPU8pLqX10/HWl+uBz+P9T6Zq
jSQJR/uQvXhBt4/b8QmHmhRuqxQ+VPEVLdtRv7WzXJ7PNme6PQckQIEZQX1HQXgM
DsxJhnYkkCrBZWjmfWsxjT1Z/Eyr/qxGuQJPaZpmH4jkQn5S4RQrfx3DaeO886wA
i2Y7V4PLfvandMa0TzYl5dzU/1Gc/FgLjptR3fEm5pC90hSfUh+ooUkrMdrTVt0y
R9OQtpoFYolG5ZsxaacVhKL3kVFRQWMeUpzvK6mN3WyZd6MLbqF/9jIAcC65g82k
WHwvc9ezcxH1d+3GHwtLD0c64HWwoF0wOGVheSNtV5M07WPcoidCanWFl+lDtk1x
B4gIcAgtAbRVuCEw1o7j
=eXKD
-----END PGP SIGNATURE-----

--=-e6v+0eKZGKcV0XmYP3Qw--

