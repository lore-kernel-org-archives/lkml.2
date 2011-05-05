Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1EEO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1EEO2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:28:11 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, hch@infradead.org
Subject: [PATCH] fs: kill default_llseek
Date: Thu,  5 May 2011 10:27:57 -0400
Message-Id: <1304605677-1882-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this llseek stuff I noticed that default_llseek is the exact same as
generic_file_llseek, so kill default_llseek.  I patched this using spatch with
just a simple

@@
@@

- default_llseek
+ generic_file_llseek

and then I manually removed the default_llseek definitions.  I've built and
booted this and it works fine.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 arch/arm/mach-msm/last_radio_log.c            |    2 +-
 arch/arm/mach-msm/smd_debug.c                 |    2 +-
 arch/arm/plat-mxc/audmux-v2.c                 |    2 +-
 arch/cris/kernel/profile.c                    |    2 +-
 arch/ia64/kernel/salinfo.c                    |    2 +-
 arch/mips/sibyte/common/sb_tbprof.c           |    2 +-
 arch/powerpc/kernel/rtas_flash.c              |    6 ++--
 arch/powerpc/platforms/iseries/mf.c           |    2 +-
 arch/um/drivers/mmapper_kern.c                |    2 +-
 arch/x86/kernel/kdebugfs.c                    |    2 +-
 arch/x86/platform/uv/tlb_uv.c                 |    2 +-
 block/bsg.c                                   |    2 +-
 drivers/acpi/debugfs.c                        |    2 +-
 drivers/acpi/ec_sys.c                         |    2 +-
 drivers/acpi/event.c                          |    2 +-
 drivers/bluetooth/btmrvl_debugfs.c            |   20 ++++++++--------
 drivers/char/bfin-otp.c                       |    2 +-
 drivers/char/mem.c                            |    2 +-
 drivers/char/mwave/mwavedd.c                  |    2 +-
 drivers/char/raw.c                            |    2 +-
 drivers/dma/coh901318.c                       |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c           |    2 +-
 drivers/idle/i7300_idle.c                     |    2 +-
 drivers/infiniband/hw/cxgb4/device.c          |    4 +-
 drivers/infiniband/hw/ipath/ipath_diag.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_fs.c        |    6 ++--
 drivers/infiniband/hw/qib/qib_diag.c          |    2 +-
 drivers/infiniband/hw/qib/qib_fs.c            |    2 +-
 drivers/lguest/lguest_user.c                  |    2 +-
 drivers/macintosh/ans-lcd.c                   |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c           |    4 +-
 drivers/media/dvb/ttpci/av7110_ca.c           |    2 +-
 drivers/mmc/core/debugfs.c                    |    2 +-
 drivers/net/cxgb4/cxgb4_main.c                |    2 +-
 drivers/net/wimax/i2400m/debugfs.c            |    4 +-
 drivers/net/wireless/airo.c                   |   16 ++++++------
 drivers/net/wireless/ath/ath5k/debug.c        |   12 +++++-----
 drivers/net/wireless/ath/ath9k/debug.c        |   26 ++++++++++----------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 ++--
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c   |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    6 ++--
 drivers/net/wireless/iwmc3200wifi/debugfs.c   |    8 +++---
 drivers/net/wireless/iwmc3200wifi/sdio.c      |    2 +-
 drivers/net/wireless/libertas/debugfs.c       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c     |    8 +++---
 drivers/net/wireless/wl12xx/debugfs.c         |    4 +-
 drivers/oprofile/oprofile_files.c             |   10 ++++----
 drivers/oprofile/oprofilefs.c                 |    6 ++--
 drivers/spi/dw_spi.c                          |    2 +-
 drivers/staging/panel/panel.c                 |    2 +-
 drivers/staging/tty/istallion.c               |    2 +-
 drivers/telephony/ixj.c                       |    2 +-
 drivers/tty/serial/mfd.c                      |    4 +-
 drivers/usb/class/usbtmc.c                    |    2 +-
 drivers/usb/host/ehci-dbg.c                   |    6 ++--
 drivers/usb/host/ohci-dbg.c                   |    6 ++--
 drivers/usb/misc/idmouse.c                    |    2 +-
 drivers/usb/misc/yurex.c                      |    2 +-
 drivers/video/fbmem.c                         |    2 +-
 drivers/video/mbx/mbxdebugfs.c                |   12 +++++-----
 drivers/xen/xenfs/super.c                     |    2 +-
 fs/binfmt_misc.c                              |    4 +-
 fs/debugfs/file.c                             |    4 +-
 fs/dlm/debug_fs.c                             |    2 +-
 fs/ecryptfs/file.c                            |    2 +-
 fs/gfs2/file.c                                |    4 +-
 fs/hppfs/hppfs.c                              |    4 +-
 fs/hugetlbfs/inode.c                          |    2 +-
 fs/logfs/dir.c                                |    2 +-
 fs/nfsd/nfsctl.c                              |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c                        |    2 +-
 fs/ocfs2/stack_user.c                         |    2 +-
 fs/proc/base.c                                |   14 +++++-----
 fs/proc/inode.c                               |    2 +-
 fs/proc/kcore.c                               |    2 +-
 fs/proc/proc_sysctl.c                         |    2 +-
 fs/proc/root.c                                |    2 +-
 fs/proc/vmcore.c                              |    2 +-
 fs/pstore/inode.c                             |    2 +-
 fs/read_write.c                               |   30 -------------------------
 fs/romfs/super.c                              |    2 +-
 fs/squashfs/dir.c                             |    2 +-
 fs/ubifs/debug.c                              |    2 +-
 include/linux/fs.h                            |    2 -
 ipc/mqueue.c                                  |    2 +-
 kernel/configs.c                              |    2 +-
 kernel/kprobes.c                              |    2 +-
 kernel/profile.c                              |    2 +-
 kernel/trace/blktrace.c                       |    2 +-
 kernel/trace/ftrace.c                         |    2 +-
 kernel/trace/ring_buffer.c                    |    2 +-
 kernel/trace/trace_events.c                   |   12 +++++-----
 kernel/trace/trace_stack.c                    |    2 +-
 lib/dma-debug.c                               |    2 +-
 net/mac80211/debugfs.c                        |   12 +++++-----
 net/mac80211/rate.c                           |    2 +-
 net/mac80211/rc80211_minstrel_debugfs.c       |    2 +-
 net/wireless/debugfs.c                        |    2 +-
 security/apparmor/apparmorfs.c                |    6 ++--
 security/smack/smackfs.c                      |   10 ++++----
 sound/soc/soc-core.c                          |    8 +++---
 sound/soc/soc-dapm.c                          |    2 +-
 103 files changed, 199 insertions(+), 231 deletions(-)

