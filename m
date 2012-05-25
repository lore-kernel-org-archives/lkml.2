Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2EYPsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:48:32 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:51472 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab2EYPs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:48:28 -0400
Date: Fri, 25 May 2012 17:47:48 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 0/6] Bridging PCI to amba
Message-ID: <cover.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces use of the pl011 AMBA serial port under a
PCI bridge.  To compile AMBA under x86, though I need <asm/sizes.h>,
which is moved to <linux/sizes.h> as suggested earlier.

I'm hereby volunteering to handle the moving of the various users
of <asm/sizes.h> to <linux/sizes.h>; this set only moves the ARM core
files and the ones that I need under x86.

The whole patch set is sent to the same set of recipients:
all relevant lists, Russell King (for arm), Greg-KH (for uart) and
Arnd Bergmann (for generic include).

With this set in place (plus a clok API not included here) I have
4 serial ports working. We have a number of other devices that can
use existing drivers, but we definitely need <linux/sizes.h> first.

  spusa.root# uname -r
  3.4.0-next-20120524-00014-gae0c129

  spusa.root# dmesg | grep ttyA
  pl011-pci-03:0005: ttyAMA0 at MMIO 0xcf400000 (irq = 46) is a PL011 rev3
  pl011-pci-03:0006: ttyAMA1 at MMIO 0xcec00000 (irq = 47) is a PL011 rev3
  pl011-pci-03:0007: ttyAMA2 at MMIO 0xce400000 (irq = 48) is a PL011 rev3
  pl011-pci-04:0005: ttyAMA3 at MMIO 0xd3400000 (irq = 49) is a PL011 rev3

  spusa.root# grep -C1 pl011 /proc/iomem
          ce400000-ce7fffff : 0000:03:00.7
            ce400000-ce400fff : pl011-pci-03:0007
            ce400000-ce400fff : uart-pl011
          ce800000-cebfffff : 0000:03:00.6
          cec00000-ceffffff : 0000:03:00.6
            cec00000-cec00fff : pl011-pci-03:0006
            cec00000-cec00fff : uart-pl011
          cf000000-cf3fffff : 0000:03:00.5
          cf400000-cf7fffff : 0000:03:00.5
            cf400000-cf400fff : pl011-pci-03:0005
            cf400000-cf400fff : uart-pl011
          cf800000-cfbfffff : 0000:03:00.4
  --
          d3400000-d37fffff : 0000:04:00.5
            d3400000-d3400fff : pl011-pci-04:0005
            d3400000-d3400fff : uart-pl011
          d3800000-d3bfffff : 0000:04:00.4


Alessandro Rubini (6):
  sizes.h: move from asm-generic to <linux/sizes.h>
  amba: use the new linux/sizes.h
  ARM: use the new linux/sizes.h
  serial: use the new linux/sizes.h
  x86: add CONFIG_ARM_AMBA, selected by STA2X11
  serial: add amba-pl011-pci

 arch/arm/include/asm/memory.h       |    2 +-
 arch/arm/mm/dma-mapping.c           |    2 +-
 arch/arm/mm/init.c                  |    2 +-
 arch/arm/mm/ioremap.c               |    2 +-
 arch/arm/mm/mmu.c                   |    2 +-
 arch/x86/Kconfig                    |    4 ++
 drivers/amba/bus.c                  |    2 +-
 drivers/tty/serial/Kconfig          |   10 +++-
 drivers/tty/serial/Makefile         |    1 +
 drivers/tty/serial/amba-pl011-pci.c |  101 +++++++++++++++++++++++++++++++++++
 drivers/tty/serial/amba-pl011.c     |    2 +-
 include/asm-generic/sizes.h         |   49 +----------------
 include/linux/sizes.h               |   47 ++++++++++++++++
 13 files changed, 171 insertions(+), 55 deletions(-)
 create mode 100644 drivers/tty/serial/amba-pl011-pci.c
 create mode 100644 include/linux/sizes.h

-- 
1.7.7.2
