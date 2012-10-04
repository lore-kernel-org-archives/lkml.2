Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2JDCBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:01:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59101 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2JDCBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:01:01 -0400
Date: Thu, 4 Oct 2012 12:00:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shobhit Kumar <shobhit.kumar@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20121004120058.eb3a528381256654ffa36ce8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_12_00_58_+1000_gn.i.+OaU2xOqfWu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_12_00_58_+1000_gn.i.+OaU2xOqfWu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got conflicts in
drivers/gpu/drm/i915/intel_dp.c and drivers/gpu/drm/i915/intel_drv.h
between commit 760285e7e7ab ("UAPI: (Scripted) Convert #include "..." to
#include <path/...> in drivers/gpu/") from Linus' tree and commit 54d63ca66=
05d
("drm/i915: Move DP structs to shared location") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_dp.c
index f1bd4f4,1474f84..0000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -28,16 -28,15 +28,14 @@@
  #include <linux/i2c.h>
  #include <linux/slab.h>
  #include <linux/export.h>
 -#include "drmP.h"
 -#include "drm.h"
 -#include "drm_crtc.h"
 -#include "drm_crtc_helper.h"
 -#include "drm_edid.h"
 +#include <drm/drmP.h>
 +#include <drm/drm_crtc.h>
 +#include <drm/drm_crtc_helper.h>
 +#include <drm/drm_edid.h>
  #include "intel_drv.h"
 -#include "i915_drm.h"
 +#include <drm/i915_drm.h>
  #include "i915_drv.h"
- #include <drm/drm_dp_helper.h>
 =20
- #define DP_RECEIVER_CAP_SIZE	0xf
  #define DP_LINK_STATUS_SIZE	6
  #define DP_LINK_CHECK_TIMEOUT	(10 * 1000)
 =20
diff --cc drivers/gpu/drm/i915/intel_drv.h
index 7db8490,351fd71..0000000
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@@ -26,11 -26,12 +26,12 @@@
  #define __INTEL_DRV_H__
 =20
  #include <linux/i2c.h>
 -#include "i915_drm.h"
 +#include <drm/i915_drm.h>
  #include "i915_drv.h"
 -#include "drm_crtc.h"
 -#include "drm_crtc_helper.h"
 -#include "drm_fb_helper.h"
 -#include "drm_dp_helper.h"
 +#include <drm/drm_crtc.h>
 +#include <drm/drm_crtc_helper.h>
 +#include <drm/drm_fb_helper.h>
++#include <drm/drm_dp_helper.h>
 =20
  #define _wait_for(COND, MS, W) ({ \
  	unsigned long timeout__ =3D jiffies + msecs_to_jiffies(MS);	\

--Signature=_Thu__4_Oct_2012_12_00_58_+1000_gn.i.+OaU2xOqfWu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbO3aAAoJEECxmPOUX5FE+nAP/3EIDQZ4J0Uo+g7OAbW8x0Yi
JDE6Nr6+Mom2rBJnqmwj1ZuLjEXUCkJPNcVNpDLRBt3TfY2gaV6m5hWqyxk1EaFd
tyRyfimLLe3RIVqdFIIsI+SrHZELr6GmiSSDj6bDBmSOlpKsaQ1wTPHBfKDt59Op
IHriQhkc+ATiHttsecHnwGclkys+HgkXz4IPmcS+dBbm2yBvoveDGxtMQATKRN8G
jxs6XTHNMtxpBos8PO6acMPbUwN3WllnCrv53iypKG2a0CF2A1JUDMK5iazhG8KL
w5IxL+bO9aQKkZIgX4fB/hqow94Obwl9H+Nlr6zWQ9wia8teKjfGQ3q3IDkEJRUe
EKQM2Ri91mCd5KKm1p5u8QAB+6ffwMN40STEvPR06iVnhI1TpVZ82gifJ82f4lLy
68UPXe55jrkuGlUGYge7e2A9+y46O/M8+4xoTC6NaW/+oJVSbB2Ar650+umZK31Q
xqDZ3/hsh2kcUjbkVcLznL+XohU6oPgziWuEt9xEB9q1t7oZxtmMjjwybEzk5ju+
XgxVxtsEuInatvOeL4k1Qje1U89+hQHre4kesfrP7ri/gGyPyuO0r+fZJd9mhFL+
nHisLrxQfjHWQcmtTEmzp6WWdoviY+nWR1ZzNBmk8Bj5a4skvC9JYQ2j+LxH2jXi
IpR+GsNKLRdF93ZcMgZJ
=Ho5w
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_12_00_58_+1000_gn.i.+OaU2xOqfWu--
