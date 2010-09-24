Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0IXQya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:54:30 -0400
Received: from kroah.org ([198.145.64.141]:38333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0IXQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162617.937425417@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [35/80] drm/i915,agp/intel: Add second set of PCI-IDs for B43
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 41a51428916ab04587bacee2dda61c4a0c4fc02f upstream.

There is a second revision of B43 (a desktop gen4 part) floating around,
functionally equivalent to the original B43, so simply add the new
PCI-IDs.

Bugzilla: https://bugs.freedesktop.org/show_bugs.cgi?id=30221
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c    |    2 ++
 drivers/char/agp/intel-agp.h    |    2 ++
 drivers/gpu/drm/i915/i915_drv.c |    1 +
 3 files changed, 5 insertions(+)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -805,6 +805,8 @@ static const struct intel_driver_descrip
 	    "G45/G43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_B43_HB, PCI_DEVICE_ID_INTEL_B43_IG,
 	    "B43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_B43_1_HB, PCI_DEVICE_ID_INTEL_B43_1_IG,
+	    "B43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G41_HB, PCI_DEVICE_ID_INTEL_G41_IG,
 	    "G41", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB, PCI_DEVICE_ID_INTEL_IRONLAKE_D_IG,
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -178,6 +178,8 @@
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
 #define PCI_DEVICE_ID_INTEL_B43_HB          0x2E40
 #define PCI_DEVICE_ID_INTEL_B43_IG          0x2E42
+#define PCI_DEVICE_ID_INTEL_B43_1_HB        0x2E90
+#define PCI_DEVICE_ID_INTEL_B43_1_IG        0x2E92
 #define PCI_DEVICE_ID_INTEL_GM45_HB         0x2A40
 #define PCI_DEVICE_ID_INTEL_GM45_IG         0x2A42
 #define PCI_DEVICE_ID_INTEL_EAGLELAKE_HB        0x2E00
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -175,6 +175,7 @@ static const struct pci_device_id pciidl
 	INTEL_VGA_DEVICE(0x2e22, &intel_g45_info),
 	INTEL_VGA_DEVICE(0x2e32, &intel_g45_info),
 	INTEL_VGA_DEVICE(0x2e42, &intel_g45_info),
+	INTEL_VGA_DEVICE(0x2e92, &intel_g45_info),		/* B43_G.1 */
 	INTEL_VGA_DEVICE(0xa001, &intel_pineview_info),
 	INTEL_VGA_DEVICE(0xa011, &intel_pineview_info),
 	INTEL_VGA_DEVICE(0x0042, &intel_ironlake_d_info),


