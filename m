Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0JVRvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:51:37 -0400
Received: from kroah.org ([198.145.64.141]:36262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0JVRvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:51:36 -0400
Date: Fri, 22 Oct 2010 10:51:12 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial merge for .37-rc1
Message-ID: <20101022175112.GC13489@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big tty and serial merge for .37-rc1

There's a nice ioctls.h cleanup and a number of serial driver updates, and some
core tty fixes and reworks from Alan.  Nothing major, just incremental stuff.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 Documentation/devices.txt             |    1 +
 Documentation/filesystems/proc.txt    |   32 +++
 MAINTAINERS                           |   10 +-
 arch/arm/include/asm/ioctls.h         |   83 +--------
 arch/avr32/include/asm/ioctls.h       |   86 +--------
 arch/cris/include/asm/ioctls.h        |   84 +--------
 arch/frv/include/asm/ioctls.h         |   80 +-------
 arch/h8300/include/asm/ioctls.h       |   81 +--------
 arch/ia64/hp/sim/simserial.c          |   12 +-
 arch/ia64/include/asm/ioctls.h        |   89 +--------
 arch/m32r/include/asm/ioctls.h        |   83 +--------
 arch/m68k/include/asm/ioctls.h        |   80 +-------
 arch/mips/alchemy/common/platform.c   |   28 +++
 arch/mips/alchemy/common/power.c      |   35 ----
 arch/mn10300/include/asm/ioctls.h     |   84 +--------
 arch/s390/include/asm/ioctls.h        |   88 +--------
 drivers/char/Kconfig                  |   15 ++
 drivers/char/Makefile                 |    1 +
 drivers/char/amiserial.c              |   56 +++---
 drivers/char/cyclades.c               |   49 +++--
 drivers/char/ip2/ip2main.c            |   72 ++++---
 drivers/char/mxser.c                  |  109 ++++++-----
 drivers/char/nozomi.c                 |   37 ++--
 drivers/char/pcmcia/synclink_cs.c     |   60 +++---
 drivers/char/pty.c                    |    4 +-
 drivers/char/synclink.c               |   73 +++----
 drivers/char/synclink_gt.c            |   55 +++---
 drivers/char/synclinkmp.c             |   61 +++---
 drivers/char/tty_io.c                 |   77 +++++++-
 drivers/char/ttyprintk.c              |  225 +++++++++++++++++++++
 drivers/char/vc_screen.c              |  135 +++++++++++++
 drivers/char/vt.c                     |    5 +
 drivers/input/serio/serport.c         |    1 +
 drivers/net/usb/hso.c                 |   35 ++--
 drivers/serial/68360serial.c          |   51 +++---
 drivers/serial/8250.c                 |   69 ++++---
 drivers/serial/Kconfig                |    7 -
 drivers/serial/altera_uart.c          |  156 ++++++++++-----
 drivers/serial/bfin_sport_uart.c      |    7 +-
 drivers/serial/imx.c                  |    5 +-
 drivers/serial/jsm/jsm_driver.c       |    4 +-
 drivers/serial/max3107.c              |   34 +++-
 drivers/serial/mfd.c                  |   47 +++--
 drivers/serial/mrst_max3110.c         |  358 ++++++++++++++++++++-------------
 drivers/serial/mrst_max3110.h         |    1 +
 drivers/serial/serial_core.c          |   51 +++--
 drivers/serial/uartlite.c             |   26 +++-
 drivers/usb/serial/ark3116.c          |   40 ++--
 drivers/usb/serial/ftdi_sio.c         |    1 +
 drivers/usb/serial/io_edgeport.c      |   49 +++--
 drivers/usb/serial/io_tables.h        |    4 +
 drivers/usb/serial/io_ti.c            |   29 ++-
 drivers/usb/serial/mos7720.c          |   54 +++---
 drivers/usb/serial/mos7840.c          |   53 +++---
 drivers/usb/serial/ssu100.c           |   48 +++--
 drivers/usb/serial/ti_usb_3410_5052.c |   37 +++-
 drivers/usb/serial/usb-serial.c       |   13 ++
 fs/proc/proc_tty.c                    |  158 +++++++++++++++
 include/asm-generic/ioctls.h          |    2 +
 include/linux/altera_uart.h           |    5 +
 include/linux/selection.h             |    1 +
 include/linux/serial_8250.h           |    8 +
 include/linux/serial_core.h           |   10 +
 include/linux/tty.h                   |    3 +-
 include/linux/tty_driver.h            |    9 +
 include/linux/usb/serial.h            |    2 +
 net/bluetooth/rfcomm/tty.c            |    4 -
 67 files changed, 1759 insertions(+), 1613 deletions(-)
 create mode 100644 drivers/char/ttyprintk.c

---------------

Alan Cox (6):
      serial: mrst_max3110: Make the IRQ option runtime
      tty: Make tiocgicount a handler
      tty: Convert the USB drivers to the new icount interface
      tty: icount changeover for other main devices
      tty: Fix warning left over from TIOCGICOUNT changes
      serial: abstraction for 8250 legacy ports

Anton Vorontsov (8):
      serial: Factor out uart_poll_timeout() from 8250 driver
      altera_uart: Add support for polling mode (IRQ-less)
      altera_uart: Add support for getting mapbase and IRQ from resources
      altera_uart: Add support for different address strides
      altera_uart: Make it possible to use Altera UART and 8250 ports together
      altera_uart: Fixup type usage of port flags
      altera_uart: Fix missing prototype for registering an early console
      altera_uart: Don't use plain integer as NULL pointer

Breno Leitao (2):
      tty: MAINTAINERS: add drivers/serial/jsm/ as maintained driver
      jsm: Remove the uart port on errors

Dan Carpenter (1):
      serial: mfd: snprintf() returns largish values

Daniel Drake (1):
      serial8250: ratelimit "too much work" error

David Daney (1):
      serial: 8250: Don't delay after transmitter is ready.

Davidlohr Bueso (1):
      serial: max3107: Fix memory leaks when returning on error

Dmitry Eremin-Solenikov (2):
      tty: add tty_struct->dev pointer to corresponding device instance
      serport: place serport serio device correctly in the device tree

Dr. Werner Fink (1):
      tty: Add a new file /proc/tty/consoles

Feng Tang (2):
      serial: mrst_max3110: some code cleanup
      serial: mfd: add more baud rates support

Greg Kroah-Hartman (1):
      serial: mark the 8250 driver as maintained

Jason Wang (2):
      serial-core: skip call set_termios/console_start when no_console_suspend
      serial-core: restore termios settings when resume console ports

Jeff Mahoney (10):
      ioctl: Use asm-generic/ioctls.h on arm (enables termiox)
      ioctl: Use asm-generic/ioctls.h on avr32 (enables termiox)
      ioctl: Use asm-generic/ioctls.h on cris (enables termiox)
      ioctl: Use asm-generic/ioctls.h on frv (enables termiox)
      ioctl: Use asm-generic/ioctls.h on h8300 (enables termiox)
      ioctl: Use asm-generic/ioctls.h on ia64 (enables termiox)
      ioctl: Use asm-generic/ioctls.h on m32r (enables termiox)
      ioctl: Use asm-generic/ioctls.h on m68k (enables termiox)
      ioctl: Use asm-generic/ioctls.h on mn10300 (enables termiox)
      ioctl: Use asm-generic/ioctls.h on s390 (enables termiox)

Jiri Slaby (1):
      Char: mxser, call pci_disable_device from probe/remove

Manuel Lauss (2):
      8250: allow platforms to override PM hook.
      Alchemy: Add UART PM methods.

Michal Simek (1):
      serial: Add CONSOLE_POLL support for uartlite

Nicolas Pitre (2):
      vcs: add poll/fasync support
      vcs: invoke the vt update callback when /dev/vcs* is written to

Pekka Enberg (1):
      tty: Remove __GFP_NOFAIL from tty_add_file()

Samo Pogacnik (1):
      add ttyprintk driver

Sonic Zhang (1):
      serial: bfin_sport_uart: speed up sport RX sample rate to be 3% faster

Vasiliy Kulikov (1):
      tty_io: check return code of tty_register_device

Volker Ernst (1):
      serial/imx: check that the buffer is non-empty before sending it out

