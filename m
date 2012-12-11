Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2LKULf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:11:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53723 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2LKULc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:11:32 -0500
Date: Tue, 11 Dec 2012 12:11:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial patches for 3.8-rc1
Message-ID: <20121211201128.GA19551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.8-rc1

for you to fetch changes up to b0ab02361167faa82198b783a8d555eb6f58901c:

  staging: sb105x: fix potential NULL pointer dereference in mp_chars_in_buffer() (2012-11-29 18:15:27 -0800)

----------------------------------------------------------------
TTY/Serial merge for 3.8-rc1

Here's the big tty/serial tree set of changes for 3.8-rc1.

Contained in here is a bunch more reworks of the tty port layer from Jiri and
bugfixes from Alan, along with a number of other tty and serial driver updates
by the various driver authors.

Also, Jiri has been coerced^Wconvinced to be the co-maintainer of the TTY
layer, which is much appreciated by me.

All of these have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (7):
      audit: remove bogus tty name check
      uart: update the sysfs handler to use uart_get_info
      uart: tidy the uart_get_info API
      uart: add other serial core layer get attributes
      moxa: dcd handling of CLOCAL is backwards
      ipwireless: don't oops if we run out of space
      serial: cast before shifting on port io

Alexander Shiyan (14):
      serial: clps711x: Add platform_driver interface to clps711x driver
      serial: clps711x: Convert all static variables to dynamic
      serial: clps711x: Do not use "uart_port->unused" field
      serial: clps711x: Using CPU clock subsystem for getting base UART speed
      serial: clps711x: Improved TX FIFO handling
      serial: clps711x: Return valid modem controls for port that not support it
      serial: clps711x: Fix break control handling
      serial: clps711x: Check for valid TTY in RX-interrupt
      serial: clps711x: Using resource-managed functions
      serial: clps711x: Disable "break"-state before port startup
      serial: clps711x: Fix TERMIOS-flags handling
      serial: clps711x: Cleanup driver
      serial: Unneeded ARCH dependencies are removed
      serial: max310x: Setup missing "can_sleep" field for GPIO

Alexey Brodkin (1):
      serial/8250/8250_early: Prevent rounding error in uartclk

Andrew Morton (1):
      drivers/tty/serial/serial_core.c: clean up HIGH_BITS_OFFSET usage

Bill Pemberton (9):
      staging: dgrp: remove use of real_raw and read_cnt in dgrp_input
      staging: dgrp: remove rawreadok module option
      tty: remove use of __devexit_p
      tty: serial: remove use of __devexit_p
      tty: remove use of __devinit
      tty: remove use of __devinitdata
      tty: remove use of __devinitdata
      tty: remove use of __devinitconst
      tty: remove use of __devexit

Cyrill Gorcunov (3):
      tty: pty - Move TIOCPKT handling into pty.c
      tty, ioctls -- Add new ioctl definitions for tty flags fetching
      tty: Add get- ioctls to fetch tty status v3

Daniel Vetter (2):
      console: implement lockdep support for console_lock
      console: use might_sleep in console_lock

David Rientjes (1):
      mm, oom: ensure sysrq+f always passes valid zonelist

Denis V. Lunev (1):
      tty: serial: KGDB support for PXA

Feng Tang (1):
      serial: mfd: Add nmi_touch_watchdog() into the console write function

Gabor Juhos (1):
      tty/serial/ar933x_uart: fix baud rate calculation

Greg Kroah-Hartman (3):
      Merge 3.7-rc3 into tty-next
      Merge v3.7-rc5 into tty-next
      Merge 3.7-rc6 into tty-next

Heiko Stübner (1):
      serial: samsung: add devicetree properties for non-Exynos SoCs

Huang Shijie (5):
      serial: mxs-auart: distinguish the different SOCs
      serial: mxs-auart: add the DMA support for mx28
      ARM: dts: enable dma support for auart0 in mx28
      serial: mxs-auart: disable the Receive Timeout Interrupt when DMA is enabled
      serial: mxs-auart: unmap the scatter list before we copy the data

