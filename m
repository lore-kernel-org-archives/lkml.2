Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514Ab2C3UiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:38:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:51045 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761468Ab2C3UhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:20 -0400
Message-ID: <4F76197C.8040907@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 6/8] Documentation: remove references to /etc/modprobe.conf
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Remove references to /etc/modprobe.conf

Usage of /etc/modprobe.conf file was deprecated by module-init-tools and
is no longer parsed by new kmod tool. References to this file are
replaced in Documentation, comments and Kconfig according to the
context.

There are also some references to the old /etc/modules.conf from 2.4
kernels that are being removed.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Acked-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/aoe/aoe.txt                       |    2 
 Documentation/aoe/autoload.sh                   |    4 -
 Documentation/blockdev/floppy.txt               |    2 
 Documentation/fb/intel810.txt                   |    2 
 Documentation/fb/intelfb.txt                    |    2 
 Documentation/i2c/busses/scx200_acb             |    2 
 Documentation/ide/ide.txt                       |    2 
 Documentation/isdn/README.gigaset               |   16 ++---
 Documentation/laptops/sonypi.txt                |    2 
 Documentation/mono.txt                          |    8 +-
 Documentation/networking/baycom.txt             |    2 
 Documentation/networking/bonding.txt            |   43 +++++---------
 Documentation/networking/dl2k.txt               |   11 +--
 Documentation/networking/e100.txt               |    6 -
 Documentation/networking/ipv6.txt               |    6 -
 Documentation/networking/ixgb.txt               |    6 -
 Documentation/networking/ltpc.txt               |    2 
 Documentation/networking/vortex.txt             |    6 -
 Documentation/parport.txt                       |   13 +---
 Documentation/s390/3270.txt                     |   21 +++---
 Documentation/scsi/aic79xx.txt                  |    2 
 Documentation/scsi/aic7xxx.txt                  |    2 
 Documentation/scsi/osst.txt                     |    2 
 Documentation/serial/computone.txt              |    8 +-
 Documentation/serial/rocket.txt                 |    2 
 Documentation/serial/stallion.txt               |    4 -
 Documentation/sound/alsa/ALSA-Configuration.txt |   10 +--
 Documentation/sound/alsa/Audiophile-Usb.txt     |    4 -
 Documentation/sound/alsa/MIXART.txt             |    6 -
 Documentation/sound/alsa/OSS-Emulation.txt      |    2 
 Documentation/sound/oss/AudioExcelDSP16         |    6 -
 Documentation/sound/oss/CMI8330                 |    5 -
 Documentation/sound/oss/Introduction            |   10 +--
 Documentation/sound/oss/Opti                    |    8 --
 Documentation/sound/oss/PAS16                   |    4 -
 Documentation/sound/oss/README.modules          |    8 +-
 Documentation/usb/power-management.txt          |    3 
 Documentation/video4linux/CQcam.txt             |   14 ----
 Documentation/video4linux/Zoran                 |    2 
 Documentation/video4linux/bttv/Modules.conf     |    2 
 Documentation/video4linux/meye.txt              |    2 
 drivers/net/wan/Kconfig                         |    4 -
 drivers/scsi/aic7xxx/aic79xx_osm.c              |    8 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |    8 +-
 drivers/staging/asus_oled/README                |    2 
 drivers/tty/isicom.c                            |    2 
 drivers/usb/serial/ftdi_sio.c                   |    3 
 drivers/usb/storage/Kconfig                     |    2 
 sound/core/seq/seq_dummy.c                      |    2 
 sound/drivers/Kconfig                           |    3 
 50 files changed, 138 insertions(+), 160 deletions(-)

--- lnx-33.orig/Documentation/aoe/aoe.txt
+++ lnx-33/Documentation/aoe/aoe.txt
@@ -35,7 +35,7 @@ CREATING DEVICE NODES
     sh Documentation/aoe/mkshelf.sh /dev/etherd 0
 
   There is also an autoload script that shows how to edit
-  /etc/modprobe.conf to ensure that the aoe module is loaded when
+  /etc/modprobe.d/aoe.conf to ensure that the aoe module is loaded when
   necessary.
 
 USING DEVICE NODES
--- lnx-33.orig/Documentation/aoe/autoload.sh
+++ lnx-33/Documentation/aoe/autoload.sh
@@ -1,8 +1,8 @@
 #!/bin/sh
 # set aoe to autoload by installing the
-# aliases in /etc/modprobe.conf
+# aliases in /etc/modprobe.d/
 
-f=/etc/modprobe.conf
+f=/etc/modprobe.d/aoe.conf
 
 if test ! -r $f || test ! -w $f; then
 	echo "cannot configure $f for module autoloading" 1>&2
--- lnx-33.orig/Documentation/blockdev/floppy.txt
+++ lnx-33/Documentation/blockdev/floppy.txt
@@ -49,7 +49,7 @@ you can put:
 
  options floppy omnibook messages
 
-in /etc/modprobe.conf.
+in a configuration file in /etc/modprobe.d/.
 
 
  The floppy driver related options are:
--- lnx-33.orig/Documentation/fb/intel810.txt
+++ lnx-33/Documentation/fb/intel810.txt
@@ -211,7 +211,7 @@ Using the same setup as described above,
 	modprobe i810fb vram=2 xres=1024 bpp=8 hsync1=30 hsync2=55 vsync1=50 \
 	         vsync2=85 accel=1 mtrr=1
 
-Or just add the following to /etc/modprobe.conf
+Or just add the following to a configuration file in /etc/modprobe.d/
 
 	options i810fb vram=2 xres=1024 bpp=16 hsync1=30 hsync2=55 vsync1=50 \
 	vsync2=85 accel=1 mtrr=1
--- lnx-33.orig/Documentation/fb/intelfb.txt
+++ lnx-33/Documentation/fb/intelfb.txt
@@ -120,7 +120,7 @@ Using the same setup as described above,
 
 	modprobe intelfb mode=800x600-32@75 vram=8 accel=1 hwcursor=1
 
-Or just add the following to /etc/modprobe.conf
+Or just add the following to a configuration file in /etc/modprobe.d/
 
 	options intelfb mode=800x600-32@75 vram=8 accel=1 hwcursor=1
 
