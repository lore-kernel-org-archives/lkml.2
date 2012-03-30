Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab2C3WUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:20:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935820Ab2C3VMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:40 -0400
Message-Id: <20120330194850.693556670@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 076/149] drm/radeon/kms: add connector quirk for Fujitsu D3003-S2 board
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4c1b2d2da3451f5c8dd59bd7e05bd9729d2aee05 upstream.

vbios lists DVI-I port as VGA and DVI-D.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=47007

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -442,6 +442,20 @@ static bool radeon_atom_apply_quirks(str
 		struct radeon_device *rdev = dev->dev_private;
 		*i2c_bus = radeon_lookup_i2c_gpio(rdev, 0x93);
 	}
+
+	/* Fujitsu D3003-S2 board lists DVI-I as DVI-D and VGA */
+	if ((dev->pdev->device == 0x9802) &&
+	    (dev->pdev->subsystem_vendor == 0x1734) &&
+	    (dev->pdev->subsystem_device == 0x11bd)) {
+		if (*connector_type == DRM_MODE_CONNECTOR_VGA) {
+			*connector_type = DRM_MODE_CONNECTOR_DVII;
+			*line_mux = 0x3103;
+		} else if (*connector_type == DRM_MODE_CONNECTOR_DVID) {
+			*connector_type = DRM_MODE_CONNECTOR_DVII;
+		}
+	}
+
+
 	return true;
 }
 


