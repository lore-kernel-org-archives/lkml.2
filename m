Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2AEXW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:22:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:61763 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2AEXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:22:23 -0500
Date: Thu, 5 Jan 2012 18:21:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Alan Cox <alan@linux.intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120105232142.GA10870@windriver.com>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
 <4F04BFA8.9010100@windriver.com>
 <20120104220332.GA22985@suse.de>
 <201201042327.33739.arnd@arndb.de>
 <20120105054240.GA9093@merkur.ravnborg.org>
 <20120105124505.73c88f2c@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120105124505.73c88f2c@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] serial: relocate remaining serial drivers from tty/ to tty/serial/] On 05/01/2012 (Thu 12:45) Alan Cox wrote:

> > drivers/tty/serial_core  <= drivers based on SERIAL_CORE
> > drivers/tty/serial       <= the rest
> > 
> > This makes it obvious that one directory is for drivers based on
> > SERIAL_CORE - and the other is sort of the "rest".
> > 
> > I know this imply moving files around again :-(
> 
> And putting one lot where the other were. Merge time is closed so we've
> got plenty of time to sort this right. For the moment can we just tidy
> up 8250, then think about it in more detail rather than play musical
> chairs ?

Presumably too late for 3.3, but I figured I'd send the 8250 tidy up
for review while the discussion was still fresh in everyone's mind.

Note that this patch is based on Greg's tty-next branch in:

   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git

since we need to move the 8250_fsl driver as well, which at the moment
only exists there.  Tested with serial console on x86-32.

Paul.
---

>From 742ad14382126ae26cf7472f5ec5556646d8bb20 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 4 Jan 2012 20:04:42 -0500
Subject: [PATCH] serial: group all the 8250 related code together

The drivers/tty/serial dir is already getting rather busy.
Relocate the 8250 related drivers to their own subdir to
reduce the clutter.

Note that sunsu.c is not included in this move -- it is
8250-like hardware, but it does not use any of the existing
infrastructure -- and does not depend on SERIAL_8250.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/serial/{ => 8250}/8250.c               |    0
 drivers/tty/serial/{ => 8250}/8250.h               |    0
 drivers/tty/serial/{ => 8250}/8250_accent.c        |    0
 drivers/tty/serial/{ => 8250}/8250_acorn.c         |    0
 drivers/tty/serial/{ => 8250}/8250_boca.c          |    0
 drivers/tty/serial/{ => 8250}/8250_dw.c            |    0
 drivers/tty/serial/{ => 8250}/8250_early.c         |    0
 drivers/tty/serial/{ => 8250}/8250_exar_st16c554.c |    0
 drivers/tty/serial/{ => 8250}/8250_fourport.c      |    0
 drivers/tty/serial/{ => 8250}/8250_fsl.c           |    0
 drivers/tty/serial/{ => 8250}/8250_gsc.c           |    0
 drivers/tty/serial/{ => 8250}/8250_hp300.c         |    0
 drivers/tty/serial/{ => 8250}/8250_hub6.c          |    0
 drivers/tty/serial/{ => 8250}/8250_mca.c           |    0
 drivers/tty/serial/{ => 8250}/8250_pci.c           |    0
 drivers/tty/serial/{ => 8250}/8250_pnp.c           |    0
 drivers/tty/serial/8250/Kconfig                    |  280 ++++++++++++++++++++
 drivers/tty/serial/8250/Makefile                   |   20 ++
 drivers/tty/serial/{ => 8250}/m32r_sio.c           |    0
 drivers/tty/serial/{ => 8250}/m32r_sio.h           |    0
 drivers/tty/serial/{ => 8250}/m32r_sio_reg.h       |    0
 drivers/tty/serial/{ => 8250}/serial_cs.c          |    0
 drivers/tty/serial/Kconfig                         |  274 +-------------------
 drivers/tty/serial/Makefile                        |   19 +--
 24 files changed, 304 insertions(+), 289 deletions(-)
 rename drivers/tty/serial/{ => 8250}/8250.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250.h (100%)
 rename drivers/tty/serial/{ => 8250}/8250_accent.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_acorn.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_boca.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_dw.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_early.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_exar_st16c554.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_fourport.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_fsl.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_gsc.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_hp300.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_hub6.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_mca.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_pci.c (100%)
 rename drivers/tty/serial/{ => 8250}/8250_pnp.c (100%)
 create mode 100644 drivers/tty/serial/8250/Kconfig
 create mode 100644 drivers/tty/serial/8250/Makefile
 rename drivers/tty/serial/{ => 8250}/m32r_sio.c (100%)
 rename drivers/tty/serial/{ => 8250}/m32r_sio.h (100%)
 rename drivers/tty/serial/{ => 8250}/m32r_sio_reg.h (100%)
 rename drivers/tty/serial/{ => 8250}/serial_cs.c (100%)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250/8250.c
similarity index 100%
rename from drivers/tty/serial/8250.c
rename to drivers/tty/serial/8250/8250.c
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250/8250.h
similarity index 100%
rename from drivers/tty/serial/8250.h
rename to drivers/tty/serial/8250/8250.h
diff --git a/drivers/tty/serial/8250_accent.c b/drivers/tty/serial/8250/8250_accent.c
similarity index 100%
rename from drivers/tty/serial/8250_accent.c
rename to drivers/tty/serial/8250/8250_accent.c
diff --git a/drivers/tty/serial/8250_acorn.c b/drivers/tty/serial/8250/8250_acorn.c
similarity index 100%
rename from drivers/tty/serial/8250_acorn.c
rename to drivers/tty/serial/8250/8250_acorn.c
diff --git a/drivers/tty/serial/8250_boca.c b/drivers/tty/serial/8250/8250_boca.c
similarity index 100%
rename from drivers/tty/serial/8250_boca.c
rename to drivers/tty/serial/8250/8250_boca.c
diff --git a/drivers/tty/serial/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
similarity index 100%
rename from drivers/tty/serial/8250_dw.c
rename to drivers/tty/serial/8250/8250_dw.c
diff --git a/drivers/tty/serial/8250_early.c b/drivers/tty/serial/8250/8250_early.c
similarity index 100%
rename from drivers/tty/serial/8250_early.c
rename to drivers/tty/serial/8250/8250_early.c
diff --git a/drivers/tty/serial/8250_exar_st16c554.c b/drivers/tty/serial/8250/8250_exar_st16c554.c
similarity index 100%
rename from drivers/tty/serial/8250_exar_st16c554.c
rename to drivers/tty/serial/8250/8250_exar_st16c554.c
diff --git a/drivers/tty/serial/8250_fourport.c b/drivers/tty/serial/8250/8250_fourport.c
similarity index 100%
rename from drivers/tty/serial/8250_fourport.c
rename to drivers/tty/serial/8250/8250_fourport.c
diff --git a/drivers/tty/serial/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
similarity index 100%
rename from drivers/tty/serial/8250_fsl.c
rename to drivers/tty/serial/8250/8250_fsl.c
diff --git a/drivers/tty/serial/8250_gsc.c b/drivers/tty/serial/8250/8250_gsc.c
similarity index 100%
rename from drivers/tty/serial/8250_gsc.c
rename to drivers/tty/serial/8250/8250_gsc.c
diff --git a/drivers/tty/serial/8250_hp300.c b/drivers/tty/serial/8250/8250_hp300.c
similarity index 100%
rename from drivers/tty/serial/8250_hp300.c
rename to drivers/tty/serial/8250/8250_hp300.c
diff --git a/drivers/tty/serial/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
similarity index 100%
rename from drivers/tty/serial/8250_hub6.c
rename to drivers/tty/serial/8250/8250_hub6.c
diff --git a/drivers/tty/serial/8250_mca.c b/drivers/tty/serial/8250/8250_mca.c
similarity index 100%
rename from drivers/tty/serial/8250_mca.c
rename to drivers/tty/serial/8250/8250_mca.c
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
similarity index 100%
rename from drivers/tty/serial/8250_pci.c
rename to drivers/tty/serial/8250/8250_pci.c
diff --git a/drivers/tty/serial/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
similarity index 100%
rename from drivers/tty/serial/8250_pnp.c
rename to drivers/tty/serial/8250/8250_pnp.c
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
new file mode 100644
index 0000000..591f801
--- /dev/null
+++ b/drivers/tty/serial/8250/Kconfig
@@ -0,0 +1,280 @@
+#
+# The 8250/16550 serial drivers.  You shouldn't be in this list unless
+# you somehow have an implicit or explicit dependency on SERIAL_8250.
+#
+
+config SERIAL_8250
+	tristate "8250/16550 and compatible serial support"
+	select SERIAL_CORE
+	---help---
+	  This selects whether you want to include the driver for the standard
+	  serial ports.  The standard answer is Y.  People who might say N
+	  here are those that are setting up dedicated Ethernet WWW/FTP
+	  servers, or users that have one of the various bus mice instead of a
+	  serial mouse and don't intend to use their machine's standard serial
+	  port for anything.  (Note that the Cyclades and Stallion multi
+	  serial port drivers do not need this driver built in for them to
+	  work.)
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called 8250.
+	  [WARNING: Do not compile this driver as a module if you are using
+	  non-standard serial ports, since the configuration information will
+	  be lost when the driver is unloaded.  This limitation may be lifted
+	  in the future.]
+
+	  BTW1: If you have a mouseman serial mouse which is not recognized by
+	  the X window system, try running gpm first.
+
+	  BTW2: If you intend to use a software modem (also called Winmodem)
+	  under Linux, forget it.  These modems are crippled and require
+	  proprietary drivers which are only available under Windows.
+
+	  Most people will say Y or M here, so that they can use serial mice,
+	  modems and similar devices connecting to the standard serial ports.
+
+config SERIAL_8250_CONSOLE
+	bool "Console on 8250/16550 and compatible serial port"
+	depends on SERIAL_8250=y
+	select SERIAL_CORE_CONSOLE
+	---help---
+	  If you say Y here, it will be possible to use a serial port as the
+	  system console (the system console is the device which receives all
+	  kernel messages and warnings and which allows logins in single user
+	  mode). This could be useful if some terminal or printer is connected
+	  to that serial port.
+
+	  Even if you say Y here, the currently visible virtual console
+	  (/dev/tty0) will still be used as the system console by default, but
+	  you can alter that using a kernel command line option such as
+	  "console=ttyS1". (Try "man bootparam" or see the documentation of
+	  your boot loader (grub or lilo or loadlin) about how to pass options
+	  to the kernel at boot time.)
+
+	  If you don't have a VGA card installed and you say Y here, the
+	  kernel will automatically use the first serial line, /dev/ttyS0, as
+	  system console.
+
+	  You can set that using a kernel command line option such as
+	  "console=uart8250,io,0x3f8,9600n8"
+	  "console=uart8250,mmio,0xff5e0000,115200n8".
+	  and it will switch to normal serial console when the corresponding
+	  port is ready.
+	  "earlycon=uart8250,io,0x3f8,9600n8"
+	  "earlycon=uart8250,mmio,0xff5e0000,115200n8".
+	  it will not only setup early console.
+
+	  If unsure, say N.
+
+config FIX_EARLYCON_MEM
+	bool
+	depends on X86
+	default y
+
+config SERIAL_8250_GSC
+	tristate
+	depends on SERIAL_8250 && GSC
+	default SERIAL_8250
+
+config SERIAL_8250_PCI
+	tristate "8250/16550 PCI device support" if EXPERT
+	depends on SERIAL_8250 && PCI
+	default SERIAL_8250
+	help
+	  This builds standard PCI serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
+	  Saves about 9K.
+
+config SERIAL_8250_PNP
+	tristate "8250/16550 PNP device support" if EXPERT
+	depends on SERIAL_8250 && PNP
+	default SERIAL_8250
+	help
+	  This builds standard PNP serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
+
+config SERIAL_8250_HP300
+	tristate
+	depends on SERIAL_8250 && HP300
+	default SERIAL_8250
+
+config SERIAL_8250_CS
+	tristate "8250/16550 PCMCIA device support"
+	depends on PCMCIA && SERIAL_8250
+	---help---
+	  Say Y here to enable support for 16-bit PCMCIA serial devices,
+	  including serial port cards, modems, and the modem functions of
+	  multi-function Ethernet/modem cards. (PCMCIA- or PC-cards are
+	  credit-card size devices often used with laptops.)
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called serial_cs.
+
+	  If unsure, say N.
+
+config SERIAL_8250_NR_UARTS
+	int "Maximum number of 8250/16550 serial ports"
+	depends on SERIAL_8250
+	default "4"
+	help
+	  Set this to the number of serial ports you want the driver
+	  to support.  This includes any ports discovered via ACPI or
+	  PCI enumeration and any ports that may be added at run-time
+	  via hot-plug, or any ISA multi-port serial cards.
+
+config SERIAL_8250_RUNTIME_UARTS
+	int "Number of 8250/16550 serial ports to register at runtime"
+	depends on SERIAL_8250
+	range 0 SERIAL_8250_NR_UARTS
+	default "4"
+	help
+	  Set this to the maximum number of serial ports you want
+	  the kernel to register at boot time.  This can be overridden
+	  with the module parameter "nr_uarts", or boot-time parameter
+	  8250.nr_uarts
+
+config SERIAL_8250_EXTENDED
+	bool "Extended 8250/16550 serial driver options"
+	depends on SERIAL_8250
+	help
+	  If you wish to use any non-standard features of the standard "dumb"
+	  driver, say Y here. This includes HUB6 support, shared serial
+	  interrupts, special multiport support, support for more than the
+	  four COM 1/2/3/4 boards, etc.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about serial driver options. If unsure, say N.
+
+config SERIAL_8250_MANY_PORTS
+	bool "Support more than 4 legacy serial ports"
+	depends on SERIAL_8250_EXTENDED && !IA64
+	help
+	  Say Y here if you have dumb serial boards other than the four
+	  standard COM 1/2/3/4 ports. This may happen if you have an AST
+	  FourPort, Accent Async, Boca (read the Boca mini-HOWTO, available
+	  from <http://www.tldp.org/docs.html#howto>), or other custom
+	  serial port hardware which acts similar to standard serial port
+	  hardware. If you only use the standard COM 1/2/3/4 ports, you can
+	  say N here to save some memory. You can also say Y if you have an
+	  "intelligent" multiport card such as Cyclades, Digiboards, etc.
+
+#
+# Multi-port serial cards
+#
+
+config SERIAL_8250_FOURPORT
+	tristate "Support Fourport cards"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  Say Y here if you have an AST FourPort serial board.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_fourport.
+
+config SERIAL_8250_ACCENT
+	tristate "Support Accent cards"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  Say Y here if you have an Accent Async serial board.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_accent.
+
+config SERIAL_8250_BOCA
+	tristate "Support Boca cards"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  Say Y here if you have a Boca serial board.  Please read the Boca
+	  mini-HOWTO, available from <http://www.tldp.org/docs.html#howto>
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_boca.
+
+config SERIAL_8250_EXAR_ST16C554
+	tristate "Support Exar ST16C554/554D Quad UART"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  The Uplogix Envoy TU301 uses this Exar Quad UART.  If you are
+	  tinkering with your Envoy TU301, or have a machine with this UART,
+	  say Y here.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_exar_st16c554.
+
+config SERIAL_8250_HUB6
+	tristate "Support Hub6 cards"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  Say Y here if you have a HUB6 serial board.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_hub6.
+
+#
+# Misc. options/drivers.
+#
+
+config SERIAL_8250_SHARE_IRQ
+	bool "Support for sharing serial interrupts"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Some serial boards have hardware support which allows multiple dumb
+	  serial ports on the same board to share a single IRQ. To enable
+	  support for this in the serial driver, say Y here.
+
+config SERIAL_8250_DETECT_IRQ
+	bool "Autodetect IRQ on standard ports (unsafe)"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Say Y here if you want the kernel to try to guess which IRQ
+	  to use for your serial port.
+
+	  This is considered unsafe; it is far better to configure the IRQ in
+	  a boot script using the setserial command.
+
+	  If unsure, say N.
+
+config SERIAL_8250_RSA
+	bool "Support RSA serial ports"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  ::: To be written :::
+
+config SERIAL_8250_MCA
+	tristate "Support 8250-type ports on MCA buses"
+	depends on SERIAL_8250 != n && MCA
+	help
+	  Say Y here if you have a MCA serial ports.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_mca.
+
+config SERIAL_8250_ACORN
+	tristate "Acorn expansion card serial port support"
+	depends on ARCH_ACORN && SERIAL_8250
+	help
+	  If you have an Atomwide Serial card or Serial Port card for an Acorn
+	  system, say Y to this option.  The driver can handle 1, 2, or 3 port
+	  cards.  If unsure, say N.
+
+config SERIAL_8250_RM9K
+	bool "Support for MIPS RM9xxx integrated serial port"
+	depends on SERIAL_8250 != n && SERIAL_RM9000
+	select SERIAL_8250_SHARE_IRQ
+	help
+	  Selecting this option will add support for the integrated serial
+	  port hardware found on MIPS RM9122 and similar processors.
+	  If unsure, say N.
+
+config SERIAL_8250_FSL
+	bool
+	depends on SERIAL_8250_CONSOLE && PPC_UDBG_16550
+	default PPC
+
+config SERIAL_8250_DW
+	tristate "Support for Synopsys DesignWare 8250 quirks"
+	depends on SERIAL_8250 && OF
+	help
+	  Selecting this option will enable handling of the extra features
+	  present in the Synopsys DesignWare APB UART.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
new file mode 100644
index 0000000..867bba7
--- /dev/null
+++ b/drivers/tty/serial/8250/Makefile
@@ -0,0 +1,20 @@
+#
+# Makefile for the 8250 serial device drivers.
+#
+
+obj-$(CONFIG_SERIAL_8250)		+= 8250.o
+obj-$(CONFIG_SERIAL_8250_PNP)		+= 8250_pnp.o
+obj-$(CONFIG_SERIAL_8250_GSC)		+= 8250_gsc.o
+obj-$(CONFIG_SERIAL_8250_PCI)		+= 8250_pci.o
+obj-$(CONFIG_SERIAL_8250_HP300)		+= 8250_hp300.o
+obj-$(CONFIG_SERIAL_8250_CS)		+= serial_cs.o
+obj-$(CONFIG_SERIAL_8250_ACORN)		+= 8250_acorn.o
+obj-$(CONFIG_SERIAL_8250_CONSOLE)	+= 8250_early.o
+obj-$(CONFIG_SERIAL_8250_FOURPORT)	+= 8250_fourport.o
+obj-$(CONFIG_SERIAL_8250_ACCENT)	+= 8250_accent.o
+obj-$(CONFIG_SERIAL_8250_BOCA)		+= 8250_boca.o
+obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554)	+= 8250_exar_st16c554.o
+obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
+obj-$(CONFIG_SERIAL_8250_MCA)		+= 8250_mca.o
+obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
+obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/8250/m32r_sio.c
similarity index 100%
rename from drivers/tty/serial/m32r_sio.c
rename to drivers/tty/serial/8250/m32r_sio.c
diff --git a/drivers/tty/serial/m32r_sio.h b/drivers/tty/serial/8250/m32r_sio.h
similarity index 100%
rename from drivers/tty/serial/m32r_sio.h
rename to drivers/tty/serial/8250/m32r_sio.h
diff --git a/drivers/tty/serial/m32r_sio_reg.h b/drivers/tty/serial/8250/m32r_sio_reg.h
similarity index 100%
rename from drivers/tty/serial/m32r_sio_reg.h
rename to drivers/tty/serial/8250/m32r_sio_reg.h
diff --git a/drivers/tty/serial/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
similarity index 100%
rename from drivers/tty/serial/serial_cs.c
rename to drivers/tty/serial/8250/serial_cs.c
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index d1e4f20..7ef5603 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -5,279 +5,7 @@
 menu "Serial drivers"
 	depends on HAS_IOMEM
 
-#
-# The new 8250/16550 serial drivers
-config SERIAL_8250
-	tristate "8250/16550 and compatible serial support"
-	select SERIAL_CORE
-	---help---
-	  This selects whether you want to include the driver for the standard
-	  serial ports.  The standard answer is Y.  People who might say N
-	  here are those that are setting up dedicated Ethernet WWW/FTP
-	  servers, or users that have one of the various bus mice instead of a
-	  serial mouse and don't intend to use their machine's standard serial
-	  port for anything.  (Note that the Cyclades and Stallion multi
-	  serial port drivers do not need this driver built in for them to
-	  work.)
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called 8250.
-	  [WARNING: Do not compile this driver as a module if you are using
-	  non-standard serial ports, since the configuration information will
-	  be lost when the driver is unloaded.  This limitation may be lifted
-	  in the future.]
-
-	  BTW1: If you have a mouseman serial mouse which is not recognized by
-	  the X window system, try running gpm first.
-
-	  BTW2: If you intend to use a software modem (also called Winmodem)
-	  under Linux, forget it.  These modems are crippled and require
-	  proprietary drivers which are only available under Windows.
-
-	  Most people will say Y or M here, so that they can use serial mice,
-	  modems and similar devices connecting to the standard serial ports.
-
-config SERIAL_8250_CONSOLE
-	bool "Console on 8250/16550 and compatible serial port"
-	depends on SERIAL_8250=y
-	select SERIAL_CORE_CONSOLE
-	---help---
-	  If you say Y here, it will be possible to use a serial port as the
-	  system console (the system console is the device which receives all
-	  kernel messages and warnings and which allows logins in single user
-	  mode). This could be useful if some terminal or printer is connected
-	  to that serial port.
-
-	  Even if you say Y here, the currently visible virtual console
-	  (/dev/tty0) will still be used as the system console by default, but
-	  you can alter that using a kernel command line option such as
-	  "console=ttyS1". (Try "man bootparam" or see the documentation of
-	  your boot loader (grub or lilo or loadlin) about how to pass options
-	  to the kernel at boot time.)
-
-	  If you don't have a VGA card installed and you say Y here, the
-	  kernel will automatically use the first serial line, /dev/ttyS0, as
-	  system console.
-
-	  You can set that using a kernel command line option such as
-	  "console=uart8250,io,0x3f8,9600n8"
-	  "console=uart8250,mmio,0xff5e0000,115200n8".
-	  and it will switch to normal serial console when the corresponding 
-	  port is ready.
-	  "earlycon=uart8250,io,0x3f8,9600n8"
-	  "earlycon=uart8250,mmio,0xff5e0000,115200n8".
-	  it will not only setup early console.
-
-	  If unsure, say N.
-
-config FIX_EARLYCON_MEM
-	bool
-	depends on X86
-	default y
-
-config SERIAL_8250_GSC
-	tristate
-	depends on SERIAL_8250 && GSC
-	default SERIAL_8250
-
-config SERIAL_8250_PCI
-	tristate "8250/16550 PCI device support" if EXPERT
-	depends on SERIAL_8250 && PCI
-	default SERIAL_8250
-	help
-	  This builds standard PCI serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
-	  Saves about 9K.
-
-config SERIAL_8250_PNP
-	tristate "8250/16550 PNP device support" if EXPERT
-	depends on SERIAL_8250 && PNP
-	default SERIAL_8250
-	help
-	  This builds standard PNP serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
-
-config SERIAL_8250_FSL
-	bool
-	depends on SERIAL_8250_CONSOLE && PPC_UDBG_16550
-	default PPC
-
-config SERIAL_8250_HP300
-	tristate
-	depends on SERIAL_8250 && HP300
-	default SERIAL_8250
-
-config SERIAL_8250_CS
-	tristate "8250/16550 PCMCIA device support"
-	depends on PCMCIA && SERIAL_8250
-	---help---
-	  Say Y here to enable support for 16-bit PCMCIA serial devices,
-	  including serial port cards, modems, and the modem functions of
-	  multi-function Ethernet/modem cards. (PCMCIA- or PC-cards are
-	  credit-card size devices often used with laptops.)
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called serial_cs.
-
-	  If unsure, say N.
-
-config SERIAL_8250_NR_UARTS
-	int "Maximum number of 8250/16550 serial ports"
-	depends on SERIAL_8250
-	default "4"
-	help
-	  Set this to the number of serial ports you want the driver
-	  to support.  This includes any ports discovered via ACPI or
-	  PCI enumeration and any ports that may be added at run-time
-	  via hot-plug, or any ISA multi-port serial cards.
-
-config SERIAL_8250_RUNTIME_UARTS
-	int "Number of 8250/16550 serial ports to register at runtime"
-	depends on SERIAL_8250
-	range 0 SERIAL_8250_NR_UARTS
-	default "4"
-	help
-	  Set this to the maximum number of serial ports you want
-	  the kernel to register at boot time.  This can be overridden
-	  with the module parameter "nr_uarts", or boot-time parameter
-	  8250.nr_uarts
-
-config SERIAL_8250_EXTENDED
-	bool "Extended 8250/16550 serial driver options"
-	depends on SERIAL_8250
-	help
-	  If you wish to use any non-standard features of the standard "dumb"
-	  driver, say Y here. This includes HUB6 support, shared serial
-	  interrupts, special multiport support, support for more than the
-	  four COM 1/2/3/4 boards, etc.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about serial driver options. If unsure, say N.
-
-config SERIAL_8250_MANY_PORTS
-	bool "Support more than 4 legacy serial ports"
-	depends on SERIAL_8250_EXTENDED && !IA64
-	help
-	  Say Y here if you have dumb serial boards other than the four
-	  standard COM 1/2/3/4 ports. This may happen if you have an AST
-	  FourPort, Accent Async, Boca (read the Boca mini-HOWTO, available
-	  from <http://www.tldp.org/docs.html#howto>), or other custom
-	  serial port hardware which acts similar to standard serial port
-	  hardware. If you only use the standard COM 1/2/3/4 ports, you can
-	  say N here to save some memory. You can also say Y if you have an
-	  "intelligent" multiport card such as Cyclades, Digiboards, etc.
-
-#
-# Multi-port serial cards
-#
-
-config SERIAL_8250_FOURPORT
-	tristate "Support Fourport cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
-	help
-	  Say Y here if you have an AST FourPort serial board.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_fourport.
-
-config SERIAL_8250_ACCENT
-	tristate "Support Accent cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
-	help
-	  Say Y here if you have an Accent Async serial board.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_accent.
-
-config SERIAL_8250_BOCA
-	tristate "Support Boca cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
-	help
-	  Say Y here if you have a Boca serial board.  Please read the Boca
-	  mini-HOWTO, available from <http://www.tldp.org/docs.html#howto>
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_boca.
-
-config SERIAL_8250_EXAR_ST16C554
-	tristate "Support Exar ST16C554/554D Quad UART"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
-	help
-	  The Uplogix Envoy TU301 uses this Exar Quad UART.  If you are
-	  tinkering with your Envoy TU301, or have a machine with this UART,
-	  say Y here.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_exar_st16c554.
-
-config SERIAL_8250_HUB6
-	tristate "Support Hub6 cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
-	help
-	  Say Y here if you have a HUB6 serial board.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_hub6.
-
-config SERIAL_8250_SHARE_IRQ
-	bool "Support for sharing serial interrupts"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  Some serial boards have hardware support which allows multiple dumb
-	  serial ports on the same board to share a single IRQ. To enable
-	  support for this in the serial driver, say Y here.
-
-config SERIAL_8250_DETECT_IRQ
-	bool "Autodetect IRQ on standard ports (unsafe)"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  Say Y here if you want the kernel to try to guess which IRQ
-	  to use for your serial port.
-
-	  This is considered unsafe; it is far better to configure the IRQ in
-	  a boot script using the setserial command.
-
-	  If unsure, say N.
-
-config SERIAL_8250_RSA
-	bool "Support RSA serial ports"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  ::: To be written :::
-
-config SERIAL_8250_MCA
-	tristate "Support 8250-type ports on MCA buses"
-	depends on SERIAL_8250 != n && MCA
-	help
-	  Say Y here if you have a MCA serial ports.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_mca.
-
-config SERIAL_8250_ACORN
-	tristate "Acorn expansion card serial port support"
-	depends on ARCH_ACORN && SERIAL_8250
-	help
-	  If you have an Atomwide Serial card or Serial Port card for an Acorn
-	  system, say Y to this option.  The driver can handle 1, 2, or 3 port
-	  cards.  If unsure, say N.
-
-config SERIAL_8250_RM9K
-	bool "Support for MIPS RM9xxx integrated serial port"
-	depends on SERIAL_8250 != n && SERIAL_RM9000
-	select SERIAL_8250_SHARE_IRQ
-	help
-	  Selecting this option will add support for the integrated serial
-	  port hardware found on MIPS RM9122 and similar processors.
-	  If unsure, say N.
-
-config SERIAL_8250_DW
-	tristate "Support for Synopsys DesignWare 8250 quirks"
-	depends on SERIAL_8250 && OF
-	help
-	  Selecting this option will enable handling of the extra features
-	  present in the Synopsys DesignWare APB UART.
+source "drivers/tty/serial/8250/Kconfig"
 
 comment "Non-8250 serial port support"
 
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 75eadb8..ee3a293 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -14,22 +14,9 @@ obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
 obj-$(CONFIG_SERIAL_SUNSU) += sunsu.o
 obj-$(CONFIG_SERIAL_SUNSAB) += sunsab.o
 
-obj-$(CONFIG_SERIAL_8250) += 8250.o
-obj-$(CONFIG_SERIAL_8250_PNP) += 8250_pnp.o
-obj-$(CONFIG_SERIAL_8250_GSC) += 8250_gsc.o
-obj-$(CONFIG_SERIAL_8250_PCI) += 8250_pci.o
-obj-$(CONFIG_SERIAL_8250_HP300) += 8250_hp300.o
-obj-$(CONFIG_SERIAL_8250_CS) += serial_cs.o
-obj-$(CONFIG_SERIAL_8250_ACORN) += 8250_acorn.o
-obj-$(CONFIG_SERIAL_8250_CONSOLE) += 8250_early.o
-obj-$(CONFIG_SERIAL_8250_FOURPORT) += 8250_fourport.o
-obj-$(CONFIG_SERIAL_8250_ACCENT) += 8250_accent.o
-obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_boca.o
-obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
-obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
-obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
-obj-$(CONFIG_SERIAL_8250_FSL) += 8250_fsl.o
-obj-$(CONFIG_SERIAL_8250_DW) += 8250_dw.o
+# Now bring in any enabled 8250/16450/16550 type drivers.
+obj-$(CONFIG_SERIAL_8250) += 8250/
+
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
-- 
1.7.7
