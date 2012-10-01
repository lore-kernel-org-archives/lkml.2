Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2JASaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:30:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38960 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab2JASat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:30:49 -0400
X-Sasl-enc: WzQ+lBgFToj5UILX0IHElvDDk+MH0cW/Ksay5ls6akhO 1349116248
Date: Mon, 1 Oct 2012 11:30:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 3.7-rc1
Message-ID: <20121001183046.GA13042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.6

for you to fetch changes up to 0c57dfcc6c1d037243c2f8fbf62eab3633326ec0:

  tty/serial: Add kgdb_nmi driver (2012-09-26 13:52:36 -0700)

----------------------------------------------------------------
TTY merge for 3.7-rc1

As we skipped the merge window for 3.6-rc1 for the tty tree, everything
is now settled down and working properly, so we are ready for 3.7-rc1.
Here's the patchset, it's big, but the large changes are removing a
firmware file and adding a staging tty driver (it depended on the tty
core changes, so it's going through this tree instead of the staging
tree.)

All of these patches have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (31):
      tty: note race we need to fix
      tty: localise the lock
      usb: fix sillies in the metro USB driver
      8250: use the 8250 register interface not the legacy one
      8250: propogate the bugs field
      8250: add support for ASIX devices with a FIFO bug
      tty: revert incorrectly applied lock patch
      tty: move the termios object into the tty
      f81232: correct stubbed termios handler
      usb, kobil: Sort out some bogus tty handling
      tty: Fix up PPC fallout from the termios move
      8250: three way resolve of the 8250 diffs
      vt: fix the keyboard/led locking
      tty: Move the handling of the tty release logic
      pch_uart: Fix missing break for 16 byte fifo
      pcmcia,synclink_cs: fix termios port I missed
      tty: Fix race in tty release
      serqt_usb2: drag screaming into the 21st century
      tty: fix the metro-usb change I messed up
      tty: localise the lock
      ipoctal: make it compile with the termios changes
      8250: add AgeStar AS-PRS2-009
      tty: Split the serial_core helpers for setserial into two
      tty: move the async flags from the serial code into the tty includes
      8250_pci: Add additional WCH CHC353 devices
      tty: Fix hvc return
      tty: serial: max3100: Fix error case
      tty: ipwireless: check ppp register worked
      tty: n_gsm: Fix incorrect debug display
      serial_core: Fix race in uart_handle_dcd_change
      pty: Fix locking bug on error path

Alexander Shiyan (7):
      serial: sc26xx: Fix compile breakage
      serial: New serial driver MAX310X
      serial: New serial driver SCCNXP
      serial: Add note about migration to driver SCCNXP
      serial: sccnxp: Report actual baudrate back to core
      serial: sccnxp: Remove mask termios caps for SW flow control
      serial: sccnxp: Make 'default' choice in switch last

Anton Vorontsov (7):
      kernel/debug: Mask KGDB NMI upon entry
      kdb: Implement disable_nmi command
      kdb: Turn KGDB_KDB=n stubs into static inlines
      tty/serial/core: Introduce poll_init callback
      tty/serial/amba-pl011: Implement poll_init callback
      tty/serial/amba-pl011: Quiesce interrupts in poll_get_char
      tty/serial: Add kgdb_nmi driver

Bill Pemberton (3):
      staging: Add dgrp driver for Digi Realport devices
      staging: dgrp: add dgrp to the build
      staging: dgrp: fix potential call to strncpy with a negative number

Chao Xie (1):
      serial: pxa: add spin lock for console write

Christophe Leroy (4):
      Powerpc 8xx CPM_UART desynchronisation
      Powerpc 8xx CPM_UART too many interrupts
      Powerpc 8xx CPM_UART maxidl should not depend on fifo size
      Powerpc 8xx CPM_UART setting MAXIDL register proportionaly to baud rate

Christopher Brannon (1):
      tty: keyboard.c: Remove locking from vt_get_leds.

