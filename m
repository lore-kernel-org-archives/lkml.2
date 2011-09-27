Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1I0Nlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:41:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53048 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1I0Nlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:41:40 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <tony@atomide.com>, <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <kyungmin.park@samsung.com>, <hverkuil@xs4all.nl>,
        <m.szyprowski@samsung.com>, <g.liakhovetski@gmx.de>,
        <santosh.shilimkar@ti.com>, <khilman@deeprootsystems.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH v2 0/5] OMAP3EVM: Add support for MT9T111 sensor
Date: Tue, 27 Sep 2011 19:10:43 +0530
Message-ID: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset
	-adds support for MT9T111 sensor on omap3evm.
	Currently the sensor driver supports only
	VGA resolution.
	-enables MT9T111 sensor in omap2plus_defconfig.

This is dependent on the following patchset
http://www.spinics.net/lists/linux-media/msg37270.html 
which adds YUYV input support for OMAP3ISP. And is 
applied on top of rc1-for-3.2 of gliakhovetski/v4l-dvb.git
---
Changes in v2:
	As per the discussion here,
	https://lkml.org/lkml/2011/9/20/280
	the existing mt9t112 driver is reused for
	adding support for mt9t111 sensor.
Deepthy Ravi (3):
  [media] v4l: Add support for mt9t111 sensor driver
  ispccdc: Configure CCDC_SYN_MODE register
  omap2plus_defconfig: Enable omap3isp and MT9T111 sensor drivers

Vaibhav Hiremath (2):
  omap3evm: Enable regulators for camera interface
  omap3evm: Add Camera board init/hookup file

 arch/arm/configs/omap2plus_defconfig        |    9 +
 arch/arm/mach-omap2/Makefile                |    5 +
 arch/arm/mach-omap2/board-omap3evm-camera.c |  185 ++++
 arch/arm/mach-omap2/board-omap3evm.c        |   26 +
 drivers/media/video/Kconfig                 |    7 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/mt9t111_reg.h           | 1367 +++++++++++++++++++++++++++
 drivers/media/video/mt9t112.c               |  320 ++++++-
 drivers/media/video/omap3isp/ispccdc.c      |   11 +-
 include/media/mt9t111.h                     |   45 +
 10 files changed, 1937 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
 create mode 100644 drivers/media/video/mt9t111_reg.h
 create mode 100644 include/media/mt9t111.h

