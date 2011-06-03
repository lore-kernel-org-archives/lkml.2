Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1FCWog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:44:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23458 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1FCWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:44:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6366"; a="95318292"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH v2 0/7] Move Qualcomm gpio drivers into drivers dir
Date: Fri,  3 Jun 2011 15:44:12 -0700
Message-Id: <1307141059-22431-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves the Qualcomm MSM gpio device drivers into the
drivers/gpio directory.

The MSM's have two flavors of gpio driver.  The one for the newer
v7-based chips is a bit cleaner, and can just be moved.  The one for
the older v6-based chips took some cleanup to get rid of numerous
ifdefs based on the particular machine.  Both drivers can now be
selected and will be used on appropriate targets.

There is still a minor entanglement with the MSM-specific gpiomux
code.  This will be cleaned up as MSM moves to use pinmux.

patch history:
------
v2 - Move header to mach-msm mach dir
   - Fix Kconfig description
   - Base off of Linus tree instead of linux-next (postponed for ARM issues)

David Brown (7):
  msm: gpio: Remove unsupported devices
  msm: Remove chip-ifdefs for GPIO io mappings
  msm: gpio: Remove chip-specific register definitions
  msm: gpio: Remove ifdefs on gpio chip registers
  msm: gpiomux: Move public API to public header
  gpio_msm: Move Qualcomm v6 MSM driver into drivers
  gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers

 arch/arm/mach-msm/Kconfig                          |    4 +
 arch/arm/mach-msm/Makefile                         |    8 -
 arch/arm/mach-msm/gpio_hw.h                        |  278 --------------------
 arch/arm/mach-msm/gpiomux.h                        |   17 +--
 arch/arm/mach-msm/include/mach/msm_gpiomux.h       |   38 +++
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +
 arch/arm/mach-msm/io.c                             |   12 +-
 drivers/gpio/Kconfig                               |   16 ++
 drivers/gpio/Makefile                              |    2 +
 arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c  |  111 +++++----
 drivers/gpio/msm_v1.h                              |  271 +++++++++++++++++++
 .../mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c    |    2 +-
 15 files changed, 414 insertions(+), 377 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 rename arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c (82%)
 create mode 100644 drivers/gpio/msm_v1.h
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c (99%)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

