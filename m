Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2LCPBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:01:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50494 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LCPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:01:53 -0500
Subject: [RFC PATCH 0/9] Upstream merge of core of Goldfish AVD support
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 03 Dec 2012 15:04:04 +0000
Message-ID: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a port and clean up of the core platform and driver code for
the Goldfish AVD (Android Virtual Device).

With these patches applied you can boot Debian on Goldfish for minimal testing
purposes. It won't boot Android as there are other drivers needed, some of
which still need out of tree Android code.

Goldfish is both an ARM and an x86 platform. These patches add the x86 code
but they also add all the cleanups done to make most of the code portable. All
the drivers therefore are put into drivers/platform/goldfish or into the 
relevant driver directories  so they can be shared by other processors as
needed in future.

Once these drivers are in an upstream acceptable shape I'll look at feeding
the other bits in.

Alan
---

Arve Hjønnevåg (4):
      goldfish: tty driver
      goldfish: framebuffer
      goldfish: real time clock
      goldfish: NAND flash driver

Brian Swetland (1):
      goldfish: virtual input event driver

Jun Nakajima (2):
      goldfish: definitions for Goldfish on x86 platforms
      goldfish: add the goldfish virtual bus

Mike Lockwood (2):
      goldfish: emulated MMC device
      goldfish: power device


 arch/x86/Kconfig                         |   12 +
 arch/x86/include/asm/goldfish.h          |   43 ++
 drivers/input/keyboard/Kconfig           |   11 +
 drivers/input/keyboard/Makefile          |    1 
 drivers/input/keyboard/goldfish_events.c |  201 ++++++++++
 drivers/mmc/host/Kconfig                 |    7 
 drivers/mmc/host/Makefile                |    1 
 drivers/mmc/host/goldfish.c              |  579 ++++++++++++++++++++++++++++++
 drivers/mtd/devices/Kconfig              |    7 
 drivers/mtd/devices/Makefile             |    3 
 drivers/mtd/devices/goldfish_nand.c      |  475 +++++++++++++++++++++++++
 drivers/mtd/devices/goldfish_nand_reg.h  |   72 ++++
 drivers/platform/Makefile                |    1 
 drivers/platform/goldfish/Makefile       |    4 
 drivers/platform/goldfish/pdev_bus.c     |  267 ++++++++++++++
 drivers/power/Kconfig                    |    8 
 drivers/power/Makefile                   |    1 
 drivers/power/goldfish_battery.c         |  263 ++++++++++++++
 drivers/rtc/Kconfig                      |    9 
 drivers/rtc/Makefile                     |    1 
 drivers/rtc/rtc-goldfish.c               |  146 ++++++++
 drivers/tty/Kconfig                      |    6 
 drivers/tty/Makefile                     |    1 
 drivers/tty/goldfish.c                   |  342 ++++++++++++++++++
 drivers/video/Kconfig                    |    9 
 drivers/video/Makefile                   |    1 
 drivers/video/goldfishfb.c               |  327 +++++++++++++++++
 27 files changed, 2796 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/goldfish.h
 create mode 100644 drivers/input/keyboard/goldfish_events.c
 create mode 100644 drivers/mmc/host/goldfish.c
 create mode 100644 drivers/mtd/devices/goldfish_nand.c
 create mode 100644 drivers/mtd/devices/goldfish_nand_reg.h
 create mode 100644 drivers/platform/goldfish/Makefile
 create mode 100644 drivers/platform/goldfish/pdev_bus.c
 create mode 100644 drivers/power/goldfish_battery.c
 create mode 100644 drivers/rtc/rtc-goldfish.c
 create mode 100644 drivers/tty/goldfish.c
 create mode 100644 drivers/video/goldfishfb.c

-- 
Moo!

