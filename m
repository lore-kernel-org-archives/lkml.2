Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0ERASL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:18:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:43085 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0ERASI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:18:08 -0400
Date: Mon, 17 May 2010 18:18:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org
Subject: [PULL] viafb
Message-ID: <20100517181804.7a4c1517@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Here's a big set of changes to the viafb framebuffer code.  The end
goal of this work - besides massively cleaning up the code - is to
support the video capture driver as used by the OLPC XO 1.5 machine.
The actual capture driver isn't here - the V4L2 folks haven't had a
chance to review it yet - but everything leading up to that point is.

These patches have been through a few rounds of review and have been in
linux-next for a couple weeks now.

It's all at:

  git://git.lwn.net/linux-2.6.git viafb-next

Thanks,

jon

Chris Ball (1):
      viafb: Add 1200x900 DCON/LCD panel modes for OLPC XO-1.5

Florian Tobias Schandinat (7):
      viafb: package often used basic io functions
      viafb: unify modesetting functions
      viafb: move some modesetting functions to a seperate file
      viafb: replace inb/outb
      viafb: improve misc register handling
      viafb: fix proc entry removal
      viafb: make procfs entries optional

Harald Welte (4):
      viafb: Fix various resource leaks during module_init()
      viafb: use proper pci config API
      viafb: Determine type of 2D engine and store it in chip_info
      viafb: rework the I2C support in the VIA framebuffer driver

Jonathan Corbet (22):
      viafb: Unmap the frame buffer on initialization error
      viafb: Retain GEMODE reserved bits
      viafb: Unify duplicated set_bpp() code
      viafb: complete support for VX800/VX855 accelerated framebuffer
      viafb: Only establish i2c busses on ports that always had them
      viafb: Move core stuff into via-core.c
      viafb: Separate global and fb-specific data
      viafb: add a driver for GPIO lines
      viafb: Convert GPIO and i2c to the new indexed port ops
      viafb: Turn GPIO and i2c into proper platform devices
      via: Do not attempt I/O on inactive I2C adapters
      viafb: Introduce viafb_find_i2c_adapter()
      via: Rationalize vt1636 detection
      viafb: Add a simple interrupt management infrastructure
      viafb: Add a simple VX855 DMA engine driver
      viafb: Reserve framebuffer memory for the upcoming camera driver
      viafb: Do not remove gpiochip under spinlock
      viafb: Fix initialization error paths
      viafb: fold via_io.h into via-core.h
      viafb: get rid of i2c debug cruft
      viafb: Eliminate some global.h references
      viafb: move some include files to include/linux

Paul Fox (1):
      suppress verbose debug messages: change printk() to DEBUG_MSG()

 drivers/video/Kconfig                              |   16 +
 drivers/video/via/Makefile                         |    4 +-
 drivers/video/via/accel.c                          |  137 +++--
 drivers/video/via/accel.h                          |   40 ++
 drivers/video/via/chip.h                           |    8 +
 drivers/video/via/dvi.c                            |   37 +-
 drivers/video/via/global.h                         |    1 -
 drivers/video/via/hw.c                             |  307 ++--------
 drivers/video/via/hw.h                             |   20 +-
 drivers/video/via/ioctl.h                          |    2 +-
 drivers/video/via/lcd.c                            |   31 +-
 drivers/video/via/lcd.h                            |    2 +
 drivers/video/via/share.h                          |   20 +-
 drivers/video/via/via-core.c                       |  668 ++++++++++++++++++++
 drivers/video/via/via-gpio.c                       |  285 +++++++++
 drivers/video/via/via_i2c.c                        |  232 +++++--
 drivers/video/via/via_modesetting.c                |  126 ++++
 drivers/video/via/{via_i2c.h => via_modesetting.h} |   42 +-
 drivers/video/via/via_utility.c                    |    1 +
 drivers/video/via/viafbdev.c                       |  181 +++---
 drivers/video/via/viafbdev.h                       |   14 +-
 drivers/video/via/viamode.c                        |   15 +
 drivers/video/via/vt1636.c                         |   34 +-
 drivers/video/via/vt1636.h                         |    2 +-
 include/linux/via-core.h                           |  219 +++++++
 include/linux/via-gpio.h                           |   14 +
 {drivers/video/via => include/linux}/via_i2c.h     |   24 +-
 27 files changed, 1884 insertions(+), 598 deletions(-)
 create mode 100644 drivers/video/via/via-core.c
 create mode 100644 drivers/video/via/via-gpio.c
 create mode 100644 drivers/video/via/via_modesetting.c
 copy drivers/video/via/{via_i2c.h => via_modesetting.h} (53%)
 create mode 100644 include/linux/via-core.h
 create mode 100644 include/linux/via-gpio.h
 rename {drivers/video/via => include/linux}/via_i2c.h (65%)
