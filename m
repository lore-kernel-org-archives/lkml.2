Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0LHBAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:23 -0500
Received: from kroah.org ([198.145.64.141]:48758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013Ab0LHBAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005729.948669945@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [086/289] drm/i915/crt: Make sure the hotplug interrupt is enabled
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yuanhan Liu <yuanhan.liu@intel.com>

commit 1510a97182b4ddb5fe3c4e8d05240f7cd6fd13e7 upstream.

After disabling the hotplug interrupts for VGA detection on Ironlake, be
sure to re-enable them again afterwards.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=30378
Signed-off-by: Yuanhan Liu <yuanhan.liu@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_crt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -191,7 +191,8 @@ static bool intel_ironlake_crt_detect_ho
 		DRM_DEBUG_KMS("timed out waiting for FORCE_TRIGGER");
 
 	if (turn_off_dac) {
-		I915_WRITE(PCH_ADPA, temp);
+		/* Make sure hotplug is enabled */
+		I915_WRITE(PCH_ADPA, temp | ADPA_CRT_HOTPLUG_ENABLE);
 		(void)I915_READ(PCH_ADPA);
 	}
 


