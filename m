Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2KPOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:45:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2KPOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:45:26 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/12] Media Controller capture driver for DM365
Date: Fri, 16 Nov 2012 20:15:02 +0530
Message-Id: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

This patch set adds media controller based capture driver for
DM365.

This driver bases its design on Laurent Pinchart's Media Controller Design
whose patches for Media Controller and subdev enhancements form the base.
The driver also takes copious elements taken from Laurent Pinchart and
others' OMAP ISP driver based on Media Controller. So thank you all the
people who are responsible for the Media Controller and the OMAP ISP driver.

Also, the core functionality of the driver comes from the arago vpfe capture
driver of which the isif capture was based on V4L2, with other drivers like
ipipe, ipipeif and Resizer.

Changes for v2:
1: Migrated the driver for videobuf2 usage pointed Hans.
2: Changed the design as pointed by Laurent, Exposed one more subdevs
   ipipeif and split the resizer subdev into three subdevs.
3: Rearrganed the patch sequence and changed the commit messages.
4: Changed the file architecture as pointed by Laurent.

Manjunath Hadli (12):
  davinci: vpfe: add v4l2 capture driver with media interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: dm365: add IPIPEIF driver based on media framework
  davinci: vpfe: dm365: add ISIF driver based on media framework
  davinci: vpfe: dm365: add IPIPE support for media controller driver
  davinci: vpfe: dm365: add IPIPE hardware layer support
  davinci: vpfe: dm365: resizer driver based on media framework
  davinci: vpss: dm365: enable ISP registers
  davinci: vpss: dm365: set vpss clk ctrl
  davinci: vpss: dm365: add vpss helper functions to be used in the
    main driver for setting hardware parameters
  davinci: vpfe: dm365: add build infrastructure for capture driver
  davinci: vpfe: Add documentation

 Documentation/video4linux/davinci-vpfe-mc.txt    |  154 ++
 drivers/media/platform/davinci/Kconfig           |   11 +
 drivers/media/platform/davinci/Makefile          |    3 +
 drivers/media/platform/davinci/dm365_ipipe.c     | 1863 +++++++++++++++++++
 drivers/media/platform/davinci/dm365_ipipe.h     |  179 ++
 drivers/media/platform/davinci/dm365_ipipe_hw.c  | 1048 +++++++++++
 drivers/media/platform/davinci/dm365_ipipe_hw.h  |  559 ++++++
 drivers/media/platform/davinci/dm365_ipipeif.c   | 1063 +++++++++++
 drivers/media/platform/davinci/dm365_ipipeif.h   |  233 +++
 drivers/media/platform/davinci/dm365_isif.c      | 2095 ++++++++++++++++++++++
 drivers/media/platform/davinci/dm365_isif.h      |  203 +++
 drivers/media/platform/davinci/dm365_isif_regs.h |  294 +++
 drivers/media/platform/davinci/dm365_resizer.c   | 1999 +++++++++++++++++++++
 drivers/media/platform/davinci/dm365_resizer.h   |  244 +++
 drivers/media/platform/davinci/vpfe_mc_capture.c |  741 ++++++++
 drivers/media/platform/davinci/vpfe_mc_capture.h |   97 +
 drivers/media/platform/davinci/vpfe_video.c      | 1620 +++++++++++++++++
 drivers/media/platform/davinci/vpfe_video.h      |  155 ++
 drivers/media/platform/davinci/vpss.c            |   59 +
 include/media/davinci/vpfe.h                     |   86 +
 include/media/davinci/vpss.h                     |   16 +
 include/uapi/linux/Kbuild                        |    2 +
 include/uapi/linux/davinci_vpfe.h                | 1285 +++++++++++++
 include/uapi/linux/dm365_ipipeif.h               |   93 +
 24 files changed, 14102 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.h
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.h
 create mode 100644 drivers/media/platform/davinci/dm365_ipipeif.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipeif.h
 create mode 100644 drivers/media/platform/davinci/dm365_isif.c
 create mode 100644 drivers/media/platform/davinci/dm365_isif.h
 create mode 100644 drivers/media/platform/davinci/dm365_isif_regs.h
 create mode 100644 drivers/media/platform/davinci/dm365_resizer.c
 create mode 100644 drivers/media/platform/davinci/dm365_resizer.h
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.c
 create mode 100644 drivers/media/platform/davinci/vpfe_mc_capture.h
 create mode 100644 drivers/media/platform/davinci/vpfe_video.c
 create mode 100644 drivers/media/platform/davinci/vpfe_video.h
 create mode 100644 include/media/davinci/vpfe.h
 create mode 100644 include/uapi/linux/davinci_vpfe.h
 create mode 100644 include/uapi/linux/dm365_ipipeif.h

-- 
1.7.4.1

