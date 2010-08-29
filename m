Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0H2VH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:07:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0H2VGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
Date: Sun, 29 Aug 2010 23:06:34 +0200
Message-Id: <1283115995-4734-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UCNW3Uz4/dvjK9fK6p3BEKrMD7m67bj1uoYdLUOMkpY
 UDVL69no9OXXD/SJQvbj62MZobxTPdBJpJs2zkYC+sH7tt9CcF
 kCGGSmAjmT5ZjnZu9HloTSMHyTU54h6s9Q3BBEmD1+JUqyO2k1
 0huV/Kr7Vfa2ysWTDAHeRymg4kB0lPnAWPke+5LqIEE4vbq7rw
 BfWimsLRt3HrLkSOM4W6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random obsolete tty drivers are mixed with random
other stuff in drivers/char, this moves all the
tty drivers into one place.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                                        |   22 +-
 drivers/char/Kconfig                               |  287 +------------------
 drivers/char/Makefile                              |   28 +--
 drivers/char/pcmcia/Kconfig                        |   22 --
 drivers/char/pcmcia/Makefile                       |    3 -
 drivers/tty/Makefile                               |    1 +
 drivers/tty/hw/Kconfig                             |  308 ++++++++++++++++++++
 drivers/tty/hw/Makefile                            |   27 ++
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
 113 files changed, 351 insertions(+), 348 deletions(-)
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

diff --git a/MAINTAINERS b/MAINTAINERS
index 637a866..b2bcd4e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -186,7 +186,7 @@ A2232 SERIAL BOARD DRIVER
 M:	Enver Haase <A2232@gmx.net>
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
-F:	drivers/char/ser_a2232*
+F:	drivers/tty/hw/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
@@ -1634,7 +1634,7 @@ M:	"Michael H. Warfield" <mhw@wittsend.com>
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
 F:	Documentation/serial/computone.txt
-F:	drivers/char/ip2/
+F:	drivers/tty/hw/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
 M:	Simon Arlott <cxacru@fire.lp0.eu>
@@ -1809,7 +1809,7 @@ F:	drivers/net/wan/cycx*
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
-F:	drivers/char/cyclades.c
+F:	drivers/tty/hw/cyclades.c
 F:	include/linux/cyclades.h
 
 CYCLADES PC300 DRIVER
@@ -1923,8 +1923,8 @@ L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
 F:	Documentation/serial/digiepca.txt
-F:	drivers/char/epca*
-F:	drivers/char/digi*
+F:	drivers/tty/hw/epca*
+F:	drivers/tty/hw/digi*
 
 DIRECTORY NOTIFICATION (DNOTIFY)
 M:	Eric Paris <eparis@parisplace.org>
@@ -3151,7 +3151,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 M:	David Sterba <dsterba@suse.cz>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
-F:	drivers/char/pcmcia/ipwireless/
+F:	drivers/tty/hw/ipwireless/
 
 IPX NETWORK LAYER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
@@ -3866,7 +3866,7 @@ MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
-F:	drivers/char/mxser.*
+F:	drivers/tty/hw/mxser.*
 
 MSI LAPTOP SUPPORT
 M:	Lennart Poettering <mzxreary@0pointer.de>
@@ -3909,7 +3909,7 @@ F:	sound/oss/msnd*
 MULTITECH MULTIPORT CARD (ISICOM)
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
-F:	drivers/char/isicom.c
+F:	drivers/tty/hw/isicom.c
 F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
@@ -4850,14 +4850,14 @@ F:	drivers/mtd/nand/r852.h
 RISCOM8 DRIVER
 S:	Orphan
 F:	Documentation/serial/riscom8.txt
-F:	drivers/char/riscom8*
+F:	drivers/tty/hw/riscom8*
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
 F:	Documentation/serial/rocket.txt
-F:	drivers/char/rocket*
+F:	drivers/tty/hw/rocket*
 
 ROSE NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
@@ -5448,7 +5448,7 @@ SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 M:	Roger Wolff <R.E.Wolff@BitWizard.nl>
 S:	Supported
 F:	Documentation/serial/specialix.txt
-F:	drivers/char/specialix*
+F:	drivers/tty/hw/specialix*
 
 SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3ce0219..834fb9e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -15,292 +15,7 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
