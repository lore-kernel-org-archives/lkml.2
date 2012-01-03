Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2ACWzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:55:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab2ACWjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:21 2012
Message-Id: <20120103223321.508292684@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [06/75] drm/i915: set the right SDVO transcoder for CPT
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 3573c4103f7a486838bb6b5b8353788103f91802 upstream.

v2: add a CPT-specific macro, make code cleaner
v3: fix commit message

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41272
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h   |    8 ++++----
 drivers/gpu/drm/i915/intel_sdvo.c |    8 ++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3271,10 +3271,10 @@
 /* or SDVOB */
 #define HDMIB   0xe1140
 #define  PORT_ENABLE    (1 << 31)
-#define  TRANSCODER_A   (0)
-#define  TRANSCODER_B   (1 << 30)
-#define  TRANSCODER(pipe)	((pipe) << 30)
-#define  TRANSCODER_MASK   (1 << 30)
+#define  TRANSCODER(pipe)       ((pipe) << 30)
+#define  TRANSCODER_CPT(pipe)   ((pipe) << 29)
+#define  TRANSCODER_MASK        (1 << 30)
+#define  TRANSCODER_MASK_CPT    (3 << 29)
 #define  COLOR_FORMAT_8bpc      (0)
 #define  COLOR_FORMAT_12bpc     (3 << 26)
 #define  SDVOB_HOTPLUG_ENABLE   (1 << 23)
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1085,8 +1085,12 @@ static void intel_sdvo_mode_set(struct d
 		}
 		sdvox |= (9 << 19) | SDVO_BORDER_ENABLE;
 	}
-	if (intel_crtc->pipe == 1)
-		sdvox |= SDVO_PIPE_B_SELECT;
+
+	if (INTEL_PCH_TYPE(dev) >= PCH_CPT)
+		sdvox |= TRANSCODER_CPT(intel_crtc->pipe);
+	else
+		sdvox |= TRANSCODER(intel_crtc->pipe);
+
 	if (intel_sdvo->has_hdmi_audio)
 		sdvox |= SDVO_AUDIO_ENABLE;
 


