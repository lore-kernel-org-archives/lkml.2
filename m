Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1FFVvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:51:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1FFVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95967498"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/8] Move Qualcomm gpio drivers into drivers dir
Date: Mon,  6 Jun 2011 14:51:07 -0700
Message-Id: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
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
v3 - Use gpio-* naming for drivers
   - Maintain order in Kconfig/Makefile
   - Fold register defs into C file

David Brown (8):
  msm: gpio: Remove unsupported devices
  msm: Remove chip-ifdefs for GPIO io mappings
  msm: gpio: Remove chip-specific register definitions
  msm: gpio: Remove ifdefs on gpio chip registers
  msm: gpiomux: Move public API to public header
  msm: gpio: Fold register defs into C file
  gpio_msm: Move Qualcomm v6 MSM driver into drivers
  gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers

 arch/arm/mach-msm/Kconfig                          |    4 +
 arch/arm/mach-msm/Makefile                         |    8 -
 arch/arm/mach-msm/gpio.c                           |  375 ------------
 arch/arm/mach-msm/gpio_hw.h                        |  278 ---------
 arch/arm/mach-msm/gpiomux.h                        |   17 +-
 arch/arm/mach-msm/include/mach/msm_gpiomux.h       |   38 ++
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +
 arch/arm/mach-msm/io.c                             |   12 +-
 drivers/gpio/Kconfig                               |   16 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-msm-v1.c                         |  636 ++++++++++++++++++++
 .../gpio-v2.c => drivers/gpio/gpio-msm-v2.c        |    4 +-
 15 files changed, 719 insertions(+), 704 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio.c
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 create mode 100644 drivers/gpio/gpio-msm-v1.c
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/gpio-msm-v2.c (99%)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