diff --git a/arch/arm/mach-msm/last_radio_log.c b/arch/arm/mach-msm/last_radio_log.c
index 1e243f4..97cff04 100644
--- a/arch/arm/mach-msm/last_radio_log.c
+++ b/arch/arm/mach-msm/last_radio_log.c
@@ -49,7 +49,7 @@ static ssize_t last_radio_log_read(struct file *file, char __user *buf,
 
 static struct file_operations last_radio_log_fops = {
 	.read = last_radio_log_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 void msm_init_last_radio_log(struct module *owner)
diff --git a/arch/arm/mach-msm/smd_debug.c b/arch/arm/mach-msm/smd_debug.c
index 8736aff..817dd07 100644
--- a/arch/arm/mach-msm/smd_debug.c
+++ b/arch/arm/mach-msm/smd_debug.c
@@ -212,7 +212,7 @@ static int debug_open(struct inode *inode, struct file *file)
 static const struct file_operations debug_ops = {
 	.read = debug_read,
 	.open = debug_open,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void debug_create(const char *name, mode_t mode,
diff --git a/arch/arm/plat-mxc/audmux-v2.c b/arch/arm/plat-mxc/audmux-v2.c
index 175e364..82f5d40 100644
--- a/arch/arm/plat-mxc/audmux-v2.c
+++ b/arch/arm/plat-mxc/audmux-v2.c
@@ -137,7 +137,7 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
 static const struct file_operations audmux_debugfs_fops = {
 	.open = audmux_open_file,
 	.read = audmux_read_file,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void audmux_debugfs_init(void)
diff --git a/arch/cris/kernel/profile.c b/arch/cris/kernel/profile.c
index b82e086..50d3800 100644
--- a/arch/cris/kernel/profile.c
+++ b/arch/cris/kernel/profile.c
@@ -59,7 +59,7 @@ write_cris_profile(struct file *file, const char __user *buf,
 static const struct file_operations cris_proc_profile_operations = {
 	.read		= read_cris_profile,
 	.write		= write_cris_profile,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init init_cris_profile(void)
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 79802e5..9f0caae 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -572,7 +572,7 @@ static const struct file_operations salinfo_data_fops = {
 	.release = salinfo_log_release,
 	.read    = salinfo_log_read,
 	.write   = salinfo_log_write,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static int __cpuinit
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 48853ab..f0428b7 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -544,7 +544,7 @@ static const struct file_operations sbprof_tb_fops = {
 	.unlocked_ioctl	= sbprof_tb_ioctl,
 	.compat_ioctl	= sbprof_tb_ioctl,
 	.mmap		= NULL,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct class *tb_class;
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index bf5f5ce..3eb1bf1 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -675,7 +675,7 @@ static const struct file_operations rtas_flash_operations = {
 	.write		= rtas_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_flash_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations manage_flash_operations = {
@@ -684,7 +684,7 @@ static const struct file_operations manage_flash_operations = {
 	.write		= manage_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_excl_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations validate_flash_operations = {
@@ -693,7 +693,7 @@ static const struct file_operations validate_flash_operations = {
 	.write		= validate_flash_write,
 	.open		= rtas_excl_open,
 	.release	= validate_flash_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init rtas_flash_init(void)
diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 62dabe3..b0c5feb 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -1187,7 +1187,7 @@ out:
 
 static const struct file_operations proc_vmlinux_operations = {
 	.write		= proc_mf_change_vmlinux,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init mf_proc_init(void)
diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 7e0619c..404134e 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -87,7 +87,7 @@ static const struct file_operations mmapper_fops = {
 	.mmap		= mmapper_mmap,
 	.open		= mmapper_open,
 	.release	= mmapper_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 90fcf62..4b225da 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -78,7 +78,7 @@ static int setup_data_open(struct inode *inode, struct file *file)
 static const struct file_operations fops_setup_data = {
 	.read		= setup_data_read,
 	.open		= setup_data_open,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 7cb6424..1512342 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1291,7 +1291,7 @@ static const struct file_operations tunables_fops = {
 	.open		= tunables_open,
 	.read		= tunables_read,
 	.write		= tunables_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int __init uv_ptc_init(void)
diff --git a/block/bsg.c b/block/bsg.c
index 0c8b64a..21804a0 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -973,7 +973,7 @@ static const struct file_operations bsg_fops = {
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
 	.owner		=	THIS_MODULE,
-	.llseek		=	default_llseek,
+	.llseek		=	generic_file_llseek,
 };
 
 void bsg_unregister_queue(struct request_queue *q)
diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
index 384f7ab..cf53b31 100644
--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -77,7 +77,7 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 
 static const struct file_operations cm_fops = {
 	.write = cm_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 int __init acpi_debugfs_init(void)
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 05b4420..340f041 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -97,7 +97,7 @@ static struct file_operations acpi_ec_io_ops = {
 	.open  = acpi_ec_open_io,
 	.read  = acpi_ec_read_io,
 	.write = acpi_ec_write_io,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index 85d9089..2298b4e 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -110,7 +110,7 @@ static const struct file_operations acpi_system_event_ops = {
 	.read = acpi_system_read_event,
 	.release = acpi_system_close_event,
 	.poll = acpi_system_poll_event,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 #endif	/* CONFIG_ACPI_PROC_EVENT */
 
diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index fd6305b..91e1c06 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -92,7 +92,7 @@ static const struct file_operations btmrvl_hscfgcmd_fops = {
 	.read	= btmrvl_hscfgcmd_read,
 	.write	= btmrvl_hscfgcmd_write,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_psmode_write(struct file *file, const char __user *ubuf,
@@ -131,7 +131,7 @@ static const struct file_operations btmrvl_psmode_fops = {
 	.read	= btmrvl_psmode_read,
 	.write	= btmrvl_psmode_write,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_pscmd_write(struct file *file, const char __user *ubuf,
@@ -175,7 +175,7 @@ static const struct file_operations btmrvl_pscmd_fops = {
 	.read = btmrvl_pscmd_read,
 	.write = btmrvl_pscmd_write,
 	.open = btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_gpiogap_write(struct file *file, const char __user *ubuf,
@@ -214,7 +214,7 @@ static const struct file_operations btmrvl_gpiogap_fops = {
 	.read	= btmrvl_gpiogap_read,
 	.write	= btmrvl_gpiogap_write,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_hscmd_write(struct file *file, const char __user *ubuf,
@@ -256,7 +256,7 @@ static const struct file_operations btmrvl_hscmd_fops = {
 	.read	= btmrvl_hscmd_read,
 	.write	= btmrvl_hscmd_write,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_hsmode_write(struct file *file, const char __user *ubuf,
@@ -294,7 +294,7 @@ static const struct file_operations btmrvl_hsmode_fops = {
 	.read	= btmrvl_hsmode_read,
 	.write	= btmrvl_hsmode_write,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_curpsmode_read(struct file *file, char __user *userbuf,
@@ -312,7 +312,7 @@ static ssize_t btmrvl_curpsmode_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_curpsmode_fops = {
 	.read	= btmrvl_curpsmode_read,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_psstate_read(struct file *file, char __user * userbuf,
@@ -330,7 +330,7 @@ static ssize_t btmrvl_psstate_read(struct file *file, char __user * userbuf,
 static const struct file_operations btmrvl_psstate_fops = {
 	.read	= btmrvl_psstate_read,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_hsstate_read(struct file *file, char __user *userbuf,
@@ -348,7 +348,7 @@ static ssize_t btmrvl_hsstate_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_hsstate_fops = {
 	.read	= btmrvl_hsstate_read,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t btmrvl_txdnldready_read(struct file *file, char __user *userbuf,
@@ -367,7 +367,7 @@ static ssize_t btmrvl_txdnldready_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_txdnldready_fops = {
 	.read	= btmrvl_txdnldready_read,
 	.open	= btmrvl_open_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 void btmrvl_debugfs_init(struct hci_dev *hdev)
diff --git a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
index 44660f1..c76f40f 100644
--- a/drivers/char/bfin-otp.c
+++ b/drivers/char/bfin-otp.c
@@ -222,7 +222,7 @@ static const struct file_operations bfin_otp_fops = {
 	.unlocked_ioctl = bfin_otp_ioctl,
 	.read           = bfin_otp_read,
 	.write          = bfin_otp_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct miscdevice bfin_otp_misc_device = {
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 436a990..0024032 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -802,7 +802,7 @@ static const struct file_operations full_fops = {
 static const struct file_operations oldmem_fops = {
 	.read	= read_oldmem,
 	.open	= open_oldmem,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 #endif
 
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 1d82d58..85a841d 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -480,7 +480,7 @@ static const struct file_operations mwave_fops = {
 	.unlocked_ioctl	= mwave_ioctl,
 	.open		= mwave_open,
 	.release	= mwave_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b4b9d5a..871ed41 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -286,7 +286,7 @@ static const struct file_operations raw_fops = {
 	.open		= raw_open,
 	.release	= raw_release,
 	.unlocked_ioctl = raw_ioctl,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index f48e540..a236c40 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -157,7 +157,7 @@ static const struct file_operations coh901318_debugfs_status_operations = {
 	.owner		= THIS_MODULE,
 	.open		= coh901318_debugfs_open,
 	.read		= coh901318_debugfs_read,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 87c8e29..24e389d 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1247,7 +1247,7 @@ static const struct file_operations i915_wedged_fops = {
 	.open = i915_wedged_open,
 	.read = i915_wedged_read,
 	.write = i915_wedged_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* As the drm_debugfs_init() routines are called before dev->dev_private is
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index c976285..ce834b7 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -536,7 +536,7 @@ static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
 static const struct file_operations idle_fops = {
 	.open	= stats_open_generic,
 	.read	= stats_read_ul,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 struct debugfs_file_info {
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index e29172c..fe4ed0b 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -163,7 +163,7 @@ static const struct file_operations qp_debugfs_fops = {
 	.open    = qp_open,
 	.release = qp_release,
 	.read    = debugfs_read,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static int dump_stag(int id, void *p, void *data)
@@ -237,7 +237,7 @@ static const struct file_operations stag_debugfs_fops = {
 	.open    = stag_open,
 	.release = stag_release,
 	.read    = debugfs_read,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static int setup_debugfs(struct c4iw_dev *devp)
diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index daef61d..fb4cde2 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -66,7 +66,7 @@ static const struct file_operations diag_file_ops = {
 	.read = ipath_diag_read,
 	.open = ipath_diag_open,
 	.release = ipath_diag_release,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t ipath_diagpkt_write(struct file *fp,
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 31ae1b1..367cf16 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -104,7 +104,7 @@ static ssize_t atomic_stats_read(struct file *file, char __user *buf,
 
 static const struct file_operations atomic_stats_ops = {
 	.read = atomic_stats_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t atomic_counters_read(struct file *file, char __user *buf,
@@ -122,7 +122,7 @@ static ssize_t atomic_counters_read(struct file *file, char __user *buf,
 
 static const struct file_operations atomic_counters_ops = {
 	.read = atomic_counters_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t flash_read(struct file *file, char __user *buf,
@@ -227,7 +227,7 @@ bail:
 static const struct file_operations flash_ops = {
 	.read = flash_read,
 	.write = flash_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int create_device_files(struct super_block *sb,
diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 204c4dd..2ae3951 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -137,7 +137,7 @@ static const struct file_operations diag_file_ops = {
 	.read = qib_diag_read,
 	.open = qib_diag_open,
 	.release = qib_diag_release,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static atomic_t diagpkt_count = ATOMIC_INIT(0);
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index df7fa25..9b4c216 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -368,7 +368,7 @@ bail:
 static const struct file_operations flash_ops = {
 	.read = flash_read,
 	.write = flash_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int add_cntr_files(struct super_block *sb, struct qib_devdata *dd)
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 948c547..927e5df 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -514,7 +514,7 @@ static const struct file_operations lguest_fops = {
 	.release = close,
 	.write	 = write,
 	.read	 = read,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 /*
diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index 1a57e88..256d1b1 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -137,7 +137,7 @@ const struct file_operations anslcd_fops = {
 	.write		= anslcd_write,
 	.unlocked_ioctl	= anslcd_ioctl,
 	.open		= anslcd_open,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct miscdevice anslcd_dev = {
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index e4b5c03..b4534cd 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -1143,7 +1143,7 @@ static const struct file_operations dvb_demux_fops = {
 	.open = dvb_demux_open,
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static struct dvb_device dvbdev_demux = {
@@ -1213,7 +1213,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.open = dvb_dvr_open,
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static struct dvb_device dvbdev_dvr = {
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 9fc1dd0..31defea 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -353,7 +353,7 @@ static const struct file_operations dvb_ca_fops = {
 	.open		= dvb_ca_open,
 	.release	= dvb_generic_release,
 	.poll		= dvb_ca_poll,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct dvb_device dvbdev_ca = {
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 998797e..eade471 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -281,7 +281,7 @@ static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.open		= mmc_ext_csd_open,
 	.read		= mmc_ext_csd_read,
 	.release	= mmc_ext_csd_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 void mmc_add_card_debugfs(struct mmc_card *card)
diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index 5352c8a..15fd31b 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -2082,7 +2082,7 @@ static const struct file_operations mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
 	.open    = mem_open,
 	.read    = mem_read,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static void __devinit add_debugfs_mem(struct adapter *adap, const char *name,
diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 9c70b5f..1a604fc 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -119,7 +119,7 @@ const struct file_operations i2400m_rx_stats_fops = {
 	.open =		i2400m_stats_open,
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 
@@ -172,7 +172,7 @@ const struct file_operations i2400m_tx_stats_fops = {
 	.open =		i2400m_stats_open,
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4e5c7a1..5d16b60 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4419,7 +4419,7 @@ static const struct file_operations proc_statsdelta_ops = {
 	.read		= proc_read,
 	.open		= proc_statsdelta_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_stats_ops = {
@@ -4427,7 +4427,7 @@ static const struct file_operations proc_stats_ops = {
 	.read		= proc_read,
 	.open		= proc_stats_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_status_ops = {
@@ -4435,7 +4435,7 @@ static const struct file_operations proc_status_ops = {
 	.read		= proc_read,
 	.open		= proc_status_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_SSID_ops = {
@@ -4444,7 +4444,7 @@ static const struct file_operations proc_SSID_ops = {
 	.write		= proc_write,
 	.open		= proc_SSID_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_BSSList_ops = {
@@ -4453,7 +4453,7 @@ static const struct file_operations proc_BSSList_ops = {
 	.write		= proc_write,
 	.open		= proc_BSSList_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_APList_ops = {
@@ -4462,7 +4462,7 @@ static const struct file_operations proc_APList_ops = {
 	.write		= proc_write,
 	.open		= proc_APList_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_config_ops = {
@@ -4471,7 +4471,7 @@ static const struct file_operations proc_config_ops = {
 	.write		= proc_write,
 	.open		= proc_config_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_wepkey_ops = {
@@ -4480,7 +4480,7 @@ static const struct file_operations proc_wepkey_ops = {
 	.write		= proc_write,
 	.open		= proc_wepkey_open,
 	.release	= proc_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct proc_dir_entry *airo_entry;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 0230f30..2808212 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -269,7 +269,7 @@ static const struct file_operations fops_beacon = {
 	.write = write_file_beacon,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -369,7 +369,7 @@ static const struct file_operations fops_debug = {
 	.write = write_file_debug,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -481,7 +481,7 @@ static const struct file_operations fops_antenna = {
 	.write = write_file_antenna,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* debugfs: misc */
@@ -651,7 +651,7 @@ static const struct file_operations fops_frameerrors = {
 	.write = write_file_frameerrors,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -810,7 +810,7 @@ static const struct file_operations fops_ani = {
 	.write = write_file_ani,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -881,7 +881,7 @@ static const struct file_operations fops_queue = {
 	.write = write_file_queue,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 8df5a92..2c70393 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -84,7 +84,7 @@ static const struct file_operations fops_debug = {
 	.write = write_file_debug,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 #endif
@@ -130,7 +130,7 @@ static const struct file_operations fops_tx_chainmask = {
 	.write = write_file_tx_chainmask,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -173,7 +173,7 @@ static const struct file_operations fops_rx_chainmask = {
 	.write = write_file_rx_chainmask,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -275,7 +275,7 @@ static const struct file_operations fops_dma = {
 	.read = read_file_dma,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 
@@ -392,7 +392,7 @@ static const struct file_operations fops_interrupt = {
 	.read = read_file_interrupt,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const char *channel_type_str(enum nl80211_channel_type t)
@@ -480,7 +480,7 @@ static const struct file_operations fops_wiphy = {
 	.read = read_file_wiphy,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 #define PR_QNUM(_n) sc->tx.txq_map[_n]->axq_qnum
@@ -819,21 +819,21 @@ static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations fops_stations = {
 	.read = read_file_stations,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
@@ -956,7 +956,7 @@ static const struct file_operations fops_recv = {
 	.read = read_file_recv,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
@@ -995,7 +995,7 @@ static const struct file_operations fops_regidx = {
 	.write = write_file_regidx,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t read_file_regval(struct file *file, char __user *user_buf,
@@ -1038,7 +1038,7 @@ static const struct file_operations fops_regval = {
 	.write = write_file_regval,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 #define REGDUMP_LINE_SIZE	20
@@ -1074,7 +1074,7 @@ static const struct file_operations fops_regdump = {
 	.read = ath9k_debugfs_read_buf,
 	.release = ath9k_debugfs_release_buf,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,/* read accesses f_pos */
+	.llseek = generic_file_llseek,/* read accesses f_pos */
 };
 
 int ath9k_init_debug(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index db8c0c0..d2b364c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -772,7 +772,7 @@ static const struct file_operations fops_tgt_stats = {
 	.read = read_file_tgt_stats,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
@@ -821,7 +821,7 @@ static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
@@ -851,7 +851,7 @@ static const struct file_operations fops_recv = {
 	.read = read_file_recv,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 int ath9k_htc_init_debug(struct ath_hw *ah)
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 977bd24..c8b828a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -873,7 +873,7 @@ static ssize_t iwl3945_sta_dbgfs_stats_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = iwl3945_sta_dbgfs_stats_table_read,
 	.open = iwl3945_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void iwl3945_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 31ac672..8fe2234 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -2725,7 +2725,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = iwl4965_rs_sta_dbgfs_scale_table_write,
 	.read = iwl4965_rs_sta_dbgfs_scale_table_read,
 	.open = iwl4965_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 static ssize_t iwl4965_rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
@@ -2768,7 +2768,7 @@ static ssize_t iwl4965_rs_sta_dbgfs_stats_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = iwl4965_rs_sta_dbgfs_stats_table_read,
 	.open = iwl4965_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t iwl4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
@@ -2800,7 +2800,7 @@ static ssize_t iwl4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = iwl4965_rs_sta_dbgfs_rate_scale_data_read,
 	.open = iwl4965_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void iwl4965_rs_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index d03b473..153903f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -3206,7 +3206,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = rs_sta_dbgfs_scale_table_write,
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
@@ -3249,7 +3249,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
@@ -3281,7 +3281,7 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void rs_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 0a0cc96..a1e987e 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -402,28 +402,28 @@ static const struct file_operations iwm_debugfs_txq_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_txq_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations iwm_debugfs_tx_credit_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_tx_credit_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations iwm_debugfs_rx_ticket_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_rx_ticket_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations iwm_debugfs_fw_err_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_fw_err_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 void iwm_debugfs_init(struct iwm_priv *iwm)
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index 56383e7..91b654f 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -364,7 +364,7 @@ static const struct file_operations iwm_debugfs_sdio_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_debugfs_sdio_open,
 	.read =		iwm_debugfs_sdio_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static void if_sdio_debugfs_init(struct iwm_priv *iwm, struct dentry *parent_dir)
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index fbf3b033..f649e37 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -962,7 +962,7 @@ static const struct file_operations lbs_debug_fops = {
 	.open = open_file_generic,
 	.write = lbs_debugfs_write,
 	.read = lbs_debugfs_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index c92db32..c370da0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -315,7 +315,7 @@ static const struct file_operations rt2x00debug_fop_queue_dump = {
 	.poll		= rt2x00debug_poll_queue_dump,
 	.open		= rt2x00debug_open_queue_dump,
 	.release	= rt2x00debug_release_queue_dump,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t rt2x00debug_read_queue_stats(struct file *file,
@@ -373,7 +373,7 @@ static const struct file_operations rt2x00debug_fop_queue_stats = {
 	.read		= rt2x00debug_read_queue_stats,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
@@ -426,7 +426,7 @@ static const struct file_operations rt2x00debug_fop_crypto_stats = {
 	.read		= rt2x00debug_read_crypto_stats,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
@@ -550,7 +550,7 @@ static const struct file_operations rt2x00debug_fop_dev_flags = {
 	.read		= rt2x00debug_read_dev_flags,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8e75b09..35daaea 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -234,7 +234,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
 	.open = wl1271_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
@@ -288,7 +288,7 @@ static const struct file_operations gpio_power_ops = {
 	.read = gpio_power_read,
 	.write = gpio_power_write,
 	.open = wl1271_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 89f6345..7deae4a 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -59,7 +59,7 @@ static ssize_t timeout_write(struct file *file, char const __user *buf,
 static const struct file_operations timeout_fops = {
 	.read		= timeout_read,
 	.write		= timeout_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #endif
@@ -98,7 +98,7 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 static const struct file_operations depth_fops = {
 	.read		= depth_read,
 	.write		= depth_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
@@ -110,7 +110,7 @@ static ssize_t pointer_size_read(struct file *file, char __user *buf, size_t cou
 
 static const struct file_operations pointer_size_fops = {
 	.read		= pointer_size_read,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
@@ -122,7 +122,7 @@ static ssize_t cpu_type_read(struct file *file, char __user *buf, size_t count,
 
 static const struct file_operations cpu_type_fops = {
 	.read		= cpu_type_read,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
@@ -158,7 +158,7 @@ static ssize_t enable_write(struct file *file, char const __user *buf, size_t co
 static const struct file_operations enable_fops = {
 	.read		= enable_read,
 	.write		= enable_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index e9ff6f7..5f6ce8a 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -122,14 +122,14 @@ static const struct file_operations ulong_fops = {
 	.read		= ulong_read_file,
 	.write		= ulong_write_file,
 	.open		= default_open,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
 static const struct file_operations ulong_ro_fops = {
 	.read		= ulong_read_file,
 	.open		= default_open,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
@@ -181,7 +181,7 @@ static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t coun
 static const struct file_operations atomic_ro_fops = {
 	.read		= atomic_read_file,
 	.open		= default_open,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
index 871e337..1ef4c1c 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/dw_spi.c
@@ -131,7 +131,7 @@ static const struct file_operations mrst_spi_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= spi_show_regs_open,
 	.read		= spi_show_regs,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int mrst_spi_debugfs_init(struct dw_spi *dws)
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 6885f9a..7b72e2e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1631,7 +1631,7 @@ static const struct file_operations keypad_fops = {
 	.read    = keypad_read,		/* read */
 	.open    = keypad_open,		/* open */
 	.release = keypad_release,	/* close */
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static struct miscdevice keypad_dev = {
diff --git a/drivers/staging/tty/istallion.c b/drivers/staging/tty/istallion.c
index 0b26627..a85c051 100644
--- a/drivers/staging/tty/istallion.c
+++ b/drivers/staging/tty/istallion.c
@@ -703,7 +703,7 @@ static const struct file_operations	stli_fsiomem = {
 	.read		= stli_memread,
 	.write		= stli_memwrite,
 	.unlocked_ioctl	= stli_memioctl,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*****************************************************************************/
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index d5f923b..7ba5a2c 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6678,7 +6678,7 @@ static const struct file_operations ixj_fops =
         .unlocked_ioctl = ixj_ioctl,
         .release        = ixj_release,
         .fasync         = ixj_fasync,
-        .llseek	 = default_llseek,
+        .llseek	 = generic_file_llseek,
 };
 
 static int ixj_linetest(IXJ *j)
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index c111f36..c36e921 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -232,14 +232,14 @@ static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= hsu_show_regs_open,
 	.read		= port_show_regs,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations dma_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= hsu_show_regs_open,
 	.read		= dma_show_regs,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int hsu_debugfs_init(struct hsu_port *hsu)
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 385acb8..f5c6e09 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -987,7 +987,7 @@ static const struct file_operations fops = {
 	.open		= usbtmc_open,
 	.release	= usbtmc_release,
 	.unlocked_ioctl	= usbtmc_ioctl,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct usb_class_driver usbtmc_class = {
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 693c29b..e7157a0 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -367,21 +367,21 @@ static const struct file_operations debug_async_fops = {
 	.open		= debug_async_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 static const struct file_operations debug_periodic_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_periodic_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 static const struct file_operations debug_registers_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_registers_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 static const struct file_operations debug_lpm_fops = {
 	.owner		= THIS_MODULE,
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index d7d3449..e769573 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -413,21 +413,21 @@ static const struct file_operations debug_async_fops = {
 	.open		= debug_async_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 static const struct file_operations debug_periodic_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_periodic_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 static const struct file_operations debug_registers_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_registers_open,
 	.read		= debug_output,
 	.release	= debug_close,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct dentry *ohci_debug_root;
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index c6184b4..11aef5d 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -105,7 +105,7 @@ static const struct file_operations idmouse_fops = {
 	.read = idmouse_read,
 	.open = idmouse_open,
 	.release = idmouse_release,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* class driver information */
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index ac5bfd6..fae13de 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -536,7 +536,7 @@ static const struct file_operations yurex_fops = {
 	.open =		yurex_open,
 	.release =	yurex_release,
 	.fasync	=	yurex_fasync,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e0c2284..3f2886b 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1421,7 +1421,7 @@ static const struct file_operations fb_fops = {
 #ifdef CONFIG_FB_DEFERRED_IO
 	.fsync =	fb_deferred_io_fsync,
 #endif
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 struct class *fb_class;
diff --git a/drivers/video/mbx/mbxdebugfs.c b/drivers/video/mbx/mbxdebugfs.c
index 12dec76..db35a6b 100644
--- a/drivers/video/mbx/mbxdebugfs.c
+++ b/drivers/video/mbx/mbxdebugfs.c
@@ -175,42 +175,42 @@ static const struct file_operations sysconf_fops = {
 	.read = sysconf_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations clock_fops = {
 	.read = clock_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations display_fops = {
 	.read = display_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations gsctl_fops = {
 	.read = gsctl_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations sdram_fops = {
 	.read = sdram_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations misc_fops = {
 	.read = misc_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void __devinit mbxfb_debugfs_init(struct fb_info *fbi)
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 1aa3897..dacbb06 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -75,7 +75,7 @@ static ssize_t capabilities_read(struct file *file, char __user *buf,
 
 static const struct file_operations capabilities_file_ops = {
 	.read = capabilities_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1befe2e..dd95e24 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -577,7 +577,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 static const struct file_operations bm_entry_operations = {
 	.read		= bm_entry_read,
 	.write		= bm_entry_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /* /register */
@@ -683,7 +683,7 @@ static ssize_t bm_status_write(struct file * file, const char __user * buffer,
 static const struct file_operations bm_status_operations = {
 	.read		= bm_status_read,
 	.write		= bm_status_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /* Superblock handling */
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 89d394d..fa9b509 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -455,7 +455,7 @@ static const struct file_operations fops_bool = {
 	.read =		read_file_bool,
 	.write =	write_file_bool,
 	.open =		default_open,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 /**
@@ -500,7 +500,7 @@ static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 static const struct file_operations fops_blob = {
 	.read =		read_file_blob,
 	.open =		default_open,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 /**
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 5977923..0da4600 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -644,7 +644,7 @@ static const struct file_operations waiters_fops = {
 	.owner   = THIS_MODULE,
 	.open    = waiters_open,
 	.read    = waiters_read,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 void dlm_delete_debug_file(struct dlm_ls *ls)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index cedc913..809017e 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -335,7 +335,7 @@ const struct file_operations ecryptfs_dir_fops = {
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 const struct file_operations ecryptfs_main_fops = {
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b2682e0..4844094 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1045,7 +1045,7 @@ const struct file_operations gfs2_dir_fops = {
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #endif /* CONFIG_GFS2_FS_LOCKING_DLM */
@@ -1073,6 +1073,6 @@ const struct file_operations gfs2_dir_fops_nolock = {
 	.open		= gfs2_open,
 	.release	= gfs2_close,
 	.fsync		= gfs2_fsync,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 87ed48e..f921361 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -538,7 +538,7 @@ static loff_t hppfs_llseek(struct file *file, loff_t off, int where)
 			return ret;
 	}
 
-	return default_llseek(file, off, where);
+	return generic_file_llseek(file, off, where);
 }
 
 static const struct file_operations hppfs_file_fops = {
@@ -598,7 +598,7 @@ static const struct file_operations hppfs_dir_fops = {
 	.readdir	= hppfs_readdir,
 	.open		= hppfs_dir_open,
 	.fsync		= hppfs_fsync,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int hppfs_statfs(struct dentry *dentry, struct kstatfs *sf)
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b9eeb1c..d7be360 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -696,7 +696,7 @@ const struct file_operations hugetlbfs_file_operations = {
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 9ed89d1..c870247 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -829,5 +829,5 @@ const struct file_operations logfs_dir_fops = {
 	.unlocked_ioctl	= logfs_ioctl,
 	.readdir	= logfs_readdir,
 	.read		= generic_read_dir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 1f5eae4..0f9243e 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -155,7 +155,7 @@ static const struct file_operations transaction_ops = {
 	.write		= nfsctl_transaction_write,
 	.read		= nfsctl_transaction_read,
 	.release	= simple_transaction_release,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static int exports_open(struct inode *inode, struct file *file)
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 8c5c0ed..c017c89 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -621,7 +621,7 @@ static const struct file_operations dlmfs_file_operations = {
 	.poll		= dlmfs_file_poll,
 	.read		= dlmfs_file_read,
 	.write		= dlmfs_file_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct inode_operations dlmfs_dir_inode_operations = {
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index a5ebe42..d8b579b 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -625,7 +625,7 @@ static const struct file_operations ocfs2_control_fops = {
 	.read    = ocfs2_control_read,
 	.write   = ocfs2_control_write,
 	.owner   = THIS_MODULE,
-	.llseek  = default_llseek,
+	.llseek  = generic_file_llseek,
 };
 
 static struct miscdevice ocfs2_control_device = {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index dd6628d..4da807c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1241,7 +1241,7 @@ out:
 static const struct file_operations proc_oom_score_adj_operations = {
 	.read		= oom_score_adj_read,
 	.write		= oom_score_adj_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -2210,7 +2210,7 @@ static const struct file_operations proc_fdinfo_file_operations = {
 static const struct file_operations proc_fd_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfd,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*
@@ -2281,7 +2281,7 @@ static int proc_readfdinfo(struct file *filp, void *dirent, filldir_t filldir)
 static const struct file_operations proc_fdinfo_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfdinfo,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*
@@ -2513,7 +2513,7 @@ static int proc_attr_dir_readdir(struct file * filp,
 static const struct file_operations proc_attr_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_attr_dir_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct dentry *proc_attr_dir_lookup(struct inode *dir,
@@ -2906,7 +2906,7 @@ static int proc_tgid_base_readdir(struct file * filp,
 static const struct file_operations proc_tgid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tgid_base_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
@@ -3244,7 +3244,7 @@ static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *den
 static const struct file_operations proc_tid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tid_base_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct inode_operations proc_tid_base_inode_operations = {
@@ -3481,5 +3481,5 @@ static const struct inode_operations proc_task_inode_operations = {
 static const struct file_operations proc_task_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_task_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d15aa1b..9509db4 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -145,7 +145,7 @@ static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (!llseek)
-		llseek = default_llseek;
+		llseek = generic_file_llseek;
 	rv = llseek(file, offset, whence);
 
 	pde_users_dec(pde);
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index d245cb2..6f37c39 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -558,7 +558,7 @@ static int open_kcore(struct inode *inode, struct file *filp)
 static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..ba98c3a 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -369,7 +369,7 @@ static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 static const struct file_operations proc_sys_file_operations = {
 	.read		= proc_sys_read,
 	.write		= proc_sys_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations proc_sys_dir_file_operations = {
diff --git a/fs/proc/root.c b/fs/proc/root.c
index a9000e9..bc81fca 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -168,7 +168,7 @@ static int proc_root_readdir(struct file * filp,
 static const struct file_operations proc_root_operations = {
 	.read		 = generic_read_dir,
 	.readdir	 = proc_root_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 74802bc5..0cafd9e 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -163,7 +163,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static struct vmcore* __init get_new_element(void)
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 977ed27..e226be1 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -62,7 +62,7 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 static const struct file_operations pstore_file_operations = {
 	.open	= pstore_file_open,
 	.read	= pstore_file_read,
-	.llseek	= default_llseek,
+	.llseek	= generic_file_llseek,
 };
 
 /*
diff --git a/fs/read_write.c b/fs/read_write.c
index 6ee63a4..107fb11 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -148,36 +148,6 @@ loff_t no_llseek(struct file *file, loff_t offset, int origin)
 }
 EXPORT_SYMBOL(no_llseek);
 
-loff_t default_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t retval;
-
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
-	switch (origin) {
-		case SEEK_END:
-			offset += i_size_read(file->f_path.dentry->d_inode);
-			break;
-		case SEEK_CUR:
-			if (offset == 0) {
-				retval = file->f_pos;
-				goto out;
-			}
-			offset += file->f_pos;
-	}
-	retval = -EINVAL;
-	if (offset >= 0 || unsigned_offsets(file)) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
-			file->f_version = 0;
-		}
-		retval = offset;
-	}
-out:
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
-	return retval;
-}
-EXPORT_SYMBOL(default_llseek);
-
 loff_t vfs_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t (*fn)(struct file *, loff_t, int);
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 2305e31..bc38bce 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -282,7 +282,7 @@ error:
 static const struct file_operations romfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= romfs_readdir,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct inode_operations romfs_dir_inode_operations = {
diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 3f79cd1..7d72368 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -240,5 +240,5 @@ failed_read:
 const struct file_operations squashfs_dir_ops = {
 	.read = generic_read_dir,
 	.readdir = squashfs_readdir,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 004d374..8b60bda 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2814,7 +2814,7 @@ static const struct file_operations dfs_fops = {
 	.open = open_debugfs_file,
 	.write = write_debugfs_file,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1b72e0c..b506567 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2237,8 +2237,6 @@ extern ino_t find_inode_number(struct dentry *, struct qstr *);
 #include <linux/err.h>
 
 /* needed for stackable file system support */
-extern loff_t default_llseek(struct file *file, loff_t offset, int origin);
-
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 14fb6d6..1d79543 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1227,7 +1227,7 @@ static const struct file_operations mqueue_file_operations = {
 	.flush = mqueue_flush_file,
 	.poll = mqueue_poll_file,
 	.read = mqueue_read_file,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct super_operations mqueue_super_ops = {
diff --git a/kernel/configs.c b/kernel/configs.c
index b4066b4..779b904 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -66,7 +66,7 @@ ikconfig_read_current(struct file *file, char __user *buf,
 static const struct file_operations ikconfig_file_ops = {
 	.owner = THIS_MODULE,
 	.read = ikconfig_read_current,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int __init ikconfig_init(void)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7798181..207e011 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2210,7 +2210,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 static const struct file_operations fops_kp = {
 	.read =         read_enabled_file_bool,
 	.write =        write_enabled_file_bool,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static int __kprobes debugfs_kprobe_init(void)
diff --git a/kernel/profile.c b/kernel/profile.c
index 66f841b..b08adc6 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -555,7 +555,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 static const struct file_operations proc_profile_operations = {
 	.read		= read_profile,
 	.write		= write_profile,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_SMP
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6957aa2..e57fcf6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -330,7 +330,7 @@ static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_dropped_open,
 	.read =		blk_dropped_read,
-	.llseek =	default_llseek,
+	.llseek =	generic_file_llseek,
 };
 
 static int blk_msg_open(struct inode *inode, struct file *filp)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..425f6ec 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -800,7 +800,7 @@ static const struct file_operations ftrace_profile_fops = {
 	.open		= tracing_open_generic,
 	.read		= ftrace_profile_read,
 	.write		= ftrace_profile_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /* used to initialize the real stat files */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ef7b4b..689d36f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4008,7 +4008,7 @@ static const struct file_operations rb_simple_fops = {
 	.open		= tracing_open_generic,
 	.read		= rb_simple_read,
 	.write		= rb_simple_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e88f74f..2d57d04 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -938,7 +938,7 @@ static const struct file_operations ftrace_enable_fops = {
 	.open = tracing_open_generic,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations ftrace_event_format_fops = {
@@ -951,34 +951,34 @@ static const struct file_operations ftrace_event_format_fops = {
 static const struct file_operations ftrace_event_id_fops = {
 	.open = tracing_open_generic,
 	.read = event_id_read,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations ftrace_event_filter_fops = {
 	.open = tracing_open_generic,
 	.read = event_filter_read,
 	.write = event_filter_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {
 	.open = tracing_open_generic,
 	.read = subsystem_filter_read,
 	.write = subsystem_filter_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
 	.open = tracing_open_generic,
 	.read = system_enable_read,
 	.write = system_enable_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static const struct file_operations ftrace_show_header_fops = {
 	.open = tracing_open_generic,
 	.read = show_header,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static struct dentry *event_trace_events_dir(void)
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4c5dead..6254244 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -195,7 +195,7 @@ static const struct file_operations stack_max_size_fops = {
 	.open		= tracing_open_generic,
 	.read		= stack_max_size_read,
 	.write		= stack_max_size_write,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 static void *
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 4bfb047..ec036d0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -590,7 +590,7 @@ out_unlock:
 static const struct file_operations filter_fops = {
 	.read  = filter_read,
 	.write = filter_write,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static int dma_debug_fs_init(void)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 51f0d78..aa60169 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -121,7 +121,7 @@ static const struct file_operations tsf_ops = {
 	.read = tsf_read,
 	.write = tsf_write,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
@@ -174,7 +174,7 @@ static const struct file_operations noack_ops = {
 	.read = noack_read,
 	.write = noack_write,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
@@ -217,7 +217,7 @@ static const struct file_operations uapsd_queues_ops = {
 	.read = uapsd_queues_read,
 	.write = uapsd_queues_write,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
@@ -261,7 +261,7 @@ static const struct file_operations uapsd_max_sp_len_ops = {
 	.read = uapsd_max_sp_len_read,
 	.write = uapsd_max_sp_len_write,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t channel_type_read(struct file *file, char __user *user_buf,
@@ -294,7 +294,7 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 static const struct file_operations channel_type_ops = {
 	.read = channel_type_read,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t queues_read(struct file *file, char __user *user_buf,
@@ -318,7 +318,7 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 static const struct file_operations queues_ops = {
 	.read = queues_read,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* statistics stuff */
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..616ed21 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -145,7 +145,7 @@ static ssize_t rcname_read(struct file *file, char __user *userbuf,
 static const struct file_operations rcname_ops = {
 	.read = rcname_read,
 	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 #endif
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index a290ad2..dde766b 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -122,7 +122,7 @@ static const struct file_operations minstrel_stat_fops = {
 	.open = minstrel_stats_open,
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 void
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 39765bc..1b4bb2e 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -103,7 +103,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
 	.open = cfg80211_open_file_generic,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 #define DEBUGFS_ADD(name)						\
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 0848292..67631d1 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -89,7 +89,7 @@ static ssize_t profile_load(struct file *f, const char __user *buf, size_t size,
 
 static const struct file_operations aa_fs_profile_load = {
 	.write = profile_load,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* .replace file hook fn to load and/or replace policy */
@@ -111,7 +111,7 @@ static ssize_t profile_replace(struct file *f, const char __user *buf,
 
 static const struct file_operations aa_fs_profile_replace = {
 	.write = profile_replace,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /* .remove file hook fn to remove loaded policy */
@@ -139,7 +139,7 @@ static ssize_t profile_remove(struct file *f, const char __user *buf,
 
 static const struct file_operations aa_fs_profile_remove = {
 	.write = profile_remove,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 /** Base file system setup **/
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f934601..831b64e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1026,7 +1026,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 static const struct file_operations smk_doi_ops = {
 	.read		= smk_read_doi,
 	.write		= smk_write_doi,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /**
@@ -1090,7 +1090,7 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 static const struct file_operations smk_direct_ops = {
 	.read		= smk_read_direct,
 	.write		= smk_write_direct,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /**
@@ -1172,7 +1172,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 static const struct file_operations smk_ambient_ops = {
 	.read		= smk_read_ambient,
 	.write		= smk_write_ambient,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /**
@@ -1252,7 +1252,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 static const struct file_operations smk_onlycap_ops = {
 	.read		= smk_read_onlycap,
 	.write		= smk_write_onlycap,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /**
@@ -1317,7 +1317,7 @@ static ssize_t smk_write_logging(struct file *file, const char __user *buf,
 static const struct file_operations smk_logging_ops = {
 	.read		= smk_read_logging,
 	.write		= smk_write_logging,
-	.llseek		= default_llseek,
+	.llseek		= generic_file_llseek,
 };
 
 /*
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b76b74d..fe91718 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -275,7 +275,7 @@ static const struct file_operations codec_reg_fops = {
 	.open = codec_reg_open_file,
 	.read = codec_reg_read_file,
 	.write = codec_reg_write_file,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 static void soc_init_codec_debugfs(struct snd_soc_codec *codec)
@@ -347,7 +347,7 @@ static ssize_t codec_list_read_file(struct file *file, char __user *user_buf,
 
 static const struct file_operations codec_list_fops = {
 	.read = codec_list_read_file,
-	.llseek = default_llseek,/* read accesses f_pos */
+	.llseek = generic_file_llseek,/* read accesses f_pos */
 };
 
 static ssize_t dai_list_read_file(struct file *file, char __user *user_buf,
@@ -379,7 +379,7 @@ static ssize_t dai_list_read_file(struct file *file, char __user *user_buf,
 
 static const struct file_operations dai_list_fops = {
 	.read = dai_list_read_file,
-	.llseek = default_llseek,/* read accesses f_pos */
+	.llseek = generic_file_llseek,/* read accesses f_pos */
 };
 
 static ssize_t platform_list_read_file(struct file *file,
@@ -413,7 +413,7 @@ static ssize_t platform_list_read_file(struct file *file,
 
 static const struct file_operations platform_list_fops = {
 	.read = platform_list_read_file,
-	.llseek = default_llseek,/* read accesses f_pos */
+	.llseek = generic_file_llseek,/* read accesses f_pos */
 };
 
 static void soc_init_card_debugfs(struct snd_soc_card *card)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 81c4052..886fc14 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1301,7 +1301,7 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 static const struct file_operations dapm_widget_power_fops = {
 	.open = dapm_widget_power_open_file,
 	.read = dapm_widget_power_read_file,
-	.llseek = default_llseek,
+	.llseek = generic_file_llseek,
 };
 
 void snd_soc_dapm_debugfs_init(struct snd_soc_dapm_context *dapm)
-- 
1.7.2.3