Ivo Sieben (3):
      tty: prevent unnecessary work queue lock checking on flip buffer copy
      TTY: Report warning when low_latency flag is wrongly used
      tty: Use raw spin lock to protect TTY ldisc administration

James Hogan (1):
      tty: serial: 8250_dw: Implement suspend/resume

Jiri Slaby (33):
      TTY: devpts, don't care about TTY in devpts_get_tty
      TTY: devpts, return created inode from devpts_pty_new
      TTY: devpts, do not set driver_data
      TTY: devpts, document devpts inode operations
      TTY: move devpts kill to pty
      TTY: vt, fix paste_selection ldisc handling
      TTY: ldisc, wait for idle ldisc in release
      TTY: hci_ldisc, remove invalid check in open
      TTY: n_tty, simplify read_buf+echo_buf allocation
      TTY: n_tty, remove bogus checks
      TTY: audit, stop accessing tty->icount
      TTY: n_tty, add ldisc data to n_tty
      TTY: move ldisc data from tty_struct: simple members
      TTY: move ldisc data from tty_struct: bitmaps
      TTY: move ldisc data from tty_struct: read_* and echo_* and canon_* stuff
      TTY: move ldisc data from tty_struct: locks
      TTY: n_tty, propagate n_tty_data
      TTY: move TTY_FLUSH* flags to tty_port
      TTY: tty_buffer, cache pointer to tty->buf
      TTY: add port -> tty link
      TTY: move tty buffers to tty_port
      UM: TTY: fix build errors now that tty->raw is gone
      TTY: isicom, stop using port->tty
      TTY: pty, fix tty buffers leak
      ISDN: capi, use kref from tty_port
      MMC: sdio_uart, remove unused member from sdio_uart_port
      MMC: sdio, use kref from tty_port
      TTY: n_gsm, use kref from tty_port
      TTY: introduce tty_port_destroy
      TTY: isicom, fix tty buffers memory leak
      TTY: call tty_port_destroy in the rest of drivers
      TTY: isdn/gigaset destroy tty_port properly
      TTY: let me eat my own cooking

Joe Perches (1):
      serial: jsm: Convert jsm_printk to jsm_dbg

Josh Cartwright (1):
      serial: xilinx_uartps: kill CONFIG_OF conditional

Josh Triplett (3):
      drivers/tty/vt/vt_ioctl.c: Include <linux/suspend.h> for pm_set_vt_switch
      tty: Mark tty_del_file and __tty_hangup static
      pty: Mark pty_resize static

Jun Chen (4):
      serial: ifx6x60: add_timer is not safe in the mrdy_assert function
      serial: ifx6x60: del_timer_sync must not be called in interrupt context.
      serial: ifx6x60: ifx_spi_write don't need to do mrdy_assert when fifo is not empty
      serial: ifx6x60: Add modem power off function in the platform reboot process

Kumar Amit Mehta (2):
      staging: dgrp: dgrp_tty.c: Remove the TIOCSSOFTCAR ioctl handler from dgrp driver
      staging: dgrp: dgrp_tty.c: Audit the return values of get/put_user()

Linus Walleij (1):
      serial/amba-pl011: use devm_* managed resources

Masanari Iida (1):
      staging: dgrp: Fix typo in dgrp driver

Matt Schulte (8):
      Serial: Add support for new devices: Exar's XR17V35x family of multi-port PCIe UARTs
      Add register definitions used in several Exar PCI/PCIe UARTs
      serial: Optimization: check for presence of UPF_EXAR_EFR flag before serial_in
      serial: Add initialization of sampling mode and tx/rx triggers to pci_xr17v35x_setup
      tty/8250: Add sleep capability to XR17D15X ports
      tty/8250 Add XR17D15x devices to the exar_handle_irq override
      tty/8250 Add support for Commtech's Fastcom Async-335 and Fastcom Async-PCIe cards
      tty/8250 Add check for pci_ioremap_bar failure

Maxime Bizon (1):
      x86: ce4100: allow second UART usage

