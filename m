Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab2K3MBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:01:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61544 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2K3MBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:01:33 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 0/9] Media Controller capture driver for DM365
Date: Fri, 30 Nov 2012 17:31:10 +0530
Message-Id: <1354276879-27244-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

The below series of patches have gone through good amount of reviews, and
agreed by Laurent, Hans and Sakari to be part of the staging tree.

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

Changes for v4:
1: Added a entry in TODO, to have a compatibility layer while replacing the
   older driver.
2: Included the ACK's in commit message.

Changes for v3:
1: Rebased on staging.
2: Seprated out patches which would go into staging.

Changes for v2:
1: Migrated the driver for videobuf2 usage pointed Hans.
2: Changed the design as pointed by Laurent, Exposed one more subdevs
   ipipeif and split the resizer subdev into three subdevs.
3: Rearrganed the patch sequence and changed the commit messages.
4: Changed the file architecture as pointed by Laurent.

Manjunath Hadli (9):
  davinci: vpfe: add v4l2 capture driver with media interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: dm365: add IPIPEIF driver based on media framework
  davinci: vpfe: dm365: add ISIF driver based on media framework
  davinci: vpfe: dm365: add IPIPE support for media controller driver
  davinci: vpfe: dm365: add IPIPE hardware layer support
  davinci: vpfe: dm365: resizer driver based on media framework
  davinci: vpfe: dm365: add build infrastructure for capture driver
  davinci: vpfe: Add documentation and TODO

 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/davinci_vpfe/Kconfig         |    9 +
 drivers/staging/media/davinci_vpfe/Makefile        |    3 +
 drivers/staging/media/davinci_vpfe/TODO            |   37 +
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |  154 ++
 .../staging/media/davinci_vpfe/davinci_vpfe_user.h | 1290 ++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 1863 +++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.h   |  179 ++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    | 1048 ++++++++++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |  559 ++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1071 ++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h |  233 +++
 .../media/davinci_vpfe/dm365_ipipeif_user.h        |   93 +
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2104 ++++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_isif.h    |  203 ++
 .../staging/media/davinci_vpfe/dm365_isif_regs.h   |  294 +++
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 1999 +++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |  244 +++
 drivers/staging/media/davinci_vpfe/vpfe.h          |   86 +
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  740 +++++++
 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |   97 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 1620 +++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  155 ++
 24 files changed, 14084 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/davinci_vpfe/Kconfig
 create mode 100644 drivers/staging/media/davinci_vpfe/Makefile
 create mode 100644 drivers/staging/media/davinci_vpfe/TODO
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.h

-- 
1.7.4.1

