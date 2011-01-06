Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1AFVyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:54:13 -0500
Received: from kroah.org ([198.145.64.141]:33529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1AFVyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:54:12 -0500
Date: Thu, 6 Jan 2011 13:54:04 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [GIT PATCH] TTY/serial merge for .38
Message-ID: <20110106215404.GA30624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big tty and serial merge for .38.  I'll be sending another
smaller one that just moves drivers around after .38-rc1 is out, as is
the norm for file moves to handle issues with other trees syncing up
properly.

There was some arguing about the tty console detection patches, but as
the existing ioctl does not work properly, Kay's patch was accepted to
resolve this issue and allow systemd to correctly detect consoles.  I
know Alan doesn't like this, but I feel it's the best way to solve the
issue (combined with the fact that there is no proposed other solution.)

This series also includes the long-out-of-tree ioctl that SUSE and
Debian have been dragging around in their kernels for the past 10+
years.  Thanks to Werner for finally submitting it in a mergable form.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-next

All of these have been in the linux-next and -mm releases for quite some time.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------


 Documentation/ABI/testing/sysfs-tty     |   19 +
 Documentation/filesystems/proc.txt      |   24 +
 Documentation/serial/00-INDEX           |    2 +
 Documentation/serial/serial-rs485.txt   |  120 +++
 arch/alpha/include/asm/ioctls.h         |    1 +
 arch/mips/include/asm/ioctls.h          |    1 +
 arch/parisc/include/asm/ioctls.h        |    1 +
 arch/parisc/kernel/pdc_cons.c           |    8 +-
 arch/powerpc/include/asm/ioctls.h       |    1 +
 arch/sh/include/asm/ioctls.h            |    1 +
 arch/sparc/include/asm/ioctls.h         |    1 +
 arch/xtensa/include/asm/ioctls.h        |    1 +
 drivers/char/Kconfig                    |    9 +
 drivers/char/Makefile                   |    1 +
 drivers/char/hvc_dcc.c                  |  133 +++
 drivers/char/ip2/ip2main.c              |    2 +-
 drivers/char/rocket.c                   |    2 +-
 drivers/char/specialix.c                |    2 +-
 drivers/serial/8250.c                   |  109 ++-
 drivers/serial/8250_pci.c               |   36 +
 drivers/serial/Kconfig                  |   25 +
 drivers/serial/Makefile                 |    5 +-
 drivers/serial/apbuart.c                |   53 +-
 drivers/serial/cpm_uart/cpm_uart.h      |    6 -
 drivers/serial/cpm_uart/cpm_uart_core.c |   19 +
 drivers/serial/ifx6x60.c                | 1406 ++++++++++++++++++++++++++++++
 drivers/serial/ifx6x60.h                |  129 +++
 drivers/serial/mpc52xx_uart.c           |    6 +-
 drivers/serial/omap-serial.c            |   38 +-
 drivers/serial/pch_uart.c               | 1451 +++++++++++++++++++++++++++++++
 drivers/serial/serial_core.c            |   10 +-
 drivers/serial/vt8500_serial.c          |  648 ++++++++++++++
 drivers/tty/n_gsm.c                     |  213 +++--
 drivers/tty/tty_io.c                    |   52 +-
 drivers/tty/vt/vt.c                     |   23 +-
 drivers/video/xen-fbfront.c             |    2 +-
 fs/compat_ioctl.c                       |    1 +
 fs/proc/Makefile                        |    1 +
 fs/proc/proc_console.c                  |  114 +++
 include/asm-generic/ioctls.h            |    1 +
 include/linux/console.h                 |    8 +-
 include/linux/serial_core.h             |    7 +-
 include/linux/spi/ifx_modem.h           |   14 +
 include/linux/tty_driver.h              |    9 +-
 kernel/printk.c                         |    8 +-
 45 files changed, 4535 insertions(+), 188 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-tty
 create mode 100644 Documentation/serial/serial-rs485.txt
 create mode 100644 drivers/char/hvc_dcc.c
 create mode 100644 drivers/serial/ifx6x60.c
 create mode 100644 drivers/serial/ifx6x60.h
 create mode 100644 drivers/serial/pch_uart.c
 create mode 100644 drivers/serial/vt8500_serial.c
 create mode 100644 fs/proc/proc_console.c
 create mode 100644 include/linux/spi/ifx_modem.h

---------------

Alan Cox (4):
      n_gsm: Fix support for legacy encoding
      n_gsm: clean up printks
      serial: ifx6x60: The IFX requires SPI
      serial: ifx6x60: Fix missing include for msleep

Alexey Charkov (1):
      serial: Add support for UART on VIA VT8500 and compatibles

Baurzhan Ismagulov (2):
      serial: cpm_uat: reducing CPM serial latency
      serial: cpu_uart: Remove unused uart_cpm_port fields

Claudio Scordino (1):
      serial: add Documentation about RS485 serial communications

Cosmin Cojocar (1):
      serial: omap-serial: Add support for kernel debugger

Daniel Walker (1):
      drivers: char: hvc: add arm JTAG DCC console support

Dirk Brandewie (1):
      Serial: ce4100: Add PCI UART support for the ce4100

Govindraj.R (1):
      Serial: Avoid unbalanced IRQ wake disable during resume

Jamie Iles (2):
      8250: use container_of() instead of casting
      8250: add a UPIO_DWAPB32 for 32 bit accesses

Jiri Slaby (5):
      console: move for_each_console to linux/console.h
      TTY: include termios.h in tty_driver.h
      VIDEO: xen-fb, switch to for_each_console
      console: add /proc/consoles
      parisc: cleanup console handling

Kay Sievers (1):
      tty: add 'active' sysfs attribute to tty0 and console device

Namhyung Kim (3):
      rocket: fix compiler warning on rocket_pci_ids
      specialix: fix compiler warning on specialix_pci_tbl
      ip2: fix compiler warning on ip2main_pci_tbl

Ondrej Puzman (1):
      8250: fix uninitialized FIFOs

Randy Dunlap (1):
      serial: fix pch_uart kconfig & build

Russ Gorby (1):
      ifx6x60: SPI protocol driver for Infineon 6x60 modem

Thomas Gleixner (2):
      drivers: serial: apbuart: Handle OF failures gracefully
      serial: apbuart: Fixup apbuart_console_init()

Timur Tabi (1):
      tty: fix typos/errors in tty_driver.h comments

Tomoya MORINAGA (2):
      Serial: EG20T: add PCH_UART driver
      pch_uart : fix warnings for 64bit compile

Vasiliy Kulikov (2):
      serial: ifx6x60: free IRQ on error
      serial: ifx6x60: fix memory leak

Werner Fink (1):
      TTY: Add tty ioctl to figure device node of the system console.

Wolfram Sang (1):
      serial: mpc52xx: make printout for type more generic

Yegor Yefremov (1):
      RS485 documentation: add 16C950 UART description

