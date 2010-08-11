Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0HKX6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:10 -0400
Received: from kroah.org ([198.145.64.141]:40186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab0HKX6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:01 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:58 2010
Message-Id: <20100811235458.559208928@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [033/111] drm/edid: Fix the HDTV hack sync adjustment
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit a4967de6cbb260ad0f6612a1d2035e119ef1578f upstream.

We're adjusting horizontal timings only here, moving vsync was just a
slavish translation of a typo in the X server.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -565,8 +565,8 @@ struct drm_display_mode *drm_mode_std(st
 		mode = drm_cvt_mode(dev, hsize, vsize, vrefresh_rate, 0, 0,
 				    false);
 		mode->hdisplay = 1366;
-		mode->vsync_start = mode->vsync_start - 1;
-		mode->vsync_end = mode->vsync_end - 1;
+		mode->hsync_start = mode->hsync_start - 1;
+		mode->hsync_end = mode->hsync_end - 1;
 		return mode;
 	}
 	mode = NULL;