Corbin (1):
      serial_core: Update buffer overrun statistics.

Dan Carpenter (4):
      tty: double unlock on error in ptmx_open()
      tty: fix missing assignment
      tty: handle NULL parameters in free_tty_struct()
      TTY: tty_alloc_driver() returns error pointers

Darren Hart (1):
      pch_uart: Add eg20t_port lock field, avoid recursive spinlocks

David Brown (1):
      msm_serial: fix clock rate on DMA-based uarts

David Daney (1):
      MIPS: OCTEON: Fix breakage due to 8250 changes.

Devendra Naga (1):
      tty: max3100: use module_spi_driver

Emil Goode (2):
      tty: serial: max310x: Check return code of gpiochip_remove
      tty: serial: max310x: Remove explicit use of devm_kfree

Felipe Balbi (22):
      serial: omap: define and use to_uart_omap_port()
      serial: omap: define helpers for pdata function pointers
      serial: omap: don't access the platform_device
      serial: omap: drop DMA support
      serial: add OMAP-specific defines
      serial: omap: simplify IRQ handling
      serial: omap: refactor receive_chars() into rdi/rlsi handlers
      serial: omap: move THRE check to transmit_chars()
      serial: omap: stick to put_autosuspend
      serial: omap: set dev->drvdata before enabling pm_runtime
      serial: omap: drop unnecessary check from remove
      serial: omap: make sure to suspend device before remove
      serial: omap: don't save IRQ flags on hardirq
      serial: omap: optimization with section annotations
      serial: omap: drop "inline" from IRQ handler prototype
      serial: omap: implement set_wake
      serial: omap: make sure to put() on poll_get_char
      serial: omap: remove unnecessary header and add a missing one
      serial: omap: move uart_omap_port definition to C file
      serial: omap: enable RX and TX FIFO usage
      serial: omap: fix compile breakage
      serial: omap: fix DeviceTree boot

Fengguang Wu (2):
      pch_uart: check kzalloc result in dma_handle_tx()
      serial_core: fix sizeof(pointer)

Flavio Leitner (2):
      8250: fix autoconfig to work with serial console
      serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Frederic Berat (1):
      n_gsm : Flow control handling in Mux driver

Gabor Juhos (1):
      tty: of_serial: add no-loopback-test property

Greg Kroah-Hartman (7):
      Merge 3.5-rc4 into tty-next
      Merge branch 'v3.6-rc7' into tty-next
      Merge tty-next into 3.6-rc1
      Merge 3.6-rc3 into tty-next
      Merge 3.6-rc6 into tty-next
      tty/serial: remove CONFIG_EXPERIMENTAL dependencies
      tty/serial: put (EXPERIMENTAL) marking back on N_GSM and SERIAL_IFX6X60

Guainluca Anzolin (1):
      parport_serial: Add support for the WCH353 2S/1P multi-IO card

Huang Shijie (4):
      serial: add a new helper function
      serial: mxs-auart: fix the wrong setting order
      serial: mxs-auart: put the device in mxs_auart_probe()
      serial: mxs-auart: put the device in the error path

Jaeden Amero (3):
      n_tty: Don't lose characters when PARMRK is enabled
      compat_ioctl: Add RS-485 IOCTLs to the list
      compat_ioctl: Avoid using undefined RS-485 IOCTLs

Jean-François Moine (1):
      tty vt: Fix line garbage in virtual console on command line edition

