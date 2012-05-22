Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab2EVPPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:15:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56639 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab2EVPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:15:32 -0400
Date: Tue, 22 May 2012 08:15:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.5-rc1 - try 2
Message-ID: <20120522151527.GA21603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.5-rc1

for you to fetch changes up to 59bd234b72fc29887839d792b7d6c7e8d2a577a6:

  serial: bfin_uart: Make MMR access compatible with 32 bits bf609 style controller. (2012-05-17 13:25:56 -0700)

----------------------------------------------------------------
TTY pull request for 3.5-rc1

Here's the big TTY/serial driver pull request for the 3.5-rc1 merge window.

Nothing major in here, just lots of incremental changes from Alan and
Jiri reworking some tty core things to behave better and to get a more
solid grasp on some of the nasty tty locking issues.

There are a few tty and serial driver updates in here as well.

All of this has been in the linux-next releases for a while with no problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (7):
      vt: push the tty_lock down into the map handling
      tty_lock: undo the old tty_lock use on the ctty
      pty: Lock the devpts bits privately
      tty_lock: Localise the lock
      tty: drop the pty lock during hangup
      tty: Allow uart_register/unregister/register
      tty: Fix LED error return

Arnaud Patard (1):
      8250_pci: fix pch uart matching

Christian Melki (1):
      8250.c: less than 2400 baud fix.

Corbin Atkinson (1):
      serial_core: Update buffer overrun statistics.

Dan Carpenter (1):
      tty: hvc_xen: NULL dereference on allocation failure

Dan Williams (2):
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Geert Uytterhoeven (1):
      tty/amiserial: Add missing argument for tty_unlock()

Govindraj.R (1):
      OMAP2+: UART: Remove cpu checks for populating errata flags

Greg Kroah-Hartman (3):
      Merge 3.4-rc3 into tty-next
      Merge 3.4-rc4 into tty-next
      Revert "serial_core: Update buffer overrun statistics."

H Hartley Sweeten (1):
      tty: mxser: local variables should not be exposed globally

Heiko Carstens (1):
      tty: add missing tty_port_tty_get() call to raw3215_wakeup

Ivo Sieben (1):
      tty: move global ldisc idle waitqueue to the individual ldisc

Jiri Slaby (71):
      TTY: crisv10, remove unused tmp_buf
      TTY: crisv10, initialize tty_port
      TTY: deprecate linux/generic_serial.h
      ISDN: i4l, remove cvs crap
      TTY: isdn, remove callout
      TTY: isdn, remove ISDN_ASYNC_* flags
      TTY: isdn, do not play with module refcounts
      TTY: isdn, make some functions readable
      TTY: isdn, remove unused members from modem_info
      TTY: isdn, add tty_port
      TTY: isdn, use open/close_wait from tty_port
      TTY: isdn, use counts from tty_port
      TTY: isdn, use tty from tty_port
      TTY: isdn, use xmit_buf from tty_port
      TTY: isdn, define local tty_port
      TTY: isdn, use tty_port_close_end helper
      TTY: isdn, define tty_port_operations
      TTY: isdn, use tty_port_block_til_ready helper
      TTY: hso, do not set TTY MAGIC
      TTY: hso, free tty_driver
      TTY: hso, add tty_port
      TTY: hso, remove tty NULL checks fro tty->ops
      TTY: hso, use tty from tty_port
      TTY: con3215, centralize allocation
      TTY: sclp_tty, add tty_port
      TTY: sclp_vt220, add tty_port
      TTY: sclp_vt220, remove unused allocation
      TTY: tty3270, move initialization to allocation
      TTY: tty3270, get rid of ugly aliasing
      TTY: tty3270, push tty down to tty3270_do_write
      TTY: tty3270, add tty_port
      TTY: bfin_jtag_comm, add tty_port
      TTY: bfin_jtag_comm, use tty from tty_port
      TTY: HVC, add tty_port
      TTY: HVC, use tty from tty_port
      TTY: HVC, use count from tty_port
      TTY: hvcs, add tty_port
      TTY: hvcs, use kref from tty_port
      TTY: hvcs, use tty from tty_port
      TTY: hvsi, CLOCAL is not in tty->flags
      TTY: hvsi, add tty_port
      TTY: hvsi, sanitize uses of tty
      TTY: hvsi, use tty from tty_port
      TTY: ipwireless, use synchronous hangup
      TTY: ipwireless, move prints to appropriate places
      TTY: ipwireless, add tty_port
      TTY: ipwireless, use tty from tty_port
      TTY: 68328serial, remove serial_state and friends
      TTY: 68328serial, remove unused stuff from m68k_serial
      TTY: 68328serial, remove garbage
      TTY: 68328serial, use ulong flags for interrupts status
      TTY: 68328serial, remove 68328serial.h
      TTY: 68328serial, add tty_port
      TTY: 68328serial, use open/close_wait from tty_port
      TTY: 68328serial, use close_delay/closing_wait from tty_port
      TTY: 68328serial, use flags from tty_port
      TTY: 68328serial, propagate tty
      TTY: 68328serial, use tty from tty_port
      TTY: 68328serial, use tty_port_block_til_ready
      TTY: usb/u_serial, add tty_port
      TTY: usb/u_serial, use tty from tty_port
      TTY: usb/u_serial use close_wait from tty_port
      TTY: rfcomm/tty, add tty_port
      TTY: rfcomm/tty, use tty_port refcounting
      TTY: rfcomm/tty, remove work for tty_wakeup
      TTY: rfcomm/tty, use count from tty_port
      ISDN: remove uses of isdn_tty_revision
      TTY: hvc, fix TTY refcounting
      TTY: con3215, add tty_port
      TTY: con3215, use tty from tty_port
      TTY: n_tty, do not dereference user buffer

