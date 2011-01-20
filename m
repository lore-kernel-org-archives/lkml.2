Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1ATRzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:55:19 -0500
Received: from kroah.org ([198.145.64.141]:46594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1ATRzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:55:17 -0500
Date: Thu, 20 Jan 2011 09:49:10 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver movement for .38
Message-ID: <20110120174910.GA30124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned before in previous TTY git pull for .38, here's the big
movement of the serial drivers into the drivers/tty/ subdirectory that
needed to wait until after .38-rc1 was out.

It merely moves the hvc drivers to drivers/tty/hvc/ and the
drivers/serial/ directory to drivers/tty/serial/ and fixes up the
MAINTAINERS file to point to the proper locations of the files now that
they have been moved.

This has been approved by all of the affected parties and has been in
the -next tree for a week or so now, with no regressions.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------


 MAINTAINERS                                       |   50 ++++++++++----------
 drivers/Makefile                                  |    3 +-
 drivers/char/Kconfig                              |    2 +-
 drivers/char/Makefile                             |   13 -----
 drivers/tty/Makefile                              |    2 +
 drivers/tty/hvc/Makefile                          |   13 +++++
 drivers/{char => tty/hvc}/hvc_beat.c              |    0
 drivers/{char => tty/hvc}/hvc_console.c           |    0
 drivers/{char => tty/hvc}/hvc_console.h           |    0
 drivers/{char => tty/hvc}/hvc_dcc.c               |    0
 drivers/{char => tty/hvc}/hvc_irq.c               |    0
 drivers/{char => tty/hvc}/hvc_iseries.c           |    0
 drivers/{char => tty/hvc}/hvc_iucv.c              |    0
 drivers/{char => tty/hvc}/hvc_rtas.c              |    0
 drivers/{char => tty/hvc}/hvc_tile.c              |    0
 drivers/{char => tty/hvc}/hvc_udbg.c              |    0
 drivers/{char => tty/hvc}/hvc_vio.c               |    0
 drivers/{char => tty/hvc}/hvc_xen.c               |    0
 drivers/{char => tty/hvc}/hvcs.c                  |    0
 drivers/{char => tty/hvc}/hvsi.c                  |    0
 drivers/{char => tty/hvc}/virtio_console.c        |    0
 drivers/{ => tty}/serial/21285.c                  |    0
 drivers/{ => tty}/serial/68328serial.c            |    0
 drivers/{ => tty}/serial/68328serial.h            |    0
 drivers/{ => tty}/serial/68360serial.c            |    0
 drivers/{ => tty}/serial/8250.c                   |    0
 drivers/{ => tty}/serial/8250.h                   |    0
 drivers/{ => tty}/serial/8250_accent.c            |    0
 drivers/{ => tty}/serial/8250_acorn.c             |    0
 drivers/{ => tty}/serial/8250_boca.c              |    0
 drivers/{ => tty}/serial/8250_early.c             |    0
 drivers/{ => tty}/serial/8250_exar_st16c554.c     |    0
 drivers/{ => tty}/serial/8250_fourport.c          |    0
 drivers/{ => tty}/serial/8250_gsc.c               |    0
 drivers/{ => tty}/serial/8250_hp300.c             |    0
 drivers/{ => tty}/serial/8250_hub6.c              |    0
 drivers/{ => tty}/serial/8250_mca.c               |    0
 drivers/{ => tty}/serial/8250_pci.c               |    0
 drivers/{ => tty}/serial/8250_pnp.c               |    0
 drivers/{ => tty}/serial/Kconfig                  |    0
 drivers/{ => tty}/serial/Makefile                 |    0
 drivers/{ => tty}/serial/altera_jtaguart.c        |    0
 drivers/{ => tty}/serial/altera_uart.c            |    0
 drivers/{ => tty}/serial/amba-pl010.c             |    0
 drivers/{ => tty}/serial/amba-pl011.c             |    0
 drivers/{ => tty}/serial/apbuart.c                |    0
 drivers/{ => tty}/serial/apbuart.h                |    0
 drivers/{ => tty}/serial/atmel_serial.c           |    0
 drivers/{ => tty}/serial/bcm63xx_uart.c           |    0
 drivers/{ => tty}/serial/bfin_5xx.c               |    0
 drivers/{ => tty}/serial/bfin_sport_uart.c        |    0
 drivers/{ => tty}/serial/bfin_sport_uart.h        |    0
 drivers/{ => tty}/serial/clps711x.c               |    0
 drivers/{ => tty}/serial/cpm_uart/Makefile        |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart.h      |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_core.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.h |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.h |    0
 drivers/{ => tty}/serial/crisv10.c                |    0
 drivers/{ => tty}/serial/crisv10.h                |    0
 drivers/{ => tty}/serial/dz.c                     |    0
 drivers/{ => tty}/serial/dz.h                     |    0
 drivers/{ => tty}/serial/icom.c                   |    0
 drivers/{ => tty}/serial/icom.h                   |    0
 drivers/{ => tty}/serial/ifx6x60.c                |    0
 drivers/{ => tty}/serial/ifx6x60.h                |    0
 drivers/{ => tty}/serial/imx.c                    |    0
 drivers/{ => tty}/serial/ioc3_serial.c            |    0
 drivers/{ => tty}/serial/ioc4_serial.c            |    0
 drivers/{ => tty}/serial/ip22zilog.c              |    0
 drivers/{ => tty}/serial/ip22zilog.h              |    0
 drivers/{ => tty}/serial/jsm/Makefile             |    0
 drivers/{ => tty}/serial/jsm/jsm.h                |    0
 drivers/{ => tty}/serial/jsm/jsm_driver.c         |    0
 drivers/{ => tty}/serial/jsm/jsm_neo.c            |    0
 drivers/{ => tty}/serial/jsm/jsm_tty.c            |    0
 drivers/{ => tty}/serial/kgdboc.c                 |    0
 drivers/{ => tty}/serial/m32r_sio.c               |    0
 drivers/{ => tty}/serial/m32r_sio.h               |    0
 drivers/{ => tty}/serial/m32r_sio_reg.h           |    0
 drivers/{ => tty}/serial/max3100.c                |    0
 drivers/{ => tty}/serial/max3107-aava.c           |    0
 drivers/{ => tty}/serial/max3107.c                |    0
 drivers/{ => tty}/serial/max3107.h                |    0
 drivers/{ => tty}/serial/mcf.c                    |    0
 drivers/{ => tty}/serial/mfd.c                    |    0
 drivers/{ => tty}/serial/mpc52xx_uart.c           |    0
 drivers/{ => tty}/serial/mpsc.c                   |    0
 drivers/{ => tty}/serial/mrst_max3110.c           |    0
 drivers/{ => tty}/serial/mrst_max3110.h           |    0
 drivers/{ => tty}/serial/msm_serial.c             |    0
 drivers/{ => tty}/serial/msm_serial.h             |    0
 drivers/{ => tty}/serial/mux.c                    |    0
 drivers/{ => tty}/serial/netx-serial.c            |    0
 drivers/{ => tty}/serial/nwpserial.c              |    0
 drivers/{ => tty}/serial/of_serial.c              |    0
 drivers/{ => tty}/serial/omap-serial.c            |    0
 drivers/{ => tty}/serial/pch_uart.c               |    0
 drivers/{ => tty}/serial/pmac_zilog.c             |    0
 drivers/{ => tty}/serial/pmac_zilog.h             |    0
 drivers/{ => tty}/serial/pnx8xxx_uart.c           |    0
 drivers/{ => tty}/serial/pxa.c                    |    0
 drivers/{ => tty}/serial/s3c2400.c                |    0
 drivers/{ => tty}/serial/s3c2410.c                |    0
 drivers/{ => tty}/serial/s3c2412.c                |    0
 drivers/{ => tty}/serial/s3c2440.c                |    0
 drivers/{ => tty}/serial/s3c24a0.c                |    0
 drivers/{ => tty}/serial/s3c6400.c                |    0
 drivers/{ => tty}/serial/s5pv210.c                |    0
 drivers/{ => tty}/serial/sa1100.c                 |    0
 drivers/{ => tty}/serial/samsung.c                |    0
 drivers/{ => tty}/serial/samsung.h                |    0
 drivers/{ => tty}/serial/sb1250-duart.c           |    0
 drivers/{ => tty}/serial/sc26xx.c                 |    0
 drivers/{ => tty}/serial/serial_core.c            |    0
 drivers/{ => tty}/serial/serial_cs.c              |    0
 drivers/{ => tty}/serial/serial_ks8695.c          |    0
 drivers/{ => tty}/serial/serial_lh7a40x.c         |    0
 drivers/{ => tty}/serial/serial_txx9.c            |    0
 drivers/{ => tty}/serial/sh-sci.c                 |    0
 drivers/{ => tty}/serial/sh-sci.h                 |    0
 drivers/{ => tty}/serial/sn_console.c             |    0
 drivers/{ => tty}/serial/suncore.c                |    0
 drivers/{ => tty}/serial/suncore.h                |    0
 drivers/{ => tty}/serial/sunhv.c                  |    0
 drivers/{ => tty}/serial/sunsab.c                 |    0
 drivers/{ => tty}/serial/sunsab.h                 |    0
 drivers/{ => tty}/serial/sunsu.c                  |    0
 drivers/{ => tty}/serial/sunzilog.c               |    0
 drivers/{ => tty}/serial/sunzilog.h               |    0
 drivers/{ => tty}/serial/timbuart.c               |    0
 drivers/{ => tty}/serial/timbuart.h               |    0
 drivers/{ => tty}/serial/uartlite.c               |    0
 drivers/{ => tty}/serial/ucc_uart.c               |    0
 drivers/{ => tty}/serial/vr41xx_siu.c             |    0
 drivers/{ => tty}/serial/vt8500_serial.c          |    0
 drivers/{ => tty}/serial/zs.c                     |    0
 drivers/{ => tty}/serial/zs.h                     |    0
 140 files changed, 42 insertions(+), 41 deletions(-)
 create mode 100644 drivers/tty/hvc/Makefile
 rename drivers/{char => tty/hvc}/hvc_beat.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.c (100%)
 rename drivers/{char => tty/hvc}/hvc_console.h (100%)
 rename drivers/{char => tty/hvc}/hvc_dcc.c (100%)
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
 rename drivers/{ => tty}/serial/21285.c (100%)
 rename drivers/{ => tty}/serial/68328serial.c (100%)
 rename drivers/{ => tty}/serial/68328serial.h (100%)
 rename drivers/{ => tty}/serial/68360serial.c (100%)
 rename drivers/{ => tty}/serial/8250.c (100%)
 rename drivers/{ => tty}/serial/8250.h (100%)
 rename drivers/{ => tty}/serial/8250_accent.c (100%)
 rename drivers/{ => tty}/serial/8250_acorn.c (100%)
 rename drivers/{ => tty}/serial/8250_boca.c (100%)
 rename drivers/{ => tty}/serial/8250_early.c (100%)
 rename drivers/{ => tty}/serial/8250_exar_st16c554.c (100%)
 rename drivers/{ => tty}/serial/8250_fourport.c (100%)
 rename drivers/{ => tty}/serial/8250_gsc.c (100%)
 rename drivers/{ => tty}/serial/8250_hp300.c (100%)
 rename drivers/{ => tty}/serial/8250_hub6.c (100%)
 rename drivers/{ => tty}/serial/8250_mca.c (100%)
 rename drivers/{ => tty}/serial/8250_pci.c (100%)
 rename drivers/{ => tty}/serial/8250_pnp.c (100%)
 rename drivers/{ => tty}/serial/Kconfig (100%)
 rename drivers/{ => tty}/serial/Makefile (100%)
 rename drivers/{ => tty}/serial/altera_jtaguart.c (100%)
 rename drivers/{ => tty}/serial/altera_uart.c (100%)
 rename drivers/{ => tty}/serial/amba-pl010.c (100%)
 rename drivers/{ => tty}/serial/amba-pl011.c (100%)
 rename drivers/{ => tty}/serial/apbuart.c (100%)
 rename drivers/{ => tty}/serial/apbuart.h (100%)
 rename drivers/{ => tty}/serial/atmel_serial.c (100%)
 rename drivers/{ => tty}/serial/bcm63xx_uart.c (100%)
 rename drivers/{ => tty}/serial/bfin_5xx.c (100%)
 rename drivers/{ => tty}/serial/bfin_sport_uart.c (100%)
 rename drivers/{ => tty}/serial/bfin_sport_uart.h (100%)
 rename drivers/{ => tty}/serial/clps711x.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/Makefile (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart.h (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_core.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.h (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.h (100%)
 rename drivers/{ => tty}/serial/crisv10.c (100%)
 rename drivers/{ => tty}/serial/crisv10.h (100%)
 rename drivers/{ => tty}/serial/dz.c (100%)
 rename drivers/{ => tty}/serial/dz.h (100%)
 rename drivers/{ => tty}/serial/icom.c (100%)
 rename drivers/{ => tty}/serial/icom.h (100%)
 rename drivers/{ => tty}/serial/ifx6x60.c (100%)
 rename drivers/{ => tty}/serial/ifx6x60.h (100%)
 rename drivers/{ => tty}/serial/imx.c (100%)
 rename drivers/{ => tty}/serial/ioc3_serial.c (100%)
 rename drivers/{ => tty}/serial/ioc4_serial.c (100%)
 rename drivers/{ => tty}/serial/ip22zilog.c (100%)
 rename drivers/{ => tty}/serial/ip22zilog.h (100%)
 rename drivers/{ => tty}/serial/jsm/Makefile (100%)
 rename drivers/{ => tty}/serial/jsm/jsm.h (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_driver.c (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_neo.c (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_tty.c (100%)
 rename drivers/{ => tty}/serial/kgdboc.c (100%)
 rename drivers/{ => tty}/serial/m32r_sio.c (100%)
 rename drivers/{ => tty}/serial/m32r_sio.h (100%)
 rename drivers/{ => tty}/serial/m32r_sio_reg.h (100%)
 rename drivers/{ => tty}/serial/max3100.c (100%)
 rename drivers/{ => tty}/serial/max3107-aava.c (100%)
 rename drivers/{ => tty}/serial/max3107.c (100%)
 rename drivers/{ => tty}/serial/max3107.h (100%)
 rename drivers/{ => tty}/serial/mcf.c (100%)
 rename drivers/{ => tty}/serial/mfd.c (100%)
 rename drivers/{ => tty}/serial/mpc52xx_uart.c (100%)
 rename drivers/{ => tty}/serial/mpsc.c (100%)
 rename drivers/{ => tty}/serial/mrst_max3110.c (100%)
 rename drivers/{ => tty}/serial/mrst_max3110.h (100%)
 rename drivers/{ => tty}/serial/msm_serial.c (100%)
 rename drivers/{ => tty}/serial/msm_serial.h (100%)
 rename drivers/{ => tty}/serial/mux.c (100%)
 rename drivers/{ => tty}/serial/netx-serial.c (100%)
 rename drivers/{ => tty}/serial/nwpserial.c (100%)
 rename drivers/{ => tty}/serial/of_serial.c (100%)
 rename drivers/{ => tty}/serial/omap-serial.c (100%)
 rename drivers/{ => tty}/serial/pch_uart.c (100%)
 rename drivers/{ => tty}/serial/pmac_zilog.c (100%)
 rename drivers/{ => tty}/serial/pmac_zilog.h (100%)
 rename drivers/{ => tty}/serial/pnx8xxx_uart.c (100%)
 rename drivers/{ => tty}/serial/pxa.c (100%)
 rename drivers/{ => tty}/serial/s3c2400.c (100%)
 rename drivers/{ => tty}/serial/s3c2410.c (100%)
 rename drivers/{ => tty}/serial/s3c2412.c (100%)
 rename drivers/{ => tty}/serial/s3c2440.c (100%)
 rename drivers/{ => tty}/serial/s3c24a0.c (100%)
 rename drivers/{ => tty}/serial/s3c6400.c (100%)
 rename drivers/{ => tty}/serial/s5pv210.c (100%)
 rename drivers/{ => tty}/serial/sa1100.c (100%)
 rename drivers/{ => tty}/serial/samsung.c (100%)
 rename drivers/{ => tty}/serial/samsung.h (100%)
 rename drivers/{ => tty}/serial/sb1250-duart.c (100%)
 rename drivers/{ => tty}/serial/sc26xx.c (100%)
 rename drivers/{ => tty}/serial/serial_core.c (100%)
 rename drivers/{ => tty}/serial/serial_cs.c (100%)
 rename drivers/{ => tty}/serial/serial_ks8695.c (100%)
 rename drivers/{ => tty}/serial/serial_lh7a40x.c (100%)
 rename drivers/{ => tty}/serial/serial_txx9.c (100%)
 rename drivers/{ => tty}/serial/sh-sci.c (100%)
 rename drivers/{ => tty}/serial/sh-sci.h (100%)
 rename drivers/{ => tty}/serial/sn_console.c (100%)
 rename drivers/{ => tty}/serial/suncore.c (100%)
 rename drivers/{ => tty}/serial/suncore.h (100%)
 rename drivers/{ => tty}/serial/sunhv.c (100%)
 rename drivers/{ => tty}/serial/sunsab.c (100%)
 rename drivers/{ => tty}/serial/sunsab.h (100%)
 rename drivers/{ => tty}/serial/sunsu.c (100%)
 rename drivers/{ => tty}/serial/sunzilog.c (100%)
 rename drivers/{ => tty}/serial/sunzilog.h (100%)
 rename drivers/{ => tty}/serial/timbuart.c (100%)
 rename drivers/{ => tty}/serial/timbuart.h (100%)
 rename drivers/{ => tty}/serial/uartlite.c (100%)
 rename drivers/{ => tty}/serial/ucc_uart.c (100%)
 rename drivers/{ => tty}/serial/vr41xx_siu.c (100%)
 rename drivers/{ => tty}/serial/vt8500_serial.c (100%)
 rename drivers/{ => tty}/serial/zs.c (100%)
 rename drivers/{ => tty}/serial/zs.h (100%)

---------------

Greg Kroah-Hartman (3):
      tty: move hvc drivers to drivers/tty/hvc/
      tty: move drivers/serial/ to drivers/tty/serial/
      tty: update MAINTAINERS file due to driver movement

