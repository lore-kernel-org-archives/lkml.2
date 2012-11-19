Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2KSSk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:40:56 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:50205 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2KSSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:40:18 -0500
Message-Id: <cover.1353349191.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Mon, 19 Nov 2012 12:19:51 -0600
Subject: [PATCH 0/3] ARM: zynq: ARCH_MULTIPLATFORM support
To: Michal Simek <michal.simek@xilinx.com>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize complete at 11/19/2012 12:40:08 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_07:2012-11-19,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal-

Here's an attempt at supporting ARCH_MULTIPLATFORM on Zynq.  I've gotten
a multiplatform kernel building and booting on the zc702, although I
haven't tried to boot the same image on another non-Zynq board, due to
lack of available hardware.

It would be super awesome if this set could land in 3.8, but I know
we're running out of time there.  I wouldn't be too heartbroken if it
didn't make it.

This patchset is on top of your arm-next branch and with the
debug_ll_init support patch @ arm-soc/devel/debug_ll_init.

Patch 1 drops the early TTC mapping.  It is not necessary, since the TTC
driver now supports pulling mapping info from the device tree.

Patch 2 converts zynq to use the debug_ll_init() infrastructure slated
to go into 3.8.

Patch 3 is the bulk of the set, moving around logic around within
mach-zynq/include, and setting up the necessary build magic to get Zynq
building w/ CONFIG_ARCH_MULTIPLATFORM.

Thanks,
   Josh

---
Josh Cartwright (3):
  ARM: zynq: remove TTC early mapping
  ARM: zynq: make use of debug_ll_io_init()
  ARM: zynq: add support for ARCH_MULTIPLATFORM

 arch/arm/Kconfig                                   | 14 +-----
 arch/arm/Kconfig.debug                             |  1 +
 .../mach/debug-macro.S => include/debug/zynq.S}    | 23 ++++++++--
 arch/arm/mach-zynq/Kconfig                         | 13 ++++++
 arch/arm/mach-zynq/common.c                        | 38 +++++-----------
 arch/arm/mach-zynq/include/mach/uart.h             | 25 ----------
 arch/arm/mach-zynq/include/mach/uncompress.h       | 51 ---------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h         | 53 ----------------------
 arch/arm/mach-zynq/timer.c                         |  1 -
 9 files changed, 46 insertions(+), 173 deletions(-)
 rename arch/arm/{mach-zynq/include/mach/debug-macro.S => include/debug/zynq.S} (61%)
 create mode 100644 arch/arm/mach-zynq/Kconfig
 delete mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h

-- 
1.8.0

