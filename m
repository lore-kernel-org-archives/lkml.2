Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2HCQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:03:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43258 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2HCQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:02:29 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 1/5] drm/i915: Add support for vga_switcheroo reprobe
Date: Fri,  3 Aug 2012 11:02:17 -0500
Message-Id: <1344009741-14248-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Heider <andreas@meetr.de>

Signed-off-by: Andreas Heider <andreas@meetr.de>
---
 drivers/gpu/drm/i915/i915_dma.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9cf7dfe..5b5176d 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1263,6 +1263,12 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 	}
 }
 
+static void i915_switcheroo_reprobe(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	intel_fb_output_poll_changed(dev);
+}
+
 static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
@@ -1276,7 +1282,7 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 
 static const struct vga_switcheroo_client_ops i915_switcheroo_ops = {
 	.set_gpu_state = i915_switcheroo_set_state,
-	.reprobe = NULL,
+	.reprobe = i915_switcheroo_reprobe,
 	.can_switch = i915_switcheroo_can_switch,
 };
 
-- 
1.7.9.5

