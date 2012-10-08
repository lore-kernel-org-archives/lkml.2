Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2JHACS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:02:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38683 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2JHACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:02:15 -0400
Date: Mon, 8 Oct 2012 11:02:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the thermal tree
Message-Id: <20121008110205.1e0abbe228186fcf30afad74@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Oct_2012_11_02_05_+1100_1gWC8GIGM.CwzHLI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Oct_2012_11_02_05_+1100_1gWC8GIGM.CwzHLI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

After merging the thermal tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/thermal/cpu_cooling.c: In function 'get_idr':
drivers/thermal/cpu_cooling.c:89:14: error: 'MAX_ID_MASK' undeclared (first=
 use in this function)

Caused by commit 023614183768 ("thermal: add generic cpufreq cooling
implementation") interacting with commit 125c4c706b68 ("idr: rename
MAX_LEVEL to MAX_IDR_LEVEL") which very recently entered Linus' tree.

I have applied the following fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Oct 2012 10:56:56 +1100
Subject: [PATCH] thermal: fix for for MAX_ID_MASK to MAX_IDR_MASK rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/thermal/cpu_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 9050c1b..cc1c930 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -86,7 +86,7 @@ again:
 	else if (unlikely(err))
 		return err;
=20
-	*id =3D *id & MAX_ID_MASK;
+	*id =3D *id & MAX_IDR_MASK;
 	return 0;
 }
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Oct_2012_11_02_05_+1100_1gWC8GIGM.CwzHLI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQchf9AAoJEECxmPOUX5FEXdwP/jZXOBu2jApcMptXGjYVotg5
O2Ajj5RUZwI/3pura8Q9g707pXYvHipWXe3SZnN+NIrcutTX3xJ/XScT0E02z98U
FfWXZ1/1vUFpgium5QlCAmnyINjEopzDKLTOX706+7CZRyOAsKETyRXvD0zvxo/1
w3Jtdu7XTR/k0ZR3Kyfy45mZv82kvowrTj5UTBtmrjs0YYOuKM02e6GVZGAsLySm
ChuJttXFNjuxZfJMWIDT0+d9iqF8buumc46gSwSZQxw/je1Uz59E1W1K8IJ/rD8H
AuDQQQ/zZUimqQi4XGb8nHtwNn67qy3T/NrdnLB2oOjSsosz2aAdCYDjuN6v8a5J
I3FVyuqnuDbJ5PHoYAjET79P3MkkdfS/+4h1kQ+sdoL9zwcugcCcV5Em2AdaZPu2
spS+hSMfO9ndnZvchYK9KK5ynb/OdmSbDKvmpwRaqoHpW/6R+BJSPkGeg/jKwWkS
zIWNaox7wfDXtDDlfrVLRj8bQN6gTKW1fkBD5iElx0xarVaDlwbLTmKoXCw/GK1q
BY6xxpI8v0q1Ue9xdyEALhvNOlIVvB7OqlM+kvp68vw/nXU+5U7EFb7YjIy4KTn4
1CYhlDK853e03jriC3tF49BBT58xO7x561P+U33ilGnjflO0Kx2cBBnN2HIv69je
vA3chq8Dd2OzwBOY4ard
=jeiF
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Oct_2012_11_02_05_+1100_1gWC8GIGM.CwzHLI--
