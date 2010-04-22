Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0DVT11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:27 -0400
Received: from kroah.org ([198.145.64.141]:37092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0DVT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:26 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:07 2010
Message-Id: <20100422190907.514814380@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [001/197] drm/edid: allow certain bogus edids to hit a fixup path rather than fail
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 44fef22416886a04d432043f741a6faf2c6ffefd upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -653,15 +653,6 @@ static struct drm_display_mode *drm_mode
 	mode->vsync_end = mode->vsync_start + vsync_pulse_width;
 	mode->vtotal = mode->vdisplay + vblank;
 
-	/* perform the basic check for the detailed timing */
-	if (mode->hsync_end > mode->htotal ||
-		mode->vsync_end > mode->vtotal) {
-		drm_mode_destroy(dev, mode);
-		DRM_DEBUG_KMS("Incorrect detailed timing. "
-				"Sync is beyond the blank.\n");
-		return NULL;
-	}
-
 	/* Some EDIDs have bogus h/vtotal values */
 	if (mode->hsync_end > mode->htotal)
 		mode->htotal = mode->hsync_end + 1;


