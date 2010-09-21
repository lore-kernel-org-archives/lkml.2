Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0IUXIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:08:38 -0400
Received: from kroah.org ([198.145.64.141]:34999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab0IUXIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:08:36 -0400
Date: Tue, 21 Sep 2010 16:08:04 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] TTY: create /tty and move the tty core files there
Message-ID: <20100921230804.GB32346@kroah.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <20100830184737.GA21339@suse.de>
 <201008302333.22447.arnd@arndb.de>
 <201009031729.58102.arnd@arndb.de>
 <20100921230733.GA32346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921230733.GA32346@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty code should be at the root of the tree, as everyone
needs it, and it's always built, and it's not really a "driver"

Based on work done by Arnd Bergmann <arnd@arndb.de>

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Makefile                           |    2 +-
 drivers/char/Makefile              |    4 +---
 tty/Makefile                       |    8 ++++++++
 {drivers/char => tty}/n_tty.c      |    0
 {drivers/char => tty}/tty_audit.c  |    0
 {drivers/char => tty}/tty_buffer.c |    0
 {drivers/char => tty}/tty_io.c     |    0
 {drivers/char => tty}/tty_ioctl.c  |    0
 {drivers/char => tty}/tty_ldisc.c  |    0
 {drivers/char => tty}/tty_mutex.c  |    0
 {drivers/char => tty}/tty_port.c   |    0
 11 files changed, 10 insertions(+), 4 deletions(-)
 create mode 100644 tty/Makefile
 rename {drivers/char => tty}/n_tty.c (100%)
 rename {drivers/char => tty}/tty_audit.c (100%)
 rename {drivers/char => tty}/tty_buffer.c (100%)
 rename {drivers/char => tty}/tty_io.c (100%)
 rename {drivers/char => tty}/tty_ioctl.c (100%)
 rename {drivers/char => tty}/tty_ldisc.c (100%)
 rename {drivers/char => tty}/tty_mutex.c (100%)
 rename {drivers/char => tty}/tty_port.c (100%)

diff --git a/Makefile b/Makefile
index 3133a57..0867819 100644
--- a/Makefile
+++ b/Makefile
@@ -483,7 +483,7 @@ scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/ firmware/
+drivers-y	:= tty/ drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index dc96416..c999eac 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -7,9 +7,8 @@
 #
 FONTMAPFILE = cp437.uni
 
-obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
+obj-y	 += mem.o random.o
 
-obj-y				+= tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
@@ -17,7 +16,6 @@ obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
-obj-$(CONFIG_AUDIT)		+= tty_audit.o
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
diff --git a/tty/Makefile b/tty/Makefile
new file mode 100644
index 0000000..3862838
--- /dev/null
+++ b/tty/Makefile
@@ -0,0 +1,8 @@
+obj-y				+= tty_io.o
+obj-y				+= n_tty.o
+obj-y				+= tty_ioctl.o
+obj-y				+= tty_ldisc.o
+obj-y				+= tty_buffer.o
+obj-y				+= tty_port.o
+obj-y				+= tty_mutex.o
+obj-$(CONFIG_AUDIT)		+= tty_audit.o
diff --git a/drivers/char/n_tty.c b/tty/n_tty.c
similarity index 100%
rename from drivers/char/n_tty.c
rename to tty/n_tty.c
diff --git a/drivers/char/tty_audit.c b/tty/tty_audit.c
similarity index 100%
rename from drivers/char/tty_audit.c
rename to tty/tty_audit.c
diff --git a/drivers/char/tty_buffer.c b/tty/tty_buffer.c
similarity index 100%
rename from drivers/char/tty_buffer.c
rename to tty/tty_buffer.c
diff --git a/drivers/char/tty_io.c b/tty/tty_io.c
similarity index 100%
rename from drivers/char/tty_io.c
rename to tty/tty_io.c
diff --git a/drivers/char/tty_ioctl.c b/tty/tty_ioctl.c
similarity index 100%
rename from drivers/char/tty_ioctl.c
rename to tty/tty_ioctl.c
diff --git a/drivers/char/tty_ldisc.c b/tty/tty_ldisc.c
similarity index 100%
rename from drivers/char/tty_ldisc.c
rename to tty/tty_ldisc.c
diff --git a/drivers/char/tty_mutex.c b/tty/tty_mutex.c
similarity index 100%
rename from drivers/char/tty_mutex.c
rename to tty/tty_mutex.c
diff --git a/drivers/char/tty_port.c b/tty/tty_port.c
similarity index 100%
rename from drivers/char/tty_port.c
rename to tty/tty_port.c
-- 
1.7.1

