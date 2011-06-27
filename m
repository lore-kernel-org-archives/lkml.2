Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1F0Pjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:39:45 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40682 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382Ab1F0PiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:38:10 -0400
Message-Id: <1868ba261f47136619ef71c85ff1ef56b085fbe2.1309182743.git.ralf@linux-mips.org>
In-Reply-To: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
From: Ralf Baechle <ralf@linux-mips.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Date: Mon, 27 Jun 2011 14:40:35 +0100
Subject: [PATCH 12/12] DRM: Radeon: Fix section mismatch.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/gpu/drm/radeon/radeon.o(.text+0x5d1fc): Section mismatch in reference from the function radeon_get_clock_info() to the function .devinit.text:radeon_read_clocks_OF()
The function radeon_get_clock_info() references
the function __devinit radeon_read_clocks_OF().
This is often because radeon_get_clock_info lacks a __devinit
annotation or the annotation of radeon_read_clocks_OF is wrong.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
---
 drivers/gpu/drm/radeon/radeon_clocks.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_clocks.c b/drivers/gpu/drm/radeon/radeon_clocks.c
index 2d48e7a..dcd0863e 100644
--- a/drivers/gpu/drm/radeon/radeon_clocks.c
+++ b/drivers/gpu/drm/radeon/radeon_clocks.c
@@ -96,7 +96,7 @@ uint32_t radeon_legacy_get_memory_clock(struct radeon_device *rdev)
  * Read XTAL (ref clock), SCLK and MCLK from Open Firmware device
  * tree. Hopefully, ATI OF driver is kind enough to fill these
  */
-static bool __devinit radeon_read_clocks_OF(struct drm_device *dev)
+static bool radeon_read_clocks_OF(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
 	struct device_node *dp = rdev->pdev->dev.of_node;
@@ -166,7 +166,7 @@ static bool __devinit radeon_read_clocks_OF(struct drm_device *dev)
 	return true;
 }
 #else
-static bool __devinit radeon_read_clocks_OF(struct drm_device *dev)
+static bool radeon_read_clocks_OF(struct drm_device *dev)
 {
 	return false;
 }
-- 
1.7.4.4

