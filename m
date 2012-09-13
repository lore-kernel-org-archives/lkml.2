Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2IMHop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:44:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45639 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2IMHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:44:44 -0400
Date: Thu, 13 Sep 2012 17:44:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_17_44_41_+1000_wiB8FWoSzd_L90An"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_17_44_41_+1000_wiB8FWoSzd_L90An
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/thermal/cpu_cooling.c: In function 'get_idr':
drivers/thermal/cpu_cooling.c:89:14: error: 'MAX_ID_MASK' undeclared (first=
 use in this function)

Caused by commit "idr: rename MAX_LEVEL to MAX_IDR_LEVEL" from the akpm
tree interacting with commit 78edc7cdcf5e ("thermal: add generic cpufreq
cooling implementation") from the thermal tree.

I have applied the following merge fix patch and can carry it as
necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 Sep 2012 17:42:11 +1000
Subject: [PATCH] thermal: fix up for MAX_ID_MASK rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/thermal/cpu_cooling.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 99a5d75..f6ce617 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -9,7 +9,7 @@
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; version 2 of the License.
  *
- *  This program is distributed in the hope that it will be useful, but
+ *  This program is distributed in the hope that it will be useful, butX_I=
D_MASK
  *  WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  *  General Public License for more details.
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

--Signature=_Thu__13_Sep_2012_17_44_41_+1000_wiB8FWoSzd_L90An
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUY7pAAoJEECxmPOUX5FEyKIP/isJUkSuFKrYEFFdVevKHPZ0
m/THCvgJlUSS1aitYlkRTyElORx1VyEX68lFXg5Wf8le5Nk9DYcrhp1IEMmpZAZS
cxWto11luf04mg4twttGyuln6NFStG/KBRk4UjEwtweUi6dpqxnhMl6tu9SmD2/k
WZ/r/iN8TeV24jzBz3rpbXUkKbSa7MWB/uzqb4fQXJyIYxTZ6zFAcyUqlglH2B+f
vPjZkU3j/+QpFLAuxUZJa0iiJD5qBTYDRQjUGepUs1sOGPsjhCjoWhtmXlj+qzF9
UqsCfROIGs8alyGdAagaBssCLxGrcTxOaAZEaHvt5VHMX8XqTwNpKwhasy+WnXR2
MdNqiJgGynOWphNpxQMgWEeqn8b9n3rPhzmOYvKmcTJxmy4CYot4QS3ahjKbGA+T
xKgfsQyjF/BcNcWEQaQmsb8abwv0nlM9VsDsdEotEGpx/75ormmyMTVjkz6vVCFZ
jfXFyNcRAQvglsj9v3qj+srj+udJc9j+Q8+qHNkJgQTljLpVv2+2BhJSN+YxX482
fdNdq3jVPIEPFipawIuyNF9n+FL8Pu/BP8pWJU6+Gzm1TDWnFiulB99bvdnrzOHe
ESdtlBv/2WwWZbxDeWpQ9LslDZU9R7tYWScQX+EEg8zm5rWt9Z5mEn/WoKgnFzfX
cKlU6QohedTlOK88dIUL
=RoSt
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_17_44_41_+1000_wiB8FWoSzd_L90An--