Jiri Slaby (67):
      TTY: cyclades, add local pointer for card
      TTY: ircomm, add tty_port
      TTY: ircomm, use close times from tty_port
      TTY: ircomm, use open counts from tty_port
      TTY: ircomm, use flags from tty_port
      TTY: ircomm, revamp locking
      TTY: ircomm, use tty from tty_port
      TTY: ircomm, define local tty_port
      TTY: ircomm, define carrier routines
      TTY: ircomm, use tty_port_close_end helper
      TTY: ircomm, use tty_port_close_start helper
      TTY: um/line, add tty_port
      TTY: um/line, use tty from tty_port
      PTY: remove one empty ops->remove
      PTY: merge pty_install implementations
      PTY: add tty_port
      TTY: vt, remove con_schedule_flip
      TTY: provide drivers with tty_port_install
      TTY: vt, add ->install
      TTY: usb-serial, use tty_port_install
      TTY: centralize fail paths in tty_register_driver
      TTY: add ports array to tty_driver
      TTY: add tty_port_register_device helper
      TTY: pty, stop passing NULL to free_tty_struct
      TTY: 68328serial, fix compilation
      TTY: n_gsm, use tty_port_install
      misc: pti, add const to pci_device_id table
      misc: pti, pci drvdata cannot be NULL in ->remove
      misc: pti, stop using iomap's unmap on ioremap space
      misc: pti, move ->remove to the PCI code
      misc: pti, do the opposite of ->probe in ->remove
      misc: pti, fix fail paths
      misc: pti, fix tty_port count
      misc: pti, use tty_port_register_device
      mxser: allow overlapping vector
      TTY: ttyprintk, unregister tty driver on failure
      TTY: ttyprintk, don't touch behind tty->write_buf
      TTY: ttyprintk, initialize tty_port earlier
      TTY: tty3270, free tty driver properly
      TTY: pass flags to alloc_tty_driver
      TTY: pty, switch to tty_alloc_driver
      TTY: move allocations to tty_alloc_driver
      TTY: add support for unnumbered device nodes
      TTY: move cdev_add to tty_register_device
      TTY: use tty_port_register_device
      TTY: automatically create nodes for some drivers
      TTY: tty_port, add some documentation
      TTY: add tty_port_link_device
      TTY: use tty_port_link_device
      TTY: synclink_cs, sanitize fail paths
      TTY: synclink_cs, use dynamic tty devices
      TTY: synclink_cs, final cleanup in synclink_cs_init
      TTY: moxa, convert to dynamic device
      TTY: nfcon, add tty_port and link it
      TTY: con3215, unset raw3215[line]
      TTY: con3215, add tty install
      TTY: i4l, add tty install
      TTY: synclink, add tty install
      TTY: synclinkmp, add tty install
      TTY: ircomm_tty, add tty install
      TTY: tty3270, add tty install
      TTY: hvc_console, add tty install
      TTY: hvcs, clean hvcs_open a bit
      TTY: hvcs, add tty install
      TTY: mxser, fix invalid module_parm permissions
      TTY: synclink_cs, fix build
      TTY: check if tty->port is assigned

Julia Lawall (3):
      drivers/tty/moxa.c: fix error return code
      drivers/tty/serial/amba-pl0{10,11}.c: use clk_prepare_enable and clk_disable_unprepare
      drivers/tty/serial/sirfsoc_uart.c: drop frees of devm_ alloc'd data

Julien Pichon (1):
      serial: samsung: Add poll_get_char & poll_put_char

KeyYoung Park (1):
      serial: samsung: protect NULL dereference of clock name

Kyoungil Kim (2):
      serial: samsung: Remove NULL checking for baud clock
      serial: samsung: Fixed wrong comparison for baudclk_rate

Laurent Pinchart (2):
      serial: sh-sci: Fix probe error paths
      serial: sh-sci: Make probe fail for ports that exceed the maximum count

Linus Walleij (4):
      serial/amba-pl011: fix ages old copy-paste errors
      serial: pl011: delete dangling bug flag
      serial: pl011: delete reset callback
      serial: pl011: handle corruption at high clock speeds

Matthew Leach (1):
      serial: pl011: honour serial aliases in device tree

NeilBrown (1):
      OMAP/serial: Add support for driving a GPIO as DTR.

Paul Bolle (2):
      delete seven tty headers
      Delete generic_serial.h

