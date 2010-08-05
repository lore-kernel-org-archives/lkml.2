Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab0HEVgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:36:00 -0400
Received: from kroah.org ([198.145.64.141]:40171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab0HEVfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:35:34 -0400
Date: Thu, 5 Aug 2010 14:35:28 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100805213528.GA13794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the tty patches for the .36 merge window.

This contains the big BKL removal of the tty layer, which has been
worked on now for a long time by Alan and Arnd.  Other than that,
there's a few new serial drivers, and minor changes around the tty area.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt     |    3 +
 arch/alpha/include/asm/ioctls.h         |    4 +-
 arch/alpha/include/asm/termbits.h       |    1 +
 arch/arm/include/asm/ioctls.h           |    2 +
 arch/arm/include/asm/termbits.h         |    1 +
 arch/avr32/include/asm/ioctls.h         |    4 +-
 arch/avr32/include/asm/termbits.h       |    1 +
 arch/cris/include/asm/ioctls.h          |    4 +-
 arch/cris/include/asm/termbits.h        |    1 +
 arch/frv/include/asm/ioctls.h           |    2 +
 arch/frv/include/asm/termbits.h         |    1 +
 arch/h8300/include/asm/ioctls.h         |    2 +
 arch/h8300/include/asm/termbits.h       |    1 +
 arch/ia64/include/asm/ioctls.h          |    4 +-
 arch/ia64/include/asm/termbits.h        |    1 +
 arch/m32r/include/asm/ioctls.h          |    4 +-
 arch/m32r/include/asm/termbits.h        |    1 +
 arch/m68k/include/asm/ioctls.h          |    2 +
 arch/m68k/include/asm/termbits.h        |    1 +
 arch/mips/include/asm/ioctls.h          |    5 +-
 arch/mips/include/asm/termbits.h        |    1 +
 arch/mn10300/include/asm/ioctls.h       |    4 +-
 arch/mn10300/include/asm/termbits.h     |    1 +
 arch/parisc/include/asm/ioctls.h        |    4 +-
 arch/parisc/include/asm/termbits.h      |    1 +
 arch/powerpc/include/asm/ioctls.h       |    2 +
 arch/powerpc/include/asm/termbits.h     |    1 +
 arch/s390/include/asm/ioctls.h          |    2 +
 arch/sh/include/asm/ioctls.h            |    2 +
 arch/sparc/include/asm/ioctls.h         |    2 +
 arch/sparc/include/asm/termbits.h       |    1 +
 arch/xtensa/include/asm/ioctls.h        |    2 +
 arch/xtensa/include/asm/termbits.h      |    1 +
 drivers/char/Makefile                   |    1 +
 drivers/char/amiserial.c                |   25 +-
 drivers/char/briq_panel.c               |    6 +-
 drivers/char/cyclades.c                 |   22 +-
 drivers/char/epca.c                     |    4 +-
 drivers/char/ip2/ip2main.c              |    4 +
 drivers/char/isicom.c                   |   13 +-
 drivers/char/istallion.c                |   68 +-
 drivers/char/keyboard.c                 |   10 +-
 drivers/char/mxser.c                    |    2 +-
 drivers/char/n_gsm.c                    |    1 -
 drivers/char/n_hdlc.c                   |   16 +-
 drivers/char/n_r3964.c                  |   10 +-
 drivers/char/n_tty.c                    |   17 +-
 drivers/char/nozomi.c                   |    4 +-
 drivers/char/pty.c                      |   47 +-
 drivers/char/riscom8.c                  |   14 +-
 drivers/char/rocket.c                   |   28 +-
 drivers/char/selection.c                |   13 +-
 drivers/char/serial167.c                |    8 +-
 drivers/char/specialix.c                |   13 +-
 drivers/char/stallion.c                 |   20 +-
 drivers/char/sx.c                       |   12 +-
 drivers/char/synclink.c                 |   21 +-
 drivers/char/synclink_gt.c              |   92 +-
 drivers/char/synclinkmp.c               |   43 +-
 drivers/char/tty_io.c                   |  150 ++--
 drivers/char/tty_ioctl.c                |   18 +-
 drivers/char/tty_ldisc.c                |   43 +-
 drivers/char/tty_mutex.c                |   47 +
 drivers/char/tty_port.c                 |    4 +-
 drivers/char/vc_screen.c                |    4 +-
 drivers/char/vt.c                       |   37 +-
 drivers/char/vt_ioctl.c                 |   17 +-
 drivers/gpu/drm/i915/intel_fb.c         |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c      |    2 +-
 drivers/serial/21285.c                  |   10 +-
 drivers/serial/68328serial.c            |   26 +-
 drivers/serial/68360serial.c            |    4 +-
 drivers/serial/8250.c                   |   11 +-
 drivers/serial/8250_early.c             |   57 +-
 drivers/serial/8250_pci.c               |   13 +
 drivers/serial/Kconfig                  |   44 +
 drivers/serial/Makefile                 |    4 +
 drivers/serial/altera_uart.c            |    2 +-
 drivers/serial/atmel_serial.c           |   11 +-
 drivers/serial/bfin_5xx.c               |    7 +-
 drivers/serial/crisv10.c                |   12 +-
 drivers/serial/imx.c                    |   10 +-
 drivers/serial/ioc3_serial.c            |    9 +-
 drivers/serial/ioc4_serial.c            |    9 +-
 drivers/serial/max3100.c                |    7 +-
 drivers/serial/max3107-aava.c           |  344 +++++++
 drivers/serial/max3107.c                | 1197 ++++++++++++++++++++++++
 drivers/serial/max3107.h                |  441 +++++++++
 drivers/serial/mcf.c                    |   31 +-
 drivers/serial/mfd.c                    | 1498 +++++++++++++++++++++++++++++++
 drivers/serial/mrst_max3110.c           |  844 +++++++++++++++++
 drivers/serial/mrst_max3110.h           |   59 ++
 drivers/serial/serial_core.c            |  288 +++----
 drivers/serial/timbuart.c               |    6 +-
 drivers/usb/class/cdc-acm.c             |   12 +-
 drivers/usb/serial/digi_acceleport.c    |   14 +-
 drivers/video/console/fbcon.c           |    4 +-
 drivers/video/console/vgacon.c          |    2 -
 fs/compat_ioctl.c                       |    1 +
 include/asm-generic/ioctls.h            |    8 +-
 include/asm-generic/termbits.h          |    1 +
 include/linux/console_struct.h          |    4 +-
 include/linux/fb.h                      |    4 +
 include/linux/istallion.h               |    2 +-
 include/linux/serial.h                  |    6 +-
 include/linux/serial_core.h             |    8 +-
 include/linux/serial_mfd.h              |   47 +
 include/linux/serial_reg.h              |   16 +
 include/linux/tty.h                     |   68 ++
 include/linux/vt_kern.h                 |   64 ++-
 lib/Kconfig.debug                       |   10 +
 112 files changed, 5481 insertions(+), 644 deletions(-)
 create mode 100644 drivers/char/tty_mutex.c
 create mode 100644 drivers/serial/max3107-aava.c
 create mode 100644 drivers/serial/max3107.c
 create mode 100644 drivers/serial/max3107.h
 create mode 100644 drivers/serial/mfd.c
 create mode 100644 drivers/serial/mrst_max3110.c
 create mode 100644 drivers/serial/mrst_max3110.h
 create mode 100644 include/linux/serial_mfd.h

---------------

Alan Cox (23):
      stallion: prune lock_kernel calls
      istallion: use bit ops for the board flags
      riscom8: kill use of lock_kernel
      isicom: kill off the BKL
      rocket: kill BKL
      synclink: kill the big kernel lock
      cyclades: Kill off BKL usage
      epca: Kill the big kernel lock
      specialix: Kill the BKL
      tty: Fix the digi acceleport driver NULL checks
      synclink: reworking locking a bit
      tty: serial - fix various misuses/mishandlings of port->tty
      tty: serial - fix tty back references in termios
      tty: serial - fix tty referencing in set_ldisc
      vc: Locking clean up
      tty: Make vt's have a tty_port
      tty: Move the vt_tty field from the vc_data into the standard tty_port
      serial: Change the wait for carrier locking
      serial: add port helpers
      serial: trim locking on the helpers
      serial: Use block_til_ready helper
      serial: max3107: Abstract out the platform specific bits
      serial: max3107: Fix gpiolib support

Andrea Gelmini (1):
      n_gsm.c: removed duplicated #includes

Andrew Morton (1):
      serial: "altera_uart: simplify altera_uart_console_putc()" checkpatch fixes

Andy Shevchenko (1):
      vt: clean up the code - use kernel library

Arjan van de Ven (2):
      serial: replace open coded mutex with a real mutex in mrst_max3110.c
      serial: fix wakup races in the mrst_max3110 driver

Arnd Bergmann (13):
      serial: fix termios settings in open
      tty: replace BKL with a new tty_lock
      tty: never hold BTM while getting tty_mutex
      tty: fix console_sem lock order
      cdc-acm: remove dead code
      tty: introduce wait_event_interruptible_tty
      tty: reorder ldisc locking
      tty: untangle locking of wait_until_sent
      tty: remove tty_lock_nested
      tty: implement BTM as mutex instead of BKL
      tty: release BTM while sleeping in block_til_ready
      8250: fix set_ldisc operation
      tty: avoid recursive BTM in pty_close

Christoph Egger (2):
      serial: There's no config CONSOLE
      serial: 68328serial.c: remove dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)

