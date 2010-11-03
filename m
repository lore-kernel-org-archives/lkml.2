Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0KCKpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:45:01 -0400
Received: from [193.12.253.22] ([193.12.253.22]:60575 "EHLO muninn.aeneby.se"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab0KCKo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:44:59 -0400
X-Greylist: delayed 1944 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 06:44:59 EDT
Date: Wed, 3 Nov 2010 11:12:29 +0100
From: Aaron Sowry <aaron@aeneby.se>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: [PATCH] nouveau: Don't expose backlight control in presence of ACPI
Message-ID: <20101103101229.GA4523@aeneby.se>
Mail-Followup-To: airlied@linux.ie, linux-kernel@vger.kernel.org,
	nouveau@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
OpenPGP: id=1F7902FD
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Aaron Sowry <aaron@aeneby.se>

Avoid confusing userspace by not publishing backlight controls if ACPI equi=
valents are available.
Signed-off-by: Aaron Sowry <aaron@aeneby.se>
---
--- linux-2.6/drivers/gpu/drm/nouveau/nouveau_state.c.orig      2010-11-03 =
09:56:29.502828966 +0100
+++ linux-2.6/drivers/gpu/drm/nouveau/nouveau_state.c   2010-11-03 10:46:27=
=2E765829000 +0100
@@ -23,6 +23,7 @@
  * DEALINGS IN THE SOFTWARE.
  */

+#include <linux/acpi.h>
 #include <linux/swab.h>
 #include <linux/slab.h>
 #include "drmP.h"
@@ -648,9 +649,14 @@ nouveau_card_init(struct drm_device *dev
                        goto out_fence;
        }

-       ret =3D nouveau_backlight_init(dev);
-       if (ret)
-               NV_ERROR(dev, "Error %d registering backlight\n", ret);
+       if (acpi_video_backlight_support())
+               NV_INFO(dev, "Detected ACPI backlight support, "
+                               "not registering interface\n");
+       else {
+               ret =3D nouveau_backlight_init(dev);
+               if (ret)
+                       NV_ERROR(dev, "Error %d registering backlight\n", r=
et);
+       }

        nouveau_fbcon_init(dev);
        drm_kms_helper_poll_init(dev);

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBAgAGBQJM0TWMAAoJECw8YUUfeQL9s9oH/iG3Tzy5RCRzDznRPpxxsSMV
V8qmc+tokkpybjvoXyRD3erp5H90AjpDEQBeu1setWeYrZDr5DuWerXEjvqSoZss
ae9Wc0+3Se7WxfeTAJY1+QuBm1dnK0lNz7q3hOeBovwBhbK5fGMxPHbFYbwFuKHB
oaiznoW3W/InGIJHqBfpA+wymd6jwt/mr6KcJi9wGcS/ZLuYTB4Z7r/InC85I8mM
tjJh+IdycT5SdQSISef6M5dWeBsgvPSY9+zw/2xmAYanXBj+1sfsoyLqh7s6gYdx
klxRU6zABMgFiGgicznS3901ZWwbIvD6EuiDZk0gxI9YSVHaX2uMiKHOCBJ3cb0=
=9m0Z
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
