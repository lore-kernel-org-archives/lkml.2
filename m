Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307Ab2CITpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:45:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030274Ab2CITpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:45:44 -0500
Message-Id: <20120309190202.757990284@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alban Browaeys <prahal@yahoo.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 05/95] drm/i915: Prevent a machine hang by checking crtc->active before loading lut
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Browaeys <prahal@yahoo.com>

commit aed3f09db39596e539f90b11a5016aea4d8442e1 upstream.

Before loading the lut (gamma), check the active state of intel_crtc,
otherwise at least on gen2 hang ensue.

This is reproducible in Xorg via:
  xset dpms force off
then
  xgamma -rgamma 2.0 # freeze.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44505
Signed-off-by: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5965,7 +5965,7 @@ void intel_crtc_load_lut(struct drm_crtc
 	int i;
 
 	/* The clocks have to be on to load the palette. */
-	if (!crtc->enabled)
+	if (!crtc->enabled || !intel_crtc->active)
 		return;
 
 	/* use legacy palette for Ironlake */