--- lnx-33.orig/Documentation/i2c/busses/scx200_acb
+++ lnx-33/Documentation/i2c/busses/scx200_acb
@@ -28,5 +28,5 @@ If the scx200_acb driver is built into t
 parameter to your boot command line:
   scx200_acb.base=0x810,0x820
 If the scx200_acb driver is built as a module, add the following line to
-the file /etc/modprobe.conf instead:
+a configuration file in /etc/modprobe.d/ instead:
   options scx200_acb base=0x810,0x820
--- lnx-33.orig/Documentation/ide/ide.txt
+++ lnx-33/Documentation/ide/ide.txt
@@ -169,7 +169,7 @@ When using ide.c as a module in combinat
 
 	alias block-major-3 ide-probe
 
-to /etc/modprobe.conf.
+to a configuration file in /etc/modprobe.d/.
 
 When ide.c is used as a module, you can pass command line parameters to the
 driver using the "options=" keyword to insmod, while replacing any ',' with
--- lnx-33.orig/Documentation/isdn/README.gigaset
+++ lnx-33/Documentation/isdn/README.gigaset
@@ -97,8 +97,7 @@ GigaSet 307x Device Driver
 				   2.5.): 1=on (default), 0=off
 
      Depending on your distribution you may want to create a separate module
-     configuration file /etc/modprobe.d/gigaset for these, or add them to a
-     custom file like /etc/modprobe.conf.local.
+     configuration file like /etc/modprobe.d/gigaset.conf for these.
 
 2.2. Device nodes for user space programs
      ------------------------------------
@@ -212,8 +211,8 @@ GigaSet 307x Device Driver
 
         options ppp_async flag_time=0
 
