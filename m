Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2IQExu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:53:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45049 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2IQExt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:53:49 -0400
Date: Mon, 17 Sep 2012 14:53:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120917145332.82a0a723c73904943190d493@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_14_53_32_+1000_zxGvq9D/YucF4O4B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_14_53_32_+1000_zxGvq9D/YucF4O4B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_dma.c between commit 99d0b1db6ccd ("drm/i915:
initialize dpio_lock spin lock") from Linus' tree and commit c6a828d3269a
("drm/i915: move all rps state into dev_priv->rps") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_dma.c
index 914c0df,2c09900..0000000
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1586,8 -1606,7 +1606,8 @@@ int i915_driver_load(struct drm_device=20
 =20
  	spin_lock_init(&dev_priv->irq_lock);
  	spin_lock_init(&dev_priv->error_lock);
- 	spin_lock_init(&dev_priv->rps_lock);
+ 	spin_lock_init(&dev_priv->rps.lock);
 +	spin_lock_init(&dev_priv->dpio_lock);
 =20
  	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
  		dev_priv->num_pipe =3D 3;

--Signature=_Mon__17_Sep_2012_14_53_32_+1000_zxGvq9D/YucF4O4B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVqzMAAoJEECxmPOUX5FE39QP/iYph/SR1EWKqe0WgeBL/itp
g0Jol7EL1pVlWQsW72cJyRK+JFiYpHhoIBQ7+mh5Ia7cn3OrQ+lhJdHI5O0fPdsY
bdygdDPlohgAJHl/vg3wkKOmE2n2gjoERsnX8ry9xZMmjfHw3y0ndPe40o56k1G9
oVnIzkwjaLShX+qxLBY7Vdcq9QswE/HqDehuNffJOHnosHdS55Z8smSRIRnlvzPE
DyRk6+OTcxf6KEMUZotQsTXtQgzFsh1bGSciK6RypSqz0sIGIcG0dhEDZo5LtYQx
vSBFaiAg45gpYy7CDx32nD/QhkhCnBuKdDF4MsS/C0PIsfFKV5Dwp7pPpq5fGBVG
R3WlI0PiRcxN2M8u/OcykcVOHbVOvXRGr8dtEIWjX1fr57y4XZKDy/1HLT6LxyzK
VlXZDdeyFMw7jYZJsQ3Prx4UqO9WCa2yPfWJroiOjD2p0LAm92hpYVLMmFRRSfbA
nZ4+fKu4W03kQihjF/fUCFTUKTztFJRUt7py/Kgurdv8em27x3SlxE+oNxtRpdMN
gSboDlXf2lc3oeQ4GYvjpjzH5Jb0gSuzXap+2NAMN6B9trzcNQaBo0mGaGOfc83L
qq4wmd8Ns3EL42io4F1CY0d75SXtMrY8SXm5UgbFvszJGmQqcjOd27Zss/avN8oa
a15WKF7gGY7dzWVERXS7
=eM50
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_14_53_32_+1000_zxGvq9D/YucF4O4B--
