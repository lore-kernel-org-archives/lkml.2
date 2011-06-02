Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1FBWFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:05:25 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:28540 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab1FBWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:05:23 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1307052292!4544061!31
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] fs: introduce a default_open for simple f_op->open use
Date: Thu, 2 Jun 2011 15:04:54 -0700
User-Agent: KMail/1.9.9
CC: <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <matthew@wil.cx>, <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        <robert.richter@amd.com>, <gregkh@suse.de>, <jmorris@namei.org>,
        <npiggin@kernel.dk>, <ak@linux.intel.com>, <dchinner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106021504.55799.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many f_op->open implementations that simply do:

	file->private_data = inode->i_private;

This introduces a new global symbol, default_open, that can be
used instead of the private implementations.

This also removes a couple private implementations that share the
same symbol name.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Morris <jmorris@namei.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <dchinner@redhat.com>

---

If this patch looks reasonable, I have some additional patches that
convert all other similar f_op->open implemenations to use default_open
tree wide.  The full diffstat looks like this:

 arch/arm/mach-msm/smd_debug.c                  |    8 +-----
 arch/arm/plat-mxc/audmux-v2.c                  |    8 +-----
 arch/arm/plat-omap/iommu-debug.c               |   10 +------
 arch/x86/kernel/kdebugfs.c                     |    9 +------
 drivers/acpi/ec_sys.c                          |    8 +-----
 drivers/bluetooth/btmrvl_debugfs.c             |   26 +++++++------------
 drivers/char/virtio_console.c                  |    8 +-----
 drivers/dma/coh901318.c                        |    9 +------
 drivers/gpu/drm/i915/i915_debugfs.c            |   10 +------
 drivers/hid/hid-picolcd.c                      |   15 +---------
 drivers/idle/i7300_idle.c                      |    8 +-----
 drivers/mfd/ab3100-core.c                      |    8 +-----
 drivers/misc/ibmasm/ibmasmfs.c                 |   10 +------
 drivers/mtd/ubi/debug.c                        |    8 ------
 drivers/net/caif/caif_spi.c                    |   10 +------
 drivers/net/cxgb4/cxgb4_main.c                 |    8 +-----
 drivers/net/wimax/i2400m/debugfs.c             |   14 +---------
 drivers/net/wireless/ath/ath5k/debug.c         |   23 ++++++-----------
 drivers/net/wireless/ath/ath9k/debug.c         |   32 +++++++++--------------
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   26 +++++++------------
 drivers/net/wireless/ath/ath9k/rc.c            |    8 +-----
 drivers/net/wireless/ath/carl9170/debug.c      |    8 +-----
 drivers/net/wireless/b43/debugfs.c             |    8 +-----
 drivers/net/wireless/b43legacy/debugfs.c       |    8 +-----
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c    |    8 +-----
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c    |   11 ++------
 drivers/net/wireless/iwlegacy/iwl-debugfs.c    |   13 ++-------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   11 ++------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   12 ++------
 drivers/net/wireless/iwmc3200wifi/debugfs.c    |   15 +++--------
 drivers/net/wireless/iwmc3200wifi/sdio.c       |    8 +-----
 drivers/net/wireless/libertas/debugfs.c        |   10 +------
 drivers/net/wireless/mwifiex/debugfs.c         |   18 ++-----------
 drivers/net/wireless/wl1251/debugfs.c          |   14 +++-------
 drivers/net/wireless/wl12xx/debugfs.c          |   22 ++++++----------
 drivers/oprofile/oprofilefs.c                  |    8 ------
 drivers/spi/dw_spi.c                           |    7 +----
 drivers/tty/serial/mfd.c                       |   10 +------
 drivers/usb/core/inode.c                       |    8 ------
 drivers/usb/host/ehci-dbg.c                    |    9 +------
 drivers/uwb/uwb-debug.c                        |    9 +------
 fs/debugfs/file.c                              |    8 ------
 fs/dlm/debug_fs.c                              |    8 +-----
 fs/open.c                                      |    7 +++++
 fs/pstore/inode.c                              |    8 +-----
 include/linux/fs.h                             |    1 +
 kernel/trace/blktrace.c                        |   18 +------------
 net/mac80211/debugfs.c                         |   20 +++++---------
 net/mac80211/debugfs.h                         |    1 -
 net/mac80211/debugfs_key.c                     |    4 +-
 net/mac80211/debugfs_netdev.c                  |    2 +-
 net/mac80211/debugfs_sta.c                     |    4 +-
 net/mac80211/rate.c                            |    2 +-
 net/wireless/debugfs.c                         |   10 +------
 security/inode.c                               |    8 ------
 sound/soc/soc-core.c                           |    8 +-----
 sound/soc/soc-dapm.c                           |   16 +----------
 57 files changed, 135 insertions(+), 473 deletions(-)


diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index ab80c0d..edc2ebd 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -386,14 +386,6 @@ out:
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 /* File operations for all UBI debugfs files */
 static const struct file_operations dfs_fops = {
 	.read   = dfs_file_read,
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index e9ff6f7..7cf1e17 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -110,14 +110,6 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 }
 
 
-static int default_open(struct inode *inode, struct file *filp)
-{
-	if (inode->i_private)
-		filp->private_data = inode->i_private;
-	return 0;
-}
-
-
 static const struct file_operations ulong_fops = {
 	.read		= ulong_read_file,
 	.write		= ulong_write_file,
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 1b125c2..9451609 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -432,14 +432,6 @@ static loff_t default_file_lseek (struct file *file, loff_t offset, int orig)
 	return retval;
 }
 
-static int default_open (struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations default_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..e9ce142 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -31,14 +31,6 @@ static ssize_t default_write_file(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 const struct file_operations debugfs_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
diff --git a/fs/open.c b/fs/open.c
index b52cf01..64039ee 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -666,6 +666,13 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
+int default_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+EXPORT_SYMBOL(default_open);
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					struct file *f,
 					int (*open)(struct inode *, struct file *),
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c55d6b7..28a0720 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1989,6 +1989,7 @@ extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
 extern int do_fallocate(struct file *file, int mode, loff_t offset,
 			loff_t len);
+extern int default_open(struct inode *inode, struct file *file);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
diff --git a/security/inode.c b/security/inode.c
index c4df2fb..af659c2 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -41,14 +41,6 @@ static ssize_t default_write_file(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations default_file_ops = {
 	.read =		default_read_file,
 	.write =	default_write_file,
