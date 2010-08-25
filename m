Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0HYE6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:58:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0HYE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012219"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366130"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH 00/24] Support for Qualcomm msm8660 target
Date: Tue, 24 Aug 2010 21:57:29 -0700
Message-Id: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to the Qualcomm msm8660 target. It currently
provides uniprocessor support only, though SMP support is forthcoming.
Note that this code is based on top of Gregory Bean's gpiomux code, and
won't build until the mach-types are updated.

Abhijeet Dharmapurikar (3):
  GIC: Dont disable INT in ack callback
  msm: irqs-8x60: interrupt map
  msm: 8x60: setup correct handlers for private interrupts

Daniel Walker (3):
  arm: mm: add proc info for ScorpionMP
  msm: add hotplug stub functions
  msm: allow uart to be conditionally disabled

Gregory Bean (1):
  msm: add MSM8x60 FFA support

Jeff Ohlstein (5):
  msm: timer: support 8x60 timers
  msm: clock: add dummy clock driver
  dma: add stub functions for dma features not yet present on 8x60
  msm: add build support for msm8x60 target
  msm: physical offset for MSM8X60

Stepan Moskovchenko (3):
  msm: Add MSM IOMMU support
  msm: Platform initialization for the IOMMU driver
  msm: Platform data for msm8x60 IOMMUs

Steve Muckle (9):
  msm: create config option for proc-comm
  arm: Kconfig option for ARCH_MSM_SCORPIONMP
  msm: io: MSM8X60 io support
  msm: initial irq definitions for MSM8X60
  msm: MSM8X60 RUMI3 board support
  msm: irq: rename existing entry-macro to entry-macro-vic
  msm: 8x60: gic initialization fixup for RUMI
  msm: add msm8x60_surf machine
  msm: MSM8X60 simulator board support

 arch/arm/Kconfig                                  |    3 +-
 arch/arm/common/gic.c                             |   14 -
 arch/arm/mach-msm/Kconfig                         |   52 +-
 arch/arm/mach-msm/Makefile                        |   20 +-
 arch/arm/mach-msm/board-msm8x60.c                 |  102 ++
 arch/arm/mach-msm/clock-dummy.c                   |   54 +
 arch/arm/mach-msm/devices-msm8x60-iommu.c         |  883 ++++++++++
 arch/arm/mach-msm/hotplug.c                       |   22 +
 arch/arm/mach-msm/include/mach/debug-macro.S      |    2 +-
 arch/arm/mach-msm/include/mach/dma.h              |   10 +-
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S |   96 ++
 arch/arm/mach-msm/include/mach/entry-macro-vic.S  |   37 +
 arch/arm/mach-msm/include/mach/entry-macro.S      |   43 +-
 arch/arm/mach-msm/include/mach/io.h               |    1 +
 arch/arm/mach-msm/include/mach/iommu.h            |  103 ++
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h    | 1871 +++++++++++++++++++++
 arch/arm/mach-msm/include/mach/irqs-8x60.h        |  267 +++
 arch/arm/mach-msm/include/mach/irqs.h             |    2 +
 arch/arm/mach-msm/include/mach/memory.h           |    2 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h   |   59 +
 arch/arm/mach-msm/include/mach/smp.h              |   39 +
 arch/arm/mach-msm/io.c                            |   15 +
 arch/arm/mach-msm/iommu.c                         |  597 +++++++
 arch/arm/mach-msm/iommu_dev.c                     |  364 ++++
 arch/arm/mach-msm/timer.c                         |  226 ++-
 arch/arm/mm/proc-v7.S                             |   24 +
 26 files changed, 4798 insertions(+), 110 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8x60.c
 create mode 100644 arch/arm/mach-msm/clock-dummy.c
 create mode 100644 arch/arm/mach-msm/devices-msm8x60-iommu.c
 create mode 100644 arch/arm/mach-msm/hotplug.c
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-qgic.S
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-vic.S
 create mode 100644 arch/arm/mach-msm/include/mach/iommu.h
 create mode 100644 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8x60.h
 create mode 100644 arch/arm/mach-msm/include/mach/smp.h
 create mode 100644 arch/arm/mach-msm/iommu.c
 create mode 100644 arch/arm/mach-msm/iommu_dev.c

-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
