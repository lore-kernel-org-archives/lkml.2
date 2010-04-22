Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0DVT2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:47 -0400
Received: from kroah.org ([198.145.64.141]:40899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab0DVT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:40 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.264710211@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [088/197] drm/radeon/kms: fix washed out image on legacy tv dac
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 643acacf02679befd0f98ac3c5fecb805f1c9548 upstream.

bad cast was overwriting the tvdac adj values
Fixes fdo bug 27478

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -281,7 +281,7 @@ int radeon_connector_set_property(struct
 		radeon_encoder = to_radeon_encoder(encoder);
 		if (!radeon_encoder->enc_priv)
 			return 0;
-		if (rdev->is_atom_bios) {
+		if (ASIC_IS_AVIVO(rdev) || radeon_r4xx_atom) {
 			struct radeon_encoder_atom_dac *dac_int;
 			dac_int = radeon_encoder->enc_priv;
 			dac_int->tv_std = val;