Lothar Waﬂmann (1):
      Add missing call to uart_update_timeout()

Magnus Damm (8):
      serial8250: Add dl_read()/dl_write() callbacks
      serial8250: Use dl_read()/dl_write() on Alchemy
      serial8250: Use dl_read()/dl_write() on RM9K
      serial8250: Clean up default map and dl code
      serial8250: Introduce serial8250_register_8250_port()
      serial8250-em: Emma Mobile UART driver V2
      serial8250-em: clk_get() IS_ERR() error handling fix
      serial8250-em: Add DT support

Michael Gehring (1):
      tty/vt: handle bad user buffer in {G,P}IO_CMAP ioctl

Paul Gortmaker (1):
      cris: fix missing tty arg in wait_event_interruptible_tty call

Rajanikanth H.V (1):
      serial: pl011: implement workaround for CTS clear event issue

Sonic Zhang (4):
      serial: bfin_uart: Adapt bf5xx serial driver to bf60x serial4 controller.
      serial: bfin_uart: narrow the reboot condition in DMA tx interrupt
      serial: bfin_uart: RTS and CTS MMRs can be either 16-bit width or 32-bit width.
      serial: bfin_uart: Make MMR access compatible with 32 bits bf609 style controller.

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI

Tomoya MORINAGA (7):
      pch_uart: Delete unused structure member
      pch_uart: change type to u8
      pch_uart: change type to %d to %02x
      pch_uart: Support modem status interrupt
      pch_uart: delete unused data structure
      pch_uart: Fix return value issue
      pch_uart: Fix duplicate memory release issue

