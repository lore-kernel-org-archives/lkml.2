Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab2IET3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:29:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48621 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2IET3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:29:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6826"; a="230947978"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/9] Move closer to single 8660/8960 zImage
Date: Wed,  5 Sep 2012 12:28:50 -0700
Message-Id: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first half of this series adds devicetree support to the msm timer.
The second half moves 8660 and 8960 to be devicetree only. After this 
patch series it should be possible to compile 8660 and 8960 together
in one zImage (although Kconfig doesn't allow it right now).

This relies on the previous 8660 dt fixlets patches I sent and it also
assumes that 'ARM: msm: Remove call to missing FPGA init on 8660' has been
applied.

Stephen Boyd (9):
  ARM: msm: Don't touch GIC registers outside of GIC code
  ARM: msm: Allow timer.c to compile on multiple targets
  ARM: msm: Add DT support to msm_timer
  ARM: msm: Move 8660 to DT timer
  ARM: msm: Make 8660 a DT only target
  ARM: msm: Rename board-msm8x60 to signify its DT only status
  ARM: msm: Move io mapping prototypes to common.h
  ARM: msm: Add DT support for 8960
  ARM: msm: Remove non-DT targets from 8960

 .../devicetree/bindings/arm/msm/timer.txt          |  38 +++++
 arch/arm/boot/dts/msm8660-surf.dts                 |  17 ++
 arch/arm/boot/dts/msm8960-cdp.dts                  |  41 +++++
 arch/arm/mach-msm/Kconfig                          |  41 +----
 arch/arm/mach-msm/Makefile                         |   4 +-
 arch/arm/mach-msm/Makefile.boot                    |   1 +
 arch/arm/mach-msm/board-dt-8660.c                  |  63 +++++++
 arch/arm/mach-msm/board-dt-8960.c                  |  49 ++++++
 arch/arm/mach-msm/board-halibut.c                  |   5 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   9 +-
 arch/arm/mach-msm/board-msm8960.c                  | 122 --------------
 arch/arm/mach-msm/board-msm8x60.c                  | 162 ------------------
 arch/arm/mach-msm/board-qsd8x50.c                  |   7 +-
 arch/arm/mach-msm/board-trout.c                    |   5 +-
 arch/arm/mach-msm/common.h                         |  30 ++++
 arch/arm/mach-msm/devices-msm8960.c                |  85 ----------
 arch/arm/mach-msm/include/mach/board.h             |   3 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   7 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |   4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |   4 -
 arch/arm/mach-msm/io.c                             |   2 +
 arch/arm/mach-msm/platsmp.c                        |   8 -
 arch/arm/mach-msm/timer.c                          | 186 ++++++++++++++++-----
 25 files changed, 404 insertions(+), 497 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/timer.txt
 create mode 100644 arch/arm/boot/dts/msm8960-cdp.dts
 create mode 100644 arch/arm/mach-msm/board-dt-8660.c
 create mode 100644 arch/arm/mach-msm/board-dt-8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm8x60.c
 create mode 100644 arch/arm/mach-msm/common.h
 delete mode 100644 arch/arm/mach-msm/devices-msm8960.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

