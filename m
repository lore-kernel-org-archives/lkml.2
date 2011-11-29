Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1K2EQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:16:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42123 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1K2EQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:16:48 -0500
Date: Tue, 29 Nov 2011 15:16:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: build failure after merge of the final tree (drm tree
 related)
Message-Id: <20111129151638.a083e93e21c7917f221af760@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_15_16_38_+1100_+KpOhozHp/_Gr.rT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_15_16_38_+1100_+KpOhozHp/_Gr.rT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpu/drm/radeon/radeon_fb.c: In function 'radeonfb_create_pinned_obj=
ect':
drivers/gpu/drm/radeon/radeon_fb.c:144:18: error: 'struct drm_mode_fb_cmd2'=
 has no member named 'bpp'

Caused by commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes
a pixel format v5").

I applied this (maybe incorrect) patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Nov 2011 15:11:10 +1100
Subject: [PATCH] drm: fix up for BIG ENDIAN breakage

Commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes a pixel
format v5") missed one spot needing to be fixed up in the __BIG_ENDIAN
case.

Fixes build error:

drivers/gpu/drm/radeon/radeon_fb.c: In function 'radeonfb_create_pinned_obj=
ect':
drivers/gpu/drm/radeon/radeon_fb.c:144:18: error: 'struct drm_mode_fb_cmd2'=
 has no member named 'bpp'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/radeon/radeon_fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/ra=
deon_fb.c
index ea110ad..9c42c6a 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -141,7 +141,7 @@ static int radeonfb_create_pinned_object(struct radeon_=
fbdev *rfbdev,
 		tiling_flags =3D RADEON_TILING_MACRO;
=20
 #ifdef __BIG_ENDIAN
-	switch (mode_cmd->bpp) {
+	switch (bpp) {
 	case 32:
 		tiling_flags |=3D RADEON_TILING_SWAP_32BIT;
 		break;
--=20
1.7.7.3


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Nov_2011_15_16_38_+1100_+KpOhozHp/_Gr.rT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1FymAAoJEECxmPOUX5FEbkAP/1z0VUT6FBAVxBO9LSYm+sAb
CSNIV0v1ym4P4h6nnvT83aHE6OA2VI/rhmPEc9QSAduc5uvlROh1Z+D9inSnG7yD
IZzNFiDzyWUgqn1d/vfKVpxfFktvosASClUxffkiV4anGtpjzJRer8e05Xlyu9H5
/hzuRpYcjvRFgOgiityJXrp/d+fgv/z4Fv+2mOJpe66B2Wkz4zgLt4cixAAe37YZ
/PvK5gV73Q6J+2QZI9AzRTUosE4ok+hgcVb467um3RDB0FHCcoXcBbry6OL0Gn3q
kca9pbDs1009NwJzw+ez72k9/1aHJFn1m9oCguYbkqVti83QknwJT3t5mmDgNGZF
gFmXIhkACqRk8wLhPvsOCM7EPAJxx02gF/9gR8HyjPDuBqVaurvnD3EXYZBHGSCK
FVJaddNCPonzcZwIsoOGu8BTUVlK2XZUI8Ytfp6lv98cp8QyBL+qBQi44sdGJlPY
DBBfaIhdJF96hMPSmbPQC076wVmsm56RoaZAZXEB+J01lyQ3eCNvCnAo6ydlZW1r
hrDdDWxmno3EBcE0yVIvfEmkyAks760ZDfLwi/mh4QFCNX/OEDoKL9ZCdgIOthN0
4FwyW8dZ9Te2Dz+iNsN1XUGNCVXCOkFBenui/PxV5JWS+pfZhx6lTIlwxjK6jyFP
dy/RlOWa51KMpQJ5M6dC
=Owcm
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_15_16_38_+1100_+KpOhozHp/_Gr.rT--
