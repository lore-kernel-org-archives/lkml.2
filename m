Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1JKRGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:06:32 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:10 2011
Message-Id: <20111011165710.587694590@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:25 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [15/38] drm/radeon: Update AVIVO cursor coordinate origin before x/yorigin calculation.
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit b8aee294d89502469f2d80ae6afb93398d8227e0 upstream.

Fixes cursor disappearing prematurely when moving off a top/left edge which
is not located at the desktop top/left edge.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_cursor.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -208,6 +208,13 @@ int radeon_crtc_cursor_move(struct drm_c
 	int xorigin = 0, yorigin = 0;
 	int w = radeon_crtc->cursor_width;
 
+	if (ASIC_IS_AVIVO(rdev)) {
+		/* avivo cursor are offset into the total surface */
+		x += crtc->x;
+		y += crtc->y;
+	}
+	DRM_DEBUG("x %d y %d c->x %d c->y %d\n", x, y, crtc->x, crtc->y);
+
 	if (x < 0)
 		xorigin = -x + 1;
 	if (y < 0)
@@ -221,11 +228,6 @@ int radeon_crtc_cursor_move(struct drm_c
 		int i = 0;
 		struct drm_crtc *crtc_p;
 
-		/* avivo cursor are offset into the total surface */
-		x += crtc->x;
-		y += crtc->y;
-		DRM_DEBUG("x %d y %d c->x %d c->y %d\n", x, y, crtc->x, crtc->y);
-
 		/* avivo cursor image can't end on 128 pixel boundary or
 		 * go past the end of the frame if both crtcs are enabled
 		 */


