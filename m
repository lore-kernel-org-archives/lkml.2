Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab0JFHnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6371 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab0JFHnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56883643"
X-IronPort-AV: E=Sophos;i="4.57,287,1283756400"; 
   d="scan'208";a="88852275"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH 00/20 v2] Support for Qualcomm msm8660 target
Date: Wed,  6 Oct 2010 00:42:39 -0700
Message-Id: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to the Qualcomm msm8660 target. It currently
provides uniprocessor support only, though SMP support is forthcoming.

Abhijeet Dharmapurikar (2):
  msm: irqs-8x60: interrupt map
  msm: 8x60: setup correct handlers for private interrupts

Daniel Walker (2):
  msm: dma: add stub functions for dma features not yet present on 8x60
  msm: allow uart to be conditionally disabled

Gregory Bean (1):
  msm: add MSM8x60 FFA support

Jeff Ohlstein (4):
  msm: timer: support 8x60 timers
  msm: clock: add dummy clock driver
  msm: add build support for msm8x60 target
  msm: physical offset for MSM8X60

Stepan Moskovchenko (3):
  msm: Add MSM IOMMU support
  msm: Platform initialization for the IOMMU driver
  msm: Platform data for msm8x60 IOMMUs

Steve Muckle (8):
  msm: create config option for proc-comm
  msm: io: MSM8X60 io support
  msm: initial irq definitions for MSM8X60
  msm: MSM8X60 RUMI3 board support
  msm: irq: rename existing entry-macro to entry-macro-vic
  msm: 8x60: gic initialization fixup for RUMI
  msm: add msm8x60_surf machine
  msm: MSM8X60 simulator board support

 arch/arm/mach-msm/Kconfig                         |   47 +
 arch/arm/mach-msm/Makefile                        |   17 +-
 arch/arm/mach-msm/board-msm8x60.c                 |  100 ++
 arch/arm/mach-msm/clock-dummy.c                   |   54 +
 arch/arm/mach-msm/devices-msm8x60-iommu.c         |  883 ++++++++++
 arch/arm/mach-msm/include/mach/board.h            |    2 +
 arch/arm/mach-msm/include/mach/debug-macro.S      |    2 +-
 arch/arm/mach-msm/include/mach/dma.h              |   10 +-
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S |   88 +
 arch/arm/mach-msm/include/mach/entry-macro-vic.S  |   37 +
 arch/arm/mach-msm/include/mach/entry-macro.S      |   43 +-
 arch/arm/mach-msm/include/mach/io.h               |    1 +
 arch/arm/mach-msm/include/mach/iommu.h            |  103 ++
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h    | 1871 +++++++++++++++++++++
 arch/arm/mach-msm/include/mach/irqs-8x60.h        |  268 +++
 arch/arm/mach-msm/include/mach/irqs.h             |    2 +
 arch/arm/mach-msm/include/mach/memory.h           |    2 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h   |   97 ++
 arch/arm/mach-msm/include/mach/msm_iomap.h        |    4 +
 arch/arm/mach-msm/include/mach/smp.h              |   39 +
 arch/arm/mach-msm/io.c                            |   15 +
 arch/arm/mach-msm/iommu.c                         |  597 +++++++
 arch/arm/mach-msm/iommu_dev.c                     |  364 ++++
 arch/arm/mach-msm/timer.c                         |   23 +-
 24 files changed, 4629 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8x60.c
 create mode 100644 arch/arm/mach-msm/clock-dummy.c
 create mode 100644 arch/arm/mach-msm/devices-msm8x60-iommu.c
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-qgic.S
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-vic.S
 create mode 100644 arch/arm/mach-msm/include/mach/iommu.h
 create mode 100644 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8x60.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
 create mode 100644 arch/arm/mach-msm/include/mach/smp.h
 create mode 100644 arch/arm/mach-msm/iommu.c
 create mode 100644 arch/arm/mach-msm/iommu_dev.c

-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
