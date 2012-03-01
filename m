Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287Ab2CAVuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207Ab2CAVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.130.138 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.690173361@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 15/34] drm/radeon/kms: fix MSI re-arm on rv370+
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b7f5b7dec3d539a84734f2bcb7e53fbb1532a40b upstream.

MSI_REARM_EN register is a write only trigger register.
There is no need RMW when re-arming.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=41668

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r100.c  |    4 +---
 drivers/gpu/drm/radeon/rs600.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -218,9 +218,7 @@ int r100_irq_process(struct radeon_devic
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
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -270,9 +270,7 @@ int rs600_irq_process(struct radeon_devi
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


