Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0KLJ5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:57:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49411 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab0KLJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:57:31 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] [Stable] agp/intel: complete the enablement for B43.1
Date: Fri, 12 Nov 2010 17:57:23 +0800
Message-Id: <1289555843-6425-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch completes the missing part of commit 41a514 and 3dde04b and I think
commit 3dde04b is already in queue for next stable release.

Thanks Chris Wilson has the patch for enabling Intel B43.1 and backports it to
stable kernel. On mainline commit 210b23 and 1a997ff the way to detect gtt size
is changed, but these two commits landed on mainline kernel after .36 kernel
released. So that mainline kernel works fine on B43.1 machine but not stable
kernel.

Without this patch, X fails to start on 2.6.35.y kernel. After patched, X
starts.

This patch is made for 2.6.35.y and I believe it suits for 2.6.36.y.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/char/agp/intel-agp.h |    1 +
 drivers/char/agp/intel-gtt.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index bc9a4ad..cdefd47 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -241,6 +241,7 @@
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G41_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_1_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB || \
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index ed11c77..c35361c 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1338,6 +1338,7 @@ static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
 	case PCI_DEVICE_ID_INTEL_G45_HB:
 	case PCI_DEVICE_ID_INTEL_G41_HB:
 	case PCI_DEVICE_ID_INTEL_B43_HB:
+	case PCI_DEVICE_ID_INTEL_B43_1_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB:
 	case PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB:
-- 
1.7.1

