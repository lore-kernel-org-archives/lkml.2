Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab0FCANf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab0FCANb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>, Arnd Bergmann <arnd@relay.de.ibm.com>
Subject: [RFC 5/5] BKL: introduce CONFIG_BKL.
Date: Thu,  3 Jun 2010 02:13:19 +0200
Message-Id: <1275523999-27462-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275523999-27462-1-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/q4ri3yB+0yDD+VX/kChB6wZx1M3rmp5GqKg
 GIP2RdbC9Kp2lL0thpPgihtDfr6k/WWcUjLMXqSo+iRAa3ppbr
 IlWrsJcYXzzxopFhLN0oA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

To make it possible to build a kernel without the
big kernel lock, we need to make sure we don't
build any code that still uses it, so disable
the options in Kconfig.

Most of the v4l, drm and oss drivers still need
it too, but their respective top-level interfaces
get disabled here, so we don't need to list them
separately.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/Kconfig          |    2 +-
 drivers/gpu/drm/Kconfig       |    5 +++--
 drivers/hid/usbhid/Kconfig    |    2 +-
 drivers/isdn/Kconfig          |    1 +
 drivers/isdn/capi/Kconfig     |    2 +-
 drivers/isdn/mISDN/Kconfig    |    1 +
 drivers/media/Kconfig         |    3 ++-
 drivers/misc/Kconfig          |    2 +-
 drivers/net/appletalk/Kconfig |    1 +
 drivers/sbus/char/Kconfig     |    2 +-
 drivers/staging/sep/Kconfig   |    2 +-
 drivers/staging/usbip/Kconfig |    2 +-
 drivers/usb/gadget/Kconfig    |    2 +-
 fs/adfs/Kconfig               |    1 +
 fs/afs/Kconfig                |    1 +
 fs/autofs/Kconfig             |    1 +
 fs/autofs4/Kconfig            |    1 +
 fs/coda/Kconfig               |    1 +
 fs/ecryptfs/Kconfig           |    1 +
 fs/fat/Kconfig                |    2 ++
 fs/freevxfs/Kconfig           |    1 +
 fs/hpfs/Kconfig               |    1 +
 fs/isofs/Kconfig              |    1 +
 fs/jffs2/Kconfig              |    1 +
 fs/ncpfs/Kconfig              |    1 +
 fs/nfs/Kconfig                |    2 +-
 fs/nfsd/Kconfig               |    1 +
 fs/ocfs2/Kconfig              |    1 +
 fs/qnx4/Kconfig               |    1 +
 fs/reiserfs/Kconfig           |    1 +
 fs/smbfs/Kconfig              |    1 +
 fs/squashfs/Kconfig           |    2 +-
 fs/udf/Kconfig                |    1 +
 fs/ufs/Kconfig                |    2 +-
 init/Kconfig                  |    2 +-
 lib/Kconfig.debug             |   11 ++++++++++-
 net/ipx/Kconfig               |    1 +
 net/irda/Kconfig              |    2 +-
 net/irda/irnet/Kconfig        |    2 +-
 net/x25/Kconfig               |    2 +-
 sound/oss/Kconfig             |    2 +-
 41 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index f09fc0e..b1d4c57 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -129,7 +129,7 @@ config SERIAL_NONSTANDARD
 
 config COMPUTONE
 	tristate "Computone IntelliPort Plus serial support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI) && BKL
 	---help---
 	  This driver supports the entire family of Intelliport II/Plus
 	  controllers with the exception of the MicroChannel controllers and
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 88910e5..f59e263 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
 #
 menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
-	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
+	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU && BKL
 	select I2C
 	select I2C_ALGOBIT
 	select SLOW_WORK
@@ -72,7 +72,7 @@ source "drivers/gpu/drm/radeon/Kconfig"
 
 config DRM_I810
 	tristate "Intel I810"
-	depends on DRM && AGP && AGP_INTEL
+	depends on DRM && AGP && AGP_INTEL && BKL
 	help
 	  Choose this option if you have an Intel I810 graphics card.  If M is
 	  selected, the module will be called i810.  AGP support is required
@@ -85,6 +85,7 @@ choice
 
 config DRM_I830
 	tristate "i830 driver"
