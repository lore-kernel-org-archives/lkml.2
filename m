Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2L1TWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:22:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab2L1TT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:58 -0500
Message-Id: <20121228190335.033137454@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 024/173] drm/i915: add Ivy Bridge GT2 Server entries
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit cc22a938fc1db0c8ef5e693a69b159c4b851dab3 upstream.

This adds PCI ID for IVB GT2 server variant which we were missing.

Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
[danvet: fix up conflict because the patch has been diffed against next. tsk.]
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/agp/intel-agp.h    |    1 +
 drivers/char/agp/intel-gtt.c    |    2 ++
 drivers/gpu/drm/i915/i915_drv.c |    1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 5da67f1..7ea18a5 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -234,6 +234,7 @@
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_M_GT2_IG		0x0166
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_HB		0x0158  /* Server */
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT1_IG		0x015A
+#define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT2_IG		0x016A
 
 int intel_gmch_probe(struct pci_dev *pdev,
 			       struct agp_bridge_data *bridge);
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 5cf47ac..f493546 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1459,6 +1459,8 @@ static const struct intel_gtt_driver_description {
 	    "Ivybridge", &sandybridge_gtt_driver },
 	{ PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT1_IG,
 	    "Ivybridge", &sandybridge_gtt_driver },
+	{ PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT2_IG,
+	    "Ivybridge", &sandybridge_gtt_driver },
 	{ 0, NULL, NULL }
 };
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index c7d689e..77afd31 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -296,6 +296,7 @@ static const struct pci_device_id pciidlist[] = {		/* aka */
 	INTEL_VGA_DEVICE(0x0152, &intel_ivybridge_d_info), /* GT1 desktop */
 	INTEL_VGA_DEVICE(0x0162, &intel_ivybridge_d_info), /* GT2 desktop */
 	INTEL_VGA_DEVICE(0x015a, &intel_ivybridge_d_info), /* GT1 server */
+	INTEL_VGA_DEVICE(0x016a, &intel_ivybridge_d_info), /* GT2 server */
 	{0, 0, 0}
 };
 


