Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0H2VGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:06:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0H2VGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 0/5] tty: move stuff around
Date: Sun, 29 Aug 2010 23:06:30 +0200
Message-Id: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:FSUUrtV0D43Hu9b0ZihwGlGD9o/pN9uhqD8yg7HymPh
 AG1o0hpn8bztnTKK2iEMCCOWLGAyS+76zF3QNq5y2BYGroazOG
 jJZi4wDkM7NCJODfMd8v7ZEN+qCNFQB4tTHR+ffdruudAUXNQ0
 R5FJKRYT2RBdviwns6cdG1HR1ZUhy95ZUQWvAO7QgHLT3LT6aT
 FkGtgMwFWBfuGZJh6408Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After fighting with the BKL removal in tty, I realized that the
files in drivers/char could use a reorganization to split the
tty files from those drivers that have nothing to do with ttys.

This moves files from drivers/char to a new hierarchy under
drivers/tty, roughly

drivers/tty/*.[ch]  generic tty code
drivers/tty/hvc     virtual drivers using hvc
drivers/tty/vt      virtual terminal code
drivers/tty/hw      hardware specific drivers
drivers/tty/hw/{rio,ip2,epca} larger drivers

I am considering the name 'legacy' instead of 'hw', but I'm
not completely sure if all the drivers in there are obsolete.
I also don't care about any of the other directory locations
for stuff. If there are better ideas, I can update my patches.

Of course, moving stuff around always has the tendency to
break patches against it, so we might not want to do this after
all.

Any other opinions?

	Arnd

---
Arnd Bergmann (5):
  tty: move tty layer code to drivers/tty
  tty/vt: move files to drivers/tty/vt/
  tty/hvc: move files to drivers/tty/hvc
  tty/hw: move hardware drivers to drivers/tty/hw
  tty: rearrange Kconfig structure

 MAINTAINERS                                        |   28 +-
 arch/cris/Kconfig                                  |    2 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/char/Kconfig                               |  573 --------------------
 drivers/char/Makefile                              |   81 +---
 drivers/char/pcmcia/Kconfig                        |   22 -
 drivers/char/pcmcia/Makefile                       |    3 -
 drivers/tty/Kconfig                                |  112 ++++
 drivers/tty/Makefile                               |   26 +
 drivers/tty/hvc/Kconfig                            |  104 ++++
 drivers/tty/hvc/Makefile                           |   12 +
 drivers/{char => tty/hvc}/hvc_beat.c               |    0
 drivers/{char => tty/hvc}/hvc_console.c            |    0
 drivers/{char => tty/hvc}/hvc_console.h            |    0
 drivers/{char => tty/hvc}/hvc_irq.c                |    0
 drivers/{char => tty/hvc}/hvc_iseries.c            |    0
 drivers/{char => tty/hvc}/hvc_iucv.c               |    0
 drivers/{char => tty/hvc}/hvc_rtas.c               |    0
 drivers/{char => tty/hvc}/hvc_tile.c               |    0
 drivers/{char => tty/hvc}/hvc_udbg.c               |    0
 drivers/{char => tty/hvc}/hvc_vio.c                |    0
 drivers/{char => tty/hvc}/hvc_xen.c                |    0
 drivers/{char => tty/hvc}/hvcs.c                   |    0
 drivers/{char => tty/hvc}/hvsi.c                   |    0
 drivers/{char => tty/hvc}/virtio_console.c         |    0
 drivers/tty/hw/Kconfig                             |  308 +++++++++++
 drivers/tty/hw/Makefile                            |   27 +
 drivers/{char => tty/hw}/amiserial.c               |    0
 drivers/{char => tty/hw}/bfin_jtag_comm.c          |    0
 drivers/{char => tty/hw}/cd1865.h                  |    0
 drivers/{char => tty/hw}/cyclades.c                |    0
 drivers/tty/hw/epca/Makefile                       |    1 +
 drivers/{char => tty/hw/epca}/digi1.h              |    0
 drivers/{char => tty/hw/epca}/digiFep1.h           |    0
 drivers/{char => tty/hw/epca}/digiPCI.h            |    0
 drivers/{char => tty/hw/epca}/epca.c               |    0
 drivers/{char => tty/hw/epca}/epca.h               |    0
 drivers/{char => tty/hw/epca}/epcaconfig.h         |    0
 drivers/{char => tty/hw}/generic_serial.c          |    0
 drivers/{char => tty/hw}/ip2/Makefile              |    0
 drivers/{char => tty/hw}/ip2/i2cmd.c               |    0
 drivers/{char => tty/hw}/ip2/i2cmd.h               |    0
 drivers/{char => tty/hw}/ip2/i2ellis.c             |    0
 drivers/{char => tty/hw}/ip2/i2ellis.h             |    0
 drivers/{char => tty/hw}/ip2/i2hw.h                |    0
 drivers/{char => tty/hw}/ip2/i2lib.c               |    0
 drivers/{char => tty/hw}/ip2/i2lib.h               |    0
 drivers/{char => tty/hw}/ip2/i2pack.h              |    0
 drivers/{char => tty/hw}/ip2/ip2.h                 |    0
 drivers/{char => tty/hw}/ip2/ip2ioctl.h            |    0
 drivers/{char => tty/hw}/ip2/ip2main.c             |    0
 drivers/{char => tty/hw}/ip2/ip2trace.h            |    0
 drivers/{char => tty/hw}/ip2/ip2types.h            |    0
 .../{char/pcmcia => tty/hw}/ipwireless/Makefile    |    0
 .../{char/pcmcia => tty/hw}/ipwireless/hardware.c  |    0
 .../{char/pcmcia => tty/hw}/ipwireless/hardware.h  |    0
 drivers/{char/pcmcia => tty/hw}/ipwireless/main.c  |    0
 drivers/{char/pcmcia => tty/hw}/ipwireless/main.h  |    0
 .../{char/pcmcia => tty/hw}/ipwireless/network.c   |    0
 .../{char/pcmcia => tty/hw}/ipwireless/network.h   |    0
 .../pcmcia => tty/hw}/ipwireless/setup_protocol.h  |    0
 drivers/{char/pcmcia => tty/hw}/ipwireless/tty.c   |    0
 drivers/{char/pcmcia => tty/hw}/ipwireless/tty.h   |    0
 drivers/{char => tty/hw}/isicom.c                  |    0
 drivers/{char => tty/hw}/istallion.c               |    0
 drivers/{char => tty/hw}/moxa.c                    |    0
 drivers/{char => tty/hw}/moxa.h                    |    0
 drivers/{char => tty/hw}/mxser.c                   |    0
 drivers/{char => tty/hw}/mxser.h                   |    0
 drivers/{char => tty/hw}/nozomi.c                  |    0
 drivers/{char => tty/hw}/rio/Makefile              |    0
 drivers/{char => tty/hw}/rio/board.h               |    0
 drivers/{char => tty/hw}/rio/cirrus.h              |    0
 drivers/{char => tty/hw}/rio/cmdblk.h              |    0
 drivers/{char => tty/hw}/rio/cmdpkt.h              |    0
 drivers/{char => tty/hw}/rio/daemon.h              |    0
 drivers/{char => tty/hw}/rio/errors.h              |    0
 drivers/{char => tty/hw}/rio/func.h                |    0
 drivers/{char => tty/hw}/rio/host.h                |    0
 drivers/{char => tty/hw}/rio/link.h                |    0
 drivers/{char => tty/hw}/rio/linux_compat.h        |    0
 drivers/{char => tty/hw}/rio/map.h                 |    0
 drivers/{char => tty/hw}/rio/param.h               |    0
 drivers/{char => tty/hw}/rio/parmmap.h             |    0
 drivers/{char => tty/hw}/rio/pci.h                 |    0
 drivers/{char => tty/hw}/rio/phb.h                 |    0
 drivers/{char => tty/hw}/rio/pkt.h                 |    0
 drivers/{char => tty/hw}/rio/port.h                |    0
 drivers/{char => tty/hw}/rio/protsts.h             |    0
 drivers/{char => tty/hw}/rio/rio.h                 |    0
 drivers/{char => tty/hw}/rio/rio_linux.c           |    0
 drivers/{char => tty/hw}/rio/rio_linux.h           |    0
 drivers/{char => tty/hw}/rio/rioboard.h            |    0
 drivers/{char => tty/hw}/rio/rioboot.c             |    0
 drivers/{char => tty/hw}/rio/riocmd.c              |    0
 drivers/{char => tty/hw}/rio/rioctrl.c             |    0
 drivers/{char => tty/hw}/rio/riodrvr.h             |    0
 drivers/{char => tty/hw}/rio/rioinfo.h             |    0
 drivers/{char => tty/hw}/rio/rioinit.c             |    0
 drivers/{char => tty/hw}/rio/riointr.c             |    0
 drivers/{char => tty/hw}/rio/rioioctl.h            |    0
 drivers/{char => tty/hw}/rio/rioparam.c            |    0
 drivers/{char => tty/hw}/rio/rioroute.c            |    0
 drivers/{char => tty/hw}/rio/riospace.h            |    0
 drivers/{char => tty/hw}/rio/riotable.c            |    0
 drivers/{char => tty/hw}/rio/riotty.c              |    0
 drivers/{char => tty/hw}/rio/route.h               |    0
 drivers/{char => tty/hw}/rio/rup.h                 |    0
 drivers/{char => tty/hw}/rio/unixrup.h             |    0
 drivers/{char => tty/hw}/riscom8.c                 |    0
 drivers/{char => tty/hw}/riscom8.h                 |    0
 drivers/{char => tty/hw}/riscom8_reg.h             |    0
 drivers/{char => tty/hw}/rocket.c                  |    0
 drivers/{char => tty/hw}/rocket.h                  |    0
 drivers/{char => tty/hw}/rocket_int.h              |    0
 drivers/{char => tty/hw}/ser_a2232.c               |    0
 drivers/{char => tty/hw}/ser_a2232.h               |    0
 drivers/{char => tty/hw}/ser_a2232fw.ax            |    0
 drivers/{char => tty/hw}/ser_a2232fw.h             |    0
 drivers/{char => tty/hw}/serial167.c               |    0
 drivers/{char => tty/hw}/specialix.c               |    0
 drivers/{char => tty/hw}/specialix_io8.h           |    0
 drivers/{char => tty/hw}/stallion.c                |    0
 drivers/{char => tty/hw}/sx.c                      |    0
 drivers/{char => tty/hw}/sx.h                      |    0
 drivers/{char => tty/hw}/sxboards.h                |    0
 drivers/{char => tty/hw}/sxwindow.h                |    0
 drivers/{char => tty/hw}/synclink.c                |    0
 drivers/{char/pcmcia => tty/hw}/synclink_cs.c      |    0
 drivers/{char => tty/hw}/synclink_gt.c             |    0
 drivers/{char => tty/hw}/synclinkmp.c              |    0
 drivers/{char => tty/hw}/vme_scc.c                 |    0
 drivers/{char => tty}/n_gsm.c                      |    0
 drivers/{char => tty}/n_hdlc.c                     |    0
 drivers/{char => tty}/n_r3964.c                    |    0
 drivers/{char => tty}/n_tty.c                      |    0
 drivers/{char => tty}/pty.c                        |    0
 drivers/{char => tty}/sysrq.c                      |    0
 drivers/{char => tty}/tty_audit.c                  |    0
 drivers/{char => tty}/tty_buffer.c                 |    0
 drivers/{char => tty}/tty_io.c                     |    0
 drivers/{char => tty}/tty_ioctl.c                  |    0
 drivers/{char => tty}/tty_ldisc.c                  |    0
 drivers/{char => tty}/tty_mutex.c                  |    0
 drivers/{char => tty}/tty_port.c                   |    0
 drivers/tty/vt/Kconfig                             |   84 +++
 drivers/tty/vt/Makefile                            |   37 ++
 drivers/{char => tty/vt}/consolemap.c              |    0
 drivers/{char => tty/vt}/cp437.uni                 |    0
 drivers/{char => tty/vt}/defkeymap.c_shipped       |    0
 drivers/{char => tty/vt}/defkeymap.map             |    0
 drivers/{char => tty/vt}/keyboard.c                |    0
 drivers/{char => tty/vt}/selection.c               |    0
 drivers/{char => tty/vt}/vc_screen.c               |    0
 drivers/{char => tty/vt}/vt.c                      |    0
 drivers/{char => tty/vt}/vt_ioctl.c                |    0
 157 files changed, 732 insertions(+), 691 deletions(-)
 create mode 100644 drivers/tty/Kconfig
 create mode 100644 drivers/tty/Makefile
 create mode 100644 drivers/tty/hvc/Kconfig
 create mode 100644 drivers/tty/hvc/Makefile
 rename drivers/{char => tty/hvc}/hvc_beat.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.h (100%)
 rename drivers/{char => tty/hvc}/hvc_irq.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iseries.c (100%)
 rename drivers/{char => tty/hvc}/hvc_iucv.c (100%)
 rename drivers/{char => tty/hvc}/hvc_rtas.c (100%)
 rename drivers/{char => tty/hvc}/hvc_tile.c (100%)
 rename drivers/{char => tty/hvc}/hvc_udbg.c (100%)
 rename drivers/{char => tty/hvc}/hvc_vio.c (100%)
 rename drivers/{char => tty/hvc}/hvc_xen.c (100%)
 rename drivers/{char => tty/hvc}/hvcs.c (100%)
 rename drivers/{char => tty/hvc}/hvsi.c (100%)
 rename drivers/{char => tty/hvc}/virtio_console.c (100%)
 create mode 100644 drivers/tty/hw/Kconfig
 create mode 100644 drivers/tty/hw/Makefile
 rename drivers/{char => tty/hw}/amiserial.c (100%)
 rename drivers/{char => tty/hw}/bfin_jtag_comm.c (100%)
 rename drivers/{char => tty/hw}/cd1865.h (100%)
 rename drivers/{char => tty/hw}/cyclades.c (100%)
 create mode 100644 drivers/tty/hw/epca/Makefile
 rename drivers/{char => tty/hw/epca}/digi1.h (100%)
 rename drivers/{char => tty/hw/epca}/digiFep1.h (100%)
 rename drivers/{char => tty/hw/epca}/digiPCI.h (100%)
 rename drivers/{char => tty/hw/epca}/epca.c (100%)
 rename drivers/{char => tty/hw/epca}/epca.h (100%)
 rename drivers/{char => tty/hw/epca}/epcaconfig.h (100%)
 rename drivers/{char => tty/hw}/generic_serial.c (100%)
 rename drivers/{char => tty/hw}/ip2/Makefile (100%)
 rename drivers/{char => tty/hw}/ip2/i2cmd.c (100%)
 rename drivers/{char => tty/hw}/ip2/i2cmd.h (100%)
 rename drivers/{char => tty/hw}/ip2/i2ellis.c (100%)
 rename drivers/{char => tty/hw}/ip2/i2ellis.h (100%)
 rename drivers/{char => tty/hw}/ip2/i2hw.h (100%)
 rename drivers/{char => tty/hw}/ip2/i2lib.c (100%)
 rename drivers/{char => tty/hw}/ip2/i2lib.h (100%)
 rename drivers/{char => tty/hw}/ip2/i2pack.h (100%)
 rename drivers/{char => tty/hw}/ip2/ip2.h (100%)
 rename drivers/{char => tty/hw}/ip2/ip2ioctl.h (100%)
 rename drivers/{char => tty/hw}/ip2/ip2main.c (100%)
 rename drivers/{char => tty/hw}/ip2/ip2trace.h (100%)
 rename drivers/{char => tty/hw}/ip2/ip2types.h (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/Makefile (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/hardware.c (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/hardware.h (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/main.c (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/main.h (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/network.c (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/network.h (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/setup_protocol.h (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/tty.c (100%)
 rename drivers/{char/pcmcia => tty/hw}/ipwireless/tty.h (100%)
 rename drivers/{char => tty/hw}/isicom.c (100%)
 rename drivers/{char => tty/hw}/istallion.c (100%)
 rename drivers/{char => tty/hw}/moxa.c (100%)
 rename drivers/{char => tty/hw}/moxa.h (100%)
 rename drivers/{char => tty/hw}/mxser.c (100%)
 rename drivers/{char => tty/hw}/mxser.h (100%)
 rename drivers/{char => tty/hw}/nozomi.c (100%)
 rename drivers/{char => tty/hw}/rio/Makefile (100%)
 rename drivers/{char => tty/hw}/rio/board.h (100%)
 rename drivers/{char => tty/hw}/rio/cirrus.h (100%)
 rename drivers/{char => tty/hw}/rio/cmdblk.h (100%)
 rename drivers/{char => tty/hw}/rio/cmdpkt.h (100%)
 rename drivers/{char => tty/hw}/rio/daemon.h (100%)
 rename drivers/{char => tty/hw}/rio/errors.h (100%)
 rename drivers/{char => tty/hw}/rio/func.h (100%)
 rename drivers/{char => tty/hw}/rio/host.h (100%)
 rename drivers/{char => tty/hw}/rio/link.h (100%)
 rename drivers/{char => tty/hw}/rio/linux_compat.h (100%)
 rename drivers/{char => tty/hw}/rio/map.h (100%)
 rename drivers/{char => tty/hw}/rio/param.h (100%)
 rename drivers/{char => tty/hw}/rio/parmmap.h (100%)
 rename drivers/{char => tty/hw}/rio/pci.h (100%)
 rename drivers/{char => tty/hw}/rio/phb.h (100%)
 rename drivers/{char => tty/hw}/rio/pkt.h (100%)
 rename drivers/{char => tty/hw}/rio/port.h (100%)
 rename drivers/{char => tty/hw}/rio/protsts.h (100%)
 rename drivers/{char => tty/hw}/rio/rio.h (100%)
 rename drivers/{char => tty/hw}/rio/rio_linux.c (100%)
 rename drivers/{char => tty/hw}/rio/rio_linux.h (100%)
 rename drivers/{char => tty/hw}/rio/rioboard.h (100%)
 rename drivers/{char => tty/hw}/rio/rioboot.c (100%)
 rename drivers/{char => tty/hw}/rio/riocmd.c (100%)
 rename drivers/{char => tty/hw}/rio/rioctrl.c (100%)
 rename drivers/{char => tty/hw}/rio/riodrvr.h (100%)
 rename drivers/{char => tty/hw}/rio/rioinfo.h (100%)
 rename drivers/{char => tty/hw}/rio/rioinit.c (100%)
 rename drivers/{char => tty/hw}/rio/riointr.c (100%)
 rename drivers/{char => tty/hw}/rio/rioioctl.h (100%)
 rename drivers/{char => tty/hw}/rio/rioparam.c (100%)
 rename drivers/{char => tty/hw}/rio/rioroute.c (100%)
 rename drivers/{char => tty/hw}/rio/riospace.h (100%)
 rename drivers/{char => tty/hw}/rio/riotable.c (100%)
 rename drivers/{char => tty/hw}/rio/riotty.c (100%)
 rename drivers/{char => tty/hw}/rio/route.h (100%)
 rename drivers/{char => tty/hw}/rio/rup.h (100%)
 rename drivers/{char => tty/hw}/rio/unixrup.h (100%)
 rename drivers/{char => tty/hw}/riscom8.c (100%)
 rename drivers/{char => tty/hw}/riscom8.h (100%)
 rename drivers/{char => tty/hw}/riscom8_reg.h (100%)
 rename drivers/{char => tty/hw}/rocket.c (100%)
 rename drivers/{char => tty/hw}/rocket.h (100%)
 rename drivers/{char => tty/hw}/rocket_int.h (100%)
 rename drivers/{char => tty/hw}/ser_a2232.c (100%)
 rename drivers/{char => tty/hw}/ser_a2232.h (100%)
 rename drivers/{char => tty/hw}/ser_a2232fw.ax (100%)
 rename drivers/{char => tty/hw}/ser_a2232fw.h (100%)
 rename drivers/{char => tty/hw}/serial167.c (100%)
 rename drivers/{char => tty/hw}/specialix.c (100%)
 rename drivers/{char => tty/hw}/specialix_io8.h (100%)
 rename drivers/{char => tty/hw}/stallion.c (100%)
 rename drivers/{char => tty/hw}/sx.c (100%)
 rename drivers/{char => tty/hw}/sx.h (100%)
 rename drivers/{char => tty/hw}/sxboards.h (100%)
 rename drivers/{char => tty/hw}/sxwindow.h (100%)
 rename drivers/{char => tty/hw}/synclink.c (100%)
 rename drivers/{char/pcmcia => tty/hw}/synclink_cs.c (100%)
 rename drivers/{char => tty/hw}/synclink_gt.c (100%)
 rename drivers/{char => tty/hw}/synclinkmp.c (100%)
 rename drivers/{char => tty/hw}/vme_scc.c (100%)
 rename drivers/{char => tty}/n_gsm.c (100%)
 rename drivers/{char => tty}/n_hdlc.c (100%)
 rename drivers/{char => tty}/n_r3964.c (100%)
 rename drivers/{char => tty}/n_tty.c (100%)
 rename drivers/{char => tty}/pty.c (100%)
 rename drivers/{char => tty}/sysrq.c (100%)
 rename drivers/{char => tty}/tty_audit.c (100%)
 rename drivers/{char => tty}/tty_buffer.c (100%)
 rename drivers/{char => tty}/tty_io.c (100%)
 rename drivers/{char => tty}/tty_ioctl.c (100%)
 rename drivers/{char => tty}/tty_ldisc.c (100%)
 rename drivers/{char => tty}/tty_mutex.c (100%)
 rename drivers/{char => tty}/tty_port.c (100%)
 create mode 100644 drivers/tty/vt/Kconfig
 create mode 100644 drivers/tty/vt/Makefile
 rename drivers/{char => tty/vt}/consolemap.c (100%)
 rename drivers/{char => tty/vt}/cp437.uni (100%)
 rename drivers/{char => tty/vt}/defkeymap.c_shipped (100%)
 rename drivers/{char => tty/vt}/defkeymap.map (100%)
 rename drivers/{char => tty/vt}/keyboard.c (100%)
 rename drivers/{char => tty/vt}/selection.c (100%)
 rename drivers/{char => tty/vt}/vc_screen.c (100%)
 rename drivers/{char => tty/vt}/vt.c (100%)
 rename drivers/{char => tty/vt}/vt_ioctl.c (100%)
