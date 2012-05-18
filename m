Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab2ERHWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:22:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44055 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2ERHWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:22:34 -0400
Date: Fri, 18 May 2012 17:22:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the usb tree with the s5p tree
Message-Id: <20120518172224.abd97797bab5d99eaeec97a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_17_22_24_+1000_1OOpMH=3nlTDvK3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_17_22_24_+1000_1OOpMH=3nlTDvK3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-exynos/mach-universal_c210.c between commit 6dafa4aead1b
("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
from the s5p tree and commit 3a36dd068f43 ("ARM: EXYNOS: Add s3c-hsotg
device support for Universal C210 board") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/mach-universal_c210.c
index dd8ec8d4,9be8a07..0000000
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@@ -23,7 -23,7 +23,8 @@@
  #include <linux/i2c-gpio.h>
  #include <linux/i2c/mcs.h>
  #include <linux/i2c/atmel_mxt_ts.h>
 +#include <drm/exynos_drm.h>
+ #include <linux/platform_data/s3c-hsotg.h>
 =20
  #include <asm/mach/arch.h>
  #include <asm/hardware/gic.h>
@@@ -1076,9 -1058,7 +1085,10 @@@ static struct platform_device *universa
  	&s5p_device_onenand,
  	&s5p_device_fimd0,
  	&s5p_device_jpeg,
 +#ifdef CONFIG_DRM_EXYNOS
 +	&exynos_device_drm,
 +#endif
+ 	&s3c_device_usb_hsotg,
  	&s5p_device_mfc,
  	&s5p_device_mfc_l,
  	&s5p_device_mfc_r,

--Signature=_Fri__18_May_2012_17_22_24_+1000_1OOpMH=3nlTDvK3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtfiwAAoJEECxmPOUX5FEK54P/jrIWAw29XgNUzW2K7w5lYns
dq5maiCb3AyMDGCz680hyC5bTYi3svEaZfjM6VsgLO4Kef4dSHLx1q6Ccm5aFnTL
Ahl2/7fJytceDeFaHAxtj+J2TtAUNjdvcccPBFDpav66p+1bOS/o4+n8MF/55iFA
GRRKONs00FDxOYdgbriXTtfQ42Ko83t1QwErw8rJXWFHgGNfE8upsdqlH0CU8oBA
GxPtFW99rZ1DQ3lNaGP2pZzeFBqghl2mDzHDUCkLxGh+V7VjUrHqFj02TCZ3bTki
AxFG2B3mWEVg5aJdHKjxYPIiPLMllgKbGBtDHIJYPHFflj4NiAeVx0/9VeEpBMm7
shTS/TrxP10ye5SQvK90iymMK6MskUjcVTZv//JnmDqdiHaXeK9TAONTMmIXVOp7
I4wFgGtw7q8LE9lSDe7xKm1AaYGHK1dmSzqF3KRPkwsFDuqOz6yaLvdFdpTDY3lV
jsnF3Cpb7a2XGALJIbcJ8T2JovSp14Ux14dEk6s/c7CbQHVis+u9kJrmSd6+0rHu
/4wONVgFThdLI58AR0cg7DIbnyux4SvIxs1vsl93v1pZL/yfAK0WnHb+x1SRcr6l
7m2Rk/RZ0+IhtvMc6VFFbyTr8xOLPrs6LZr9ri/lC5Vupzm+QuvS8bQ8ywTjBL1a
5BnfMYyu+gCubg+GPXuP
=+efe
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_17_22_24_+1000_1OOpMH=3nlTDvK3.--