Paul Gortmaker (3):
      m32r_sio: remove dependency on struct serial_uart_config
      serial: sunsu.c - don't explicitly tie array size to dynamic entity
      serial: diminish usage of struct serial_uart_config

Rabin Vincent (1):
      vt: fix race in vt_waitactive()

Richard Zhao (2):
      serial: imx: set sport as drvdata, like it's used elsewhere
      serial: imx: remove null check of sport in suspend/resume function

Roland Stigge (3):
      serial/8250: Add LPC3220 standard UART type
      serial/of-serial: Add LPC3220 standard UART compatible string
      serial: Add driver for LPC32xx High Speed UARTs

Ruchika Kharwar (2):
      serial: omap: fix sequence of pm_runtime_* calls.
      serial: omap: unlock the port lock

Russ Gorby (5):
      n_gsm: uplink SKBs accumulate on list
      n_gsm: added interlocking for gsm_data_lock for certain code paths
      n_gsm: avoid accessing freed memory during CMD_FCOFF condition
      n_gsm: replace kfree_skb w/ appropriate dev_* versions
      n_gsm: memory leak in uplink error path

Sachin Kamat (3):
      serial: Samsung: Replace printk with dev_* functions
      serial: Samsung: Silence some checkpatch errors and warnings
      tty: serial: Samsung: Fix return value

Sean Young (2):
      8250_pnp: do pnp probe before legacy probe
      8250: blacklist Winbond CIR port

Shachar Shemesh (1):
      tty ldisc: Close/Reopen race prevention should check the proper flag

Shawn Bohrer (1):
      8250_pci: Remove duplicate struct pciserial_board

Shubhrajyoti D (1):
      serial: omap: fix the reciever line error case

Sourav Poddar (1):
      serial: omap: Remove unnecessary checks from suspend/resume

Stanislav Kozina (2):
      tty: Fix possible race in n_tty_read()
      Remove BUG_ON from n_tty_read()

Stephen Rothwell (3):
      tty: fix up usb serial console for termios change.
      serial: serial_core.h needs console.h included first
      staging: dgrp: using vmalloc needs to include vmalloc.h

Tim Gardner (1):
      firmware: remove computone driver firmware and documentation

Tobias Klauser (1):
      tty: serial: altera_uart: Use platform_{get,set}_drvdata

Tomas Hlavacek (2):
      tty: uartclk value from serial_core exposed to sysfs
      tty_register_device_attr updated for tty-next

Tomoya MORINAGA (2):
      pch_uart: Fix rx error interrupt setting issue
      pch_uart: Fix parity setting issue

Tony Lindgren (2):
      serial: omap: Request pins using pinctrl framework
      serial/8250: Limit the omap workarounds to omap1

Uwe Kleine-König (2):
      serial/imx: make devdata member point to const data
      serial/imx: improve error diagnosics for clock and pinctrl failures

Vikram Pandita (1):
      serial: omap: fix software flow control

Wanlong Gao (1):
      drivers:tty:fix up ENOIOCTLCMD error handling

Wei Yongjun (2):
      parport: fix possible memory leak in parport_gsc_probe_port()
      TTY: serial: move the dereference below the NULL test

Wolfram Sang (1):
      tty: serial: mpc5xxx: add support for mark/space parity

samix.lebsir (1):
      char: n_gsm: remove message filtering for contipated DLCI

