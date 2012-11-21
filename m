Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2KUPvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:51:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57809 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2KUPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:51:10 -0500
MIME-Version: 1.0
Date: Wed, 21 Nov 2012 16:51:07 +0100
X-Google-Sender-Auth: BtnFzB3ZoHjsUne63m6RIH6S21w
Message-ID: <CAHTX3d+bqMnsWxQp3GAmprSDzNB18otT3SrPi5MkA+d8006Aww@mail.gmail.com>
Subject: [GIT PULL] arm-soc: Xilinx zynq multiplatform changes for v3.8
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Josh Cartwright <josh.cartwright@ni.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof and Arnd,

based on my chat with Olof today I have created new branch
with 4 patches which move zynq to multiplatform.

This branch depends on arm-soc devel/debug_ll_init branch because
we needed Rob's "ARM: implement debug_ll_io_init()"
(sha1: afaee03511ba8002b26a9c6b1fe7d6baf33eac86)
patch.

This branch also depends on zynq/dt branch because of previous major
zynq changes.
zynq/cleanup branch is subset of zynq/dt.

That's why I have merged devel/debug_ll_init branch with zynq/dt and
add 4 patches
on the top of it.

Please let me know if there is necessary to clean something.

Thanks,
Michal

P.S.: I had to use different server because git.xilinx.com is down right now.


The following changes since commit 84d2e38e935620004245f0e22113cf8389834635:
  Michal Simek (1):
        Merge branch 'devel/debug_ll_init' into zynq/multiplatform

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git zynq/multiplatform

Josh Cartwright (3):
      ARM: zynq: remove TTC early mapping
      ARM: zynq: make use of debug_ll_io_init()
      ARM: zynq: add support for ARCH_MULTIPLATFORM

Michal Simek (1):
      ARM: zynq: Remove all unused mach headers

 arch/arm/Kconfig                                   |   14 +-----
 arch/arm/Kconfig.debug                             |    1 +
 .../mach/debug-macro.S => include/debug/zynq.S}    |   23 +++++++--
 arch/arm/mach-zynq/Kconfig                         |   13 +++++
 arch/arm/mach-zynq/common.c                        |   38 ++++----------
 arch/arm/mach-zynq/include/mach/hardware.h         |   18 -------
 arch/arm/mach-zynq/include/mach/irqs.h             |   21 --------
 arch/arm/mach-zynq/include/mach/timex.h            |   23 ---------
 arch/arm/mach-zynq/include/mach/uart.h             |   25 ---------
 arch/arm/mach-zynq/include/mach/uncompress.h       |   51 -------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h         |   53 --------------------
 arch/arm/mach-zynq/timer.c                         |    1 -
 12 files changed, 46 insertions(+), 235 deletions(-)
 rename arch/arm/{mach-zynq/include/mach/debug-macro.S =>
include/debug/zynq.S} (61%)
 create mode 100644 arch/arm/mach-zynq/Kconfig
 delete mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/timex.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