-     to an appropriate module configuration file, like /etc/modprobe.d/gigaset
-     or /etc/modprobe.conf.local.
+     to an appropriate module configuration file, like
+     /etc/modprobe.d/gigaset.conf.
 
      Unimodem mode is needed for making some devices [e.g. SX100] work which
      do not support the regular Gigaset command set. If debug output (see
@@ -237,8 +236,8 @@ GigaSet 307x Device Driver
 	modprobe usb_gigaset startmode=0
      or by adding a line like
 	options usb_gigaset startmode=0
-     to an appropriate module configuration file, like /etc/modprobe.d/gigaset
-     or /etc/modprobe.conf.local.
+     to an appropriate module configuration file, like
+     /etc/modprobe.d/gigaset.conf
 
 2.6. Call-ID (CID) mode
      ------------------
@@ -310,7 +309,7 @@ GigaSet 307x Device Driver
 
            options isdn dialtimeout=15
 
-        to /etc/modprobe.d/gigaset, /etc/modprobe.conf.local or a similar file.
+        to /etc/modprobe.d/gigaset.conf or a similar file.
 
      Problem:
         The isdnlog program emits error messages or just doesn't work.
@@ -350,8 +349,7 @@ GigaSet 307x Device Driver
      The initial value can be set using the debug parameter when loading the
      module "gigaset", e.g. by adding a line
         options gigaset debug=0
-     to your module configuration file, eg. /etc/modprobe.d/gigaset or
-     /etc/modprobe.conf.local.
+     to your module configuration file, eg. /etc/modprobe.d/gigaset.conf
 
      Generated debugging information can be found
      - as output of the command
--- lnx-33.orig/Documentation/laptops/sonypi.txt
+++ lnx-33/Documentation/laptops/sonypi.txt
@@ -110,7 +110,7 @@ Module use:
 -----------
 
 In order to automatically load the sonypi module on use, you can put those
-lines in your /etc/modprobe.conf file:
+lines a configuration file in /etc/modprobe.d/:
 
 	alias char-major-10-250 sonypi
 	options sonypi minor=250
--- lnx-33.orig/Documentation/mono.txt
+++ lnx-33/Documentation/mono.txt
@@ -38,11 +38,11 @@ if [ ! -e /proc/sys/fs/binfmt_misc/regis
         /sbin/modprobe binfmt_misc
 	# Some distributions, like Fedora Core, perform
 	# the following command automatically when the
-	# binfmt_misc module is loaded into the kernel.
+	# binfmt_misc module is loaded into the kernel
+	# or during normal boot up (systemd-based systems).
 	# Thus, it is possible that the following line
-	# is not needed at all. Look at /etc/modprobe.conf
-	# to check whether this is applicable or not.
-        mount -t binfmt_misc none /proc/sys/fs/binfmt_misc
+	# is not needed at all.
+	mount -t binfmt_misc none /proc/sys/fs/binfmt_misc
 fi
 
 # Register support for .NET CLR binaries
--- lnx-33.orig/Documentation/networking/baycom.txt
+++ lnx-33/Documentation/networking/baycom.txt
@@ -93,7 +93,7 @@ Every time a driver is inserted into the
 modems it should access at which ports. This can be done with the setbaycom
 utility. If you are only using one modem, you can also configure the
 driver from the insmod command line (or by means of an option line in
-/etc/modprobe.conf).
+/etc/modprobe.d/*.conf).
 
 Examples:
   modprobe baycom_ser_fdx mode="ser12*" iobase=0x3f8 irq=4
--- lnx-33.orig/Documentation/networking/bonding.txt
+++ lnx-33/Documentation/networking/bonding.txt
@@ -173,9 +173,8 @@ bonding module at load time, or are spec
 
 	Module options may be given as command line arguments to the
 insmod or modprobe command, but are usually specified in either the
-/etc/modules.conf or /etc/modprobe.conf configuration file, or in a
-distro-specific configuration file (some of which are detailed in the next
-section).
+/etc/modrobe.d/*.conf configuration files, or in a distro-specific
+configuration file (some of which are detailed in the next section).
 
 	Details on bonding support for sysfs is provided in the
 "Configuring Bonding Manually via Sysfs" section, below.
@@ -1021,7 +1020,7 @@ ifcfg-bondX files.
 
 	Because the sysconfig scripts supply the bonding module
 options in the ifcfg-bondX file, it is not necessary to add them to
-the system /etc/modules.conf or /etc/modprobe.conf configuration file.
+the system /etc/modules.d/*.conf configuration files.
 
 3.2 Configuration with Initscripts Support
 ------------------------------------------
@@ -1098,15 +1097,13 @@ queried targets, e.g.,
 	arp_ip_target=+192.168.1.1 arp_ip_target=+192.168.1.2
 
 	is the proper syntax to specify multiple targets.  When specifying
-options via BONDING_OPTS, it is not necessary to edit /etc/modules.conf or
-/etc/modprobe.conf.
+options via BONDING_OPTS, it is not necessary to edit /etc/modprobe.d/*.conf.
 
 	For even older versions of initscripts that do not support
-BONDING_OPTS, it is necessary to edit /etc/modules.conf (or
-/etc/modprobe.conf, depending upon your distro) to load the bonding module
-with your desired options when the bond0 interface is brought up.  The
-following lines in /etc/modules.conf (or modprobe.conf) will load the
-bonding module, and select its options:
+BONDING_OPTS, it is necessary to edit /etc/modprobe.d/*.conf, depending upon
+your distro) to load the bonding module with your desired options when the
+bond0 interface is brought up.  The following lines in /etc/modprobe.d/*.conf
+will load the bonding module, and select its options:
 
 alias bond0 bonding
 options bond0 mode=balance-alb miimon=100
@@ -1152,7 +1149,7 @@ knowledge of bonding.  One such distro i
 version 8.
 
 	The general method for these systems is to place the bonding
-module parameters into /etc/modules.conf or /etc/modprobe.conf (as
+module parameters into a config file in /etc/modprobe.d/ (as
 appropriate for the installed distro), then add modprobe and/or
 ifenslave commands to the system's global init script.  The name of
 the global init script differs; for sysconfig, it is
@@ -1228,7 +1225,7 @@ network initialization scripts.
 specify a different name for each instance (the module loading system
 requires that every loaded module, even multiple instances of the same
 module, have a unique name).  This is accomplished by supplying multiple
-sets of bonding options in /etc/modprobe.conf, for example:
+sets of bonding options in /etc/modprobe.d/*.conf, for example:
 
 alias bond0 bonding
 options bond0 -o bond0 mode=balance-rr miimon=100
@@ -1793,8 +1790,8 @@ route additions may cause trouble.
 	On systems with network configuration scripts that do not
 associate physical devices directly with network interface names (so
 that the same physical device always has the same "ethX" name), it may
-be necessary to add some special logic to either /etc/modules.conf or
-/etc/modprobe.conf (depending upon which is installed on the system).
+be necessary to add some special logic to config files in
+/etc/modprobe.d/.
 
 	For example, given a modules.conf containing the following:
 
@@ -1821,20 +1818,16 @@ add above bonding e1000 tg3
 bonding is loaded.  This command is fully documented in the
 modules.conf manual page.
 
-	On systems utilizing modprobe.conf (or modprobe.conf.local),
-an equivalent problem can occur.  In this case, the following can be
-added to modprobe.conf (or modprobe.conf.local, as appropriate), as
-follows (all on one line; it has been split here for clarity):
+	On systems utilizing modprobe an equivalent problem can occur.
+In this case, the following can be added to config files in
+/etc/modprobe.d/ as:
 
 install bonding /sbin/modprobe tg3; /sbin/modprobe e1000;
 	/sbin/modprobe --ignore-install bonding
 
-	This will, when loading the bonding module, rather than
-performing the normal action, instead execute the provided command.
-This command loads the device drivers in the order needed, then calls
-modprobe with --ignore-install to cause the normal action to then take
-place.  Full documentation on this can be found in the modprobe.conf
-and modprobe manual pages.
+	This will load tg3 and e1000 modules before loading the bonding one.
+Full documentation on this can be found in the modprobe.d and modprobe
+manual pages.
 
 8.3. Painfully Slow Or No Failed Link Detection By Miimon
 ---------------------------------------------------------
--- lnx-33.orig/Documentation/networking/dl2k.txt
+++ lnx-33/Documentation/networking/dl2k.txt
@@ -45,12 +45,13 @@ Now eth0 should active, you can test it
 "ifconfig". If tested ok, continue the next step.
 
 4. cp dl2k.ko /lib/modules/`uname -r`/kernel/drivers/net
-5. Add the following line to /etc/modprobe.conf:
+5. Add the following line to /etc/modprobe.d/dl2k.conf:
 	alias eth0 dl2k
-6. Run "netconfig" or "netconf" to create configuration script ifcfg-eth0
+6. Run depmod to updated module indexes.
+7. Run "netconfig" or "netconf" to create configuration script ifcfg-eth0
    located at /etc/sysconfig/network-scripts or create it manually.
    [see - Configuration Script Sample]
-7. Driver will automatically load and configure at next boot time.
+8. Driver will automatically load and configure at next boot time.
 
 Compiling the Driver
 ====================
@@ -154,8 +155,8 @@ Installing the Driver
   -----------------
   1. Copy dl2k.o to the network modules directory, typically
      /lib/modules/2.x.x-xx/net or /lib/modules/2.x.x/kernel/drivers/net.
-  2. Locate the boot module configuration file, most commonly modprobe.conf
-     or modules.conf (for 2.4) in the /etc directory. Add the following lines:
+  2. Locate the boot module configuration file, most commonly in the
+     /etc/modprobe.d/ directory. Add the following lines:
 
      alias ethx dl2k
      options dl2k <optional parameters>
--- lnx-33.orig/Documentation/networking/e100.txt
+++ lnx-33/Documentation/networking/e100.txt
@@ -94,8 +94,8 @@ Additional Configurations
 
   Configuring a network driver to load properly when the system is started is
   distribution dependent. Typically, the configuration process involves adding
-  an alias line to /etc/modules.conf or /etc/modprobe.conf as well as editing
-  other system startup scripts and/or configuration files.  Many popular Linux
+  an alias line to /etc/modprobe.d/*.conf as well as editing other system
+  startup scripts and/or configuration files.  Many popular Linux
   distributions ship with tools to make these changes for you. To learn the
   proper way to configure a network device for your system, refer to your
   distribution documentation.  If during this process you are asked for the
@@ -103,7 +103,7 @@ Additional Configurations
   PRO/100 Family of Adapters is e100.
 
   As an example, if you install the e100 driver for two PRO/100 adapters
-  (eth0 and eth1), add the following to modules.conf or modprobe.conf:
+  (eth0 and eth1), add the following to a configuraton file in /etc/modprobe.d/
 
        alias eth0 e100
        alias eth1 e100
--- lnx-33.orig/Documentation/networking/ipv6.txt
+++ lnx-33/Documentation/networking/ipv6.txt
@@ -2,9 +2,9 @@
 Options for the ipv6 module are supplied as parameters at load time.
 
 Module options may be given as command line arguments to the insmod
-or modprobe command, but are usually specified in either the
-/etc/modules.conf or /etc/modprobe.conf configuration file, or in a
-distro-specific configuration file.
+or modprobe command, but are usually specified in either
+/etc/modules.d/*.conf configuration files, or in a distro-specific
+configuration file.
 
 The available ipv6 module parameters are listed below.  If a parameter
 is not specified the default value is used.
--- lnx-33.orig/Documentation/networking/ixgb.txt
+++ lnx-33/Documentation/networking/ixgb.txt
@@ -274,9 +274,9 @@ Additional Configurations
   -------------------------------------------------
   Configuring a network driver to load properly when the system is started is
   distribution dependent. Typically, the configuration process involves adding
-  an alias line to /etc/modprobe.conf as well as editing other system startup
-  scripts and/or configuration files.  Many popular Linux distributions ship
-  with tools to make these changes for you.  To learn the proper way to
+  an alias line to files in /etc/modprobe.d/ as well as editing other system
+  startup scripts and/or configuration files.  Many popular Linux distributions
+  ship with tools to make these changes for you.  To learn the proper way to
   configure a network device for your system, refer to your distribution
   documentation.  If during this process you are asked for the driver or module
   name, the name for the Linux Base Driver for the Intel 10GbE Family of
--- lnx-33.orig/Documentation/networking/ltpc.txt
+++ lnx-33/Documentation/networking/ltpc.txt
@@ -25,7 +25,7 @@ the driver will try to determine them it
 
 If you load the driver as a module, you can pass the parameters "io=",
 "irq=", and "dma=" on the command line with insmod or modprobe, or add
-them as options in /etc/modprobe.conf:
+them as options in a configuration file in /etc/modprobe.d/ directory:
 
  alias lt0 ltpc # autoload the module when the interface is configured
  options ltpc io=0x240 irq=9 dma=1
--- lnx-33.orig/Documentation/networking/vortex.txt
+++ lnx-33/Documentation/networking/vortex.txt
@@ -67,8 +67,8 @@ Module parameters
 =================
 
 There are several parameters which may be provided to the driver when
-its module is loaded.  These are usually placed in /etc/modprobe.conf
-(/etc/modules.conf in 2.4).  Example:
+its module is loaded.  These are usually placed in /etc/modprobe.d/*.conf
+configuretion files.  Example:
 
 options 3c59x debug=3 rx_copybreak=300
 
@@ -425,7 +425,7 @@ steps you should take:
       1) Increase the debug level.  Usually this is done via:
 
          a) modprobe driver debug=7
-         b) In /etc/modprobe.conf (or /etc/modules.conf for 2.4):
+         b) In /etc/modprobe.d/driver.conf:
             options driver debug=7
 
       2) Recreate the problem with the higher debug level,
--- lnx-33.orig/Documentation/parport.txt
+++ lnx-33/Documentation/parport.txt
@@ -36,18 +36,17 @@ addresses should not be specified for su
 are automatically detected.
 
 
-KMod
-----
+modprobe
+--------
 
-If you use kmod, you will find it useful to edit /etc/modprobe.conf.
-Here is an example of the lines that need to be added:
+If you use modprobe , you will find it useful to add lines as below to a
+configuration file in /etc/modprobe.d/ directory:.
 
 	alias parport_lowlevel parport_pc
 	options parport_pc io=0x378,0x278 irq=7,auto
 
-KMod will then automatically load parport_pc (with the options
-"io=0x378,0x278 irq=7,auto") whenever a parallel port device driver
-(such as lp) is loaded.
+modprobe will load parport_pc (with the options "io=0x378,0x278 irq=7,auto")
+whenever a parallel port device driver (such as lp) is loaded.
 
 Note that these are example lines only!  You shouldn't in general need
 to specify any options to parport_pc in order to be able to use a
--- lnx-33.orig/Documentation/s390/3270.txt
+++ lnx-33/Documentation/s390/3270.txt
@@ -47,9 +47,9 @@ including the console 3270, changes subc
 one another.  ReIPL as soon as possible after running the configuration
 script and the resulting /tmp/mkdev3270.
 
-If you have chosen to make tub3270 a module, you add a line to
-/etc/modprobe.conf.  If you are working on a VM virtual machine, you
-can use DEF GRAF to define virtual 3270 devices.
+If you have chosen to make tub3270 a module, you add a line to a
+configuration file under /etc/modprobe.d/.  If you are working on a VM
+virtual machine, you can use DEF GRAF to define virtual 3270 devices.
 
 You may generate both 3270 and 3215 console support, or one or the
 other, or neither.  If you generate both, the console type under VM is
@@ -60,7 +60,7 @@ at boot time to a 3270 if it is a 3215.
 
 In brief, these are the steps:
 	1. Install the tub3270 patch
-	2. (If a module) add a line to /etc/modprobe.conf
+	2. (If a module) add a line to a file in /etc/modprobe.d/*.conf
 	3. (If VM) define devices with DEF GRAF
 	4. Reboot
 	5. Configure
@@ -84,13 +84,12 @@ Here are the installation steps in detai
 		make modules_install
 
 	2. (Perform this step only if you have configured tub3270 as a
-	module.)  Add a line to /etc/modprobe.conf to automatically
-	load the driver when it's needed.  With this line added,
-	you will see login prompts appear on your 3270s as soon as
-	boot is complete (or with emulated 3270s, as soon as you dial
-	into your vm guest using the command "DIAL <vmguestname>").
-	Since the line-mode major number is 227, the line to add to
-	/etc/modprobe.conf should be:
+	module.)  Add a line to a file /etc/modprobe.d/*.conf to automatically
+	load the driver when it's needed.  With this line added, you will see
+	login prompts appear on your 3270s as soon as boot is complete (or
+	with emulated 3270s, as soon as you dial into your vm guest using the
+	command "DIAL <vmguestname>").  Since the line-mode major number is
+	227, the line to add should be:
 		alias char-major-227 tub3270
 
 	3. Define graphic devices to your vm guest machine, if you
--- lnx-33.orig/Documentation/scsi/aic79xx.txt
+++ lnx-33/Documentation/scsi/aic79xx.txt
@@ -215,7 +215,7 @@ The following information is available i
                  INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
                  USE THEM WITH CAUTION. 
 
-   Edit the file "modprobe.conf" in the directory /etc and add/edit a
+   Put a .conf file in the /etc/modprobe.d/ directory and add/edit a
    line containing 'options aic79xx aic79xx=[command[,command...]]' where
    'command' is one or more of the following:
    -----------------------------------------------------------------
--- lnx-33.orig/Documentation/scsi/aic7xxx.txt
+++ lnx-33/Documentation/scsi/aic7xxx.txt
@@ -190,7 +190,7 @@ The following information is available i
                  INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
                  USE THEM WITH CAUTION. 
 
-   Edit the file "modprobe.conf" in the directory /etc and add/edit a
+   Put a .conf file in the /etc/modprobe.d directory and add/edit a
    line containing 'options aic7xxx aic7xxx=[command[,command...]]' where
    'command' is one or more of the following:
    -----------------------------------------------------------------
--- lnx-33.orig/Documentation/scsi/osst.txt
+++ lnx-33/Documentation/scsi/osst.txt
@@ -66,7 +66,7 @@ recognized.
 If you want to have the module autoloaded on access to /dev/osst, you may
 add something like
 alias char-major-206 osst
-to your /etc/modprobe.conf (before 2.6: modules.conf).
+to a file under /etc/modprobe.d/ directory.
 
 You may find it convenient to create a symbolic link 
 ln -s nosst0 /dev/tape
--- lnx-33.orig/Documentation/serial/computone.txt
+++ lnx-33/Documentation/serial/computone.txt
@@ -49,7 +49,7 @@ Hardware - If you have an ISA card, find
 
 	Note the hardware address from the Computone ISA cards installed into
 		the system.  These are required for editing ip2.c or editing
-		/etc/modprobe.conf, or for specification on the modprobe
+		/etc/modprobe.d/*.conf, or for specification on the modprobe
 		command line.
 
 	Note that the /etc/modules.conf should be used for older (pre-2.6)
@@ -66,7 +66,7 @@ b) Run "make config" or "make menuconfig
 c) Set address on ISA cards then:
    edit /usr/src/linux/drivers/char/ip2.c if needed 
 	or
-   edit /etc/modprobe.conf if needed (module).
+   edit config file in  /etc/modprobe.d/ if needed (module).
 	or both to match this setting.
 d) Run "make modules"
 e) Run "make modules_install"
@@ -153,11 +153,11 @@ the irqs are not specified the driver us
 selects polled mode). If no base addresses are specified the defaults in 
 ip2.c are used. If you are autoloading the driver module with kerneld or
 kmod the base addresses and interrupt number must also be set in ip2.c
-and recompile or just insert and options line in /etc/modprobe.conf or both.
+and recompile or just insert and options line in /etc/modprobe.d/*.conf or both.
 The options line is equivalent to the command line and takes precedence over
 what is in ip2.c. 
 
-/etc/modprobe.conf sample:
+config sample to put /etc/modprobe.d/*.conf:
 	options ip2 io=1,0x328 irq=1,10
 	alias char-major-71 ip2
 	alias char-major-72 ip2
--- lnx-33.orig/Documentation/serial/rocket.txt
+++ lnx-33/Documentation/serial/rocket.txt
@@ -62,7 +62,7 @@ in the system log at /var/log/messages.
 
 If installed as a module, the module must be loaded.  This can be done
 manually by entering "modprobe rocket".  To have the module loaded automatically
-upon system boot, edit the /etc/modprobe.conf file and add the line
+upon system boot, edit a /etc/modprobe.d/*.conf file and add the line
 "alias char-major-46 rocket".
 
 In order to use the ports, their device names (nodes) must be created with mknod.
--- lnx-33.orig/Documentation/serial/stallion.txt
+++ lnx-33/Documentation/serial/stallion.txt
@@ -139,8 +139,8 @@ secondary address 0x280 and IRQ 10.
 
 You will probably want to enter this module load and configuration information
 into your system startup scripts so that the drivers are loaded and configured
-on each system boot. Typically the start up script would be something like
-/etc/modprobe.conf.
+on each system boot. Typically configuration files are put in the
+/etc/modprobe.d/ directory.
 
 
 2.2 STATIC DRIVER CONFIGURATION:
--- lnx-33.orig/Documentation/sound/alsa/ALSA-Configuration.txt
+++ lnx-33/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2038,7 +2038,7 @@ Prior to version 0.9.0rc4 options had a
     Install the necessary firmware files in alsa-firmware package.
     When no hotplug fw loader is available, you need to load the
     firmware via vxloader utility in alsa-tools package.  To invoke
-    vxloader automatically, add the following to /etc/modprobe.conf
+    vxloader automatically, add the following to /etc/modprobe.d/alsa.conf
 
 	install snd-vx222 /sbin/modprobe --first-time -i snd-vx222 && /usr/bin/vxloader
 
@@ -2162,10 +2162,10 @@ corresponds to the card index of ALSA.
 as the same card module.
 
 An example configuration for a single emu10k1 card is like below:
------ /etc/modprobe.conf
+----- /etc/modprobe.d/alsa.conf
 alias snd-card-0 snd-emu10k1
 alias sound-slot-0 snd-emu10k1
------ /etc/modprobe.conf
+----- /etc/modprobe.d/alsa.conf
 
 The available number of auto-loaded sound cards depends on the module
 option "cards_limit" of snd module.  As default it's set to 1.
@@ -2178,7 +2178,7 @@ cards is kept consistent.
 
 An example configuration for two sound cards is like below:
 
------ /etc/modprobe.conf
+----- /etc/modprobe.d/alsa.conf
 # ALSA portion
 options snd cards_limit=2
 alias snd-card-0 snd-interwave
@@ -2188,7 +2188,7 @@ options snd-ens1371 index=1
 # OSS/Free portion
 alias sound-slot-0 snd-interwave
 alias sound-slot-1 snd-ens1371
------ /etc/modprobe.conf
+----- /etc/modprobe.d/alsa.conf
 
 In this example, the interwave card is always loaded as the first card
 (index 0) and ens1371 as the second (index 1).
--- lnx-33.orig/Documentation/sound/alsa/Audiophile-Usb.txt
+++ lnx-33/Documentation/sound/alsa/Audiophile-Usb.txt
@@ -232,7 +232,7 @@ The parameter can be given:
    # modprobe snd-usb-audio index=1 device_setup=0x09
 
  * Or while configuring the modules options in your modules configuration file
-   - For Fedora distributions, edit the /etc/modprobe.conf file:
+   (tipically a .conf file in /etc/modprobe.d/ directory:
        alias snd-card-1 snd-usb-audio
        options snd-usb-audio index=1 device_setup=0x09
 
@@ -253,7 +253,7 @@ CAUTION when initializing the device
    - first turn off the device
    - de-register the snd-usb-audio module (modprobe -r)
    - change the device_setup parameter by changing the device_setup
-     option in /etc/modprobe.conf 
+     option in /etc/modprobe.d/*.conf
    - turn on the device
  * A workaround for this last issue has been applied to kernel 2.6.23, but it may not
    be enough to ensure the 'stability' of the device initialization.
--- lnx-33.orig/Documentation/sound/alsa/MIXART.txt
+++ lnx-33/Documentation/sound/alsa/MIXART.txt
@@ -76,9 +76,9 @@ FIRMWARE
  when CONFIG_FW_LOADER is set.  The mixartloader is necessary only
  for older versions or when you build the driver into kernel.]
  
-For loading the firmware automatically after the module is loaded, use
-the post-install command.  For example, add the following entry to
-/etc/modprobe.conf for miXart driver:
+For loading the firmware automatically after the module is loaded, use a
+install command.  For example, add the following entry to
+/etc/modprobe.d/mixart.conf for miXart driver:
 
 	install snd-mixart /sbin/modprobe --first-time -i snd-mixart && \
 			   /usr/bin/mixartloader
--- lnx-33.orig/Documentation/sound/alsa/OSS-Emulation.txt
+++ lnx-33/Documentation/sound/alsa/OSS-Emulation.txt
@@ -19,7 +19,7 @@ the card number and the minor unit numbe
 define these aliases by yourself.
 
 Only necessary step for auto-loading of OSS modules is to define the
-card alias in /etc/modprobe.conf, such as
+card alias in /etc/modprobe.d/alsa.conf, such as
 
 	alias sound-slot-0 snd-emu10k1
 
--- lnx-33.orig/Documentation/sound/oss/AudioExcelDSP16
+++ lnx-33/Documentation/sound/oss/AudioExcelDSP16
@@ -41,7 +41,7 @@ mpu_base	I/O base address for activate M
 		(0x300, 0x310, 0x320 or 0x330)
 mpu_irq		MPU-401 irq line (5, 7, 9, 10 or 0)
 
-The /etc/modprobe.conf will have lines like this:
+A configuration file in /etc/modprobe.d/ directory will have lines like this:
 
 options opl3 io=0x388
 options ad1848 io=0x530 irq=11 dma=3
@@ -51,8 +51,8 @@ Where the aedsp16 options are the option
 ad1848 are the corresponding options for the MSS and OPL3 modules.
 
 Loading MSS and OPL3 needs to pre load the aedsp16 module to set up correctly
-the sound card. Installation dependencies must be written in the modprobe.conf
-file:
+the sound card. Installation dependencies must be written in configuration
+files under /etc/modprobe.d/ directory:
 
 install ad1848 /sbin/modprobe aedsp16 && /sbin/modprobe -i ad1848
 install opl3 /sbin/modprobe aedsp16 && /sbin/modprobe -i opl3
--- lnx-33.orig/Documentation/sound/oss/CMI8330
+++ lnx-33/Documentation/sound/oss/CMI8330
@@ -143,11 +143,10 @@ CONFIG_SOUND_MSS=m
 
 
 
-Alma Chao <elysian@ethereal.torsion.org> suggests the following /etc/modprobe.conf:
+Alma Chao <elysian@ethereal.torsion.org> suggests the following in
+a /etc/modprobe.d/*conf file:
 
 alias sound ad1848
 alias synth0 opl3
 options ad1848 io=0x530 irq=7 dma=0 soundpro=1
 options opl3 io=0x388
-
-	
--- lnx-33.orig/Documentation/sound/oss/Introduction
+++ lnx-33/Documentation/sound/oss/Introduction
@@ -167,8 +167,8 @@ in a file such as /root/soundon.sh.
 MODPROBE:
 =========
 
-If loading via modprobe, these common files are automatically loaded 
-when requested by modprobe.  For example, my /etc/modprobe.conf contains:
+If loading via modprobe, these common files are automatically loaded when
+requested by modprobe.  For example, my /etc/modprobe.d/oss.conf contains:
 
 alias sound sb 
 options sb io=0x240 irq=9 dma=3 dma16=5 mpu_io=0x300
@@ -228,7 +228,7 @@ http://www.opensound.com.  Before loadin
 driver, you should do the following:
 
 1.  remove sound modules (detailed above)
-2.  remove the sound modules from /etc/modprobe.conf
+2.  remove the sound modules from /etc/modprobe.d/*.conf
 3.  move the sound modules from /lib/modules/<kernel>/misc
     (for example, I make a /lib/modules/<kernel>/misc/tmp
     directory and copy the sound module files to that 
@@ -265,7 +265,7 @@ twice, you need to do the following:
     sb.o could be copied (or symlinked) to sb1.o for the
     second SoundBlaster.
 
-2.  Make a second entry in /etc/modprobe.conf, for example,
+2.  Make a second entry in /etc/modprobe.d/*conf, for example,
     sound1 or sb1.  This second entry should refer to the
     new module names for example sb1, and should include
     the I/O, etc. for the second sound card.
@@ -369,7 +369,7 @@ There are several ways of configuring yo
 2)  On the command line when using insmod or in a bash script
     using command line calls to load sound.
 
-3)  In /etc/modprobe.conf when using modprobe.
+3)  In /etc/modprobe.d/*conf when using modprobe.
 
 4)  Via Red Hat's GPL'd /usr/sbin/sndconfig program (text based).
 
--- lnx-33.orig/Documentation/sound/oss/Opti
+++ lnx-33/Documentation/sound/oss/Opti
@@ -18,7 +18,7 @@ force the card into a mode in which it c
 If you have another OS installed on your computer it is recommended
 that Linux and the other OS use the same resources.
 
-Also, it is recommended that resources specified in /etc/modprobe.conf
+Also, it is recommended that resources specified in /etc/modprobe.d/*.conf
 and resources specified in /etc/isapnp.conf agree.
 
 Compiling the sound driver
@@ -67,11 +67,7 @@ address is hard-coded into the driver.
 
 Using kmod and autoloading the sound driver
 -------------------------------------------
-Comment: as of linux-2.1.90 kmod is replacing kerneld.
-The config file '/etc/modprobe.conf' is used as before.
-
-This is the sound part of my /etc/modprobe.conf file.
-Following that I will explain each line.
+Config files in '/etc/modprobe.d/' are used as below:
 
 alias mixer0 mad16
 alias audio0 mad16
--- lnx-33.orig/Documentation/sound/oss/PAS16
+++ lnx-33/Documentation/sound/oss/PAS16
@@ -128,7 +128,7 @@ CONFIG_SOUND_YM3812
   You can then get OPL3 functionality by issuing the command:
   insmod opl3
   In addition, you must either add the following line to 
-  /etc/modprobe.conf:
+  /etc/modprobe.d/*.conf:
   options opl3 io=0x388
   or else add the following line to /etc/lilo.conf:
   opl3=0x388
@@ -158,5 +158,5 @@ following line would be appropriate:
 append="pas2=0x388,10,3,-1,0,-1,-1,-1 opl3=0x388"
 
 If sound is built totally modular, the above options may be 
-specified in /etc/modprobe.conf for pas2, sb and opl3
+specified in /etc/modprobe.d/*.conf for pas2, sb and opl3
 respectively. 
--- lnx-33.orig/Documentation/sound/oss/README.modules
+++ lnx-33/Documentation/sound/oss/README.modules
@@ -26,7 +26,7 @@ Note that it is no longer necessary or p
 drivers/sound dir. Now one simply configures and makes one's kernel and
 modules in the usual way.
 
- Then, add to your /etc/modprobe.conf something like:
+ Then, add to your /etc/modprobe.d/oss.conf something like:
 
 alias char-major-14-* sb
 install sb /sbin/modprobe -i sb && /sbin/modprobe adlib_card
@@ -66,12 +66,12 @@ args are expected.
  Note that at present there is no way to configure the io, irq and other
 parameters for the modular drivers as one does for the wired drivers.. One
 needs to pass the modules the necessary parameters as arguments, either
-with /etc/modprobe.conf or with command-line args to modprobe, e.g.
+with /etc/modprobe.d/*.conf or with command-line args to modprobe, e.g.
 
 modprobe sb io=0x220 irq=7 dma=1 dma16=5 mpu_io=0x330
 modprobe adlib_card io=0x388
 
- recommend using /etc/modprobe.conf.
+ recommend using /etc/modprobe.d/*.conf.
 
 Persistent DMA Buffers:
 
@@ -89,7 +89,7 @@ wasteful of RAM, but it guarantees that
 
 To make the sound driver use persistent DMA buffers we need to pass the
 sound.o module a "dmabuf=1" command-line argument. This is normally done
-in /etc/modprobe.conf like so:
+in /etc/modprobe.d/*.conf files like so:
 
 options sound		dmabuf=1
 
--- lnx-33.orig/Documentation/usb/power-management.txt
+++ lnx-33/Documentation/usb/power-management.txt
@@ -179,7 +179,8 @@ do:
 
 	modprobe usbcore autosuspend=5
 
-Equivalently, you could add to /etc/modprobe.conf a line saying:
+Equivalently, you could add to a configuration file in /etc/modprobe.d
+a line saying:
 
 	options usbcore autosuspend=5
 
--- lnx-33.orig/Documentation/video4linux/CQcam.txt
+++ lnx-33/Documentation/video4linux/CQcam.txt
@@ -61,29 +61,19 @@ But that is my personal preference.
 2.2 Configuration
 
   The configuration requires module configuration and device
-configuration.  I like kmod or kerneld process with the
-/etc/modprobe.conf file so the modules can automatically load/unload as
-they are used.  The video devices could already exist, be generated
-using MAKEDEV, or need to be created.  The following sections detail
-these procedures.
+configuration.  The following sections detail these procedures.
 
 
 2.1 Module Configuration
 
   Using modules requires a bit of work to install and pass the
-parameters.  Understand that entries in /etc/modprobe.conf of:
+parameters.  Understand that entries in /etc/modprobe.d/*.conf of:
 
    alias parport_lowlevel parport_pc
    options parport_pc io=0x378 irq=none
    alias char-major-81 videodev
    alias char-major-81-0 c-qcam
 
-will cause the kmod/modprobe to do certain things.  If you are
-using kmod, then a request for a 'char-major-81-0' will cause
-the 'c-qcam' module to load.  If you have other video sources with
-modules, you might want to assign the different minor numbers to
-different modules.
-
 2.2 Device Configuration
 
   At this point, we need to ensure that the device files exist.
--- lnx-33.orig/Documentation/video4linux/Zoran
+++ lnx-33/Documentation/video4linux/Zoran
@@ -255,7 +255,7 @@ Load zr36067.o. If it can't autodetect y
 option with X being the card number as given in the previous section.
 To have more than one card, use card=X1[,X2[,X3,[X4[..]]]]
 
-To automate this, add the following to your /etc/modprobe.conf:
+To automate this, add the following to your /etc/modprobe.d/zoran.conf:
 
 options zr36067 card=X1[,X2[,X3[,X4[..]]]]
 alias char-major-81-0 zr36067
--- lnx-33.orig/Documentation/video4linux/bttv/Modules.conf
+++ lnx-33/Documentation/video4linux/bttv/Modules.conf
@@ -1,4 +1,4 @@
-# For modern kernels (2.6 or above), this belongs in /etc/modprobe.conf
+# For modern kernels (2.6 or above), this belongs in /etc/modprobe.d/*.conf
 # For for 2.4 kernels or earlier, this belongs in /etc/modules.conf.
 
 # i2c
--- lnx-33.orig/Documentation/video4linux/meye.txt
+++ lnx-33/Documentation/video4linux/meye.txt
@@ -55,7 +55,7 @@ Module use:
 -----------
 
 In order to automatically load the meye module on use, you can put those lines
-in your /etc/modprobe.conf file:
+in your /etc/modprobe.d/meye.conf file:
 
 	alias char-major-81 videodev
 	alias char-major-81-0 meye
--- lnx-33.orig/drivers/net/wan/Kconfig
+++ lnx-33/drivers/net/wan/Kconfig
@@ -290,8 +290,8 @@ config FARSYNC
 	  Frame Relay or X.25/LAPB.
 
 	  If you want the module to be automatically loaded when the interface
-	  is referenced then you should add "alias hdlcX farsync" to
-	  /etc/modprobe.conf for each interface, where X is 0, 1, 2, ..., or
+	  is referenced then you should add "alias hdlcX farsync" to a file
+	  in /etc/modprobe.d/ for each interface, where X is 0, 1, 2, ..., or
 	  simply use "alias hdlc* farsync" to indicate all of them.
 
 	  To compile this driver as a module, choose M here: the
--- lnx-33.orig/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ lnx-33/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -341,10 +341,10 @@ MODULE_PARM_DESC(aic79xx,
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
 "	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"		 
 "\n"
-"	Sample /etc/modprobe.conf line:\n"
-"		Enable verbose logging\n"
-"		Set tag depth on Controller 2/Target 2 to 10 tags\n"
-"		Shorten the selection timeout to 128ms\n"
+"	Sample modprobe configuration file:\n"
+"	#	Enable verbose logging\n"
+"	#	Set tag depth on Controller 2/Target 2 to 10 tags\n"
+"	#	Shorten the selection timeout to 128ms\n"
 "\n"
 "	options aic79xx 'aic79xx=verbose.tag_info:{{}.{}.{..10}}.seltime:1'\n"
 );
--- lnx-33.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ lnx-33/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -360,10 +360,10 @@ MODULE_PARM_DESC(aic7xxx,
 "	seltime:<int>		Selection Timeout\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
 "\n"
-"	Sample /etc/modprobe.conf line:\n"
-"		Toggle EISA/VLB probing\n"
-"		Set tag depth on Controller 1/Target 1 to 10 tags\n"
-"		Shorten the selection timeout to 128ms\n"
+"	Sample modprobe configuration file:\n"
+"	#	Toggle EISA/VLB probing\n"
+"	#	Set tag depth on Controller 1/Target 1 to 10 tags\n"
+"	#	Shorten the selection timeout to 128ms\n"
 "\n"
 "	options aic7xxx 'aic7xxx=probe_eisa_vl.tag_info:{{}.{.10}}.seltime:1'\n"
 );
--- lnx-33.orig/drivers/staging/asus_oled/README
+++ lnx-33/drivers/staging/asus_oled/README
@@ -52,7 +52,7 @@ Configuration
 
    There is only one option: start_off.
    You can use it by: 'modprobe asus_oled start_off=1', or by adding this
-   line to /etc/modprobe.conf:
+   line to /etc/modprobe.d/asus_oled.conf:
    options asus_oled start_off=1
 
    With this option provided, asus_oled driver will switch off the display
--- lnx-33.orig/drivers/tty/isicom.c
+++ lnx-33/drivers/tty/isicom.c
@@ -102,7 +102,7 @@
  *	You can find the original tools for this direct from Multitech
  *		ftp://ftp.multitech.com/ISI-Cards/
  *
- *	Having installed the cards the module options (/etc/modprobe.conf)
+ *	Having installed the cards the module options (/etc/modprobe.d/)
  *
  *	options isicom   io=card1,card2,card3,card4 irq=card1,card2,card3,card4
  *
--- lnx-33.orig/drivers/usb/serial/ftdi_sio.c
+++ lnx-33/drivers/usb/serial/ftdi_sio.c
@@ -1706,7 +1706,8 @@ static void ftdi_HE_TIRA1_setup(struct f
 
 /*
  * Module parameter to control latency timer for NDI FTDI-based USB devices.
- * If this value is not set in modprobe.conf.local its value will be set to 1ms.
+ * If this value is not set in /etc/modprobe.d/ its value will be set
+ * to 1ms.
  */
 static int ndi_latency_timer = 1;
 
--- lnx-33.orig/drivers/usb/storage/Kconfig
+++ lnx-33/drivers/usb/storage/Kconfig
@@ -222,7 +222,7 @@ config USB_LIBUSUAL
 	  for usb-storage and ub drivers, and allows to switch binding
 	  of these devices without rebuilding modules.
 
-	  Typical syntax of /etc/modprobe.conf is:
+	  Typical syntax of /etc/modprobe.d/*conf is:
 
 		options libusual bias="ub"
 
--- lnx-33.orig/sound/core/seq/seq_dummy.c
+++ lnx-33/sound/core/seq/seq_dummy.c
@@ -46,7 +46,7 @@
 
   The number of ports to be created can be specified via the module
   parameter "ports".  For example, to create four ports, add the
-  following option in /etc/modprobe.conf:
+  following option in a configuration file under /etc/modprobe.d/:
 
 	option snd-seq-dummy ports=4
 
--- lnx-33.orig/sound/drivers/Kconfig
+++ lnx-33/sound/drivers/Kconfig
@@ -50,7 +50,8 @@ config SND_PCSP
 	  before the other sound driver of yours, making the
 	  pc-speaker a default sound device. Which is likely not
 	  what you want. To make this driver play nicely with other
-	  sound driver, you can add this into your /etc/modprobe.conf:
+	  sound driver, you can add this in a configuration file under
+	  /etc/modprobe.d/ directory:
 	  options snd-pcsp index=2
 
 	  You don't need this driver if you only want your pc-speaker to beep.