+	depends on BKL
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
 	  852GM, 855GM or 865G integrated graphics.  If M is selected, the
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 4edb3be..deee423 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -4,7 +4,7 @@ comment "USB Input Devices"
 config USB_HID
 	tristate "USB Human Interface Device (full HID) support"
 	default y
-	depends on USB && INPUT
+	depends on USB && INPUT && BKL
 	select HID
 	---help---
 	  Say Y here if you want full HID support to connect USB keyboards,
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 4fb6016..ecf58c5 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -22,6 +22,7 @@ if ISDN
 
 menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
+	depends on BKL
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index a168e8a..bb40d8d 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -35,7 +35,7 @@ config ISDN_CAPI_CAPI20
 
 config ISDN_CAPI_CAPIFS_BOOL
 	bool "CAPI2.0 filesystem support (DEPRECATED)"
-	depends on ISDN_CAPI_MIDDLEWARE && ISDN_CAPI_CAPI20
+	depends on ISDN_CAPI_MIDDLEWARE && ISDN_CAPI_CAPI20 && BKL
 	help
 	  This option provides a special file system, similar to /dev/pts with
 	  device nodes for the special ttys established by using the
diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 1747a02..ba4fbd9 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig MISDN
 	tristate "Modular ISDN driver"
+	depends on BKL
 	help
 	  Enable support for the modular ISDN driver.
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a28541b..95d2a8b 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -19,6 +19,7 @@ comment "Multimedia core support"
 
 config VIDEO_DEV
 	tristate "Video For Linux"
+	depends on BKL
 	---help---
 	  V4L core support for video capture and overlay devices, webcams and
 	  AM/FM radio cards.
@@ -75,7 +76,7 @@ config VIDEO_V4L1_COMPAT
 
 config DVB_CORE
 	tristate "DVB for Linux"
-	depends on NET && INET
+	depends on NET && INET && BKL
 	select CRC32
 	help
 	  DVB core utility functions for device handling, software fallbacks etc.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 26386a9..a79d8d2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -263,7 +263,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on X86_UV && SMP
+	depends on X86_UV && SMP && BKL
 	default n
 	select MMU_NOTIFIER
 	---help---
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 0a0e0cd..04fa1e7 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -3,6 +3,7 @@
 #
 config ATALK
 	tristate "Appletalk protocol support"
+	depends on BKL
 	select LLC
 	---help---
 	  AppleTalk is the protocol that Apple computers can use to communicate
diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 73cde85..b0272e2 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -31,7 +31,7 @@ config TADPOLE_TS102_UCTRL
 
 config SUN_JSFLASH
 	tristate "JavaStation OS Flash SIMM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	depends on EXPERIMENTAL && SPARC32 && BKL
 	help
 	  If you say Y here, you will be able to boot from your JavaStation's
 	  Flash memory.
diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 0a9c39c..ae1e181 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -1,7 +1,7 @@
 config DX_SEP
 	tristate "Discretix SEP driver"
 #	depends on MRST
-	depends on RAR_REGISTER && PCI
+	depends on RAR_REGISTER && PCI && BKL
 	default y
 	help
 	  Discretix SEP driver
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 2c1d10a..b11ec37 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,6 +1,6 @@
 config USB_IP_COMMON
 	tristate "USB IP support (EXPERIMENTAL)"
-	depends on USB && NET && EXPERIMENTAL
+	depends on USB && NET && EXPERIMENTAL && BKL
 	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 649c0c5..94500dc 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -696,7 +696,7 @@ config USB_ETH_EEM
 
 config USB_GADGETFS
 	tristate "Gadget Filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && BKL
 	help
 	  This driver provides a filesystem based API that lets user mode
 	  programs implement a single-configuration USB device, including
diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..d72c786 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,7 @@
 config ADFS_FS
 	tristate "ADFS file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
+	depends on BKL
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 5c4e61d..0874017 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,6 +1,7 @@
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
+	depends on BKL
 	select AF_RXRPC
 	help
 	  If you say Y here, you will get an experimental Andrew File System
diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
index 5f3bea9..9126a42 100644
--- a/fs/autofs/Kconfig
+++ b/fs/autofs/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS_FS
 	tristate "Kernel automounter support"
+	depends on BKL
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..06831b5 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS4_FS
 	tristate "Kernel automounter version 4 support (also supports v3)"
