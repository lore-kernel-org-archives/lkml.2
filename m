Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab1KBShG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1KBSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706926"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [RFC PATCH 00/34] msm: msm8660 and msm8960 clock support
Date: Wed,  2 Nov 2011 11:35:57 -0700
Message-Id: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM8660 and MSM8960 have had out-of-tree clock drivers for quite
some time.  Since people can now order the Dragonboard with the
MSM8660, I thought it would be good to make sure these get sent out.
Saravana is actively working on this getting this code into the tree,
so this RFC is mostly to make the code available for people who get
the hardware before this work is done.

I'll also put these changes on top of a recent version of Linus'
master branch and make them available at

  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-clock-rfc

David

David Brown (2):
  ARM: msm: fix names of UART clocks
  msm_serial: fix clock rate on DMA-based uarts

Matt Wagantall (8):
  msm: clock-local: Add support for 8x60 clock types
  msm: clock: Add 8x60 clock support
  msm: clock: Add list_rate debugfs nodes for locally-controlled clocks
  msm: clock: Add debugfs interface to measure clock rates
  msm: clock-8x60: Support measurement of CPU and L2 clocks
  msm: clock: Expand CLK_MIN, CLK_MAX and CLK_MINMAX macros
  msm: clock: Add EBI1 voter clocks for ADM on SoCs without them
  msm: clock-8x60: Add local control of vpe_axi_clk and vpe_axi_clk

Saravana Kannan (1):
  msm: clock: Add 7x30 local clock support

Stepan Moskovchenko (1):
  msm-8x60: Add serial support

Stephen Boyd (22):
  msm: clock-pcom: Mark functions static
  msm: clock: Always use an array to iterate over clocks
  msm: clock: Pass struct clk to the clk_ops
  msm: clock: Support one lock per clock
  msm: clock-pcom: Introduce a struct pcom_clk
  msm: clock: Support clk_[s|g]et_parent() clk_ops
  msm: clock-debug: Use clk_enable()/clk_disable() directly
  msm: clock: Enable/disable parent clocks generically
  msm: clock: Implement rate voting
  msm: clock-pcom: Add pbus specific clock ops
  msm: Migrate to clock rate voting
  msm: clock: Make most clk_*() operations optional
  msm: clock-debug: Implement a default is_enabled()
  msm: proc_comm: Add CLKCTL_RPC_SRC_REQUEST
  msm: clock: Add local clock control framework
  msm: clock-pcom: Expose pc_clk_reset
  msm: Unify iomap for clock regions
  msm: clock: Support dummy clocks
  msm: clock: Add 8960 clock support
  msm: 8660: Add FLUID support
  msm: clock: Invert CLKFLAG_AUTO_OFF
  msm: clock: Remove msm_clk_soc_init()

 arch/arm/mach-msm/Kconfig                       |    6 +
 arch/arm/mach-msm/Makefile                      |    5 +
 arch/arm/mach-msm/board-msm7x30.c               |    2 +-
 arch/arm/mach-msm/board-msm8960.c               |    9 +-
 arch/arm/mach-msm/board-msm8x60.c               |   69 +
 arch/arm/mach-msm/clock-7x30.c                  | 3001 +++++++++++++++++
 arch/arm/mach-msm/clock-7x30.h                  |  155 -
 arch/arm/mach-msm/clock-8960.c                  | 3930 +++++++++++++++++++++++
 arch/arm/mach-msm/clock-8x60.c                  | 3684 +++++++++++++++++++++
 arch/arm/mach-msm/clock-8x60.h                  |  293 ++
 arch/arm/mach-msm/clock-debug.c                 |   83 +-
 arch/arm/mach-msm/clock-dummy.c                 |   69 +
 arch/arm/mach-msm/clock-local.c                 |  969 ++++++
 arch/arm/mach-msm/clock-local.h                 |  316 ++
 arch/arm/mach-msm/clock-pcom-lookup.c           |  385 +++
 arch/arm/mach-msm/clock-pcom.c                  |   65 +-
 arch/arm/mach-msm/clock-pcom.h                  |   35 +-
 arch/arm/mach-msm/clock-voter.c                 |  187 ++
 arch/arm/mach-msm/clock-voter.h                 |   42 +
 arch/arm/mach-msm/clock.c                       |  150 +-
 arch/arm/mach-msm/clock.h                       |   63 +-
 arch/arm/mach-msm/devices-msm7x00.c             |  124 +-
 arch/arm/mach-msm/devices-msm7x30.c             |   82 -
 arch/arm/mach-msm/devices-qsd8x50.c             |  175 +-
 arch/arm/mach-msm/devices.h                     |    4 +-
 arch/arm/mach-msm/include/mach/board.h          |    2 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    9 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    9 +
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    3 +
 arch/arm/mach-msm/io.c                          |   12 +-
 arch/arm/mach-msm/proc_comm.h                   |    1 +
 drivers/tty/serial/msm_serial.c                 |    2 +-
 35 files changed, 13506 insertions(+), 450 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-7x30.c
 delete mode 100644 arch/arm/mach-msm/clock-7x30.h
 create mode 100644 arch/arm/mach-msm/clock-8960.c
 create mode 100644 arch/arm/mach-msm/clock-8x60.c
 create mode 100644 arch/arm/mach-msm/clock-8x60.h
 create mode 100644 arch/arm/mach-msm/clock-dummy.c
 create mode 100644 arch/arm/mach-msm/clock-local.c
 create mode 100644 arch/arm/mach-msm/clock-local.h
 create mode 100644 arch/arm/mach-msm/clock-pcom-lookup.c
 create mode 100644 arch/arm/mach-msm/clock-voter.c
 create mode 100644 arch/arm/mach-msm/clock-voter.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