Murali Karicheri (2):
      of serial port driver - add clk_get_rate() support
      Documentation: of-serial.txt - update for clocks phandle for clk

Noam Camus (1):
      tty/8250_early: Turn serial_in/serial_out into weak symbols.

Peter Hurley (5):
      staging: fwserial: Add TTY-over-Firewire serial driver
      staging/fwserial: Fix build breakage when !CONFIG_BUG
      staging/fwserial: Destruct embedded tty_port on teardown
      staging/fwserial: Use WARN_ONCE when port table is corrupted
      staging/fwserial: Remove superfluous free

Randy Dunlap (1):
      tty/serial: fix ifx6x60.c declaration warning

Sachin Kamat (1):
      tty: vt: Remove redundant null check before kfree.

Sangho Yi (1):
      tty: tty_mutex.c: Fixed coding style warning (using printk)

Sasha Levin (1):
      tty: add missing newlines to WARN_RATELIMIT

Shinya Kuribayashi (5):
      Revert "sh-sci / PM: Avoid deadlocking runtime PM"
      Revert "sh-sci / PM: Use power.irq_safe"
      Partially revert "serial: sh-sci: console Runtime PM support"
      serial: sh-sci: add locking to console write function to avoid SMP lockup
      serial: sh-sci: fix possible race cases on SCSCR register accesses

Shubhrajyoti D (3):
      serial: omap: Make context_loss_cnt signed
      serial: omap: Remove the default setting of special character
      serial: omap: Remove the hardcode serial_omap_console_ports array.

Sonic Zhang (1):
      serial: bfin_uart: Don't switch baud rate untill the transfer buffer is empty.

Steven Miao (1):
      serial: bfin-uart: avoid dead lock in rx irq handler in smp kernel

Steven Rostedt (1):
      staging: Add SystemBase Multi-2/PCI driver

Takashi YOSHII (4):
      serial: sh-sci: fix condition test to set SCBRR
      serial: sh-sci: support lower baud rate
      serial: sh-sci: mask SCTFDR/RFDR according to fifosize
      serial: sh-sci: fix common SCIFB regmap definition

Teppei Kamijou (1):
      serial: sh-sci: console runtime PM support (revisit)

Thomas Abraham (2):
      serial: samsung: use clk_prepare_enable and clk_disable_unprepare
      serial: samsung: fix potential soft lockup during uart write

Tony Lindgren (1):
      tty/serial/8250: Make omap hardware workarounds local to 8250.h

Vineet Gupta (1):
      serial/arc-uart: Add new driver

Wei Yongjun (5):
      serial: vt8500: fix possible memory leak in vt8500_serial_probe()
      TTY: hvcs: fix missing unlock on error in hvcs_initialize()
      serial: 8250_pci: use module_pci_driver to simplify the code
      tty: of_serial: fix return value check in of_platform_serial_setup()
      staging: sb105x: fix potential NULL pointer dereference in mp_chars_in_buffer()

