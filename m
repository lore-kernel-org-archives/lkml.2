Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab1C3Vzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:55:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:17364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933363Ab1C3VHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447398"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: alexdeucher@gmail.com, airlied@gmail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [80/275] drm/radeon/kms: make the mac rv630 quirk generic
Message-Id: <20110330210517.E35663E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit be23da8ad219650517cbbb7acbeaeb235667113a upstream.

Seems some other boards do this as well.

Reported-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 23:02:59.799305306 -0700
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 23:55:08.406252081 -0700
@@ -289,15 +289,11 @@
 			*line_mux = 0x90;
 	}
 
-	/* mac rv630 */
-	if ((dev->pdev->device == 0x9588) &&
-	    (dev->pdev->subsystem_vendor == 0x106b) &&
-	    (dev->pdev->subsystem_device == 0x00a6)) {
-		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
-		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
-			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
-			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
-		}
+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
 	}
 
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