+	depends on BKL
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/coda/Kconfig b/fs/coda/Kconfig
index c0e5a7f..8689de8 100644
--- a/fs/coda/Kconfig
+++ b/fs/coda/Kconfig
@@ -1,6 +1,7 @@
 config CODA_FS
 	tristate "Coda file system support (advanced network fs)"
 	depends on INET
+	depends on BKL
 	help
 	  Coda is an advanced network file system, similar to NFS in that it
 	  enables you to mount file systems of a remote server and access them
diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index 1cd6d9d..2e8660f 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,7 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && KEYS && CRYPTO
+	depends on BKL
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index 182f9ff..c4777ea 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -34,6 +34,7 @@ config FAT_FS
 
 config MSDOS_FS
 	tristate "MSDOS fs support"
+	depends on BKL
 	select FAT_FS
 	help
 	  This allows you to mount MSDOS partitions of your hard drive (unless
@@ -59,6 +60,7 @@ config MSDOS_FS
 
 config VFAT_FS
 	tristate "VFAT (Windows-95) fs support"
+	depends on BKL
 	select FAT_FS
 	help
 	  This option provides support for normal Windows file systems with
diff --git a/fs/freevxfs/Kconfig b/fs/freevxfs/Kconfig
index 8dc1cd5..aba5cb5 100644
--- a/fs/freevxfs/Kconfig
+++ b/fs/freevxfs/Kconfig
@@ -1,6 +1,7 @@
 config VXFS_FS
 	tristate "FreeVxFS file system support (VERITAS VxFS(TM) compatible)"
 	depends on BLOCK
+	depends on BKL
 	help
 	  FreeVxFS is a file system driver that support the VERITAS VxFS(TM)
 	  file system format.  VERITAS VxFS(TM) is the standard file system
diff --git a/fs/hpfs/Kconfig b/fs/hpfs/Kconfig
index 56bd15c..1012579 100644
--- a/fs/hpfs/Kconfig
+++ b/fs/hpfs/Kconfig
@@ -1,6 +1,7 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
+	depends on BKL
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
diff --git a/fs/isofs/Kconfig b/fs/isofs/Kconfig
index 8ab9878..2c45a34 100644
--- a/fs/isofs/Kconfig
+++ b/fs/isofs/Kconfig
@@ -1,5 +1,6 @@
 config ISO9660_FS
 	tristate "ISO 9660 CDROM file system support"
+	depends on BKL
 	help
 	  This is the standard file system used on CD-ROMs.  It was previously
 	  known as "High Sierra File System" and is called "hsfs" on other
diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
index 6ae169c..d13b148 100644
--- a/fs/jffs2/Kconfig
+++ b/fs/jffs2/Kconfig
@@ -1,6 +1,7 @@
 config JFFS2_FS
 	tristate "Journalling Flash File System v2 (JFFS2) support"
 	select CRC32
+	depends on BKL
 	depends on MTD
 	help
 	  JFFS2 is the second generation of the Journalling Flash File System
diff --git a/fs/ncpfs/Kconfig b/fs/ncpfs/Kconfig
index c931cf2..d0ed28d 100644
--- a/fs/ncpfs/Kconfig
+++ b/fs/ncpfs/Kconfig
@@ -3,6 +3,7 @@
 #
 config NCP_FS
 	tristate "NCP file system support (to mount NetWare volumes)"
+	depends on BKL
 	depends on IPX!=n || INET
 	help
 	  NCP (NetWare Core Protocol) is a protocol that runs over IPX and is
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index a43d07e..16ab92c 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -1,6 +1,6 @@
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET && FILE_LOCKING
+	depends on INET && FILE_LOCKING && BKL
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 503b9da..afdf7ce 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -2,6 +2,7 @@ config NFSD
 	tristate "NFS server support"
 	depends on INET
 	depends on FILE_LOCKING
+	depends on BKL
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 0d84066..11b66d0 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,5 +1,6 @@
 config OCFS2_FS
 	tristate "OCFS2 file system support"
+	depends on BKL
 	depends on NET && SYSFS
 	select CONFIGFS_FS
 	select JBD2
diff --git a/fs/qnx4/Kconfig b/fs/qnx4/Kconfig
index 5f60899..4fae4a9 100644
--- a/fs/qnx4/Kconfig
+++ b/fs/qnx4/Kconfig
@@ -1,5 +1,6 @@
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
+	depends on BKL
 	depends on BLOCK
 	help
 	  This is the file system used by the real-time operating systems
diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..d9ac7c5 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -1,5 +1,6 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
+	depends on BKL
 	select CRC32
 	help
 	  Stores not just filenames but the files themselves in a balanced
diff --git a/fs/smbfs/Kconfig b/fs/smbfs/Kconfig
index e668127..5361221 100644
--- a/fs/smbfs/Kconfig
+++ b/fs/smbfs/Kconfig
@@ -1,5 +1,6 @@
 config SMB_FS
 	tristate "SMB file system support (OBSOLETE, please use CIFS)"
+	depends on BKL
 	depends on INET
 	select NLS
 	help
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index cc6ce8a..26fcaf3 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,6 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/udf/Kconfig b/fs/udf/Kconfig
index 0e0e99b..b344257 100644
--- a/fs/udf/Kconfig
+++ b/fs/udf/Kconfig
@@ -1,5 +1,6 @@
 config UDF_FS
 	tristate "UDF file system support"
+	depends on BKL
 	select CRC_ITU_T
 	help
 	  This is the new file system used on some CD-ROMs and DVDs. Say Y if
diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index e4f10a4..7f1410f 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -1,6 +1,6 @@
 config UFS_FS
 	tristate "UFS file system support (read only)"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	help
 	  BSD and derivate versions of Unix (such as SunOS, FreeBSD, NetBSD,
 	  OpenBSD and NeXTstep) use a file system called UFS. Some System V
diff --git a/init/Kconfig b/init/Kconfig
index 2cce9f3..e44b0c9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -64,7 +64,7 @@ config BROKEN_ON_SMP
 
 config LOCK_KERNEL
 	bool
-	depends on SMP || PREEMPT
+	depends on (SMP || PREEMPT) && BKL
 	default y
 
 config INIT_ENV_ARG_LIMIT
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..8240de9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -424,7 +424,7 @@ config DEBUG_PI_LIST
 
 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
-	depends on DEBUG_KERNEL && RT_MUTEXES
+	depends on DEBUG_KERNEL && RT_MUTEXES && BKL = y
 	help
 	  This option enables a rt-mutex tester.
 
@@ -444,6 +444,15 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config BKL
+	tristate "Big Kernel Lock" if SMP || PREEMPT
+	default y
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  Say Y here unless you are working on removing the BKL.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
diff --git a/net/ipx/Kconfig b/net/ipx/Kconfig
index e9ad006..45b232e 100644
--- a/net/ipx/Kconfig
+++ b/net/ipx/Kconfig
@@ -3,6 +3,7 @@
 #
 config IPX
 	tristate "The IPX protocol"
+	depends on BKL
 	select LLC
 	---help---
 	  This is support for the Novell networking protocol, IPX, commonly
diff --git a/net/irda/Kconfig b/net/irda/Kconfig
index c8671a7..b92874b 100644
--- a/net/irda/Kconfig
+++ b/net/irda/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig IRDA
-	depends on NET && !S390
+	depends on NET && !S390 && BKL
 	tristate "IrDA (infrared) subsystem support"
 	select CRC_CCITT
 	---help---
diff --git a/net/irda/irnet/Kconfig b/net/irda/irnet/Kconfig
index 28c557f..4646380 100644
--- a/net/irda/irnet/Kconfig
+++ b/net/irda/irnet/Kconfig
@@ -1,6 +1,6 @@
 config IRNET
 	tristate "IrNET protocol"
-	depends on IRDA && PPP
+	depends on IRDA && PPP && BKL
 	help
 	  Say Y here if you want to build support for the IrNET protocol.
 	  To compile it as a module, choose M here: the module will be
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..71f3164 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -4,7 +4,7 @@
 
 config X25
 	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && BKL
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index a513651..9552197 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -253,7 +253,7 @@ config MSND_FIFOSIZE
 
 menuconfig SOUND_OSS
 	tristate "OSS sound modules"
-	depends on ISA_DMA_API && VIRT_TO_BUS
+	depends on ISA_DMA_API && VIRT_TO_BUS && BKL
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
-- 
1.7.0.4

