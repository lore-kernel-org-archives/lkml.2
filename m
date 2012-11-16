Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2KPOrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:47:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2KPOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:47:43 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>
Subject: [PATCH v2 12/12] davinci: vpfe: Add documentation
Date: Fri, 16 Nov 2012 20:15:14 +0530
Message-Id: <1353077114-19296-13-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add documentation on the Davinci VPFE driver. Document the subdevs,
and private IOTCLs the driver implements.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Rob Landley <rob@landley.net>
Cc: <linux-doc@vger.kernel.org>
---
 Documentation/video4linux/davinci-vpfe-mc.txt |  154 +++++++++++++++++++++++++
 1 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt

diff --git a/Documentation/video4linux/davinci-vpfe-mc.txt b/Documentation/video4linux/davinci-vpfe-mc.txt
new file mode 100644
index 0000000..1dbd564
--- /dev/null
+++ b/Documentation/video4linux/davinci-vpfe-mc.txt
@@ -0,0 +1,154 @@
+Davinci Video processing Front End (VPFE) driver
+
+Copyright (C) 2012 Texas Instruments Inc
+
+Contacts: Manjunath Hadli <manjunath.hadli@ti.com>
+	  Prabhakar Lad <prabhakar.lad@ti.com>
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
+	DAVINCI ISIF
+	DAVINCI IPIPEIF
+	DAVINCI IPIPE
+	DAVINCI CROP RESIZER
+	DAVINCI RESIZER A
+	DAVINCI RESIZER B
+
+Each possible link in the VPFE is modeled by a link in the Media controller
+interface. For an example program see [1].
+
+
+ISIF, IPIPE, and RESIZER block IOCTLs
+======================================
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
+	VIDIOC_VPFE_ISIF_[S/G]_RAW_PARAMS
+	VIDIOC_VPFE_IPIPE_[S/G]_CONFIG
+	VIDIOC_VPFE_RSZ_[S/G]_CONFIG
+
+The parameter structures used by these ioctl's are described in
+include/uapi/linux/davinci_vpfe.h.
+
+The VIDIOC_VPFE_ISIF_S_RAW_PARAMS, VIDIOC_VPFE_IPIPE_S_CONFIG and
+VIDIOC_VPFE_RSZ_S_CONFIG are used to configure, enable and disable functions in
+the isif, ipipe and resizer blocks respectively. These IOCTL's control several
+functions in the blocks they control. VIDIOC_VPFE_ISIF_S_RAW_PARAMS IOCTL
+accepts a pointer to struct vpfe_isif_raw_config as its argument. Similarly
+VIDIOC_VPFE_IPIPE_S_CONFIG accepts a pointer to struct vpfe_ipipe_config. And
+VIDIOC_VPFE_RSZ_S_CONFIG accepts a pointer to struct vpfe_rsz_config as its
+argument. Similarly VIDIOC_VPFE_ISIF_G_RAW_PARAMS, VIDIOC_VPFE_IPIPE_G_CONFIG
+and VIDIOC_VPFE_RSZ_G_CONFIG are used to get the current configuration set in
+the isif, ipipe and resizer blocks respectively.
+
+The detailed functions of the VPFE itself related to a given VPFE block is
+described in the Technical Reference Manuals (TRMs) --- see the end of the
+document for those.
+
+
+IPIPEIF block IOCTLs
+======================================
+
+The following private IOCTLs are supported:
+
+	VIDIOC_VPFE_IPIPEIF_[S/G]_CONFIG
+
+The parameter structures used by these ioctl's are described in
+include/uapi/linux/dm365_ipipeif.h
+
+The VIDIOC_VPFE_IPIPEIF_S_CONFIG is used to configure the ipipeif
+hardware block. The VIDIOC_VPFE_IPIPEIF_S_CONFIG and
+VIDIOC_VPFE_IPIPEIF_G_CONFIG accepts a pointer to struct ipipeif_params
+as its argument.
+
+
+VPFE Operating Modes
+==========================================
+
+a: Continuous Modes
+------------------------
+
+1: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> SDRAM
+
+2: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> DAVINCI IPIPEIF--->|
+                                                                   |
+   <--------------------<----------------<---------------------<---|
+   |
+   V
+ DAVINCI CROP RESIZER--->DAVINCI RESIZER [A/B]---> SDRAM
+
+3: tvp514x/tvp7002/mt9p031---> DAVINCI ISIF---> DAVINCI IPIPEIF--->|
+                                                                   |
+   <--------------------<----------------<---------------------<---|
+   |
+   V
+ DAVINCI IPIPE---> DAVINCI CROP RESIZER--->DAVINCI RESIZER [A/B]---> SDRAM
+
+a: Single Shot Modes
+------------------------
+
+1: SDRAM---> DAVINCI IPIPEIF---> DAVINCI IPIPE---> DAVINCI CROP RESIZER--->|
+                                                                           |
+   <----------------<----------------<------------------<---------------<--|
+   |
+   V
+DAVINCI RESIZER [A/B]---> SDRAM
+
+2: SDRAM---> DAVINCI IPIPEIF---> DAVINCI CROP RESIZER--->|
+                                                         |
+   <----------------<----------------<---------------<---|
+   |
+   V
+DAVINCI RESIZER [A/B]---> SDRAM
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
-- 
1.7.4.1

