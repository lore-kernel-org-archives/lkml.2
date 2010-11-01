Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0KASlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:41:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62766 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0KASle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LtyuvL6ozmxlEdjHKu//hJ6D9OhGimSE0Nr54xlF+WbqM3KScWg2wO4AW8/J0lnzgX
         lLkQ5GGqbFgiR/1NkjfSEofSuF5RA7LXBYHNGDT6mmAz1QQW5M48fQFd3k5znTLLpGSl
         DYoBbmK6Kl/htXnTOOvUzxKDLu9VqCt3CILog=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/29] Staging: yaffs2: Add Makefile and Kconfig files
Date: Mon,  1 Nov 2010 14:40:50 -0400
Message-Id: <1288636877-7964-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Makefile and Kconfig files so that we can start to compile the
filesystem.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/Kconfig  |  190 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/Makefile |   18 ++++
 2 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/Kconfig
 create mode 100644 drivers/staging/yaffs2/Makefile

diff --git a/drivers/staging/yaffs2/Kconfig b/drivers/staging/yaffs2/Kconfig
new file mode 100644
index 0000000..7b3988c
--- /dev/null
+++ b/drivers/staging/yaffs2/Kconfig
@@ -0,0 +1,190 @@
+#
+# YAFFS file system configurations
+#
+
+config YAFFS_FS
+	tristate "YAFFS2 file system support"
+	default n
+	depends on MTD_BLOCK
+	select YAFFS_YAFFS1
+	select YAFFS_YAFFS2
+	help
+	  YAFFS2, or Yet Another Flash Filing System, is a filing system
+	  optimised for NAND Flash chips.
+
+	  To compile the YAFFS2 file system support as a module, choose M
+	  here: the module will be called yaffs2.
+
+	  If unsure, say N.
+
+	  Further information on YAFFS2 is available at
+	  <http://www.aleph1.co.uk/yaffs/>.
+
+config YAFFS_YAFFS1
+	bool "512 byte / page devices"
+	depends on YAFFS_FS
+	default y
+	help
+	  Enable YAFFS1 support -- yaffs for 512 byte / page devices
+
+	  Not needed for 2K-page devices.
+
+	  If unsure, say Y.
+
+config YAFFS_9BYTE_TAGS
+	bool "Use older-style on-NAND data format with pageStatus byte"
+	depends on YAFFS_YAFFS1
+	default n
+	help
+
+	  Older-style on-NAND data format has a "pageStatus" byte to record
+	  chunk/page state.  This byte is zero when the page is discarded.
+	  Choose this option if you have existing on-NAND data using this
+	  format that you need to continue to support.  New data written
+	  also uses the older-style format.  Note: Use of this option
+	  generally requires that MTD's oob layout be adjusted to use the
+	  older-style format.  See notes on tags formats and MTD versions
+	  in yaffs_mtdif1.c.
+
+	  If unsure, say N.
+
+config YAFFS_DOES_ECC
+	bool "Lets Yaffs do its own ECC"
+	depends on YAFFS_FS && YAFFS_YAFFS1 && !YAFFS_9BYTE_TAGS
+	default n
+	help
+	  This enables Yaffs to use its own ECC functions instead of using
+	  the ones from the generic MTD-NAND driver.
+
+	  If unsure, say N.
+
+config YAFFS_ECC_WRONG_ORDER
+	bool "Use the same ecc byte order as Steven Hill's nand_ecc.c"
+	depends on YAFFS_FS && YAFFS_DOES_ECC && !YAFFS_9BYTE_TAGS
+	default n
+	help
+	  This makes yaffs_ecc.c use the same ecc byte order as Steven
+	  Hill's nand_ecc.c. If not set, then you get the same ecc byte
+	  order as SmartMedia.
+
+	  If unsure, say N.
+
+config YAFFS_YAFFS2
+	bool "2048 byte (or larger) / page devices"
+	depends on YAFFS_FS
+	default y
+	help
+	  Enable YAFFS2 support -- yaffs for >= 2K bytes per page devices
+
+	  If unsure, say Y.
+
+config YAFFS_AUTO_YAFFS2
+	bool "Autoselect yaffs2 format"
+	depends on YAFFS_YAFFS2
+	default y
+	help
+	  Without this, you need to explicitely use yaffs2 as the file
+	  system type. With this, you can say "yaffs" and yaffs or yaffs2
+	  will be used depending on the device page size (yaffs on
+	  512-byte page devices, yaffs2 on 2K page devices).
+
+	  If unsure, say Y.
+
+config YAFFS_DISABLE_TAGS_ECC
+	bool "Disable YAFFS from doing ECC on tags by default"
+	depends on YAFFS_FS && YAFFS_YAFFS2
+	default n
+	help
+	  This defaults Yaffs to using its own ECC calculations on tags instead of
+	  just relying on the MTD.
+	  This behavior can also be overridden with tags_ecc_on and
+	  tags_ecc_off mount options.
+
+	  If unsure, say N.
+
+
+config YAFFS_DISABLE_WIDE_TNODES
+	bool "Turn off wide tnodes"
+	depends on YAFFS_FS
+	default n
+	help
+	  Wide tnodes are only used for NAND arrays >=32MB for 512-byte
+	  page devices and >=128MB for 2k page devices. They use slightly
+	  more RAM but are faster since they eliminate chunk group
+	  searching.
+
+	  Setting this to 'y' will force tnode width to 16 bits and save
+	  memory but make large arrays slower.
+
+	  If unsure, say N.
+
+config YAFFS_ALWAYS_CHECK_CHUNK_ERASED
+	bool "Force chunk erase check"
+	depends on YAFFS_FS
+	default n
+	help
+          Normally YAFFS only checks chunks before writing until an erased
+	  chunk is found. This helps to detect any partially written
+	  chunks that might have happened due to power loss.
+
+	  Enabling this forces on the test that chunks are erased in flash
+	  before writing to them. This takes more time but is potentially
+	  a bit more secure.
+
+	  Suggest setting Y during development and ironing out driver
+	  issues etc. Suggest setting to N if you want faster writing.
+
+	  If unsure, say Y.
+
+config YAFFS_SHORT_NAMES_IN_RAM
+	bool "Cache short names in RAM"
+	depends on YAFFS_FS
+	default y
+	help
+	  If this config is set, then short names are stored with the
+	  yaffs_Object.  This costs an extra 16 bytes of RAM per object,
+	  but makes look-ups faster.
+
+	  If unsure, say Y.
+
+config YAFFS_EMPTY_LOST_AND_FOUND
+	bool "Empty lost and found on boot"
+	depends on YAFFS_FS
+	default n
+	help
+	  If this is enabled then the contents of lost and found is
+	  automatically dumped at mount.
+
+	  If unsure, say N.
+
+config YAFFS_DISABLE_BLOCK_REFRESHING
+	bool "Disable yaffs2 block refreshing"
+	depends on YAFFS_FS
+	default n
+	help
+	 If this is set, then block refreshing is disabled.
+	 Block refreshing infrequently refreshes the oldest block in
+	 a yaffs2 file system. This mechanism helps to refresh flash to
+	 mitigate against data loss. This is particularly useful for MLC.
+
+	  If unsure, say N.
+
+config YAFFS_DISABLE_BACKGROUND
+	bool "Disable yaffs2 background processing"
+	depends on YAFFS_FS
+	default n
+	help
+	 If this is set, then background processing is disabled.
+	 Background processing makes many foreground activities faster.
+
+	  If unsure, say N.
+
+config YAFFS_XATTR
+	bool "Enable yaffs2 xattr support"
+	depends on YAFFS_FS
+	default y
+	help
+	 If this is set then yaffs2 will provide xattr support.
+	 If unsure, say Y.
+
+
diff --git a/drivers/staging/yaffs2/Makefile b/drivers/staging/yaffs2/Makefile
new file mode 100644
index 0000000..ac4a72d
--- /dev/null
+++ b/drivers/staging/yaffs2/Makefile
@@ -0,0 +1,18 @@
+#
+# Makefile for the linux YAFFS filesystem routines.
+#
+
+obj-$(CONFIG_YAFFS_FS) += yaffs.o
+
+yaffs-y := yaffs_ecc.o yaffs_vfs_glue.o yaffs_guts.o yaffs_checkptrw.o
+yaffs-y += yaffs_packedtags1.o yaffs_packedtags2.o yaffs_nand.o
+yaffs-y += yaffs_tagscompat.o yaffs_tagsvalidity.o
+yaffs-y += yaffs_mtdif.o yaffs_mtdif1.o yaffs_mtdif2.o
+yaffs-y += yaffs_nameval.o
+yaffs-y += yaffs_allocator.o
+yaffs-y += yaffs_yaffs1.o
+yaffs-y += yaffs_yaffs2.o
+yaffs-y += yaffs_bitmap.o
+yaffs-y += yaffs_verify.o
+
+
-- 
1.7.3.2.146.gca209