xiaojin (1):
      n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX

 Documentation/ABI/testing/sysfs-tty                                 |    9 +
 Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt |   14 +
 Documentation/devicetree/bindings/tty/serial/of-serial.txt          |    2 +
 Documentation/serial/00-INDEX                                       |    2 -
 Documentation/serial/computone.txt                                  |  520 ------
 arch/alpha/kernel/srmcons.c                                         |    1 +
 arch/arm/mach-omap2/serial.c                                        |   18 +-
 arch/arm/mach-ux500/board-mop500.c                                  |   21 -
 arch/arm/plat-omap/include/plat/omap-serial.h                       |   50 +-
 arch/ia64/hp/sim/simserial.c                                        |    3 +-
 arch/m68k/emu/nfcon.c                                               |    4 +
 arch/mips/cavium-octeon/serial.c                                    |   30 +-
 arch/mips/sni/a20r.c                                                |   32 +
 arch/parisc/kernel/pdc_cons.c                                       |    1 +
 arch/um/drivers/line.c                                              |    3 +-
 arch/xtensa/platforms/iss/console.c                                 |    1 +
 drivers/bluetooth/hci_ath.c                                         |    2 +-
 drivers/char/mwave/mwavedd.c                                        |   16 +-
 drivers/char/pcmcia/synclink_cs.c                                   |  131 +-
 drivers/char/ttyprintk.c                                            |   33 +-
 drivers/isdn/capi/capi.c                                            |    3 +-
 drivers/isdn/gigaset/interface.c                                    |    7 +-
 drivers/isdn/i4l/isdn_tty.c                                         |   41 +-
 drivers/misc/ibmasm/uart.c                                          |   16 +-
 drivers/misc/pti.c                                                  |  128 +-
 drivers/mmc/card/sdio_uart.c                                        |   24 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                                 |   22 +-
 drivers/net/irda/irtty-sir.c                                        |   10 +-
 drivers/net/usb/hso.c                                               |   19 +-
 drivers/parport/parport_gsc.c                                       |    1 +
 drivers/parport/parport_serial.c                                    |   11 +-
 drivers/s390/char/con3215.c                                         |   28 +-
 drivers/s390/char/sclp_tty.c                                        |    1 +
 drivers/s390/char/sclp_vt220.c                                      |    1 +
 drivers/s390/char/tty3270.c                                         |   34 +-
 drivers/staging/Kconfig                                             |    2 +
 drivers/staging/Makefile                                            |    1 +
 drivers/staging/dgrp/Kconfig                                        |    9 +
 drivers/staging/dgrp/Makefile                                       |   12 +
 drivers/staging/dgrp/README                                         |    2 +
 drivers/staging/dgrp/TODO                                           |   13 +
 drivers/staging/dgrp/dgrp_common.c                                  |  200 +++
 drivers/staging/dgrp/dgrp_common.h                                  |  208 +++
 drivers/staging/dgrp/dgrp_dpa_ops.c                                 |  556 +++++++
 drivers/staging/dgrp/dgrp_driver.c                                  |  110 ++
 drivers/staging/dgrp/dgrp_mon_ops.c                                 |  346 ++++
 drivers/staging/dgrp/dgrp_net_ops.c                                 | 3737 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/dgrp/dgrp_ports_ops.c                               |  170 ++
 drivers/staging/dgrp/dgrp_specproc.c                                |  822 ++++++++++
 drivers/staging/dgrp/dgrp_sysfs.c                                   |  555 +++++++
 drivers/staging/dgrp/dgrp_tty.c                                     | 3331 +++++++++++++++++++++++++++++++++++++
 drivers/staging/dgrp/digirp.h                                       |  129 ++
 drivers/staging/dgrp/drp.h                                          |  693 ++++++++
 drivers/staging/ipack/devices/ipoctal.c                             |   14 +-
 drivers/staging/serqt_usb2/serqt_usb2.c                             |   18 +-
 drivers/staging/speakup/serialio.h                                  |    3 +-
 drivers/tty/Kconfig                                                 |    9 +-
 drivers/tty/amiserial.c                                             |   45 +-
 drivers/tty/bfin_jtag_comm.c                                        |    1 +
 drivers/tty/cyclades.c                                              |  102 +-
 drivers/tty/ehv_bytechan.c                                          |    9 +-
 drivers/tty/hvc/Kconfig                                             |    2 +-
 drivers/tty/hvc/hvc_console.c                                       |   33 +-
 drivers/tty/hvc/hvcs.c                                              |   82 +-
 drivers/tty/hvc/hvsi.c                                              |    2 +
 drivers/tty/hvc/hvsi_lib.c                                          |    2 +-
 drivers/tty/ipwireless/network.c                                    |    7 +-
 drivers/tty/ipwireless/tty.c                                        |    2 +-
 drivers/tty/isicom.c                                                |   13 +-
 drivers/tty/moxa.c                                                  |   39 +-
 drivers/tty/mxser.c                                                 |   63 +-
 drivers/tty/n_gsm.c                                                 |  144 +-
 drivers/tty/n_r3964.c                                               |   10 +-
 drivers/tty/n_tty.c                                                 |   29 +-
 drivers/tty/nozomi.c                                                |    4 +-
 drivers/tty/pty.c                                                   |  234 +--
 drivers/tty/rocket.c                                                |   22 +-
 drivers/tty/serial/68328serial.c                                    |   23 +-
 drivers/tty/serial/8250/8250.c                                      |  156 +-
 drivers/tty/serial/8250/8250.h                                      |   43 +-
 drivers/tty/serial/8250/8250_acorn.c                                |   22 +-
 drivers/tty/serial/8250/8250_dw.c                                   |   38 +-
 drivers/tty/serial/8250/8250_gsc.c                                  |   26 +-
 drivers/tty/serial/8250/8250_hp300.c                                |   26 +-
 drivers/tty/serial/8250/8250_pci.c                                  |  214 ++-
 drivers/tty/serial/8250/8250_pnp.c                                  |   59 +-
 drivers/tty/serial/8250/Kconfig                                     |   16 +-
 drivers/tty/serial/8250/Makefile                                    |    5 +-
 drivers/tty/serial/8250/serial_cs.c                                 |   30 +-
 drivers/tty/serial/Kconfig                                          |   73 +-
 drivers/tty/serial/Makefile                                         |    5 +-
 drivers/tty/serial/altera_uart.c                                    |    6 +-
 drivers/tty/serial/amba-pl010.c                                     |   15 +-
 drivers/tty/serial/amba-pl011.c                                     |  177 +-
 drivers/tty/serial/bfin_uart.c                                      |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                         |   23 +-
 drivers/tty/serial/crisv10.c                                        |   45 +-
 drivers/tty/serial/ifx6x60.c                                        |    4 +-
 drivers/tty/serial/imx.c                                            |   13 +-
 drivers/tty/serial/ioc3_serial.c                                    |    3 +-
 drivers/tty/serial/ioc4_serial.c                                    |    5 +-
 drivers/tty/serial/jsm/jsm_tty.c                                    |    8 +-
 drivers/tty/serial/kgdb_nmi.c                                       |  402 +++++
 drivers/tty/serial/kgdboc.c                                         |    9 +
 drivers/tty/serial/lpc32xx_hs.c                                     |  823 ++++++++++
 drivers/tty/serial/m32r_sio.c                                       |   36 +-
 drivers/tty/serial/max3100.c                                        |   26 +-
 drivers/tty/serial/max3107.c                                        | 1215 --------------
 drivers/tty/serial/max3107.h                                        |  441 -----
 drivers/tty/serial/max310x.c                                        | 1260 ++++++++++++++
 drivers/tty/serial/mpc52xx_uart.c                                   |    8 +-
 drivers/tty/serial/msm_serial.c                                     |    2 +-
 drivers/tty/serial/msm_smd_tty.c                                    |    8 +-
 drivers/tty/serial/mxs-auart.c                                      |    8 +-
 drivers/tty/serial/of_serial.c                                      |   13 +-
 drivers/tty/serial/omap-serial.c                                    |  885 +++++-----
 drivers/tty/serial/pch_uart.c                                       |    4 +
 drivers/tty/serial/pxa.c                                            |   14 +
 drivers/tty/serial/samsung.c                                        |   95 +-
 drivers/tty/serial/sc26xx.c                                         |    4 +
 drivers/tty/serial/sccnxp.c                                         |  990 +++++++++++
 drivers/tty/serial/serial_core.c                                    |  251 +--
 drivers/tty/serial/sirfsoc_uart.c                                   |    8 +-
 drivers/tty/serial/sunsu.c                                          |    8 +-
 drivers/tty/synclink.c                                              |   86 +-
 drivers/tty/synclink_gt.c                                           |   37 +-
 drivers/tty/synclinkmp.c                                            |   58 +-
 drivers/tty/tty_io.c                                                |  375 +++--
 drivers/tty/tty_ioctl.c                                             |  100 +-
 drivers/tty/tty_ldisc.c                                             |   78 +-
 drivers/tty/tty_mutex.c                                             |   71 +-
 drivers/tty/tty_port.c                                              |   94 +-
 drivers/tty/vt/keyboard.c                                           |   50 +-
 drivers/tty/vt/vt.c                                                 |  141 +-
 drivers/usb/class/cdc-acm.c                                         |    5 +-
 drivers/usb/gadget/u_serial.c                                       |    3 +-
 drivers/usb/serial/ark3116.c                                        |    4 +-
 drivers/usb/serial/belkin_sa.c                                      |    2 +-
 drivers/usb/serial/console.c                                        |    4 +-
 drivers/usb/serial/cp210x.c                                         |    8 +-
 drivers/usb/serial/cypress_m8.c                                     |   40 +-
 drivers/usb/serial/digi_acceleport.c                                |   14 +-
 drivers/usb/serial/empeg.c                                          |    2 +-
 drivers/usb/serial/f81232.c                                         |    3 +-
 drivers/usb/serial/ftdi_sio.c                                       |    2 +-
 drivers/usb/serial/io_edgeport.c                                    |   12 +-
 drivers/usb/serial/io_ti.c                                          |   12 +-
 drivers/usb/serial/ir-usb.c                                         |    2 +-
 drivers/usb/serial/iuu_phoenix.c                                    |   28 +-
 drivers/usb/serial/keyspan.c                                        |    6 +-
 drivers/usb/serial/keyspan_pda.c                                    |    4 +-
 drivers/usb/serial/kl5kusb105.c                                     |   18 +-
 drivers/usb/serial/kobil_sct.c                                      |   14 +-
 drivers/usb/serial/mct_u232.c                                       |    4 +-
 drivers/usb/serial/metro-usb.c                                      |    6 -
 drivers/usb/serial/mos7720.c                                        |   14 +-
 drivers/usb/serial/mos7840.c                                        |   12 +-
 drivers/usb/serial/oti6858.c                                        |   10 +-
 drivers/usb/serial/pl2303.c                                         |    6 +-
 drivers/usb/serial/quatech2.c                                       |    4 +-
 drivers/usb/serial/sierra.c                                         |    2 +-
 drivers/usb/serial/spcp8x5.c                                        |   12 +-
 drivers/usb/serial/ssu100.c                                         |    4 +-
 drivers/usb/serial/ti_usb_3410_5052.c                               |   10 +-
 drivers/usb/serial/usb-serial.c                                     |    7 +-
 drivers/usb/serial/usb_wwan.c                                       |    2 +-
 drivers/usb/serial/whiteheat.c                                      |    2 +-
 firmware/Makefile                                                   |    1 -
 firmware/intelliport2.bin.ihex                                      | 2147 ------------------------
 fs/compat_ioctl.c                                                   |    6 +
 include/linux/Kbuild                                                |    4 +-
 include/linux/amba/serial.h                                         |    1 -
 include/linux/cd1400.h                                              |  292 ----
 include/linux/cdk.h                                                 |  486 ------
 include/linux/comstats.h                                            |  119 --
 include/linux/generic_serial.h                                      |   35 -
 include/linux/istallion.h                                           |  123 --
 include/linux/kbd_kern.h                                            |   13 -
 include/linux/kdb.h                                                 |   29 +-
 include/linux/kgdb.h                                                |   13 +
 include/linux/pci_ids.h                                             |    1 -
 include/linux/platform_data/max310x.h                               |   67 +
 include/linux/platform_data/sccnxp.h                                |   93 ++
 include/linux/sc26198.h                                             |  533 ------
 include/linux/serial.h                                              |   81 +-
 include/linux/serial167.h                                           |  157 --
 include/linux/serial_8250.h                                         |   33 +-
 include/linux/serial_core.h                                         |    8 +-
 include/linux/serial_reg.h                                          |    4 +
 include/linux/stallion.h                                            |  147 --
 include/linux/tty.h                                                 |   92 +-
 include/linux/tty_driver.h                                          |   47 +-
 include/linux/tty_flags.h                                           |   78 +
 include/net/irda/ircomm_tty.h                                       |   17 +-
 kernel/debug/debug_core.c                                           |   14 +-
 kernel/debug/kdb/kdb_main.c                                         |   31 +
 net/bluetooth/rfcomm/tty.c                                          |   10 +-
 net/irda/ircomm/ircomm_param.c                                      |    5 -
 net/irda/ircomm/ircomm_tty.c                                        |  320 ++--
 net/irda/ircomm/ircomm_tty_attach.c                                 |   40 +-
 net/irda/ircomm/ircomm_tty_ioctl.c                                  |   33 +-
 201 files changed, 18056 insertions(+), 8963 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt
 delete mode 100644 Documentation/serial/computone.txt
 create mode 100644 drivers/staging/dgrp/Kconfig
 create mode 100644 drivers/staging/dgrp/Makefile
 create mode 100644 drivers/staging/dgrp/README
 create mode 100644 drivers/staging/dgrp/TODO
 create mode 100644 drivers/staging/dgrp/dgrp_common.c
 create mode 100644 drivers/staging/dgrp/dgrp_common.h
 create mode 100644 drivers/staging/dgrp/dgrp_dpa_ops.c
 create mode 100644 drivers/staging/dgrp/dgrp_driver.c
 create mode 100644 drivers/staging/dgrp/dgrp_mon_ops.c
 create mode 100644 drivers/staging/dgrp/dgrp_net_ops.c
 create mode 100644 drivers/staging/dgrp/dgrp_ports_ops.c
 create mode 100644 drivers/staging/dgrp/dgrp_specproc.c
 create mode 100644 drivers/staging/dgrp/dgrp_sysfs.c
 create mode 100644 drivers/staging/dgrp/dgrp_tty.c
 create mode 100644 drivers/staging/dgrp/digirp.h
 create mode 100644 drivers/staging/dgrp/drp.h
 create mode 100644 drivers/tty/serial/kgdb_nmi.c
 create mode 100644 drivers/tty/serial/lpc32xx_hs.c
 delete mode 100644 drivers/tty/serial/max3107.c
 delete mode 100644 drivers/tty/serial/max3107.h
 create mode 100644 drivers/tty/serial/max310x.c
 create mode 100644 drivers/tty/serial/sccnxp.c
 delete mode 100644 firmware/intelliport2.bin.ihex
 delete mode 100644 include/linux/cd1400.h
 delete mode 100644 include/linux/cdk.h
 delete mode 100644 include/linux/comstats.h
 delete mode 100644 include/linux/generic_serial.h
 delete mode 100644 include/linux/istallion.h
 create mode 100644 include/linux/platform_data/max310x.h
 create mode 100644 include/linux/platform_data/sccnxp.h
 delete mode 100644 include/linux/sc26198.h
 delete mode 100644 include/linux/serial167.h
 delete mode 100644 include/linux/stallion.h
 create mode 100644 include/linux/tty_flags.h
