Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab0HLAWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:22:53 -0400
Received: from kroah.org ([198.145.64.141]:60302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab0HLAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:33 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.018624684@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [41/54] drm/edid: Fix the HDTV hack sync adjustment
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -577,8 +577,8 @@ struct drm_display_mode *drm_mode_std(st
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


