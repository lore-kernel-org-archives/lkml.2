Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2CIC0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:26:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39484 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2CIC0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:26:05 -0500
Date: Fri, 9 Mar 2012 13:25:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javi Merino <javi.merino@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the slave-dma tree with Linus' tree
Message-Id: <20120309132554.a82c72a8f2dab11c9104a596@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_13_25_54_+1100_jPa9Yi.b48IL2NwT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_13_25_54_+1100_jPa9Yi.b48IL2NwT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got conflicts in
arch/arm/include/asm/hardware/pl330.h and arch/arm/common/pl330.c between
commits 4272f98a1ae8 ("ARM: 7164/3: PL330: Fix the size of the
dst_cache_ctrl field") and 46e33c606af8 ("ARM: 7326/2: PL330: fix null
pointer dereference in pl330_chan_ctrl()") from Linus' tree and commit
b7d861d93945 ("DMA: PL330: Merge PL330 driver into drivers/dma/") from
the slave-dma tree.

I removed the files and then applied changes from the patchs in Linus'
tree to drivers/dma/pl330.c.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 9 Mar 2012 13:21:55 +1100
Subject: [PATCH] DMA: PL330: update for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/dma/pl330.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7253d17..41ec06d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -48,7 +48,7 @@ enum pl330_dstcachectrl {
 	DCCTRL1,	/* Bufferable only */
 	DCCTRL2,	/* Cacheable, but do not allocate */
 	DCCTRL3,	/* Cacheable and bufferable, but do not allocate */
-	DINVALID1 =3D 8,
+	DINVALID1,		/* AWCACHE =3D 0x1000 */
 	DINVALID2,
 	DCCTRL6,	/* Cacheable write-through, allocate on writes only */
 	DCCTRL7,	/* Cacheable write-back, allocate on writes only */
@@ -1799,12 +1799,13 @@ static int pl330_chan_ctrl(void *ch_id, enum pl330_=
chan_op op)
 	struct pl330_thread *thrd =3D ch_id;
 	struct pl330_dmac *pl330;
 	unsigned long flags;
-	int ret =3D 0, active =3D thrd->req_running;
+	int ret =3D 0, active;
=20
 	if (!thrd || thrd->free || thrd->dmac->state =3D=3D DYING)
 		return -EINVAL;
=20
 	pl330 =3D thrd->dmac;
+	active =3D thrd->req_running;
=20
 	spin_lock_irqsave(&pl330->lock, flags);
=20
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Mar_2012_13_25_54_+1100_jPa9Yi.b48IL2NwT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWWoyAAoJEECxmPOUX5FEf8kQAKJpe2KmYr58YwfSTqgQZzuF
hotWJ5FPKGxM70ecUtwQYT+uJ+E/AaFWIuVmIHz4sf+JxeSjeDZCZiUlyCNvbNgD
C8vFYx72oG6YhWKnhF4SAWPGuC7iHrAGNn+LIOOmiMTjxDq5OKCyAZob73V+/Dpv
ifeGhKOXkyTpLB1P3Lbv9jnWtRiRXN4VTv5uq0RY9wtjtqG6RV1R59T4dO2+CBAd
sJCj1R59+rob9DFNxqqTCezWBMFrhTcCwFY3LSWXjvaNx77BwcHrb4n1neWrlGbW
JM7SdMCjbN2BqzYuhhRj2agWTFbPNFsQmMJpjRsSamN7j1lUzx0PaJuAyzbpCjLN
OjKa2jVhM9OTbfc9nkCCvP/98OOlCX2F3IuCR4mY3CHVpz/zJg9gD8G+7pbWKPwW
Nh5ocSRBBf6j2aECmZ05do066r5y9ep0Gi3Cgqj7Tfi0dB9/IoFI9UWB5t6CiO7l
XFWUXs13FDtg7fqsvXcZBxYOfQX7AOhq9z2yWqEylJOl4aMvZwZROpeAAafYixmT
JMOoyBJZa3WV5gLaRe1MRN7qvsgPkRomzgjXwoATOxcEO8wtJ6d2wsJBGybKn7NM
J7DwmDgXXWqOL5WE0BBFJN/vY0476DK+MmB6QYTFpUgLRL59uO+Xnu2NpliAQY2n
QWlAzRa/2kE23+Ysc04q
=Q2sN
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_13_25_54_+1100_jPa9Yi.b48IL2NwT--
