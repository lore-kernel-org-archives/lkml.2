Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1HRTO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:14:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48437 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1HRTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:13:01 -0400
Date: Thu, 18 Aug 2011 20:13:00 +0100
To: richard@nod.at
Subject: Subject: [PATCH 84/91] um: clean Kconfig up a bit
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu81U-00087z-1U@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* kill duplicates with drivers/char/Kconfig
* take watchdog one into drivers/watchdog/Kconfig
* take mmapper to arch/um/Kconfig.um
* rename Kconfig.char menu to "UML Character Devices"

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Kconfig.char           |  114 +---------------------------------------
 arch/um/Kconfig.um             |    6 ++
 drivers/char/hw_random/Kconfig |   15 +++++
 drivers/watchdog/Kconfig       |    4 ++
 4 files changed, 26 insertions(+), 113 deletions(-)

diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
index 70dabd1..b9d7c42 100644
--- a/arch/um/Kconfig.char
+++ b/arch/um/Kconfig.char
@@ -1,5 +1,4 @@
-
-menu "Character Devices"
+menu "UML Character Devices"
 
 config STDERR_CONSOLE
 	bool "stderr console"
@@ -105,92 +104,6 @@ config SSL_CHAN
           this if you expect the UML that you build to be run in environments
           which don't have a set of /dev/pty* devices.
 
-config UNIX98_PTYS
-	bool "Unix98 PTY support"
-	help
-	  A pseudo terminal (PTY) is a software device consisting of two
-	  halves: a master and a slave. The slave device behaves identical to
-	  a physical terminal; the master device is used by a process to
-	  read data from and write data to the slave, thereby emulating a
-	  terminal. Typical programs for the master side are telnet servers
-	  and xterms.
-
-	  Linux has traditionally used the BSD-like names /dev/ptyxx for
-	  masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
-	  has a number of problems. The GNU C library glibc 2.1 and later,
-	  however, supports the Unix98 naming standard: in order to acquire a
-	  pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
-	  terminal is then made available to the process and the pseudo
-	  terminal slave can be accessed as /dev/pts/<number>. What was
-	  traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
-
-	  All modern Linux systems use the Unix98 ptys.  Say Y unless
-	  you're on an embedded system and want to conserve memory.
-
-config LEGACY_PTYS
-	bool "Legacy (BSD) PTY support"
-	default y
-	help
-	  A pseudo terminal (PTY) is a software device consisting of two
-	  halves: a master and a slave. The slave device behaves identical to
-	  a physical terminal; the master device is used by a process to
-	  read data from and write data to the slave, thereby emulating a
-	  terminal. Typical programs for the master side are telnet servers
-	  and xterms.
-
-	  Linux has traditionally used the BSD-like names /dev/ptyxx
-	  for masters and /dev/ttyxx for slaves of pseudo
-	  terminals. This scheme has a number of problems, including
-	  security.  This option enables these legacy devices; on most
-	  systems, it is safe to say N.
-
-config RAW_DRIVER
-        tristate "RAW driver (/dev/raw/rawN)"
-	depends on BLOCK
-        help
-          The raw driver permits block devices to be bound to /dev/raw/rawN.
-          Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
-          See the raw(8) manpage for more details.
-
-          Applications should preferably open the device (eg /dev/hda1)
-          with the O_DIRECT flag.
-
-config MAX_RAW_DEVS
-        int "Maximum number of RAW devices to support (1-8192)"
-        depends on RAW_DRIVER
-        default "256"
-        help
-          The maximum number of RAW devices that are supported.
-          Default is 256. Increase this number in case you need lots of
-          raw devices.
-
-config LEGACY_PTY_COUNT
-	int "Maximum number of legacy PTY in use"
-	depends on LEGACY_PTYS
-	default "256"
-	help
-	  The maximum number of legacy PTYs that can be used at any one time.
-	  The default is 256, and should be more than enough.  Embedded
-	  systems may want to reduce this to save memory.
-
-	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
-	  architectures and 24 bytes on 64-bit architectures.
-
-config WATCHDOG
-	bool "Watchdog Timer Support"
-
-config WATCHDOG_NOWAYOUT
-	bool "Disable watchdog shutdown on close"
-	depends on WATCHDOG
-
-config SOFT_WATCHDOG
-	tristate "Software Watchdog"
-	depends on WATCHDOG
-
-config UML_WATCHDOG
-	tristate "UML watchdog"
-	depends on WATCHDOG
-
 config UML_SOUND
 	tristate "Sound support"
 	help
@@ -211,29 +124,4 @@ config HOSTAUDIO
 	tristate
 	default UML_SOUND
 
-#It is selected elsewhere, so kconfig would warn without this.
-config HW_RANDOM
-	tristate
-	default n
-
-config UML_RANDOM
-	tristate "Hardware random number generator"
-	help
-	  This option enables UML's "hardware" random number generator.  It
-	  attaches itself to the host's /dev/random, supplying as much entropy
-	  as the host has, rather than the small amount the UML gets from its
-	  own drivers.  It registers itself as a standard hardware random number
-	  generator, major 10, minor 183, and the canonical device name is
-	  /dev/hwrng.
-	  The way to make use of this is to install the rng-tools package
-	  (check your distro, or download from
-	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
-	  /dev/hwrng and injects the entropy into /dev/random.
-
-config MMAPPER
-	tristate "iomem emulation driver"
-	help
-	  This driver allows a host file to be used as emulated IO memory inside
-	  UML.
-
 endmenu
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index b5e675e..70fd690 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -148,5 +148,11 @@ config KERNEL_STACK_ORDER
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
 
+config MMAPPER
+	tristate "iomem emulation driver"
+	help
+	  This driver allows a host file to be used as emulated IO memory inside
+	  UML.
+
 config NO_DMA
 	def_bool y
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1d2ebc7..e5cd79c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -222,3 +222,18 @@ config HW_RANDOM_PPC4XX
 	 module will be called ppc4xx-rng.
 
 	 If unsure, say N.
+
+config UML_RANDOM
+	depends on UML
+	tristate "Hardware random number generator"
+	help
+	  This option enables UML's "hardware" random number generator.  It
+	  attaches itself to the host's /dev/random, supplying as much entropy
+	  as the host has, rather than the small amount the UML gets from its
+	  own drivers.  It registers itself as a standard hardware random number
+	  generator, major 10, minor 183, and the canonical device name is
+	  /dev/hwrng.
+	  The way to make use of this is to install the rng-tools package
+	  (check your distro, or download from
+	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
+	  /dev/hwrng and injects the entropy into /dev/random.
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index be740ce..64c6752 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1174,6 +1174,10 @@ config XEN_WDT
 	  by Xen 4.0 and newer.  The watchdog timeout period is normally one
 	  minute but can be changed with a boot-time parameter.
 
+config UML_WATCHDOG
+	tristate "UML watchdog"
+	depends on UML
+
 #
 # ISA-based Watchdog Cards
 #
-- 
1.7.2.5


