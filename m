Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2CENkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:40:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2CENkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:40:10 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/radeon/kms: fix MSI re-arm on rv370+" has been added to staging queue
Date: Mon,  5 Mar 2012 14:40:07 +0100
Message-Id: <1330954807-5825-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/radeon/kms: fix MSI re-arm on rv370+

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 2e1a2aa9a9969836243d634dfbf1631e7e63f53e Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Mon, 13 Feb 2012 16:36:34 -0500
Subject: [PATCH] drm/radeon/kms: fix MSI re-arm on rv370+

commit b7f5b7dec3d539a84734f2bcb7e53fbb1532a40b upstream.

MSI_REARM_EN register is a write only trigger register.
There is no need RMW when re-arming.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=41668

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c  |    4 +---
 drivers/gpu/drm/radeon/rs600.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index c9e93ea..a2ae151 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -218,9 +218,7 @@ int r100_irq_process(struct radeon_device *rdev)
 			WREG32(RADEON_AIC_CNTL, msi_rearm | RS400_MSI_REARM);
 			break;
 		default:
-			msi_rearm = RREG32(RADEON_MSI_REARM_EN) & ~RV370_MSI_REARM_EN;
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm);
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm | RV370_MSI_REARM_EN);
+			WREG32(RADEON_MSI_REARM_EN, RV370_MSI_REARM_EN);
 			break;
 		}
 	}
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 1700297..52b7799 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -270,9 +270,7 @@ int rs600_irq_process(struct radeon_device *rdev)
 			WREG32(RADEON_BUS_CNTL, msi_rearm | RS600_MSI_REARM);
 			break;
 		default:
-			msi_rearm = RREG32(RADEON_MSI_REARM_EN) & ~RV370_MSI_REARM_EN;
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm);
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm | RV370_MSI_REARM_EN);
+			WREG32(RADEON_MSI_REARM_EN, RV370_MSI_REARM_EN);
 			break;
 		}
 	}
--
1.7.9

