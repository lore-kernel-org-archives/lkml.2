Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0IQDvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:51:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43090 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab0IQDvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:51:12 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>
Subject: [PATCH 1/2] apg/intel: Support for another B43 device id
Date: Fri, 17 Sep 2010 11:51:04 +0800
Message-Id: <1284695464-6324-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284695424-6294-1-git-send-email-ike.pan@canonical.com>
References: <1284695424-6294-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We find there is another device id set for B43 chipset. After adding the device
id 4E90/4E92 beside 4E40/4E42, the machine works fine with the same
modification in xserver-xorg-video-intel.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/char/agp/intel-agp.c |    7 +++++--
 drivers/char/agp/intel-agp.h |    9 ++++++---
 drivers/char/agp/intel-gtt.c |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index eab58db..b7eef63 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -804,7 +804,9 @@ static const struct intel_driver_description {
 	    "Q45/Q43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G45_HB, PCI_DEVICE_ID_INTEL_G45_IG,
 	    "G45/G43", NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_B43_HB, PCI_DEVICE_ID_INTEL_B43_IG,
+	{ PCI_DEVICE_ID_INTEL_B43_1_HB, PCI_DEVICE_ID_INTEL_B43_1_IG,
+	    "B43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_B43_2_HB, PCI_DEVICE_ID_INTEL_B43_2_IG,
 	    "B43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G41_HB, PCI_DEVICE_ID_INTEL_G41_IG,
 	    "G41", NULL, &intel_i965_driver },
@@ -1046,7 +1048,8 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G41_HB),
-	ID(PCI_DEVICE_ID_INTEL_B43_HB),
+	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
+	ID(PCI_DEVICE_ID_INTEL_B43_2_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),
diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index ee189c7..5d9c17c 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -184,8 +184,10 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
-#define PCI_DEVICE_ID_INTEL_B43_HB          0x2E40
-#define PCI_DEVICE_ID_INTEL_B43_IG          0x2E42
+#define PCI_DEVICE_ID_INTEL_B43_1_HB        0x2E40
+#define PCI_DEVICE_ID_INTEL_B43_1_IG        0x2E42
+#define PCI_DEVICE_ID_INTEL_B43_2_HB        0x2E90
+#define PCI_DEVICE_ID_INTEL_B43_2_IG        0x2E92
 #define PCI_DEVICE_ID_INTEL_GM45_HB         0x2A40
 #define PCI_DEVICE_ID_INTEL_GM45_IG         0x2A42
 #define PCI_DEVICE_ID_INTEL_EAGLELAKE_HB        0x2E00
@@ -246,7 +248,8 @@
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G41_HB || \
-		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_1_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_2_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB || \
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 75e0a34..3c71568 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1379,7 +1379,8 @@ static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
 	case PCI_DEVICE_ID_INTEL_G41_HB:
-	case PCI_DEVICE_ID_INTEL_B43_HB:
+	case PCI_DEVICE_ID_INTEL_B43_1_HB:
+	case PCI_DEVICE_ID_INTEL_B43_2_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB:
-- 
1.7.1

