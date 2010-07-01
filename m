Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab0GAWOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:14:01 -0400
Received: from kroah.org ([198.145.64.141]:47365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614Ab0GAUuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:00 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.883227963@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Jackson <ajax@redhat.com>, Eric Anholt <eric@anholt.net>
Subject: [patch 048/164] drm/i915: Fix 82854 PCI ID, and treat it like other 85X
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 5ce8ba7c9279a63f99e1f131602580472b8af968 upstream.

pci.ids and the datasheet both say it's 358e, not 35e8.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c |    5 +++--
 drivers/gpu/drm/i915/i915_drv.h |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -68,7 +68,8 @@ const static struct intel_device_info in
 };
 
 const static struct intel_device_info intel_i85x_info = {
-	.is_i8xx = 1, .is_mobile = 1, .cursor_needs_physical = 1,
+	.is_i8xx = 1, .is_i85x = 1, .is_mobile = 1,
+	.cursor_needs_physical = 1,
 };
 
 const static struct intel_device_info intel_i865g_info = {
@@ -140,7 +141,7 @@ const static struct pci_device_id pciidl
 	INTEL_VGA_DEVICE(0x3577, &intel_i830_info),
 	INTEL_VGA_DEVICE(0x2562, &intel_845g_info),
 	INTEL_VGA_DEVICE(0x3582, &intel_i85x_info),
-	INTEL_VGA_DEVICE(0x35e8, &intel_i85x_info),
+	INTEL_VGA_DEVICE(0x358e, &intel_i85x_info),
 	INTEL_VGA_DEVICE(0x2572, &intel_i865g_info),
 	INTEL_VGA_DEVICE(0x2582, &intel_i915g_info),
 	INTEL_VGA_DEVICE(0x258a, &intel_i915g_info),
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -175,6 +175,7 @@ struct intel_overlay;
 struct intel_device_info {
 	u8 is_mobile : 1;
 	u8 is_i8xx : 1;
+	u8 is_i85x : 1;
 	u8 is_i915g : 1;
 	u8 is_i9xx : 1;
 	u8 is_i945gm : 1;
@@ -1027,7 +1028,7 @@ extern int i915_wait_ring(struct drm_dev
 
 #define IS_I830(dev)		((dev)->pci_device == 0x3577)
 #define IS_845G(dev)		((dev)->pci_device == 0x2562)
-#define IS_I85X(dev)		((dev)->pci_device == 0x3582)
+#define IS_I85X(dev)		(INTEL_INFO(dev)->is_i85x)
 #define IS_I865G(dev)		((dev)->pci_device == 0x2572)
 #define IS_GEN2(dev)		(INTEL_INFO(dev)->is_i8xx)
 #define IS_I915G(dev)		(INTEL_INFO(dev)->is_i915g)