chao bi (3):
      serial: ifx6x60: different SPI word width configure requires different swap process
      serial:ifx6x60:Prevent data transfer when IFX6x60 port is shutdown
      serial:ifx6x60:SPI header is decoded incorrectly

 Documentation/ABI/testing/sysfs-tty                            |  112 +++
 Documentation/devicetree/bindings/tty/serial/fsl-mxs-auart.txt |    8 +
 Documentation/devicetree/bindings/tty/serial/of-serial.txt     |    5 +-
 MAINTAINERS                                                    |    1 +
 arch/alpha/include/asm/ioctls.h                                |    3 +
 arch/alpha/kernel/srmcons.c                                    |    5 +-
 arch/arm/boot/dts/imx28.dtsi                                   |    1 +
 arch/arm/plat-omap/include/plat/serial.h                       |    9 -
 arch/ia64/hp/sim/simserial.c                                   |    1 +
 arch/m68k/emu/nfcon.c                                          |    6 +-
 arch/mips/include/uapi/asm/ioctls.h                            |    3 +
 arch/parisc/include/uapi/asm/ioctls.h                          |    3 +
 arch/parisc/kernel/pdc_cons.c                                  |    5 +-
 arch/powerpc/include/uapi/asm/ioctls.h                         |    3 +
 arch/sh/include/uapi/asm/ioctls.h                              |    3 +
 arch/sparc/include/uapi/asm/ioctls.h                           |    3 +
 arch/um/drivers/chan_kern.c                                    |   17 +-
 arch/um/drivers/line.c                                         |    2 +
 arch/x86/platform/ce4100/ce4100.c                              |    3 +
 arch/xtensa/include/uapi/asm/ioctls.h                          |    3 +
 arch/xtensa/platforms/iss/console.c                            |    1 +
 drivers/bluetooth/hci_ldisc.c                                  |    7 +-
 drivers/char/pcmcia/synclink_cs.c                              |    5 +-
 drivers/char/ttyprintk.c                                       |    4 +-
 drivers/isdn/capi/capi.c                                       |   36 +-
 drivers/isdn/gigaset/common.c                                  |    1 +
 drivers/isdn/i4l/isdn_tty.c                                    |    4 +
 drivers/misc/pti.c                                             |    7 +-
 drivers/mmc/card/sdio_uart.c                                   |   24 +-
 drivers/net/usb/hso.c                                          |    5 +-
 drivers/s390/char/con3215.c                                    |    1 +
 drivers/s390/char/sclp_tty.c                                   |    4 +-
 drivers/s390/char/sclp_vt220.c                                 |    2 +
 drivers/s390/char/tty3270.c                                    |    2 +
 drivers/staging/Kconfig                                        |    4 +
 drivers/staging/Makefile                                       |    2 +
 drivers/staging/ccg/u_serial.c                                 |    5 +-
 drivers/staging/dgrp/dgrp_common.h                             |    1 -
 drivers/staging/dgrp/dgrp_driver.c                             |    4 -
 drivers/staging/dgrp/dgrp_net_ops.c                            |   73 +-
 drivers/staging/dgrp/dgrp_specproc.c                           |    4 +-
 drivers/staging/dgrp/dgrp_sysfs.c                              |   18 -
 drivers/staging/dgrp/dgrp_tty.c                                |   39 +-
 drivers/staging/fwserial/Kconfig                               |    9 +
 drivers/staging/fwserial/Makefile                              |    2 +
 drivers/staging/fwserial/TODO                                  |   37 +
 drivers/staging/fwserial/dma_fifo.c                            |  307 ++++++++
 drivers/staging/fwserial/dma_fifo.h                            |  130 ++++
 drivers/staging/fwserial/fwserial.c                            | 2943 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h                            |  387 ++++++++++
 drivers/staging/ipack/devices/ipoctal.c                        |    2 +
 drivers/staging/sb105x/Kconfig                                 |    9 +
 drivers/staging/sb105x/Makefile                                |    3 +
 drivers/staging/sb105x/sb_mp_register.h                        |  295 ++++++++
 drivers/staging/sb105x/sb_pci_mp.c                             | 3196 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/sb105x/sb_pci_mp.h                             |  293 ++++++++
 drivers/staging/sb105x/sb_ser_core.h                           |  368 +++++++++
 drivers/tty/amiserial.c                                        |    2 +
 drivers/tty/bfin_jtag_comm.c                                   |    6 +-
 drivers/tty/cyclades.c                                         |   28 +-
 drivers/tty/ehv_bytechan.c                                     |    4 +-
 drivers/tty/hvc/hvc_opal.c                                     |    8 +-
 drivers/tty/hvc/hvc_vio.c                                      |    6 +-
 drivers/tty/hvc/hvc_xen.c                                      |    2 +-
 drivers/tty/hvc/hvcs.c                                         |   20 +-
 drivers/tty/hvc/hvsi.c                                         |    1 +
 drivers/tty/ipwireless/network.c                               |    5 +-
 drivers/tty/ipwireless/tty.c                                   |    1 +
 drivers/tty/isicom.c                                           |   35 +-
 drivers/tty/moxa.c                                             |   12 +-
 drivers/tty/mxser.c                                            |   35 +-
 drivers/tty/n_gsm.c                                            |   11 +-
 drivers/tty/n_tty.c                                            |  752 ++++++++++---------
 drivers/tty/nozomi.c                                           |   23 +-
 drivers/tty/pty.c                                              |   81 +-
 drivers/tty/rocket.c                                           |    4 +-
 drivers/tty/serial/68328serial.c                               |    2 +
 drivers/tty/serial/8250/8250.c                                 |   98 ++-
 drivers/tty/serial/8250/8250.h                                 |   36 +
 drivers/tty/serial/8250/8250_acorn.c                           |    6 +-
 drivers/tty/serial/8250/8250_dw.c                              |   31 +-
 drivers/tty/serial/8250/8250_early.c                           |   46 +-
 drivers/tty/serial/8250/8250_em.c                              |    8 +-
 drivers/tty/serial/8250/8250_hp300.c                           |   10 +-
 drivers/tty/serial/8250/8250_pci.c                             |  352 +++++++--
 drivers/tty/serial/8250/8250_pnp.c                             |   14 +-
 drivers/tty/serial/Kconfig                                     |   48 +-
 drivers/tty/serial/Makefile                                    |    1 +
 drivers/tty/serial/altera_jtaguart.c                           |    6 +-
 drivers/tty/serial/altera_uart.c                               |    6 +-
 drivers/tty/serial/amba-pl011.c                                |   25 +-
 drivers/tty/serial/apbuart.c                                   |    2 +-
 drivers/tty/serial/ar933x_uart.c                               |   96 ++-
 drivers/tty/serial/arc_uart.c                                  |  746 ++++++++++++++++++
 drivers/tty/serial/atmel_serial.c                              |   10 +-
 drivers/tty/serial/bcm63xx_uart.c                              |    6 +-
 drivers/tty/serial/bfin_sport_uart.c                           |    6 +-
 drivers/tty/serial/bfin_uart.c                                 |   20 +-
 drivers/tty/serial/clps711x.c                                  |  595 +++++++--------
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                    |    4 +-
 drivers/tty/serial/efm32-uart.c                                |    6 +-
 drivers/tty/serial/icom.c                                      |   14 +-
 drivers/tty/serial/ifx6x60.c                                   |  168 ++++-
 drivers/tty/serial/ifx6x60.h                                   |    2 +
 drivers/tty/serial/ioc3_serial.c                               |    2 +-
 drivers/tty/serial/jsm/jsm.h                                   |    8 +-
 drivers/tty/serial/jsm/jsm_driver.c                            |    9 +-
 drivers/tty/serial/jsm/jsm_neo.c                               |  116 +--
 drivers/tty/serial/jsm/jsm_tty.c                               |  104 +--
 drivers/tty/serial/kgdb_nmi.c                                  |    2 +
 drivers/tty/serial/lpc32xx_hs.c                                |    6 +-
 drivers/tty/serial/max3100.c                                   |    6 +-
 drivers/tty/serial/max310x.c                                   |   11 +-
 drivers/tty/serial/mcf.c                                       |    6 +-
 drivers/tty/serial/mfd.c                                       |    7 +-
 drivers/tty/serial/mpc52xx_uart.c                              |    2 +-
 drivers/tty/serial/mrst_max3110.c                              |    6 +-
 drivers/tty/serial/msm_serial.c                                |    2 +-
 drivers/tty/serial/msm_serial_hs.c                             |    8 +-
 drivers/tty/serial/mux.c                                       |    6 +-
 drivers/tty/serial/mxs-auart.c                                 |  376 +++++++++-
 drivers/tty/serial/of_serial.c                                 |   38 +-
 drivers/tty/serial/omap-serial.c                               |   30 +-
 drivers/tty/serial/pch_uart.c                                  |    4 +-
 drivers/tty/serial/pxa.c                                       |   55 ++
 drivers/tty/serial/sa1100.c                                    |    2 +-
 drivers/tty/serial/samsung.c                                   |   46 +-
 drivers/tty/serial/sc26xx.c                                    |    6 +-
 drivers/tty/serial/sccnxp.c                                    |    6 +-
 drivers/tty/serial/serial_core.c                               |  186 ++++-
 drivers/tty/serial/serial_txx9.c                               |   16 +-
 drivers/tty/serial/sh-sci.c                                    |  154 ++--
 drivers/tty/serial/sirfsoc_uart.c                              |    4 +-
 drivers/tty/serial/sunhv.c                                     |    6 +-
 drivers/tty/serial/sunsab.c                                    |    8 +-
 drivers/tty/serial/sunsu.c                                     |   10 +-
 drivers/tty/serial/sunzilog.c                                  |   14 +-
 drivers/tty/serial/timbuart.c                                  |    6 +-
 drivers/tty/serial/uartlite.c                                  |   14 +-
 drivers/tty/serial/vr41xx_siu.c                                |    8 +-
 drivers/tty/serial/vt8500_serial.c                             |   14 +-
 drivers/tty/serial/xilinx_uartps.c                             |   15 +-
 drivers/tty/synclink.c                                         |    7 +-
 drivers/tty/synclink_gt.c                                      |   11 +-
 drivers/tty/synclinkmp.c                                       |   11 +-
 drivers/tty/sysrq.c                                            |    3 +-
 drivers/tty/tty_audit.c                                        |   15 +-
 drivers/tty/tty_buffer.c                                       |  228 +++---
 drivers/tty/tty_io.c                                           |   24 +-
 drivers/tty/tty_ioctl.c                                        |   21 -
 drivers/tty/tty_ldisc.c                                        |   47 +-
 drivers/tty/tty_mutex.c                                        |    4 +-
 drivers/tty/tty_port.c                                         |   18 +-
 drivers/tty/vt/consolemap.c                                    |    6 +-
 drivers/tty/vt/selection.c                                     |    9 +-
 drivers/tty/vt/vt.c                                            |    5 +-
 drivers/tty/vt/vt_ioctl.c                                      |    1 +
 drivers/usb/gadget/u_serial.c                                  |    5 +-
 drivers/usb/serial/usb-serial.c                                |    1 +
 fs/compat_ioctl.c                                              |    3 +
 fs/devpts/inode.c                                              |   61 +-
 include/linux/devpts_fs.h                                      |   20 +-
 include/linux/pci_ids.h                                        |    5 +
 include/linux/serial_8250.h                                    |    2 +
 include/linux/tty.h                                            |   45 +-
 include/linux/tty_flip.h                                       |    2 +-
 include/uapi/asm-generic/ioctls.h                              |    3 +
 include/uapi/linux/serial_core.h                               |    5 +-
 include/uapi/linux/serial_reg.h                                |   18 +
 kernel/auditsc.c                                               |    2 +-
 kernel/printk.c                                                |   12 +-
 net/irda/ircomm/ircomm_tty.c                                   |    1 +
 172 files changed, 11959 insertions(+), 1785 deletions(-)
 create mode 100644 drivers/staging/fwserial/Kconfig
 create mode 100644 drivers/staging/fwserial/Makefile
 create mode 100644 drivers/staging/fwserial/TODO
 create mode 100644 drivers/staging/fwserial/dma_fifo.c
 create mode 100644 drivers/staging/fwserial/dma_fifo.h
 create mode 100644 drivers/staging/fwserial/fwserial.c
 create mode 100644 drivers/staging/fwserial/fwserial.h
 create mode 100644 drivers/staging/sb105x/Kconfig
 create mode 100644 drivers/staging/sb105x/Makefile
 create mode 100644 drivers/staging/sb105x/sb_mp_register.h
 create mode 100644 drivers/staging/sb105x/sb_pci_mp.c
 create mode 100644 drivers/staging/sb105x/sb_pci_mp.h
 create mode 100644 drivers/staging/sb105x/sb_ser_core.h
 create mode 100644 drivers/tty/serial/arc_uart.c
