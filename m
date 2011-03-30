Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab1C3V4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:56:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:17364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933341Ab1C3VG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447393"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [79/275] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
Message-Id: <20110330210516.D6B983E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit f598aa7593427ffe3a61e7767c34bd695a5e7ed0 upstream.

Reported-by: 屋国遥 <hyagni@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 22:51:38.578736036 -0700
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 23:55:09.579222069 -0700
@@ -289,6 +289,17 @@
 			*line_mux = 0x90;
 	}
 
+	/* mac rv630 */
+	if ((dev->pdev->device == 0x9588) &&
+	    (dev->pdev->subsystem_vendor == 0x106b) &&
+	    (dev->pdev->subsystem_device == 0x00a6)) {
+		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+		}
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&