-config BFIN_JTAG_COMM
-	tristate "Blackfin JTAG Communication"
-	depends on BLACKFIN
-	help
-	  Add support for emulating a TTY device over the Blackfin JTAG.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bfin_jtag_comm.
-
-config BFIN_JTAG_COMM_CONSOLE
-	bool "Console on Blackfin JTAG"
-	depends on BFIN_JTAG_COMM=y
-
-config SERIAL_NONSTANDARD
-	bool "Non-standard serial port support"
-	depends on HAS_IOMEM
-	---help---
-	  Say Y here if you have any non-standard serial boards -- boards
-	  which aren't supported using the standard "dumb" serial driver.
-	  This includes intelligent serial boards such as Cyclades,
-	  Digiboards, etc. These are usually used for systems that need many
-	  serial ports because they serve many terminals or dial-in
-	  connections.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about non-standard serial boards.
-
-	  Most people can say N here.
-
-config COMPUTONE
-	tristate "Computone IntelliPort Plus serial support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	---help---
-	  This driver supports the entire family of Intelliport II/Plus
-	  controllers with the exception of the MicroChannel controllers and
-	  products previous to the Intelliport II. These are multiport cards,
-	  which give you many serial ports. You would need something like this
-	  to connect more than two modems to your Linux box, for instance in
-	  order to become a dial-in server. If you have a card like that, say
-	  Y here and read <file:Documentation/serial/computone.txt>.
-
-	  To compile this driver as module, choose M here: the
-	  module will be called ip2.
-
-config ROCKETPORT
-	tristate "Comtrol RocketPort support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	help
-	  This driver supports Comtrol RocketPort and RocketModem PCI boards.   
-          These boards provide 2, 4, 8, 16, or 32 high-speed serial ports or
-          modems.  For information about the RocketPort/RocketModem  boards
-          and this driver read <file:Documentation/serial/rocket.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rocket.
-
-	  If you want to compile this driver into the kernel, say Y here.  If
-          you don't have a Comtrol RocketPort/RocketModem card installed, say N.
-
-config CYCLADES
-	tristate "Cyclades async mux support"
-	depends on SERIAL_NONSTANDARD && (PCI || ISA)
-	select FW_LOADER
-	---help---
-	  This driver supports Cyclades Z and Y multiserial boards.
-	  You would need something like this to connect more than two modems to
-	  your Linux box, for instance in order to become a dial-in server.
-
-	  For information about the Cyclades-Z card, read
-	  <file:Documentation/serial/README.cycladesZ>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called cyclades.
-
-	  If you haven't heard about it, it's safe to say N.
-
-config CYZ_INTR
-	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && CYCLADES
-	help
-	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
-	  modes: polling and interrupt. In polling mode, the driver will check
-	  the status of the Cyclades-Z ports every certain amount of time
-	  (which is called polling cycle and is configurable). In interrupt
-	  mode, it will use an interrupt line (IRQ) in order to check the
-	  status of the Cyclades-Z ports. The default op mode is polling. If
-	  unsure, say N.
-
-config DIGIEPCA
-	tristate "Digiboard Intelligent Async Support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	---help---
-	  This is a driver for Digi International's Xx, Xeve, and Xem series
-	  of cards which provide multiple serial ports. You would need
-	  something like this to connect more than two modems to your Linux
-	  box, for instance in order to become a dial-in server. This driver
-	  supports the original PC (ISA) boards as well as PCI, and EISA. If
-	  you have a card like this, say Y here and read the file
-	  <file:Documentation/serial/digiepca.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called epca.
-
-config MOXA_INTELLIO
-	tristate "Moxa Intellio support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	select FW_LOADER
-	help
-	  Say Y here if you have a Moxa Intellio multiport serial card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called moxa.
-
-config MOXA_SMARTIO
-	tristate "Moxa SmartIO support v. 2.0"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
-	help
-	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
-	  want to help develop a new version of this driver.
-
-	  This is upgraded (1.9.1) driver from original Moxa drivers with
-	  changes finally resulting in PCI probing.
-
-	  This driver can also be built as a module. The module will be called
-	  mxser. If you want to do that, say M here.
-
-config ISI
-	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
-	depends on SERIAL_NONSTANDARD && PCI
-	select FW_LOADER
-	help
-	  This is a driver for the Multi-Tech cards which provide several
-	  serial ports.  The driver is experimental and can currently only be
-	  built as a module. The module will be called isicom.
-	  If you want to do that, choose M here.
-
-config SYNCLINK
-	tristate "Microgate SyncLink card support"
-	depends on SERIAL_NONSTANDARD && PCI && ISA_DMA_API
-	help
-	  Provides support for the SyncLink ISA and PCI multiprotocol serial
-	  adapters. These adapters support asynchronous and HDLC bit
-	  synchronous communication up to 10Mbps (PCI adapter).
-
-	  This driver can only be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclink.  If you want to do that, say M
-	  here.
-
-config SYNCLINKMP
-	tristate "SyncLink Multiport support"
-	depends on SERIAL_NONSTANDARD && PCI
-	help
-	  Enable support for the SyncLink Multiport (2 or 4 ports)
-	  serial adapter, running asynchronous and HDLC communications up
-	  to 2.048Mbps. Each ports is independently selectable for
-	  RS-232, V.35, RS-449, RS-530, and X.21
-
-	  This driver may be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclinkmp.  If you want to do that, say M
-	  here.
-
-config SYNCLINK_GT
-	tristate "SyncLink GT/AC support"
-	depends on SERIAL_NONSTANDARD && PCI
-	help
-	  Support for SyncLink GT and SyncLink AC families of
-	  synchronous and asynchronous serial adapters
-	  manufactured by Microgate Systems, Ltd. (www.microgate.com)
-
-config RISCOM8
-	tristate "SDL RISCom/8 card support"
-	depends on SERIAL_NONSTANDARD
-	help
-	  This is a driver for the SDL Communications RISCom/8 multiport card,
-	  which gives you many serial ports. You would need something like
-	  this to connect more than two modems to your Linux box, for instance
-	  in order to become a dial-in server. If you have a card like that,
-	  say Y here and read the file <file:Documentation/serial/riscom8.txt>.
-
-	  Also it's possible to say M here and compile this driver as kernel
-	  loadable module; the module will be called riscom8.
-
-config SPECIALIX
-	tristate "Specialix IO8+ card support"
-	depends on SERIAL_NONSTANDARD
-	help
-	  This is a driver for the Specialix IO8+ multiport card (both the
-	  ISA and the PCI version) which gives you many serial ports. You
-	  would need something like this to connect more than two modems to
-	  your Linux box, for instance in order to become a dial-in server.
-
-	  If you have a card like that, say Y here and read the file
-	  <file:Documentation/serial/specialix.txt>. Also it's possible to say
-	  M here and compile this driver as kernel loadable module which will be
-	  called specialix.
-
-config SX
-	tristate "Specialix SX (and SI) card support"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
-	help
-	  This is a driver for the SX and SI multiport serial cards.
-	  Please read the file <file:Documentation/serial/sx.txt> for details.
-
-	  This driver can only be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called sx. If you want to do that, say M here.
-
-config RIO
-	tristate "Specialix RIO system support"
-	depends on SERIAL_NONSTANDARD && BROKEN
-	help
-	  This is a driver for the Specialix RIO, a smart serial card which
-	  drives an outboard box that can support up to 128 ports.  Product
-	  information is at <http://www.perle.com/support/documentation.html#multiport>.
-	  There are both ISA and PCI versions.
-
-config RIO_OLDPCI
-	bool "Support really old RIO/PCI cards"
-	depends on RIO
-	help
-	  Older RIO PCI cards need some initialization-time configuration to
-	  determine the IRQ and some control addresses.  If you have a RIO and
-	  this doesn't seem to work, try setting this to Y.
-
-config STALDRV
-	bool "Stallion multiport serial support"
-	depends on SERIAL_NONSTANDARD
-	help
-	  Stallion cards give you many serial ports.  You would need something
-	  like this to connect more than two modems to your Linux box, for
-	  instance in order to become a dial-in server.  If you say Y here,
-	  you will be asked for your specific card model in the next
-	  questions.  Make sure to read <file:Documentation/serial/stallion.txt>
-	  in this case.  If you have never heard about all this, it's safe to
-	  say N.
-
-config STALLION
-	tristate "Stallion EasyIO or EC8/32 support"
-	depends on STALDRV && (ISA || EISA || PCI)
-	help
-	  If you have an EasyIO or EasyConnection 8/32 multiport Stallion
-	  card, then this is for you; say Y.  Make sure to read
-	  <file:Documentation/serial/stallion.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called stallion.
-
-config ISTALLION
-	tristate "Stallion EC8/64, ONboard, Brumby support"
-	depends on STALDRV && (ISA || EISA || PCI)
-	help
-	  If you have an EasyConnection 8/64, ONboard, Brumby or Stallion
-	  serial multiport card, say Y here. Make sure to read
-	  <file:Documentation/serial/stallion.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called istallion.
-
-config NOZOMI
-	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
-	depends on PCI && EXPERIMENTAL
-	help
-	  If you have a HSDPA driver Broadband Wireless Data Card -
-	  Globe Trotter PCMCIA card, say Y here.
-
-	  To compile this driver as a module, choose M here, the module
-	  will be called nozomi.
-
-config A2232
-	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ZORRO && BROKEN
-	---help---
-	  This option supports the 2232 7-port serial card shipped with the
-	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
-	  a max of 19,200 bps, the ports are served by a 6551 ACIA UART chip
-	  each, plus a 8520 CIA, and a master 6502 CPU and buffer as well. The
-	  ports were connected with 8 pin DIN connectors on the card bracket,
-	  for which 8 pin to DB25 adapters were supplied. The card also had
-	  jumpers internally to toggle various pinning configurations.
-
-	  This driver can be built as a module; but then "generic_serial"
-	  will also be built as a module. This has to be loaded before
-	  "ser_a2232". If you want to do this, answer M here.
+source "drivers/tty/hw/Kconfig"
 
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index d2fd481..65e1955 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -2,34 +2,10 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y	 += mem.o random.o
+obj-y				+= mem.o
+obj-y				+= random.o
 
 obj-y				+= misc.o
-obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
-obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
-obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
-obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
-obj-$(CONFIG_ROCKETPORT)	+= rocket.o
-obj-$(CONFIG_SERIAL167)		+= serial167.o
-obj-$(CONFIG_CYCLADES)		+= cyclades.o
-obj-$(CONFIG_STALLION)		+= stallion.o
-obj-$(CONFIG_ISTALLION)		+= istallion.o
-obj-$(CONFIG_NOZOMI)		+= nozomi.o
-obj-$(CONFIG_DIGIEPCA)		+= epca.o
-obj-$(CONFIG_SPECIALIX)		+= specialix.o
-obj-$(CONFIG_MOXA_INTELLIO)	+= moxa.o
-obj-$(CONFIG_A2232)		+= ser_a2232.o generic_serial.o
-obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
-obj-$(CONFIG_MOXA_SMARTIO)	+= mxser.o
-obj-$(CONFIG_COMPUTONE)		+= ip2/
-obj-$(CONFIG_RISCOM8)		+= riscom8.o
-obj-$(CONFIG_ISI)		+= isicom.o
-obj-$(CONFIG_SYNCLINK)		+= synclink.o
-obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
-obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
-obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
-obj-$(CONFIG_SX)		+= sx.o generic_serial.o
-obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index ffa0efc..51934cf 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -5,19 +5,6 @@
 menu "PCMCIA character devices"
 	depends on HOTPLUG && PCMCIA!=n
 
-config SYNCLINK_CS
-	tristate "SyncLink PC Card support"
-	depends on PCMCIA
-	help
-	  Enable support for the SyncLink PC Card serial adapter, running
-	  asynchronous and HDLC communications up to 512Kbps. The port is
-	  selectable for RS-232, V.35, RS-449, RS-530, and X.21
-
-	  This driver may be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclinkmp.  If you want to do that, say M
-	  here.
-
 config CARDMAN_4000
 	tristate "Omnikey Cardman 4000 support"
 	depends on PCMCIA
