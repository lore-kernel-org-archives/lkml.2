Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2INMrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:47:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2INMr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:47:29 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 00/14] Media Controller capture driver for DM365
Date: Fri, 14 Sep 2012 18:16:30 +0530
Message-Id: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch set adds media controller based capture driver for
DM365.

This driver bases its design on Laurent Pinchart's Media Controller Design
whose patches for Media Controller and subdev enhancements form the base.
The driver also takes copious elements taken from Laurent Pinchart and
others' OMAP ISP driver based on Media Controller. So thank you all the
people who are responsible for the Media Controller and the OMAP ISP driver.

Also, the core functionality of the driver comes from the arago vpfe capture
driver of which the CCDC capture was based on V4L2, with other drivers like
Previwer, and Resizer.

The current driver caters to dm6446,dm355 and dm365 of which the current
implementation works for dm365. The three VPFE IPs have some common elements
in terms of some high level functionality but there are differences in terms
of register definitions and some core blocks.

The individual specifications for each of these can be found here:
dm365  vpfe: http://www.ti.com/litv/pdf/sprufg8c
dm6446 vpfe: http://www.ti.com/litv/pdf/sprue38h
dm355  vpfe: http://www.ti.com/litv/pdf/spruf71a

This patch set has undergone reviewed several revisions.
(http://davinci-linux-open-source.1494791.n2.nabble.com/
RESEND-RFC-PATCH-v4-00-15-RFC-for-Media-Controller-capture-
driver-for-DM365-td7003648.html). This patches might be appearing
new due to the new folder structure changes to video drivers.

Manjunath Hadli (14):
  davinci: vpfe: add dm3xx IPIPEIF hardware support module
  davinci: vpfe: add IPIPE hardware layer support
  davinci: vpfe: add IPIPE support for media controller driver
  davinci: vpfe: add support for CCDC hardware for dm365
  davinci: vpfe: add ccdc driver with media controller interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: v4l2 capture driver with media interface
  davinci: vpfe: previewer driver based on v4l2 media controller
    framework
  davinci: vpfe: resizer driver based on media framework
  dm365: vpss: setup ISP registers
  dm365: vpss: set vpss clk ctrl
  dm365: vpss: add vpss helper functions to be used in the main driver
    for setting hardware parameters
  davinci: vpfe: build infrastructure for dm365
  [media] davinci: vpfe: Add documentation

 Documentation/video4linux/davinci-vpfe-mc.txt    |   95 +
 drivers/media/platform/davinci/Kconfig           |   40 +-
 drivers/media/platform/davinci/Makefile          |    9 +
 drivers/media/platform/davinci/ccdc_hw_device.h  |   11 +-
 drivers/media/platform/davinci/dm355_ccdc.c      |    2 +-
 drivers/media/platform/davinci/dm365_ccdc.c      | 1424 +++++++++
 drivers/media/platform/davinci/dm365_ccdc.h      |  137 +
 drivers/media/platform/davinci/dm365_ccdc_regs.h |  314 ++
 drivers/media/platform/davinci/dm365_def_para.c  |  294 ++
 drivers/media/platform/davinci/dm365_def_para.h  |   49 +
 drivers/media/platform/davinci/dm365_ipipe.c     | 3673 ++++++++++++++++++++++
 drivers/media/platform/davinci/dm365_ipipe.h     |  430 +++
 drivers/media/platform/davinci/dm365_ipipe_hw.c  |  936 ++++++
 drivers/media/platform/davinci/dm365_ipipe_hw.h  |  538 ++++
 drivers/media/platform/davinci/dm3xx_ipipeif.c   |  318 ++
 drivers/media/platform/davinci/dm3xx_ipipeif.h   |  262 ++
 drivers/media/platform/davinci/dm644x_ccdc.c     |    2 +-
 drivers/media/platform/davinci/imp_hw_if.h       |  180 ++
 drivers/media/platform/davinci/isif.c            |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c    |    2 +-
 drivers/media/platform/davinci/vpfe_ccdc.c       |  903 ++++++
 drivers/media/platform/davinci/vpfe_ccdc.h       |   87 +
 drivers/media/platform/davinci/vpfe_imp_common.h |   84 +
 drivers/media/platform/davinci/vpfe_mc_capture.c |  764 +++++
 drivers/media/platform/davinci/vpfe_mc_capture.h |  104 +
 drivers/media/platform/davinci/vpfe_previewer.c  | 1041 ++++++
 drivers/media/platform/davinci/vpfe_previewer.h  |   71 +
 drivers/media/platform/davinci/vpfe_resizer.c    | 1080 +++++++
 drivers/media/platform/davinci/vpfe_resizer.h    |   66 +
 drivers/media/platform/davinci/vpfe_video.c      | 1725 ++++++++++
 drivers/media/platform/davinci/vpfe_video.h      |  150 +
 drivers/media/platform/davinci/vpss.c            |   56 +
 include/linux/davinci_vpfe.h                     |  929 ++++++
 include/linux/dm365_ccdc.h                       |  592 ++++
 include/linux/dm3xx_ipipeif.h                    |   62 +
 include/media/davinci/vpfe.h                     |   84 +
 include/media/davinci/vpss.h                     |   16 +
 37 files changed, 16518 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt
 create mode 100644 drivers/media/platform/davinci/dm365_ccdc.c
 create mode 100644 drivers/media/platform/davinci/dm365_ccdc.h
 create mode 100644 drivers/media/platform/davinci/dm365_ccdc_regs.h
 create mode 100644 drivers/media/platform/davinci/dm365_def_para.c
 create mode 100644 drivers/media/platform/davinci/dm365_def_para.h
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.h
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.h
 create mode 100644 drivers/media/platform/davinci/dm3xx_ipipeif.c
 create mode 100644 drivers/media/platform/davinci/dm3xx_ipipeif.h
 create mode 100644 drivers/media/platform/davinci/imp_hw_if.h
 create mode 100644 drivers/media/platform/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/platform/davinci/vpfe_ccdc.h
 create mode 100644 drivers/media/platform/davinci/vpfe_imp_common.h
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.c
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.h
 create mode 100644 drivers/media/platform/davinci/vpfe_previewer.c
 create mode 100644 drivers/media/platform/davinci/vpfe_previewer.h
 create mode 100644 drivers/media/platform/davinci/vpfe_resizer.c
 create mode 100644 drivers/media/platform/davinci/vpfe_resizer.h
 create mode 100644 drivers/media/platform/davinci/vpfe_video.c
 create mode 100644 drivers/media/platform/davinci/vpfe_video.h
 create mode 100644 include/linux/davinci_vpfe.h
 create mode 100644 include/linux/dm365_ccdc.h
 create mode 100644 include/linux/dm3xx_ipipeif.h
 create mode 100644 include/media/davinci/vpfe.h

-- 
1.7.4.1

