Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2CWWBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:01:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab2CWWBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="121053864"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] gma500: medfield: fix build without CONFIG_BACKLIGHT_CLASS_DEVICE
Date: Sat, 24 Mar 2012 00:01:52 +0200
Message-Id: <1332540112-469-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120323140323.3903f23b.akpm@linux-foundation.org>
References: <20120323140323.3903f23b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

drivers/built-in.o: In function `mdfld_dsi_connector_set_property':
mdfld_dsi_output.c:(.text+0x6e909): undefined reference to `mdfld_set_brightness'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
index 4c2cb4a..5675d93 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
@@ -244,7 +244,6 @@ static int mdfld_dsi_connector_set_property(struct drm_connector *connector,
 				uint64_t value)
 {
 	struct drm_encoder *encoder = connector->encoder;
-	struct backlight_device *psb_bd;
 
 	if (!strcmp(property->name, "scaling mode") && encoder) {
 		struct psb_intel_crtc *psb_crtc =
@@ -301,11 +300,15 @@ static int mdfld_dsi_connector_set_property(struct drm_connector *connector,
 									value))
 			goto set_prop_error;
 		else {
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+			struct backlight_device *psb_bd;
+
 			psb_bd = mdfld_get_backlight_device();
 			if (psb_bd) {
 				psb_bd->props.brightness = value;
 				mdfld_set_brightness(psb_bd);
 			}
+#endif
 		}
 	}
 set_prop_done:
-- 
1.7.9.1

