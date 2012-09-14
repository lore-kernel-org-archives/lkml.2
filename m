Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2INMyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:54:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36503 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2INMyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:54:10 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 14/14] [media] davinci: vpfe: Add documentation
Date: Fri, 14 Sep 2012 18:16:44 +0530
Message-Id: <1347626804-5703-15-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add documentation on the Davinci VPFE driver. Document the subdevs,
and private IOTCLs the driver implements

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Rob Landley <rob@landley.net>
Cc: <linux-doc@vger.kernel.org>
---
 Documentation/video4linux/davinci-vpfe-mc.txt |   95 +++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt

diff --git a/Documentation/video4linux/davinci-vpfe-mc.txt b/Documentation/video4linux/davinci-vpfe-mc.txt
new file mode 100644
index 0000000..9dfc4f9
--- /dev/null
+++ b/Documentation/video4linux/davinci-vpfe-mc.txt
@@ -0,0 +1,95 @@
+Davinci Video processing Front End (VPFE) driver
+
+Copyright (C) 2012 Texas Instruments Inc
+
+Contacts: Manjunath Hadli <manjunath.hadli@ti.com>
+
+
+Introduction
+============
+
+This file documents the Texas Instruments Davinci Video processing Front End
+(VPFE) driver located under drivers/media/platform/davinci. The original driver
+exists for Davinci VPFE, which is now being changed to Media Controller
+Framework.
+
+Currently the driver has been successfully used on the following
+version of Davinci:
+
+	DM365/DM368
+
+The driver implements V4L2, Media controller and v4l2_subdev interfaces. Sensor,
+lens and flash drivers using the v4l2_subdev interface in the kernel are
+supported.
+
+
+Split to subdevs
+================
+
+The Davinci VPFE is split into V4L2 subdevs, each of the blocks inside the VPFE
+having one subdev to represent it. Each of the subdevs provide a V4L2 subdev
+interface to userspace.
+
+	DAVINCI CCDC
+	DAVINCI PREVIEWER
+	DAVINCI RESIZER
+
+Each possible link in the VPFE is modeled by a link in the Media controller
+interface. For an example program see [1].
+
+
+Private IOCTLs
+==============
+
+The Davinci Video processing Front End (VPFE) driver supports standard V4L2
+IOCTLs and controls where possible and practical. Much of the functions provided
+by the VPFE, however, does not fall under the standard IOCTL's.
+
+In general, there is a private ioctl for configuring each of the blocks
+containing hardware-dependent functions.
+
+The following private IOCTLs are supported:
+
+	VIDIOC_VPFE_CCDC_[S/G]_RAW_PARAMS
+	VIDIOC_VPFE_PRV_[S/G]_CONFIG
+	VIDIOC_VPFE_RSZ_[S/G]_CONFIG
+
+The parameter structures used by these ioctl's are described in
+include/linux/davinci_vpfe.h and include/linux/dm365_ccdc.h.
+
+The VIDIOC_VPFE_CCDC_S_RAW_PARAMS, VIDIOC_VPFE_PRV_S_CONFIG and
+VIDIOC_VPFE_RSZ_S_CONFIG are used to configure, enable and disable functions in
+the CCDC, preview and resizer blocks respectively. These IOCTL's control several
+functions in the blocks they control. VIDIOC_VPFE_CCDC_S_RAW_PARAMS IOCTL
+accepts a pointer to struct ccdc_config_params_raw as its argument. Similarly
+VIDIOC_VPFE_PRV_S_CONFIG accepts a pointer to struct vpfe_prev_config. And
+VIDIOC_VPFE_RSZ_S_CONFIG accepts a pointer to struct vpfe_rsz_config as its
+argument. Similarly VIDIOC_VPFE_CCDC_G_RAW_PARAMS, VIDIOC_VPFE_PRV_G_CONFIG and
+VIDIOC_VPFE_RSZ_G_CONFIG are used to get the current configuration set
+in the CCDC, preview and resizer blocks respectively.
+
+The detailed functions of the VPFE itself related to a given VPFE block is
+described in the Technical Reference Manuals (TRMs) --- see the end of the
+document for those.
+
+
+Technical reference manuals (TRMs) and other documentation
+==========================================================
+
+Davinci DM365 TRM:
+<URL:http://www.ti.com/lit/ds/sprs457e/sprs457e.pdf>
+Referenced MARCH 2009-REVISED JUNE 2011
+
+Davinci DM368 TRM:
+<URL:http://www.ti.com/lit/ds/sprs668c/sprs668c.pdf>
+Referenced APRIL 2010-REVISED JUNE 2011
+
+Davinci Video Processing Front End (VPFE) DM36x
+<URL:http://www.ti.com/lit/ug/sprufg8c/sprufg8c.pdf>
+
+
+References
+==========
+
+[1] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
+[2] include/linux/davinci_vpfe.h & include/linux/dm365_ccdc.h
-- 
1.7.4.1

