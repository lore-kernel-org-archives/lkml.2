Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1AWRpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:45:12 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:45000 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab1AWRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:45:11 -0500
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: chris@chris-wilson.co.uk, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Use cachable mapping for i915 opregion.
Date: Sun, 23 Jan 2011 18:23:34 +0100
Message-Id: <1295803414-5373-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 87.123.113.19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opregion is a shared memory region between ACPI and the graphics
driver. As the ACPI mapping has been changed to cachable in commit
6d5bbf00d251cc73223a71422d69e069dc2e0b8d, mapping the intel opregion
non-cachable now fails. As no bus-master hardware is involved in the
opregion, cachable map should do no harm.

Tested on a Fujitsu Lifebook P8010.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 drivers/gpu/drm/i915/intel_opregion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index f295a7a..dfaccd5 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -476,7 +476,7 @@ int intel_opregion_setup(struct drm_device *dev)
 		return -ENOTSUPP;
 	}
 
-	base = ioremap(asls, OPREGION_SIZE);
+	base = ioremap_cache(asls, OPREGION_SIZE);
 	if (!base)
 		return -ENOMEM;
 
-- 
1.7.2.3

