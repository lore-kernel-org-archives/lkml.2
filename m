Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2EIGI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:08:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39134 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805Ab2EIFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:35 -0400
Message-Id: <20120509055047.840592599@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 132/167] [PATCH] drm/i915: enable dip before writing data on gen4
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit c1230df7e19e0f27655c0eb9d966c7e03be7cc50 upstream.

While testing with the intel_infoframes tool on gen4, I see that when
video DIP is disabled, what we write to the DATA memory is not exactly
what we read back later.

This regression has been introduce in

commit 64a8fc0145a1d0fdc25fc9367c2e6c621955fb3b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Sep 22 11:16:00 2011 +0530

    drm/i915: fix ILK+ infoframe support

That commit was setting VIDEO_DIP_CTL to 0 when initializing, which
caused the problem.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=43947
Tested-by: Yang Guang <guang.a.yang@intel.com>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
[danvet: Pimped commit message by using the usual commit citation
layout.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index cae3e5f..2d7f47b 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -136,7 +136,7 @@ static void i9xx_write_infoframe(struct drm_encoder *encoder,
 
 	val &= ~VIDEO_DIP_SELECT_MASK;
 
-	I915_WRITE(VIDEO_DIP_CTL, val | port | flags);
+	I915_WRITE(VIDEO_DIP_CTL, VIDEO_DIP_ENABLE | val | port | flags);
 
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(VIDEO_DIP_DATA, *data);
-- 
1.7.10



