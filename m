Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032843Ab2CST45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:56:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51581 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032756Ab2CST4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:56:52 -0400
Date: Mon, 19 Mar 2012 12:56:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.4-rc1
Message-ID: <20120319195649.GD9883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 19e00f2f1d5273dbc52eab0ebc315cae3aa44b2a:

  Merge tag 'tty-3.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty (2012-02-09 13:52:57 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.3

for you to fetch changes up to fb8ebec00b04f921ea1614a7303f1a8e5e9e47c5:

  serial: pxa: add clk_prepare/clk_unprepare calls (2012-03-15 13:46:04 -0700)

----------------------------------------------------------------
tty and serial merge for 3.4-rc1

Here's the big serial and tty merge for the 3.4-rc1 tree.

There's loads of fixes and reworks in here from Jiri for the tty layer,
and a number of patches from Alan to help try to wrestle the vt layer
into a sane model.

Other than that, lots of driver updates and fixes, and other minor
stuff, all detailed in the shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (9):
      serial: Kill off NO_IRQ
      vt: lock the accent table
      vt: tidy a few bits of checkpatch noise
      vt:tackle kbd_table
      vt: sort out locking for font handling
      vt: push down the tty lock so we can see what is left to tackle
      vt: push down tioclinux cases
      vt: waitevent is self locked so drop the tty_lock
      vt: tackle the main part of the selection logic

Anton Vorontsov (2):
      sysrq: Fix possible race with exiting task
      sysrq: Properly check for kernel threads

Chanho Min (1):
      amba-pl011​/dma: Add check for the residue in DMA callback

Cousson, Benoit (1):
      tty: serial: OMAP: Fix oops due to NULL pdata in DT boot

Dan Carpenter (3):
      tty: cyclades: TIOCSERGETLSR should should store to a uint
      tty: moxa: fix bit test in moxa_start()
      vt: NULL dereference in vt_do_kdsk_ioctl()

Danny Kukawka (1):
      tty/serial/mux.c: linux/tty.h included twice

Darren Hart (5):
      pch_uart: Use uartclk instead of base_baud
      pch_uart: Add Fish River Island II uart clock quirks
      pch_uart: Add user_uartclk parameter
      pch_uart: Use existing default_baud in setup_console
      pch_uart: Add module parameter descriptions

Denis 'GNUtoo' Carikli (1):
      serial: samsung: fix s3c2442 platform data

Feng Tang (3):
      serial: pch_uart: add debugfs hook for register dump
      serial: pch_uart: trivial cleanup by removing the get_msr()
      serial: pch_uart: trivail cleanup by removing the pch_uart_hal_request()

Frank Benkert (1):
      mpc5200b/uart: select more tolerant uart prescaler on low baudrates

Greg Kroah-Hartman (5):
      Merge tag 'tty-3.3-rc3' tty-next
      Revert "TTY: get rid of BTM around devpts_*"
      Revert "TTY: pty, remove superfluous ptm test"
      tty: keyboard.c: add uaccess.h to fix a build problem on sparc32
      tty: delete briq_panel.c driver

