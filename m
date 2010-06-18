Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0FRTNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:13:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55857 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0FRTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:12:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6017"; a="44863404"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 0/3] msm: Add gpiolib devices to MSM7x30 and QSD8x50.
Date: Fri, 18 Jun 2010 12:12:52 -0700
Message-Id: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

Here is a proposed patch series which adds the configuration and devices
needed to enable gpiolib on the MSM7x30 and QSD8x50 chipsets.

Patch 1 adds the register mapping information for all supported
MSM/QSD targets.  I wasn't sure about adding register definitions for boards
which weren't yet using those definitions, but the alternative was to have
each following patch change gpio_hw.h over and over, so I put all the
definitions in at once.  Thoughts?

Patch 2 adds the first target, the 7x30, as well as some generic macros
to ease the definition of the gpio devices and their platform data,
as this is long-winded, but mindless and repetitive work.  I considered
putting the generic macro-definitions in their own patch, but without
any targets to use them it seemed a little silly to leave them on their
own and I ended up attaching them to the first patch to use them - 
what do y'all think?  Does it warrant being split up?

Patch 3 adds device configuration for the 8x50.

Thanks,

G

Gregory Bean (3):
  msm: Add gpio register address mapping information.
  msm: 7x30: Add gpio device configuration.
  msm: 8x50: add gpio device configuration.

 arch/arm/mach-msm/board-msm7x30.c     |   29 ++++++++-
 arch/arm/mach-msm/board-qsd8x50.c     |   29 ++++++++-
 arch/arm/mach-msm/devices-msm7x30.c   |   23 +++++++
 arch/arm/mach-msm/devices-qsd8x50.c   |   23 +++++++
 arch/arm/mach-msm/devices.h           |   35 ++++++++++
 arch/arm/mach-msm/gpio_hw-7x30.h      |  112 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw-7xxx.h      |   97 ++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw-8x50.h      |  112 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw.h           |   35 ++++++++++
 arch/arm/mach-msm/include/mach/gpio.h |    2 +
 10 files changed, 493 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-msm/gpio_hw-7x30.h
 create mode 100644 arch/arm/mach-msm/gpio_hw-7xxx.h
 create mode 100644 arch/arm/mach-msm/gpio_hw-8x50.h
 create mode 100644 arch/arm/mach-msm/gpio_hw.h

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