Xiaobing Tu (1):
      tty: hold lock across tty buffer finding and buffer filling

 arch/arm/mach-omap2/serial.c                  |    8 -
 arch/arm/mach-tegra/board-harmony.c           |    2 +
 arch/arm/mach-tegra/board-paz00.c             |    3 +
 arch/arm/mach-tegra/board-seaboard.c          |    2 +
 arch/arm/mach-tegra/board-trimslice.c         |    2 +
 arch/arm/plat-omap/include/plat/omap-serial.h |    1 -
 drivers/isdn/i4l/isdn_common.c                |    5 -
 drivers/isdn/i4l/isdn_tty.c                   |  466 ++++++++++---------------
 drivers/net/usb/hso.c                         |  105 +++---
 drivers/s390/char/con3215.c                   |  142 ++++----
 drivers/s390/char/keyboard.c                  |   30 +-
 drivers/s390/char/keyboard.h                  |   14 +-
 drivers/s390/char/sclp_tty.c                  |   33 +-
 drivers/s390/char/sclp_vt220.c                |   33 +-
 drivers/s390/char/tty3270.c                   |  121 +++----
 drivers/staging/serial/68360serial.c          |    4 +-
 drivers/tty/amiserial.c                       |   14 +-
 drivers/tty/bfin_jtag_comm.c                  |   44 +--
 drivers/tty/cyclades.c                        |    2 +-
 drivers/tty/hvc/hvc_console.c                 |   96 +++--
 drivers/tty/hvc/hvc_console.h                 |    4 +-
 drivers/tty/hvc/hvc_xen.c                     |    4 +-
 drivers/tty/hvc/hvcs.c                        |   74 ++--
 drivers/tty/hvc/hvsi.c                        |  128 +++----
 drivers/tty/hvc/hvsi_lib.c                    |    2 +-
 drivers/tty/ipwireless/tty.c                  |   81 ++---
 drivers/tty/mxser.c                           |    2 +-
 drivers/tty/n_r3964.c                         |   11 +-
 drivers/tty/n_tty.c                           |    9 +-
 drivers/tty/pty.c                             |   40 ++-
 drivers/tty/serial/68328serial.c              |  383 ++++++++------------
 drivers/tty/serial/68328serial.h              |  186 ----------
 drivers/tty/serial/8250/8250.c                |  312 ++++++++---------
 drivers/tty/serial/8250/8250.h                |   16 +
 drivers/tty/serial/8250/8250_em.c             |  186 ++++++++++
 drivers/tty/serial/8250/8250_pci.c            |   63 ++++
 drivers/tty/serial/8250/Kconfig               |    8 +
 drivers/tty/serial/8250/Makefile              |    1 +
 drivers/tty/serial/amba-pl011.c               |  109 +-----
 drivers/tty/serial/bfin_uart.c                |   74 ++--
 drivers/tty/serial/crisv10.c                  |   36 +-
 drivers/tty/serial/mxs-auart.c                |    2 +
 drivers/tty/serial/of_serial.c                |   26 ++
 drivers/tty/serial/omap-serial.c              |   74 +++-
 drivers/tty/serial/pch_uart.c                 |   53 +--
 drivers/tty/serial/serial_core.c              |    1 +
 drivers/tty/synclink.c                        |    4 +-
 drivers/tty/synclink_gt.c                     |    4 +-
 drivers/tty/synclinkmp.c                      |    4 +-
 drivers/tty/tty_buffer.c                      |   85 +++--
 drivers/tty/tty_io.c                          |   76 ++--
 drivers/tty/tty_ldisc.c                       |   37 +-
 drivers/tty/tty_mutex.c                       |   60 +++-
 drivers/tty/tty_port.c                        |    6 +-
 drivers/tty/vt/consolemap.c                   |  123 +++++--
 drivers/tty/vt/keyboard.c                     |    2 +-
 drivers/tty/vt/vt.c                           |   68 ++--
 drivers/tty/vt/vt_ioctl.c                     |   25 +-
 drivers/usb/gadget/u_serial.c                 |   51 ++-
 include/linux/generic_serial.h                |   64 +---
 include/linux/isdn.h                          |   26 +-
 include/linux/of_serial.h                     |   17 +
 include/linux/serial_8250.h                   |    2 +
 include/linux/serial_core.h                   |    5 +
 include/linux/tty.h                           |   23 +-
 include/linux/tty_ldisc.h                     |    2 +
 include/linux/vt_kern.h                       |    1 -
 net/bluetooth/rfcomm/tty.c                    |  137 ++++----
 68 files changed, 1877 insertions(+), 1957 deletions(-)
 delete mode 100644 drivers/tty/serial/68328serial.h
 create mode 100644 drivers/tty/serial/8250/8250_em.c
 create mode 100644 include/linux/of_serial.h