Claudio Scordino (1):
      serial: general fixes in the serial_rs485 structure

Feng Tang (5):
      mrst_max3110: add UART driver for Max3110 on Moorestown
      hsu: driver for Medfield High Speed UART device
      hsu: add a periodic timer to check dma rx channel
      hsu: some code cleanup
      hsu: call PCI pm hooks in suspend/resume function

Greg Kroah-Hartman (1):
      tty: remove remaining Hayes ESP ioctls

Jeff Dike (1):
      tty: Remove Hayes ESP ioctls

Jesse Barnes (1):
      vt/console: try harder to print output when panicing

Jiri Slaby (2):
      Char: nozomi, fix tty->count counting
      Char: nozomi, set tty->driver_data appropriately

John Villalovos (1):
      serial: fix missing bit coverage of ASYNC_FLAGS

Kevin Winchester (1):
      vt: Fix warning: statement with no effect due to vt_kern.h

Kulikov Vasiliy (3):
      tty_io: remove casts from void*
      serial: crisv10: formatting of pointers in printk()
      mxser: remove unnesesary NULL check

Lytochkin Boris (1):
      serial: add support for OX16PCI958 card

Richard Röjfors (1):
      timbuart: use __devinit and __devexit macros for probe and remove

Samium Gromoff (1):
      serial: MMIO32 support for 8250_early.c

Yegor Yefremov (1):
      serial: add UART_CAP_EFR and UART_CAP_SLEEP flags to 16C950 UARTs definition

Yury Georgievskiy (1):
      serial: mcf: don't take spinlocks in already protected functions

hyc@symas.com (1):
      tty: Add EXTPROC support for LINEMODE

jianwei.yang (2):
      max3110 sanity check a register
      serial: max3107: introduce a max3107 driver

