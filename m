Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0KDWag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:30:36 -0400
Received: from kroah.org ([198.145.64.141]:35668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0KDWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:30:17 -0400
Date: Thu, 4 Nov 2010 15:30:01 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [00/01] TTY: create drivers/tty and move the tty core files there
Message-ID: <20101104223001.GB3390@kroah.com>
References: <20101104222906.GA3390@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104222906.GA3390@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

The tty code should be in its own subdirectory and not in the char
driver with all of the cruft that is currently there.

Based on work done by Arnd Bergmann <arnd@arndb.de>

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/Makefile                   |    1 +
 drivers/char/Makefile              |   11 +----------
 drivers/tty/Makefile               |    9 +++++++++
 drivers/{char => tty}/n_gsm.c      |    0
 drivers/{char => tty}/n_hdlc.c     |    0
 drivers/{char => tty}/n_r3964.c    |    0
 drivers/{char => tty}/n_tty.c      |    0
 drivers/{char => tty}/pty.c        |    0
 drivers/{char => tty}/sysrq.c      |    0
 drivers/{char => tty}/tty_audit.c  |    0
 drivers/{char => tty}/tty_buffer.c |    0
 drivers/{char => tty}/tty_io.c     |    0
 drivers/{char => tty}/tty_ioctl.c  |    0
 drivers/{char => tty}/tty_ldisc.c  |    0
 drivers/{char => tty}/tty_mutex.c  |    0
 drivers/{char => tty}/tty_port.c   |    0
 16 files changed, 11 insertions(+), 10 deletions(-)
 create mode 100644 drivers/tty/Makefile
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

diff --git a/drivers/Makefile b/drivers/Makefile
index 14cf907..f3ebb30 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_REGULATOR)		+= regulator/
 
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
+obj-y				+= tty/
 obj-y				+= char/
 
 # gpu/ comes after char for AGP vs DRM startup
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 3a9c014..f308494 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -7,19 +7,13 @@
 #
 FONTMAPFILE = cp437.uni
 
-obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
-
-obj-y				+= tty_mutex.o
-obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
-obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+obj-y				+= mem.o random.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
-obj-$(CONFIG_AUDIT)		+= tty_audit.o
-obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
@@ -41,8 +35,6 @@ obj-$(CONFIG_ISI)		+= isicom.o
 obj-$(CONFIG_SYNCLINK)		+= synclink.o
 obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
 obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
-obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
-obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
@@ -74,7 +66,6 @@ obj-$(CONFIG_PRINTER)		+= lp.o
 obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
 
 obj-$(CONFIG_DTLK)		+= dtlk.o
-obj-$(CONFIG_R3964)		+= n_r3964.o
 obj-$(CONFIG_APPLICOM)		+= applicom.o
 obj-$(CONFIG_SONYPI)		+= sonypi.o
 obj-$(CONFIG_RTC)		+= rtc.o
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
new file mode 100644
index 0000000..7f63b33
--- /dev/null
+++ b/drivers/tty/Makefile
@@ -0,0 +1,9 @@
+obj-y				+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
+				   tty_buffer.o tty_port.o tty_mutex.o
+obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
+obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+obj-$(CONFIG_AUDIT)		+= tty_audit.o
+obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
+obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
+obj-$(CONFIG_N_GSM)		+= n_gsm.o
+obj-$(CONFIG_R3964)		+= n_r3964.o
diff --git a/drivers/char/n_gsm.c b/drivers/tty/n_gsm.c
similarity index 100%
rename from drivers/char/n_gsm.c
rename to drivers/tty/n_gsm.c
diff --git a/drivers/char/n_hdlc.c b/drivers/tty/n_hdlc.c
similarity index 100%
rename from drivers/char/n_hdlc.c
rename to drivers/tty/n_hdlc.c
diff --git a/drivers/char/n_r3964.c b/drivers/tty/n_r3964.c
similarity index 100%
rename from drivers/char/n_r3964.c
rename to drivers/tty/n_r3964.c
diff --git a/drivers/char/n_tty.c b/drivers/tty/n_tty.c
similarity index 100%
rename from drivers/char/n_tty.c
rename to drivers/tty/n_tty.c
diff --git a/drivers/char/pty.c b/drivers/tty/pty.c
similarity index 100%
rename from drivers/char/pty.c
rename to drivers/tty/pty.c
diff --git a/drivers/char/sysrq.c b/drivers/tty/sysrq.c
similarity index 100%
rename from drivers/char/sysrq.c
rename to drivers/tty/sysrq.c
diff --git a/drivers/char/tty_audit.c b/drivers/tty/tty_audit.c
similarity index 100%
rename from drivers/char/tty_audit.c
rename to drivers/tty/tty_audit.c
diff --git a/drivers/char/tty_buffer.c b/drivers/tty/tty_buffer.c
similarity index 100%
rename from drivers/char/tty_buffer.c
rename to drivers/tty/tty_buffer.c
diff --git a/drivers/char/tty_io.c b/drivers/tty/tty_io.c
similarity index 100%
rename from drivers/char/tty_io.c
rename to drivers/tty/tty_io.c
diff --git a/drivers/char/tty_ioctl.c b/drivers/tty/tty_ioctl.c
similarity index 100%
rename from drivers/char/tty_ioctl.c
rename to drivers/tty/tty_ioctl.c
diff --git a/drivers/char/tty_ldisc.c b/drivers/tty/tty_ldisc.c
similarity index 100%
rename from drivers/char/tty_ldisc.c
rename to drivers/tty/tty_ldisc.c
diff --git a/drivers/char/tty_mutex.c b/drivers/tty/tty_mutex.c
similarity index 100%
rename from drivers/char/tty_mutex.c
rename to drivers/tty/tty_mutex.c
diff --git a/drivers/char/tty_port.c b/drivers/tty/tty_port.c
similarity index 100%
rename from drivers/char/tty_port.c
rename to drivers/tty/tty_port.c
-- 
1.7.3.1

