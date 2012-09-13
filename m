Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2IMS5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:57:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31096 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2IMS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:56:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="234069028"
Date: Thu, 13 Sep 2012 11:56:55 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/5] msm devicetree changes
Message-ID: <20120913185655.GC30032@codeaurora.org>
References: <20120913185342.GA29823@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913185342.GA29823@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-dt-for-3.7

for you to fetch changes up to 0607fa5884f1759b396a0e1c07be561515daddc8:

  ARM: msm: Remove non-DT targets from 8960 (2012-09-13 11:17:01 -0700)

----------------------------------------------------------------
These patches migrate both the 8660 and 8960 targets on msm to be
devicetree only.  This also sets most of the frame in place necessary
to build both targets into the same image.

There's a couple of cleanups in here that are kept in this series
because they are intimately tied to the changes necessary to support
the devicetree conversions.

----------------------------------------------------------------
Stephen Boyd (11):
      ARM: msm: Add handle_irq handler for 8660 DT machine
      ARM: msm: Add msm8660-surf.dts to Makefile.boot
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
 arch/arm/boot/dts/msm8660-surf.dts                 |  19 ++-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  41 +++++
 arch/arm/mach-msm/Kconfig                          |  41 +----
 arch/arm/mach-msm/Makefile                         |   4 +-
 arch/arm/mach-msm/Makefile.boot                    |   3 +
 arch/arm/mach-msm/board-dt-8660.c                  |  68 ++++++++
 arch/arm/mach-msm/board-dt-8960.c                  |  49 ++++++
 arch/arm/mach-msm/board-halibut.c                  |   5 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   9 +-
 arch/arm/mach-msm/board-msm8960.c                  | 122 --------------
 arch/arm/mach-msm/board-msm8x60.c                  | 166 ------------------
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
 25 files changed, 412 insertions(+), 502 deletions(-)
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
