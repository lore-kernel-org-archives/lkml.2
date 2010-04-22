Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0DVUXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:23:55 -0400
Received: from kroah.org ([198.145.64.141]:59678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab0DVUAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:16 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:09 2010
Message-Id: <20100422195409.818418434@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [050/139] drm/radeon/kms: fix washed out image on legacy tv dac
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
@@ -315,7 +315,7 @@ int radeon_connector_set_property(struct
 		radeon_encoder = to_radeon_encoder(encoder);
 		if (!radeon_encoder->enc_priv)
 			return 0;
-		if (rdev->is_atom_bios) {
+		if (ASIC_IS_AVIVO(rdev) || radeon_r4xx_atom) {
 			struct radeon_encoder_atom_dac *dac_int;
 			dac_int = radeon_encoder->enc_priv;
 			dac_int->tv_std = val;


