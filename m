Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1HNQG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1HNQG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.237169562@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>
Subject: [24/90] drm/i915: load the LUT before pipe enable on ILK+
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 9c54c0dd948d715ccfd79e97d852f80eeb53254a upstream.

Per the specs and to address
https://bugs.freedesktop.org/show_bug.cgi?id=36888.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2699,14 +2699,18 @@ static void ironlake_crtc_enable(struct
 		I915_WRITE(PF_WIN_SZ(pipe), dev_priv->pch_pf_size);
 	}
 
+	/*
+	 * On ILK+ LUT must be loaded before the pipe is running but with
+	 * clocks enabled
+	 */
+	intel_crtc_load_lut(crtc);
+
 	intel_enable_pipe(dev_priv, pipe, is_pch_port);
 	intel_enable_plane(dev_priv, plane, pipe);
 
 	if (is_pch_port)
 		ironlake_pch_enable(crtc);
 
-	intel_crtc_load_lut(crtc);
-
 	mutex_lock(&dev->struct_mutex);
 	intel_update_fbc(dev);
 	mutex_unlock(&dev->struct_mutex);


