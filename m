Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab0HXX2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:28:13 -0400
Received: from kroah.org ([198.145.64.141]:40613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088Ab0HXW7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:44 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.690608275@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [77/91] drm/radeon/kms: fix GTT/VRAM overlapping test
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 2cbeb4efc2b9739fe6019b613ae658bd2119a3eb upstream.

GTT/VRAM overlapping test had a typo which leaded to not
detecting case when vram_end > gtt_end. This patch fix the
logic and should fix #16574

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -199,7 +199,7 @@ void radeon_vram_location(struct radeon_
 		mc->mc_vram_size = mc->aper_size;
 	}
 	mc->vram_end = mc->vram_start + mc->mc_vram_size - 1;
-	if (rdev->flags & RADEON_IS_AGP && mc->vram_end > mc->gtt_start && mc->vram_end <= mc->gtt_end) {
+	if (rdev->flags & RADEON_IS_AGP && mc->vram_end > mc->gtt_start && mc->vram_start <= mc->gtt_end) {
 		dev_warn(rdev->dev, "limiting VRAM to PCI aperture size\n");
 		mc->real_vram_size = mc->aper_size;
 		mc->mc_vram_size = mc->aper_size;