Jiri Slaby (77):
      TTY: provide tty_standard_install helper
      USB: serial, use tty_standard_install
      TTY: use tty_standard_install
      TTY: pty, remove superfluous ptm test
      TTY: get rid of BTM around devpts_*
      USB: cdc-acm, use tty_standard_install
      TTY: tty_io, remove buffer re-assignments
      TTY: let alloc_tty_driver deduce the owner automatically
      TTY: remove minor_num from tty_driver
      TTY: remove re-assignments to tty_driver members
      TTY: simplify tty_driver_lookup_tty a bit
      TTY: remove tty driver re-set from tty_reopen
      TTY: serial, simplify ASYNC_USR_MASK
      TTY: tty_driver, document tty->ops->shutdown limitation
      ALPHA: srmcons, use timer functions
      ALPHA: srmcons, fix racy singleton structure
      TTY: srmcons, convert to use tty_port
      TTY: serialP, remove DECLARE_WAITQUEUE check
      TTY: remove unneeded tty->index checks
      TTY: ipwireless, fix tty->index handling
      NET: pc300, do not zero global variables
      NET: pc300, show version info from module init
      XTENSA: iss/console, use setup_timer
      XTENSA: iss/console, fix potential deadlock
      TTY: iss/console, use tty_port
      TTY: serial, use atomic_inc_return in ioc4_serial
      TTY: serial, include pci.h in m32r_sio
      TTY: remove serialP.h inclusion from some files
      TTY: speakup, do not use serialP
      TTY: serialP, remove unused material
      TTY: amiserial, remove tasklet for tty_wakeup
      TTY: amiserial, use only one copy of async flags
      hpsim, fix SAL handling in fw-emu
      simserial, include some headers
      hpsim, initialize chip for assigned irqs
      simserial, bail out when request_irq fails
      TTY: simserial, use only one copy of async flags
      TTY: simserial/amiserial, use one instance of other members
      TTY: simserial, remove support of shared interrupts
      TTY: simserial, remove IRQ_T
      TTY: amiserial, remove IRQ_ports
      TTY: serialP, merge serial_state and async_struct
      TTY: amiserial, simplify set_serial_info
      TTY: amiserial, pass tty down to functions
      TTY: simserial, pass tty down to functions
      TTY: amiserial/simserial, use tty_port
      TTY: amiserial/simserial, use close delays from tty_port
      TTY: amiserial/simserial, use count from tty_port
      TTY: amiserial/simserial, use flags from tty_port
      TTY: simserial, remove static initialization
      TTY: simserial, remove tmp_buf
      TTY: simserial, stop using serial_state->{line,icount}
      TTY: simserial no longer needs serialP
      TTY: simserial, define local tty_port pointer
      TTY: simserial, remove some tty ops
      TTY: simserial, use tty_port_close_end
      TTY: simserial, use tty_port_close_start
      TTY: simserial, properly refcount tty_port->tty
      TTY: simserial, use tty_port_open
      TTY: simserial, use tty_port_hangup
      TTY: simserial, remove useless comments
      TTY: simserial, fix includes
      TTY: simserial, reindent some code
      TTY: simserial, final cleanup
      TTY: amiserial, define local tty_port pointer
      TTY: amiserial, stop using serial_state->{irq,type,line}
      TTY: amiserial no longer needs serialP
      TTY: amiserial, provide carrier helpers
      TTY: amiserial, use tty_port_block_til_ready
      TTY: amiserial, use tty_port_close_end
      TTY: amiserial, use tty_port_close_start
      TTY: pdc_cons, fix racy tty test
      TTY: pdc_cons, fix open vs timer race
      TTY: pdc_cons, fix open vs pdc_console_tty_driver race
      TTY: pdc_cons, use tty_port
      TTY: isdn/gigaset, do not set tty->driver_data to NULL
      TTY: isdn/gigaset, use tty_port

Konstantin Khlebnikov (3):
      tty: cleanup prohibition of direct opening for unix98 pty master
      tty: move pty count limiting into devpts
      tty: rework pty count limiting

Linus Walleij (1):
      serial: PL011: clear pending interrupts

Liz Clark (1):
      TTY: Wrong unicode value copied in con_set_unimap()

Masanari Iida (1):
      serial: Fix typo in sn_console.c

Paul Gortmaker (8):
      tty: sparc: rename drivers/tty/serial/suncore.h -> include/linux/sunserialcore.h
      serial: delete last unused traces of pausing I/O in 8250
      serial: make 8250's serial_in shareable to other drivers.
      serial: delete useless void casts in 8250.c
      serial: reduce number of indirections in 8250 code
      serial: introduce generic port in/out helpers
      serial: use serial_port_in/out vs serial_in/out in 8250
      serial: remove back and forth conversions in serial_out_sync

Paul Walmsley (3):
      tty: serial: OMAP: use a 1-byte RX FIFO threshold in PIO mode
      tty: serial: OMAP: block idle while the UART is transferring data in PIO mode
      tty: serial: omap-serial: wakeup latency constraint is in microseconds, not milliseconds

Philipp Zabel (1):
      serial: pxa: add clk_prepare/clk_unprepare calls

Sonic Zhang (1):
      serial: bfin-uart: Don't access tty circular buffer in TX DMA interrupt after it is reset.

Stephen Rothwell (1):
      tty/powerpc: early udbg consoles can't be modules