@@ -43,14 +30,5 @@ config CARDMAN_4040
 	  (http://www.omnikey.com/), or a current development version of OpenCT
 	  (http://www.opensc.org/).
 
-config IPWIRELESS
-	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA && NETDEVICES
-	select PPP
-	help
-	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
-	  some countries (for example Czech Republic, T-Mobile ISP) this card
-	  is shipped for service called UMTS 4G.
-
 endmenu
 
diff --git a/drivers/char/pcmcia/Makefile b/drivers/char/pcmcia/Makefile
index be8f287..82a9016 100644
--- a/drivers/char/pcmcia/Makefile
+++ b/drivers/char/pcmcia/Makefile
@@ -4,8 +4,5 @@
 # Makefile for the Linux PCMCIA char device drivers.
 #
 
-obj-y += ipwireless/
-
-obj-$(CONFIG_SYNCLINK_CS) += synclink_cs.o
 obj-$(CONFIG_CARDMAN_4000) += cm4000_cs.o
 obj-$(CONFIG_CARDMAN_4040) += cm4040_cs.o
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 938cb73..130078b 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -8,6 +8,7 @@ obj-y				+= tty_ldisc.o
 obj-y				+= tty_buffer.o
 obj-y				+= tty_port.o
 obj-y				+= tty_mutex.o
+obj-y				+= hw/
 
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
diff --git a/drivers/tty/hw/Kconfig b/drivers/tty/hw/Kconfig
new file mode 100644
index 0000000..4328aa4
--- /dev/null
+++ b/drivers/tty/hw/Kconfig
@@ -0,0 +1,308 @@
+config BFIN_JTAG_COMM
+	tristate "Blackfin JTAG Communication"
+	depends on BLACKFIN
+	help
+	  Add support for emulating a TTY device over the Blackfin JTAG.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_jtag_comm.
+
+config BFIN_JTAG_COMM_CONSOLE
+	bool "Console on Blackfin JTAG"
+	depends on BFIN_JTAG_COMM=y
+
+config SERIAL_NONSTANDARD
+	bool "Non-standard serial port support"
+	depends on HAS_IOMEM
+	---help---
+	  Say Y here if you have any non-standard serial boards -- boards
+	  which aren't supported using the standard "dumb" serial driver.
+	  This includes intelligent serial boards such as Cyclades,
+	  Digiboards, etc. These are usually used for systems that need many
+	  serial ports because they serve many terminals or dial-in
+	  connections.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about non-standard serial boards.
+
+	  Most people can say N here.
+
+config COMPUTONE
+	tristate "Computone IntelliPort Plus serial support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	---help---
+	  This driver supports the entire family of Intelliport II/Plus
+	  controllers with the exception of the MicroChannel controllers and
+	  products previous to the Intelliport II. These are multiport cards,
+	  which give you many serial ports. You would need something like this
+	  to connect more than two modems to your Linux box, for instance in
+	  order to become a dial-in server. If you have a card like that, say
+	  Y here and read <file:Documentation/serial/computone.txt>.
+
+	  To compile this driver as module, choose M here: the
+	  module will be called ip2.
+
+config ROCKETPORT
+	tristate "Comtrol RocketPort support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	help
+	  This driver supports Comtrol RocketPort and RocketModem PCI boards.   
+          These boards provide 2, 4, 8, 16, or 32 high-speed serial ports or
+          modems.  For information about the RocketPort/RocketModem  boards
+          and this driver read <file:Documentation/serial/rocket.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rocket.
+
+	  If you want to compile this driver into the kernel, say Y here.  If
+          you don't have a Comtrol RocketPort/RocketModem card installed, say N.
+
+config CYCLADES
+	tristate "Cyclades async mux support"
+	depends on SERIAL_NONSTANDARD && (PCI || ISA)
+	select FW_LOADER
+	---help---
+	  This driver supports Cyclades Z and Y multiserial boards.
+	  You would need something like this to connect more than two modems to
+	  your Linux box, for instance in order to become a dial-in server.
+
+	  For information about the Cyclades-Z card, read
+	  <file:Documentation/serial/README.cycladesZ>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyclades.
+
+	  If you haven't heard about it, it's safe to say N.
+
+config CYZ_INTR
+	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && CYCLADES
+	help
+	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
+	  modes: polling and interrupt. In polling mode, the driver will check
+	  the status of the Cyclades-Z ports every certain amount of time
+	  (which is called polling cycle and is configurable). In interrupt
+	  mode, it will use an interrupt line (IRQ) in order to check the
+	  status of the Cyclades-Z ports. The default op mode is polling. If
+	  unsure, say N.
+
+config DIGIEPCA
+	tristate "Digiboard Intelligent Async Support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	---help---
+	  This is a driver for Digi International's Xx, Xeve, and Xem series
+	  of cards which provide multiple serial ports. You would need
+	  something like this to connect more than two modems to your Linux
+	  box, for instance in order to become a dial-in server. This driver
+	  supports the original PC (ISA) boards as well as PCI, and EISA. If
+	  you have a card like this, say Y here and read the file
+	  <file:Documentation/serial/digiepca.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called epca.
+
+config MOXA_INTELLIO
+	tristate "Moxa Intellio support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	select FW_LOADER
+	help
+	  Say Y here if you have a Moxa Intellio multiport serial card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called moxa.
+
+config MOXA_SMARTIO
+	tristate "Moxa SmartIO support v. 2.0"
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+	help
+	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
+	  want to help develop a new version of this driver.
+
+	  This is upgraded (1.9.1) driver from original Moxa drivers with
+	  changes finally resulting in PCI probing.
+
+	  This driver can also be built as a module. The module will be called
+	  mxser. If you want to do that, say M here.
+
+config ISI
+	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
+	depends on SERIAL_NONSTANDARD && PCI
+	select FW_LOADER
+	help
+	  This is a driver for the Multi-Tech cards which provide several
+	  serial ports.  The driver is experimental and can currently only be
+	  built as a module. The module will be called isicom.
+	  If you want to do that, choose M here.
+
+config SYNCLINK
+	tristate "Microgate SyncLink card support"
+	depends on SERIAL_NONSTANDARD && PCI && ISA_DMA_API
+	help
+	  Provides support for the SyncLink ISA and PCI multiprotocol serial
+	  adapters. These adapters support asynchronous and HDLC bit
+	  synchronous communication up to 10Mbps (PCI adapter).
+
+	  This driver can only be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called synclink.  If you want to do that, say M
+	  here.
+
+config SYNCLINKMP
+	tristate "SyncLink Multiport support"
+	depends on SERIAL_NONSTANDARD && PCI
+	help
+	  Enable support for the SyncLink Multiport (2 or 4 ports)
+	  serial adapter, running asynchronous and HDLC communications up
+	  to 2.048Mbps. Each ports is independently selectable for
+	  RS-232, V.35, RS-449, RS-530, and X.21
+
+	  This driver may be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called synclinkmp.  If you want to do that, say M
+	  here.
+
+config SYNCLINK_GT
+	tristate "SyncLink GT/AC support"
+	depends on SERIAL_NONSTANDARD && PCI
+	help
+	  Support for SyncLink GT and SyncLink AC families of
+	  synchronous and asynchronous serial adapters
+	  manufactured by Microgate Systems, Ltd. (www.microgate.com)
+
+config RISCOM8
+	tristate "SDL RISCom/8 card support"
+	depends on SERIAL_NONSTANDARD
+	help
+	  This is a driver for the SDL Communications RISCom/8 multiport card,
+	  which gives you many serial ports. You would need something like
+	  this to connect more than two modems to your Linux box, for instance
+	  in order to become a dial-in server. If you have a card like that,
+	  say Y here and read the file <file:Documentation/serial/riscom8.txt>.
+
+	  Also it's possible to say M here and compile this driver as kernel
+	  loadable module; the module will be called riscom8.
+
+config SPECIALIX
+	tristate "Specialix IO8+ card support"
+	depends on SERIAL_NONSTANDARD
+	help
+	  This is a driver for the Specialix IO8+ multiport card (both the
+	  ISA and the PCI version) which gives you many serial ports. You
+	  would need something like this to connect more than two modems to
+	  your Linux box, for instance in order to become a dial-in server.
+
+	  If you have a card like that, say Y here and read the file
+	  <file:Documentation/serial/specialix.txt>. Also it's possible to say
+	  M here and compile this driver as kernel loadable module which will be
+	  called specialix.
+
+config SX
+	tristate "Specialix SX (and SI) card support"
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
+	help
+	  This is a driver for the SX and SI multiport serial cards.
+	  Please read the file <file:Documentation/serial/sx.txt> for details.
+
+	  This driver can only be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called sx. If you want to do that, say M here.
+
+config RIO
+	tristate "Specialix RIO system support"
+	depends on SERIAL_NONSTANDARD && BROKEN
+	help
+	  This is a driver for the Specialix RIO, a smart serial card which
+	  drives an outboard box that can support up to 128 ports.  Product
+	  information is at <http://www.perle.com/support/documentation.html#multiport>.
+	  There are both ISA and PCI versions.
+
+config RIO_OLDPCI
+	bool "Support really old RIO/PCI cards"
+	depends on RIO
+	help
+	  Older RIO PCI cards need some initialization-time configuration to
+	  determine the IRQ and some control addresses.  If you have a RIO and
+	  this doesn't seem to work, try setting this to Y.
+
+config STALDRV
+	bool "Stallion multiport serial support"
+	depends on SERIAL_NONSTANDARD
+	help
+	  Stallion cards give you many serial ports.  You would need something
+	  like this to connect more than two modems to your Linux box, for
+	  instance in order to become a dial-in server.  If you say Y here,
+	  you will be asked for your specific card model in the next
+	  questions.  Make sure to read <file:Documentation/serial/stallion.txt>
+	  in this case.  If you have never heard about all this, it's safe to
+	  say N.
+
+config STALLION
+	tristate "Stallion EasyIO or EC8/32 support"
+	depends on STALDRV && (ISA || EISA || PCI)
+	help
+	  If you have an EasyIO or EasyConnection 8/32 multiport Stallion
+	  card, then this is for you; say Y.  Make sure to read
+	  <file:Documentation/serial/stallion.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stallion.
+
+config ISTALLION
+	tristate "Stallion EC8/64, ONboard, Brumby support"
+	depends on STALDRV && (ISA || EISA || PCI)
+	help
+	  If you have an EasyConnection 8/64, ONboard, Brumby or Stallion
+	  serial multiport card, say Y here. Make sure to read
+	  <file:Documentation/serial/stallion.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called istallion.
+
+config NOZOMI
+	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
+	depends on PCI && EXPERIMENTAL
+	help
+	  If you have a HSDPA driver Broadband Wireless Data Card -
+	  Globe Trotter PCMCIA card, say Y here.
+
+	  To compile this driver as a module, choose M here, the module
+	  will be called nozomi.
+
+config A2232
+	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && ZORRO && BROKEN
+	---help---
+	  This option supports the 2232 7-port serial card shipped with the
+	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
+	  a max of 19,200 bps, the ports are served by a 6551 ACIA UART chip
+	  each, plus a 8520 CIA, and a master 6502 CPU and buffer as well. The
+	  ports were connected with 8 pin DIN connectors on the card bracket,
+	  for which 8 pin to DB25 adapters were supplied. The card also had
+	  jumpers internally to toggle various pinning configurations.
+
+	  This driver can be built as a module; but then "generic_serial"
+	  will also be built as a module. This has to be loaded before
+	  "ser_a2232". If you want to do this, answer M here.
+
+config SYNCLINK_CS
+	tristate "SyncLink PC Card support"
+	depends on PCMCIA
+	help
+	  Enable support for the SyncLink PC Card serial adapter, running
+	  asynchronous and HDLC communications up to 512Kbps. The port is
+	  selectable for RS-232, V.35, RS-449, RS-530, and X.21
+
+	  This driver may be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called synclinkmp.  If you want to do that, say M
+	  here.
+ 
+config IPWIRELESS
+	tristate "IPWireless 3G UMTS PCMCIA card support"
+	depends on PCMCIA && NETDEVICES
+	select PPP
+	help
+	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
+	  some countries (for example Czech Republic, T-Mobile ISP) this card
+	  is shipped for service called UMTS 4G.
diff --git a/drivers/tty/hw/Makefile b/drivers/tty/hw/Makefile
new file mode 100644
index 0000000..de6c412
--- /dev/null
+++ b/drivers/tty/hw/Makefile
@@ -0,0 +1,27 @@
+obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
+obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
+obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
+obj-$(CONFIG_ROCKETPORT)	+= rocket.o
+obj-$(CONFIG_SERIAL167)		+= serial167.o
+obj-$(CONFIG_CYCLADES)		+= cyclades.o
+obj-$(CONFIG_STALLION)		+= stallion.o
+obj-$(CONFIG_ISTALLION)		+= istallion.o
+obj-$(CONFIG_NOZOMI)		+= nozomi.o
+obj-$(CONFIG_DIGIEPCA)		+= epca/
+obj-$(CONFIG_SPECIALIX)		+= specialix.o
+obj-$(CONFIG_MOXA_INTELLIO)	+= moxa.o
+obj-$(CONFIG_A2232)		+= ser_a2232.o generic_serial.o
+obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
+obj-$(CONFIG_MOXA_SMARTIO)	+= mxser.o
+obj-$(CONFIG_COMPUTONE)		+= ip2/
+obj-$(CONFIG_RISCOM8)		+= riscom8.o
+obj-$(CONFIG_ISI)		+= isicom.o
+obj-$(CONFIG_SYNCLINK)		+= synclink.o
+obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
+obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
+obj-$(CONFIG_SYNCLINK_CS)	+= synclink_cs.o
+obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
+obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
+obj-$(CONFIG_SX)		+= sx.o generic_serial.o
+obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
+obj-$(CONFIG_IPWIRELESS)	+= ipwireless/
diff --git a/drivers/char/amiserial.c b/drivers/tty/hw/amiserial.c
similarity index 100%
rename from drivers/char/amiserial.c
rename to drivers/tty/hw/amiserial.c
diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/tty/hw/bfin_jtag_comm.c
similarity index 100%
rename from drivers/char/bfin_jtag_comm.c
rename to drivers/tty/hw/bfin_jtag_comm.c
diff --git a/drivers/char/cd1865.h b/drivers/tty/hw/cd1865.h
similarity index 100%
rename from drivers/char/cd1865.h
rename to drivers/tty/hw/cd1865.h
diff --git a/drivers/char/cyclades.c b/drivers/tty/hw/cyclades.c
similarity index 100%
rename from drivers/char/cyclades.c
rename to drivers/tty/hw/cyclades.c
diff --git a/drivers/tty/hw/epca/Makefile b/drivers/tty/hw/epca/Makefile
new file mode 100644
index 0000000..daa8ed8
--- /dev/null
+++ b/drivers/tty/hw/epca/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DIGIEPCA)		+= epca.o
diff --git a/drivers/char/digi1.h b/drivers/tty/hw/epca/digi1.h
similarity index 100%
rename from drivers/char/digi1.h
rename to drivers/tty/hw/epca/digi1.h
diff --git a/drivers/char/digiFep1.h b/drivers/tty/hw/epca/digiFep1.h
similarity index 100%
rename from drivers/char/digiFep1.h
rename to drivers/tty/hw/epca/digiFep1.h
diff --git a/drivers/char/digiPCI.h b/drivers/tty/hw/epca/digiPCI.h
similarity index 100%
rename from drivers/char/digiPCI.h
rename to drivers/tty/hw/epca/digiPCI.h
diff --git a/drivers/char/epca.c b/drivers/tty/hw/epca/epca.c
similarity index 100%
rename from drivers/char/epca.c
rename to drivers/tty/hw/epca/epca.c
diff --git a/drivers/char/epca.h b/drivers/tty/hw/epca/epca.h
similarity index 100%
rename from drivers/char/epca.h
rename to drivers/tty/hw/epca/epca.h
diff --git a/drivers/char/epcaconfig.h b/drivers/tty/hw/epca/epcaconfig.h
similarity index 100%
rename from drivers/char/epcaconfig.h
rename to drivers/tty/hw/epca/epcaconfig.h
diff --git a/drivers/char/generic_serial.c b/drivers/tty/hw/generic_serial.c
similarity index 100%
rename from drivers/char/generic_serial.c
rename to drivers/tty/hw/generic_serial.c
diff --git a/drivers/char/ip2/Makefile b/drivers/tty/hw/ip2/Makefile
similarity index 100%
rename from drivers/char/ip2/Makefile
rename to drivers/tty/hw/ip2/Makefile
diff --git a/drivers/char/ip2/i2cmd.c b/drivers/tty/hw/ip2/i2cmd.c
similarity index 100%
rename from drivers/char/ip2/i2cmd.c
rename to drivers/tty/hw/ip2/i2cmd.c
diff --git a/drivers/char/ip2/i2cmd.h b/drivers/tty/hw/ip2/i2cmd.h
similarity index 100%
rename from drivers/char/ip2/i2cmd.h
rename to drivers/tty/hw/ip2/i2cmd.h
diff --git a/drivers/char/ip2/i2ellis.c b/drivers/tty/hw/ip2/i2ellis.c
similarity index 100%
rename from drivers/char/ip2/i2ellis.c
rename to drivers/tty/hw/ip2/i2ellis.c
diff --git a/drivers/char/ip2/i2ellis.h b/drivers/tty/hw/ip2/i2ellis.h
similarity index 100%
rename from drivers/char/ip2/i2ellis.h
rename to drivers/tty/hw/ip2/i2ellis.h
diff --git a/drivers/char/ip2/i2hw.h b/drivers/tty/hw/ip2/i2hw.h
similarity index 100%
rename from drivers/char/ip2/i2hw.h
rename to drivers/tty/hw/ip2/i2hw.h
diff --git a/drivers/char/ip2/i2lib.c b/drivers/tty/hw/ip2/i2lib.c
similarity index 100%
rename from drivers/char/ip2/i2lib.c
rename to drivers/tty/hw/ip2/i2lib.c
diff --git a/drivers/char/ip2/i2lib.h b/drivers/tty/hw/ip2/i2lib.h
similarity index 100%
rename from drivers/char/ip2/i2lib.h
rename to drivers/tty/hw/ip2/i2lib.h
diff --git a/drivers/char/ip2/i2pack.h b/drivers/tty/hw/ip2/i2pack.h
similarity index 100%
rename from drivers/char/ip2/i2pack.h
rename to drivers/tty/hw/ip2/i2pack.h
diff --git a/drivers/char/ip2/ip2.h b/drivers/tty/hw/ip2/ip2.h
similarity index 100%
rename from drivers/char/ip2/ip2.h
rename to drivers/tty/hw/ip2/ip2.h
diff --git a/drivers/char/ip2/ip2ioctl.h b/drivers/tty/hw/ip2/ip2ioctl.h
similarity index 100%
rename from drivers/char/ip2/ip2ioctl.h
rename to drivers/tty/hw/ip2/ip2ioctl.h
diff --git a/drivers/char/ip2/ip2main.c b/drivers/tty/hw/ip2/ip2main.c
similarity index 100%
rename from drivers/char/ip2/ip2main.c
rename to drivers/tty/hw/ip2/ip2main.c
diff --git a/drivers/char/ip2/ip2trace.h b/drivers/tty/hw/ip2/ip2trace.h
similarity index 100%
rename from drivers/char/ip2/ip2trace.h
rename to drivers/tty/hw/ip2/ip2trace.h
diff --git a/drivers/char/ip2/ip2types.h b/drivers/tty/hw/ip2/ip2types.h
similarity index 100%
rename from drivers/char/ip2/ip2types.h
rename to drivers/tty/hw/ip2/ip2types.h
diff --git a/drivers/char/pcmcia/ipwireless/Makefile b/drivers/tty/hw/ipwireless/Makefile
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/Makefile
rename to drivers/tty/hw/ipwireless/Makefile
diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/tty/hw/ipwireless/hardware.c
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/hardware.c
rename to drivers/tty/hw/ipwireless/hardware.c
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/tty/hw/ipwireless/hardware.h
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/hardware.h
rename to drivers/tty/hw/ipwireless/hardware.h
diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/tty/hw/ipwireless/main.c
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/main.c
rename to drivers/tty/hw/ipwireless/main.c
diff --git a/drivers/char/pcmcia/ipwireless/main.h b/drivers/tty/hw/ipwireless/main.h
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/main.h
rename to drivers/tty/hw/ipwireless/main.h
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/tty/hw/ipwireless/network.c
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/network.c
rename to drivers/tty/hw/ipwireless/network.c
diff --git a/drivers/char/pcmcia/ipwireless/network.h b/drivers/tty/hw/ipwireless/network.h
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/network.h
rename to drivers/tty/hw/ipwireless/network.h
diff --git a/drivers/char/pcmcia/ipwireless/setup_protocol.h b/drivers/tty/hw/ipwireless/setup_protocol.h
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/setup_protocol.h
rename to drivers/tty/hw/ipwireless/setup_protocol.h
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/tty/hw/ipwireless/tty.c
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/tty.c
rename to drivers/tty/hw/ipwireless/tty.c
diff --git a/drivers/char/pcmcia/ipwireless/tty.h b/drivers/tty/hw/ipwireless/tty.h
similarity index 100%
rename from drivers/char/pcmcia/ipwireless/tty.h
rename to drivers/tty/hw/ipwireless/tty.h
diff --git a/drivers/char/isicom.c b/drivers/tty/hw/isicom.c
similarity index 100%
rename from drivers/char/isicom.c
rename to drivers/tty/hw/isicom.c
diff --git a/drivers/char/istallion.c b/drivers/tty/hw/istallion.c
similarity index 100%
rename from drivers/char/istallion.c
rename to drivers/tty/hw/istallion.c
diff --git a/drivers/char/moxa.c b/drivers/tty/hw/moxa.c
similarity index 100%
rename from drivers/char/moxa.c
rename to drivers/tty/hw/moxa.c
diff --git a/drivers/char/moxa.h b/drivers/tty/hw/moxa.h
similarity index 100%
rename from drivers/char/moxa.h
rename to drivers/tty/hw/moxa.h
diff --git a/drivers/char/mxser.c b/drivers/tty/hw/mxser.c
similarity index 100%
rename from drivers/char/mxser.c
rename to drivers/tty/hw/mxser.c
diff --git a/drivers/char/mxser.h b/drivers/tty/hw/mxser.h
similarity index 100%
rename from drivers/char/mxser.h
rename to drivers/tty/hw/mxser.h
diff --git a/drivers/char/nozomi.c b/drivers/tty/hw/nozomi.c
similarity index 100%
rename from drivers/char/nozomi.c
rename to drivers/tty/hw/nozomi.c
diff --git a/drivers/char/rio/Makefile b/drivers/tty/hw/rio/Makefile
similarity index 100%
rename from drivers/char/rio/Makefile
rename to drivers/tty/hw/rio/Makefile
diff --git a/drivers/char/rio/board.h b/drivers/tty/hw/rio/board.h
similarity index 100%
rename from drivers/char/rio/board.h
rename to drivers/tty/hw/rio/board.h
diff --git a/drivers/char/rio/cirrus.h b/drivers/tty/hw/rio/cirrus.h
similarity index 100%
rename from drivers/char/rio/cirrus.h
rename to drivers/tty/hw/rio/cirrus.h
diff --git a/drivers/char/rio/cmdblk.h b/drivers/tty/hw/rio/cmdblk.h
similarity index 100%
rename from drivers/char/rio/cmdblk.h
rename to drivers/tty/hw/rio/cmdblk.h
diff --git a/drivers/char/rio/cmdpkt.h b/drivers/tty/hw/rio/cmdpkt.h
similarity index 100%
rename from drivers/char/rio/cmdpkt.h
rename to drivers/tty/hw/rio/cmdpkt.h
diff --git a/drivers/char/rio/daemon.h b/drivers/tty/hw/rio/daemon.h
similarity index 100%
rename from drivers/char/rio/daemon.h
rename to drivers/tty/hw/rio/daemon.h
diff --git a/drivers/char/rio/errors.h b/drivers/tty/hw/rio/errors.h
similarity index 100%
rename from drivers/char/rio/errors.h
rename to drivers/tty/hw/rio/errors.h
diff --git a/drivers/char/rio/func.h b/drivers/tty/hw/rio/func.h
similarity index 100%
rename from drivers/char/rio/func.h
rename to drivers/tty/hw/rio/func.h
diff --git a/drivers/char/rio/host.h b/drivers/tty/hw/rio/host.h
similarity index 100%
rename from drivers/char/rio/host.h
rename to drivers/tty/hw/rio/host.h
diff --git a/drivers/char/rio/link.h b/drivers/tty/hw/rio/link.h
similarity index 100%
rename from drivers/char/rio/link.h
rename to drivers/tty/hw/rio/link.h
diff --git a/drivers/char/rio/linux_compat.h b/drivers/tty/hw/rio/linux_compat.h
similarity index 100%
rename from drivers/char/rio/linux_compat.h
rename to drivers/tty/hw/rio/linux_compat.h
diff --git a/drivers/char/rio/map.h b/drivers/tty/hw/rio/map.h
similarity index 100%
rename from drivers/char/rio/map.h
rename to drivers/tty/hw/rio/map.h
diff --git a/drivers/char/rio/param.h b/drivers/tty/hw/rio/param.h
similarity index 100%
rename from drivers/char/rio/param.h
rename to drivers/tty/hw/rio/param.h
diff --git a/drivers/char/rio/parmmap.h b/drivers/tty/hw/rio/parmmap.h
similarity index 100%
rename from drivers/char/rio/parmmap.h
rename to drivers/tty/hw/rio/parmmap.h
diff --git a/drivers/char/rio/pci.h b/drivers/tty/hw/rio/pci.h
similarity index 100%
rename from drivers/char/rio/pci.h
rename to drivers/tty/hw/rio/pci.h
diff --git a/drivers/char/rio/phb.h b/drivers/tty/hw/rio/phb.h
similarity index 100%
rename from drivers/char/rio/phb.h
rename to drivers/tty/hw/rio/phb.h
diff --git a/drivers/char/rio/pkt.h b/drivers/tty/hw/rio/pkt.h
similarity index 100%
rename from drivers/char/rio/pkt.h
rename to drivers/tty/hw/rio/pkt.h
diff --git a/drivers/char/rio/port.h b/drivers/tty/hw/rio/port.h
similarity index 100%
rename from drivers/char/rio/port.h
rename to drivers/tty/hw/rio/port.h
diff --git a/drivers/char/rio/protsts.h b/drivers/tty/hw/rio/protsts.h
similarity index 100%
rename from drivers/char/rio/protsts.h
rename to drivers/tty/hw/rio/protsts.h
diff --git a/drivers/char/rio/rio.h b/drivers/tty/hw/rio/rio.h
similarity index 100%
rename from drivers/char/rio/rio.h
rename to drivers/tty/hw/rio/rio.h
diff --git a/drivers/char/rio/rio_linux.c b/drivers/tty/hw/rio/rio_linux.c
similarity index 100%
rename from drivers/char/rio/rio_linux.c
rename to drivers/tty/hw/rio/rio_linux.c
diff --git a/drivers/char/rio/rio_linux.h b/drivers/tty/hw/rio/rio_linux.h
similarity index 100%
rename from drivers/char/rio/rio_linux.h
rename to drivers/tty/hw/rio/rio_linux.h
diff --git a/drivers/char/rio/rioboard.h b/drivers/tty/hw/rio/rioboard.h
similarity index 100%
rename from drivers/char/rio/rioboard.h
rename to drivers/tty/hw/rio/rioboard.h
diff --git a/drivers/char/rio/rioboot.c b/drivers/tty/hw/rio/rioboot.c
similarity index 100%
rename from drivers/char/rio/rioboot.c
rename to drivers/tty/hw/rio/rioboot.c
diff --git a/drivers/char/rio/riocmd.c b/drivers/tty/hw/rio/riocmd.c
similarity index 100%
rename from drivers/char/rio/riocmd.c
rename to drivers/tty/hw/rio/riocmd.c
diff --git a/drivers/char/rio/rioctrl.c b/drivers/tty/hw/rio/rioctrl.c
similarity index 100%
rename from drivers/char/rio/rioctrl.c
rename to drivers/tty/hw/rio/rioctrl.c
diff --git a/drivers/char/rio/riodrvr.h b/drivers/tty/hw/rio/riodrvr.h
similarity index 100%
rename from drivers/char/rio/riodrvr.h
rename to drivers/tty/hw/rio/riodrvr.h
diff --git a/drivers/char/rio/rioinfo.h b/drivers/tty/hw/rio/rioinfo.h
similarity index 100%
rename from drivers/char/rio/rioinfo.h
rename to drivers/tty/hw/rio/rioinfo.h
diff --git a/drivers/char/rio/rioinit.c b/drivers/tty/hw/rio/rioinit.c
similarity index 100%
rename from drivers/char/rio/rioinit.c
rename to drivers/tty/hw/rio/rioinit.c
diff --git a/drivers/char/rio/riointr.c b/drivers/tty/hw/rio/riointr.c
similarity index 100%
rename from drivers/char/rio/riointr.c
rename to drivers/tty/hw/rio/riointr.c
diff --git a/drivers/char/rio/rioioctl.h b/drivers/tty/hw/rio/rioioctl.h
similarity index 100%
rename from drivers/char/rio/rioioctl.h
rename to drivers/tty/hw/rio/rioioctl.h
diff --git a/drivers/char/rio/rioparam.c b/drivers/tty/hw/rio/rioparam.c
similarity index 100%
rename from drivers/char/rio/rioparam.c
rename to drivers/tty/hw/rio/rioparam.c
diff --git a/drivers/char/rio/rioroute.c b/drivers/tty/hw/rio/rioroute.c
similarity index 100%
rename from drivers/char/rio/rioroute.c
rename to drivers/tty/hw/rio/rioroute.c
diff --git a/drivers/char/rio/riospace.h b/drivers/tty/hw/rio/riospace.h
similarity index 100%
rename from drivers/char/rio/riospace.h
rename to drivers/tty/hw/rio/riospace.h
diff --git a/drivers/char/rio/riotable.c b/drivers/tty/hw/rio/riotable.c
similarity index 100%
rename from drivers/char/rio/riotable.c
rename to drivers/tty/hw/rio/riotable.c
diff --git a/drivers/char/rio/riotty.c b/drivers/tty/hw/rio/riotty.c
similarity index 100%
rename from drivers/char/rio/riotty.c
rename to drivers/tty/hw/rio/riotty.c
diff --git a/drivers/char/rio/route.h b/drivers/tty/hw/rio/route.h
similarity index 100%
rename from drivers/char/rio/route.h
rename to drivers/tty/hw/rio/route.h
diff --git a/drivers/char/rio/rup.h b/drivers/tty/hw/rio/rup.h
similarity index 100%
rename from drivers/char/rio/rup.h
rename to drivers/tty/hw/rio/rup.h
diff --git a/drivers/char/rio/unixrup.h b/drivers/tty/hw/rio/unixrup.h
similarity index 100%
rename from drivers/char/rio/unixrup.h
rename to drivers/tty/hw/rio/unixrup.h
diff --git a/drivers/char/riscom8.c b/drivers/tty/hw/riscom8.c
similarity index 100%
rename from drivers/char/riscom8.c
rename to drivers/tty/hw/riscom8.c
diff --git a/drivers/char/riscom8.h b/drivers/tty/hw/riscom8.h
similarity index 100%
rename from drivers/char/riscom8.h
rename to drivers/tty/hw/riscom8.h
diff --git a/drivers/char/riscom8_reg.h b/drivers/tty/hw/riscom8_reg.h
similarity index 100%
rename from drivers/char/riscom8_reg.h
rename to drivers/tty/hw/riscom8_reg.h
diff --git a/drivers/char/rocket.c b/drivers/tty/hw/rocket.c
similarity index 100%
rename from drivers/char/rocket.c
rename to drivers/tty/hw/rocket.c
diff --git a/drivers/char/rocket.h b/drivers/tty/hw/rocket.h
similarity index 100%
rename from drivers/char/rocket.h
rename to drivers/tty/hw/rocket.h
diff --git a/drivers/char/rocket_int.h b/drivers/tty/hw/rocket_int.h
similarity index 100%
rename from drivers/char/rocket_int.h
rename to drivers/tty/hw/rocket_int.h
diff --git a/drivers/char/ser_a2232.c b/drivers/tty/hw/ser_a2232.c
similarity index 100%
rename from drivers/char/ser_a2232.c
rename to drivers/tty/hw/ser_a2232.c
diff --git a/drivers/char/ser_a2232.h b/drivers/tty/hw/ser_a2232.h
similarity index 100%
rename from drivers/char/ser_a2232.h
rename to drivers/tty/hw/ser_a2232.h
diff --git a/drivers/char/ser_a2232fw.ax b/drivers/tty/hw/ser_a2232fw.ax
similarity index 100%
rename from drivers/char/ser_a2232fw.ax
rename to drivers/tty/hw/ser_a2232fw.ax
diff --git a/drivers/char/ser_a2232fw.h b/drivers/tty/hw/ser_a2232fw.h
similarity index 100%
rename from drivers/char/ser_a2232fw.h
rename to drivers/tty/hw/ser_a2232fw.h
diff --git a/drivers/char/serial167.c b/drivers/tty/hw/serial167.c
similarity index 100%
rename from drivers/char/serial167.c
rename to drivers/tty/hw/serial167.c
diff --git a/drivers/char/specialix.c b/drivers/tty/hw/specialix.c
similarity index 100%
rename from drivers/char/specialix.c
rename to drivers/tty/hw/specialix.c
diff --git a/drivers/char/specialix_io8.h b/drivers/tty/hw/specialix_io8.h
similarity index 100%
rename from drivers/char/specialix_io8.h
rename to drivers/tty/hw/specialix_io8.h
diff --git a/drivers/char/stallion.c b/drivers/tty/hw/stallion.c
similarity index 100%
rename from drivers/char/stallion.c
rename to drivers/tty/hw/stallion.c
diff --git a/drivers/char/sx.c b/drivers/tty/hw/sx.c
similarity index 100%
rename from drivers/char/sx.c
rename to drivers/tty/hw/sx.c
diff --git a/drivers/char/sx.h b/drivers/tty/hw/sx.h
similarity index 100%
rename from drivers/char/sx.h
rename to drivers/tty/hw/sx.h
diff --git a/drivers/char/sxboards.h b/drivers/tty/hw/sxboards.h
similarity index 100%
rename from drivers/char/sxboards.h
rename to drivers/tty/hw/sxboards.h
diff --git a/drivers/char/sxwindow.h b/drivers/tty/hw/sxwindow.h
similarity index 100%
rename from drivers/char/sxwindow.h
rename to drivers/tty/hw/sxwindow.h
diff --git a/drivers/char/synclink.c b/drivers/tty/hw/synclink.c
similarity index 100%
rename from drivers/char/synclink.c
rename to drivers/tty/hw/synclink.c
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/tty/hw/synclink_cs.c
similarity index 100%
rename from drivers/char/pcmcia/synclink_cs.c
rename to drivers/tty/hw/synclink_cs.c
diff --git a/drivers/char/synclink_gt.c b/drivers/tty/hw/synclink_gt.c
similarity index 100%
rename from drivers/char/synclink_gt.c
rename to drivers/tty/hw/synclink_gt.c
diff --git a/drivers/char/synclinkmp.c b/drivers/tty/hw/synclinkmp.c
similarity index 100%
rename from drivers/char/synclinkmp.c
rename to drivers/tty/hw/synclinkmp.c
diff --git a/drivers/char/vme_scc.c b/drivers/tty/hw/vme_scc.c
similarity index 100%
rename from drivers/char/vme_scc.c
rename to drivers/tty/hw/vme_scc.c
-- 
1.7.1

