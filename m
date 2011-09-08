Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab1IHNdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:33:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58746 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab1IHNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:33:41 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <g.liakhovetski@gmx.de>, Deepthy Ravi <deepthy.ravi@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/8] OMAP3EVM: Add tvp514x video decoder support
Date: Thu, 8 Sep 2011 19:03:12 +0530
Message-ID: <1315488792-15949-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset
        -add support for tvp514x video decoder on omap3evm and also migrate the
         decoder driver to media controller framework.
        -add support for BT656 interface.
        -enable multimedia driver and tvp514x decoder support in omap2plus_defconfig.

It is dependent on the following patch
https://patchwork.kernel.org/patch/1062042/ which moves
platform data definitions from isp.h to media/omap3isp.h

Cc: Vaibhav Hiremath <hvaibhav@ti.com>
---

Deepthy Ravi (1):
  omap2plus_defconfig: Enable tvp514x video decoder support

Vaibhav Hiremath (7):
  omap3evm: Enable regulators for camera interface
  omap3evm: Add Camera board init/hookup file
  tvp514x: Migrate to media-controller framework
  ispvideo: Add support for G/S/ENUM_STD ioctl
  ispccdc: Configure CCDC registers
  ispccdc: Add support for BT656 interface
  omap3evm: camera: Configure BT656 interface

 arch/arm/configs/omap2plus_defconfig        |   10 +
 arch/arm/mach-omap2/Makefile                |    5 +
 arch/arm/mach-omap2/board-omap3evm-camera.c |  258 +++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3evm.c        |   44 +++++
 drivers/media/video/omap3isp/ispccdc.c      |  185 +++++++++++++++-----
 drivers/media/video/omap3isp/ispreg.h       |    1 +
 drivers/media/video/omap3isp/ispvideo.c     |  106 +++++++++++-
 drivers/media/video/omap3isp/ispvideo.h     |    5 +-
 drivers/media/video/tvp514x.c               |  241 ++++++++++++++++++++++---
 include/media/omap3isp.h                    |    7 +
 include/media/tvp514x.h                     |    3 +
 include/media/v4l2-subdev.h                 |    7 +-
 12 files changed, 797 insertions(+), 75 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c