Tobias Klauser (2):
      tty: serial: altera_uart: remove early_altera_uart_setup
      tty: serial: altera_uart: Add CONSOLE_POLL support

Uwe Kleine-König (1):
      serial/efm32: add new driver

Wolfram Sang (1):
      tty: serial: vt8500: fix annotations for probe/remove

 .../devicetree/bindings/tty/serial/efm32-uart.txt  |   14 +
 MAINTAINERS                                        |    2 +-
 arch/alpha/kernel/srmcons.c                        |   78 +-
 arch/ia64/hp/sim/boot/fw-emu.c                     |   17 +-
 arch/ia64/hp/sim/hpsim_irq.c                       |   36 +-
 arch/ia64/hp/sim/hpsim_setup.c                     |    6 -
 arch/ia64/hp/sim/simeth.c                          |   19 +-
 arch/ia64/hp/sim/simserial.c                       |  705 ++++-------------
 arch/ia64/include/asm/hpsim.h                      |    2 +-
 arch/m68k/emu/nfcon.c                              |    1 -
 arch/parisc/kernel/pdc_cons.c                      |   59 +-
 arch/xtensa/platforms/iss/console.c                |   22 +-
 drivers/accessibility/braille/braille_console.c    |    9 +-
 drivers/char/Kconfig                               |   15 -
 drivers/char/Makefile                              |    1 -
 drivers/char/briq_panel.c                          |  266 -------
 drivers/char/pcmcia/synclink_cs.c                  |    3 +-
 drivers/char/ttyprintk.c                           |    2 -
 drivers/isdn/capi/capi.c                           |   13 +-
 drivers/isdn/gigaset/common.c                      |    5 +-
 drivers/isdn/gigaset/gigaset.h                     |    3 +-
 drivers/isdn/gigaset/interface.c                   |  158 +---
 drivers/isdn/i4l/isdn_tty.c                        |    7 +-
 drivers/misc/pti.c                                 |   12 +-
 drivers/mmc/card/sdio_uart.c                       |   10 +-
 drivers/net/usb/hso.c                              |    2 -
 drivers/net/wan/pc300_drv.c                        |   13 +-
 drivers/net/wan/pc300_tty.c                        |   18 -
 drivers/s390/char/con3215.c                        |    9 +-
 drivers/s390/char/sclp_tty.c                       |    1 -
 drivers/s390/char/sclp_vt220.c                     |    1 -
 drivers/s390/char/tty3270.c                        |    1 -
 drivers/staging/speakup/main.c                     |    8 +-
 drivers/staging/speakup/serialio.c                 |   11 +-
 drivers/staging/speakup/serialio.h                 |   13 +-
 drivers/staging/speakup/spk_priv.h                 |    2 +-
 drivers/staging/speakup/synth.c                    |    2 +-
 drivers/tty/Kconfig                                |    2 +-
 drivers/tty/amiserial.c                            |  730 ++++++-----------
 drivers/tty/bfin_jtag_comm.c                       |    1 -
 drivers/tty/cyclades.c                             |    9 +-
 drivers/tty/ehv_bytechan.c                         |    1 -
 drivers/tty/hvc/hvc_beat.c                         |    2 +-
 drivers/tty/hvc/hvc_console.c                      |    1 -
 drivers/tty/hvc/hvc_rtas.c                         |    2 +-
 drivers/tty/hvc/hvc_udbg.c                         |    2 +-
 drivers/tty/hvc/hvc_xen.c                          |    2 +-
 drivers/tty/hvc/hvcs.c                             |   30 +-
 drivers/tty/hvc/hvsi.c                             |    8 +-
 drivers/tty/ipwireless/tty.c                       |   37 +-
 drivers/tty/isicom.c                               |    3 -
 drivers/tty/moxa.c                                 |    3 +-
 drivers/tty/mxser.c                                |    5 -
 drivers/tty/n_gsm.c                                |    1 -
 drivers/tty/nozomi.c                               |    9 +-
 drivers/tty/pty.c                                  |   63 +-
 drivers/tty/rocket.c                               |    7 +-
 drivers/tty/serial/21285.c                         |    4 +-
 drivers/tty/serial/68328serial.c                   |    9 +-
 drivers/tty/serial/8250/8250.c                     |  744 +++++++++---------
 drivers/tty/serial/8250/8250.h                     |   10 +
 drivers/tty/serial/Kconfig                         |   13 +
 drivers/tty/serial/Makefile                        |    3 +-
 drivers/tty/serial/altera_uart.c                   |   47 +-
 drivers/tty/serial/amba-pl011.c                    |   32 +-
 drivers/tty/serial/bfin_uart.c                     |    8 +-
 drivers/tty/serial/crisv10.c                       |   15 +-
 drivers/tty/serial/efm32-uart.c                    |  830 ++++++++++++++++++++
 drivers/tty/serial/ifx6x60.c                       |    3 -
 drivers/tty/serial/ioc4_serial.c                   |    3 +-
 drivers/tty/serial/m32r_sio.c                      |   12 +-
 drivers/tty/serial/m32r_sio.h                      |    1 +
 drivers/tty/serial/mpc52xx_uart.c                  |    9 +-
 drivers/tty/serial/msm_smd_tty.c                   |    1 -
 drivers/tty/serial/mux.c                           |    3 +-
 drivers/tty/serial/omap-serial.c                   |    6 +-
 drivers/tty/serial/pch_uart.c                      |  172 ++--
 drivers/tty/serial/pmac_zilog.c                    |    2 +-
 drivers/tty/serial/pxa.c                           |    8 +-
 drivers/tty/serial/samsung.c                       |    2 +-
 drivers/tty/serial/serial_core.c                   |    1 -
 drivers/tty/serial/sn_console.c                    |    4 +-
 drivers/tty/serial/suncore.c                       |    2 +-
 drivers/tty/serial/sunhv.c                         |    3 +-
 drivers/tty/serial/sunsab.c                        |    2 +-
 drivers/tty/serial/sunsu.c                         |    3 +-
 drivers/tty/serial/sunzilog.c                      |   12 +-
 drivers/tty/serial/ucc_uart.c                      |    2 +-
 drivers/tty/serial/vr41xx_siu.c                    |    4 +-
 drivers/tty/serial/vt8500_serial.c                 |    4 +-
 drivers/tty/synclink.c                             |    3 +-
 drivers/tty/synclink_gt.c                          |    3 +-
 drivers/tty/synclinkmp.c                           |    3 +-
 drivers/tty/sysrq.c                                |   17 +-
 drivers/tty/tty_io.c                               |   54 +-
 drivers/tty/vt/consolemap.c                        |   51 +-
 drivers/tty/vt/keyboard.c                          |  803 ++++++++++++++++++-
 drivers/tty/vt/selection.c                         |   58 +-
 drivers/tty/vt/vc_screen.c                         |    4 +-
 drivers/tty/vt/vt.c                                |   66 +-
 drivers/tty/vt/vt_ioctl.c                          |  495 ++----------
 drivers/usb/class/cdc-acm.c                        |    8 +-
 drivers/usb/gadget/u_serial.c                      |    4 -
 drivers/usb/serial/usb-serial.c                    |   17 +-
 fs/devpts/inode.c                                  |   85 +-
 include/linux/altera_uart.h                        |    4 -
 include/linux/kbd_kern.h                           |    7 +-
 include/linux/keyboard.h                           |    2 -
 include/linux/platform_data/efm32-uart.h           |   18 +
 include/linux/serial.h                             |    4 +-
 include/linux/serialP.h                            |  142 ----
 include/linux/serial_core.h                        |   12 +
 .../suncore.h => include/linux/sunserialcore.h     |    2 +-
 include/linux/tty.h                                |    6 +-
 include/linux/tty_driver.h                         |    8 +-
 include/linux/vt_kern.h                            |   26 +
 net/bluetooth/rfcomm/tty.c                         |    1 -
 net/irda/ircomm/ircomm_tty.c                       |    7 +-
 118 files changed, 3208 insertions(+), 3140 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
 delete mode 100644 drivers/char/briq_panel.c
 create mode 100644 drivers/tty/serial/efm32-uart.c
 create mode 100644 include/linux/platform_data/efm32-uart.h
 delete mode 100644 include/linux/serialP.h
 rename drivers/tty/serial/suncore.h => include/linux/sunserialcore.h (98%)
