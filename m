Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1GFXak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:30:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1GFXaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:30:39 -0400
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH 3/3] drm/radeon: Log Subsystem Vendor and Device Information
Date: Thu,  7 Jul 2011 01:30:10 +0200
Message-Id: <1309995012-5873-2-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309995012-5873-1-git-send-email-reimth@gmail.com>
References: <1309995012-5873-1-git-send-email-reimth@gmail.com>
In-Reply-To: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

    Log PCI subsystem vendor and subsystem device ID in addition to
    PCI vendor and device ID during kernel mode initialisation. This helps
    to better identify radeon devices of third-party vendors, e. g. for
    bug analysis.

    Tested for kernel 2.35, 2.38 and 3.0 on Asus M2A-VM HDMI board

Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
---
 drivers/gpu/drm/radeon/radeon_device.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 7cfaa7e..440e6ec 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -704,8 +704,9 @@ int radeon_device_init(struct radeon_device *rdev,
 	rdev->gpu_lockup = false;
 	rdev->accel_working = false;
 
-	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
-		radeon_family_name[rdev->family], pdev->vendor, pdev->device);
+	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
+		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device);
 
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */
-- 
1.7.1

