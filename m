Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1DRUWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:22:30 -0400
Received: from mail.perches.com ([173.55.12.10]:4806 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1DRUW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:22:27 -0400
Subject: [PATCH] treewide: Convert typedef match_table_t to struct
 match_token, use const
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 13:22:25 -0700
Message-ID: <1303158145.31723.34.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the uses of match_table_t typedef to struct match_token.
Add const to some declarations.

Text increases, data decreases ~1KB for the new const uses.

Signed-off-by: Joe Perches <joe@perches.com>

---

 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/hypfs/inode.c                   |    2 +-
 drivers/block/rbd.c                       |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |    2 +-
 drivers/target/target_core_configfs.c     |    2 +-
 drivers/target/target_core_file.c         |    2 +-
 drivers/target/target_core_iblock.c       |    2 +-
 drivers/target/target_core_pscsi.c        |    2 +-
 drivers/target/target_core_rd.c           |    2 +-
 drivers/usb/core/inode.c                  |    2 +-
 fs/9p/v9fs.c                              |    2 +-
 fs/adfs/super.c                           |    2 +-
 fs/affs/super.c                           |    2 +-
 fs/afs/super.c                            |    2 +-
 fs/autofs4/inode.c                        |    2 +-
 fs/befs/linuxvfs.c                        |    2 +-
 fs/btrfs/super.c                          |    2 +-
 fs/ceph/super.c                           |    2 +-
 fs/devpts/inode.c                         |    2 +-
 fs/ecryptfs/main.c                        |    2 +-
 fs/exofs/super.c                          |    2 +-
 fs/ext2/super.c                           |    2 +-
 fs/ext3/super.c                           |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/inode.c                            |    6 +++---
 fs/fuse/inode.c                           |    2 +-
 fs/gfs2/glock.h                           |    2 +-
 fs/gfs2/lock_dlm.c                        |    4 ++--
 fs/gfs2/ops_fstype.c                      |    6 +++---
 fs/gfs2/super.c                           |    2 +-
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/options.c                      |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/isofs/inode.c                          |    2 +-
 fs/jfs/super.c                            |    2 +-
 fs/nfs/super.c                            |   10 +++++-----
 fs/nilfs2/super.c                         |    2 +-
 fs/ocfs2/super.c                          |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/pstore/inode.c                         |    2 +-
 fs/ramfs/inode.c                          |    2 +-
 fs/ubifs/super.c                          |    2 +-
 fs/udf/super.c                            |    2 +-
 fs/ufs/super.c                            |    2 +-
 fs/xfs/linux-2.6/xfs_super.c              |    2 +-
 include/linux/parser.h                    |    2 +-
 lib/parser.c                              |    8 ++++----
 net/9p/client.c                           |    2 +-
 net/9p/trans_fd.c                         |    2 +-
 net/9p/trans_rdma.c                       |    2 +-
 net/ceph/ceph_common.c                    |    2 +-
 security/integrity/ima/ima_policy.c       |    2 +-
 security/keys/encrypted.c                 |    2 +-
 security/keys/trusted.c                   |    2 +-
 security/selinux/hooks.c                  |    2 +-
 56 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 856e9c3..cce6350 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -662,7 +662,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_mode, Opt_debug, Opt_err,
 };
 
-static const match_table_t spufs_tokens = {
+static const struct match_token spufs_tokens[] = {
 	{ Opt_uid,   "uid=%d" },
 	{ Opt_gid,   "gid=%d" },
 	{ Opt_mode,  "mode=%o" },
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6fe874f..788ad70 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -221,7 +221,7 @@ static int hypfs_release(struct inode *inode, struct file *filp)
 
 enum { opt_uid, opt_gid, opt_err };
 
-static const match_table_t hypfs_tokens = {
+static const struct match_token hypfs_tokens[] = {
 	{opt_uid, "uid=%u"},
 	{opt_gid, "gid=%u"},
 	{opt_err, NULL}
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 16dc364..2e6b155 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -295,7 +295,7 @@ enum {
 	/* string args above */
 };
 
-static match_table_t rbdopt_tokens = {
+static const struct match_token rbdopt_tokens[] = {
 	{Opt_notify_timeout, "notify_timeout=%d"},
 	/* int args above */
 	/* string args above */
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 376d640..9cd404a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1922,7 +1922,7 @@ enum {
 				   SRP_OPT_SERVICE_ID),
 };
 
-static const match_table_t srp_opt_tokens = {
+static const struct match_token srp_opt_tokens[] = {
 	{ SRP_OPT_ID_EXT,		"id_ext=%s" 		},
 	{ SRP_OPT_IOC_GUID,		"ioc_guid=%s" 		},
 	{ SRP_OPT_DGID,			"dgid=%s" 		},
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f44a6..427d98c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1428,7 +1428,7 @@ enum {
 	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun, Opt_err
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_initiator_fabric, "initiator_fabric=%s"},
 	{Opt_initiator_node, "initiator_node=%s"},
 	{Opt_initiator_sid, "initiator_sid=%s"},
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 150c430..80186b8 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -511,7 +511,7 @@ enum {
 	Opt_fd_dev_name, Opt_fd_dev_size, Opt_fd_buffered_io, Opt_err
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
 	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8663900..0983975 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -457,7 +457,7 @@ enum {
 	Opt_udev_path, Opt_force, Opt_err
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_udev_path, "udev_path=%s"},
 	{Opt_force, "force=%d"},
 	{Opt_err, NULL}
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7ff6a35..13079a2 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -940,7 +940,7 @@ enum {
 	Opt_scsi_lun_id, Opt_err
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_scsi_host_id, "scsi_host_id=%d"},
 	{Opt_scsi_channel_id, "scsi_channel_id=%d"},
 	{Opt_scsi_target_id, "scsi_target_id=%d"},
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 7837dd3..b3926fb 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -925,7 +925,7 @@ enum {
 	Opt_rd_pages, Opt_err
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_rd_pages, "rd_pages=%d"},
 	{Opt_err, NULL}
 };
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 1b125c2..e29c57f 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -96,7 +96,7 @@ enum {
 	Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_devuid, "devuid=%u"},
 	{Opt_devgid, "devgid=%u"},
 	{Opt_devmode, "devmode=%o"},
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index c82b017..2387686 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -61,7 +61,7 @@ enum {
 	Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_debug, "debug=%x"},
 	{Opt_dfltuid, "dfltuid=%u"},
 	{Opt_dfltgid, "dfltgid=%u"},
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index c8bf36a..8f581f3 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -146,7 +146,7 @@ static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
 
 enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_ftsuffix, Opt_err};
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_ownmask, "ownmask=%o"},
diff --git a/fs/affs/super.c b/fs/affs/super.c
index b31507d..db45d2d 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -152,7 +152,7 @@ enum {
 	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_bs, "bs=%u"},
 	{Opt_mode, "mode=%o"},
 	{Opt_mufs, "mufs"},
diff --git a/fs/afs/super.c b/fs/afs/super.c
index fb240e8..423f4c4 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -65,7 +65,7 @@ enum {
 	afs_opt_autocell,
 };
 
-static const match_table_t afs_options_list = {
+static const struct match_token afs_options_list[] = {
 	{ afs_opt_cell,		"cell=%s"	},
 	{ afs_opt_rwpath,	"rwpath"	},
 	{ afs_opt_vol,		"vol=%s"	},
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 180fa24..59d8119 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -113,7 +113,7 @@ static const struct super_operations autofs4_sops = {
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
 	Opt_indirect, Opt_direct, Opt_offset};
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 54b8c28..ef606f0 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -656,7 +656,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_charset, Opt_debug, Opt_err,
 };
 
-static const match_table_t befs_tokens = {
+static const struct match_token befs_tokens[] = {
 	{Opt_uid, "uid=%d"},
 	{Opt_gid, "gid=%d"},
 	{Opt_charset, "iocharset=%s"},
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d3e542c..6b3cd45 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -163,7 +163,7 @@ enum {
 	Opt_enospc_debug, Opt_err,
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_degraded, "degraded"},
 	{Opt_subvol, "subvol=%s"},
 	{Opt_subvolid, "subvolid=%d"},
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f2f77fd..d44d706 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -134,7 +134,7 @@ enum {
 	Opt_ino32,
 };
 
-static match_table_t fsopt_tokens = {
+static const struct match_token fsopt_tokens[] = {
 	{Opt_wsize, "wsize=%d"},
 	{Opt_rsize, "rsize=%d"},
 	{Opt_caps_wanted_delay_min, "caps_wanted_delay_min=%d"},
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 2f27e57..cd2049f 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -56,7 +56,7 @@ enum {
 	Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%o"},
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 89b93389..b84029b 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -246,7 +246,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
        ecryptfs_opt_err };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{ecryptfs_opt_sig, "sig=%s"},
 	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
 	{ecryptfs_opt_cipher, "cipher=%s"},
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 06065bd..3266988 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -64,7 +64,7 @@ enum { Opt_name, Opt_pid, Opt_to, Opt_err };
  * kernel's parsing functions do not currently support that.  32-bit should be
  * sufficient for most applications now.
  */
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_name, "osdname=%s"},
 	{Opt_pid, "pid=%u"},
 	{Opt_to, "to=%u"},
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0a78dae..7b59ced 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -397,7 +397,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index aad153e..fdb022e 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -824,7 +824,7 @@ enum {
 	Opt_resize, Opt_usrquota, Opt_grpquota
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5147647..821c24e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1280,7 +1280,7 @@ enum {
 	Opt_init_inode_table, Opt_noinit_inode_table,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index cb8d839..0aaaa89 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -900,7 +900,7 @@ enum {
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_err,
 };
 
-static const match_table_t fat_tokens = {
+static const struct match_token fat_tokens[] = {
 	{Opt_check_r, "check=relaxed"},
 	{Opt_check_s, "check=strict"},
 	{Opt_check_n, "check=normal"},
@@ -939,14 +939,14 @@ static const match_table_t fat_tokens = {
 	{Opt_obsolate, "posix"},
 	{Opt_err, NULL},
 };
-static const match_table_t msdos_tokens = {
+static const struct match_token msdos_tokens[] = {
 	{Opt_nodots, "nodots"},
 	{Opt_nodots, "dotsOK=no"},
 	{Opt_dots, "dots"},
 	{Opt_dots, "dotsOK=yes"},
 	{Opt_err, NULL}
 };
-static const match_table_t vfat_tokens = {
+static const struct match_token vfat_tokens[] = {
 	{Opt_charset, "iocharset=%s"},
 	{Opt_shortname_lower, "shortname=lower"},
 	{Opt_shortname_win95, "shortname=win95"},
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index cc6ec4b..3e7f9fe 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -408,7 +408,7 @@ enum {
 	OPT_ERR
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{OPT_FD,			"fd=%u"},
 	{OPT_ROOTMODE,			"rootmode=%o"},
 	{OPT_USER_ID,			"user_id=%u"},
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 6b2f757..d72c1d2 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -122,7 +122,7 @@ struct lm_lockops {
 	int (*lm_lock) (struct gfs2_glock *gl, unsigned int req_state,
 			unsigned int flags);
 	void (*lm_cancel) (struct gfs2_glock *gl);
-	const match_table_t *lm_tokens;
+	const struct match_token *lm_tokens;
 };
 
 extern struct workqueue_struct *gfs2_delete_workqueue;
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 98c80d8..a300e88 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -215,7 +215,7 @@ static void gdlm_unmount(struct gfs2_sbd *sdp)
 	}
 }
 
-static const match_table_t dlm_tokens = {
+static const struct match_token dlm_tokens[] = {
 	{ Opt_jid, "jid=%d"},
 	{ Opt_id, "id=%d"},
 	{ Opt_first, "first=%d"},
@@ -230,6 +230,6 @@ const struct lm_lockops gfs2_dlm_ops = {
 	.lm_put_lock = gdlm_put_lock,
 	.lm_lock = gdlm_lock,
 	.lm_cancel = gdlm_cancel,
-	.lm_tokens = &dlm_tokens,
+	.lm_tokens = dlm_tokens,
 };
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index d3c69eb..bbb5d11 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -924,7 +924,7 @@ fail:
 	return error;
 }
 
-static const match_table_t nolock_tokens = {
+static const struct match_token nolock_tokens[] = {
 	{ Opt_jid, "jid=%d\n", },
 	{ Opt_err, NULL },
 };
@@ -932,7 +932,7 @@ static const match_table_t nolock_tokens = {
 static const struct lm_lockops nolock_ops = {
 	.lm_proto_name = "lock_nolock",
 	.lm_put_lock = gfs2_glock_free,
-	.lm_tokens = &nolock_tokens,
+	.lm_tokens = nolock_tokens,
 };
 
 /**
@@ -979,7 +979,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 		if (!o || !*o)
 			continue;
 
-		token = match_token(o, *lm->lm_tokens, tmp);
+		token = match_token(o, lm->lm_tokens, tmp);
 		switch (token) {
 		case Opt_jid:
 			ret = match_int(&tmp[0], &option);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 215c37b..0d39152 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -80,7 +80,7 @@ enum {
 	Opt_error,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_lockproto, "lockproto=%s"},
 	{Opt_locktable, "locktable=%s"},
 	{Opt_hostdata, "hostdata=%s"},
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 1b55f70..0941098 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -199,7 +199,7 @@ enum {
 	opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{ opt_uid, "uid=%u" },
 	{ opt_gid, "gid=%u" },
 	{ opt_umask, "umask=%o" },
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index bb62a5882..4f582cb 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -27,7 +27,7 @@ enum {
 	opt_force, opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{ opt_creator, "creator=%s" },
 	{ opt_type, "type=%s" },
 	{ opt_umask, "umask=%o" },
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index c89b408..7b2bb4c 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -226,7 +226,7 @@ enum {
 	Opt_timeshift, Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_help, "help"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b9eeb1c..318da41 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -56,7 +56,7 @@ enum {
 	Opt_err,
 };
 
-static const match_table_t tokens = {
+static const const struct match_token tokens[] = {
 	{Opt_size,	"size=%s"},
 	{Opt_nr_inodes,	"nr_inodes=%s"},
 	{Opt_mode,	"mode=%o"},
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 3db5ba4..bbb9834 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -327,7 +327,7 @@ enum {
 	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode, Opt_overriderockperm,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_norock, "norock"},
 	{Opt_nojoliet, "nojoliet"},
 	{Opt_unhide, "unhide"},
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 06c8a67..f4ff63e 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -201,7 +201,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_uid, Opt_gid, Opt_umask
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_integrity, "integrity"},
 	{Opt_nointegrity, "nointegrity"},
 	{Opt_iocharset, "iocharset=%s"},
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 75bcc3f..d88ccbe 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -113,7 +113,7 @@ enum {
 	Opt_err
 };
 
-static const match_table_t nfs_mount_option_tokens = {
+static const struct match_token nfs_mount_option_tokens[] = {
 	{ Opt_userspace, "bg" },
 	{ Opt_userspace, "fg" },
 	{ Opt_userspace, "retry=%s" },
@@ -188,7 +188,7 @@ enum {
 	Opt_xprt_err
 };
 
-static const match_table_t nfs_xprt_protocol_tokens = {
+static const struct match_token nfs_xprt_protocol_tokens[] = {
 	{ Opt_xprt_udp, "udp" },
 	{ Opt_xprt_udp6, "udp6" },
 	{ Opt_xprt_tcp, "tcp" },
@@ -207,7 +207,7 @@ enum {
 	Opt_sec_err
 };
 
-static const match_table_t nfs_secflavor_tokens = {
+static const struct match_token nfs_secflavor_tokens[] = {
 	{ Opt_sec_none, "none" },
 	{ Opt_sec_none, "null" },
 	{ Opt_sec_sys, "sys" },
@@ -234,7 +234,7 @@ enum {
 	Opt_lookupcache_err
 };
 
-static match_table_t nfs_lookupcache_tokens = {
+static const struct match_token nfs_lookupcache_tokens[] = {
 	{ Opt_lookupcache_all, "all" },
 	{ Opt_lookupcache_positive, "pos" },
 	{ Opt_lookupcache_positive, "positive" },
@@ -250,7 +250,7 @@ enum {
 	Opt_local_lock_err
 };
 
-static match_table_t nfs_local_lock_tokens = {
+static const struct match_token nfs_local_lock_tokens[] = {
 	{ Opt_local_lock_all, "all" },
 	{ Opt_local_lock_flock, "flock" },
 	{ Opt_local_lock_posix, "posix" },
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 062cca0..fa73d6e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -572,7 +572,7 @@ enum {
 	Opt_discard, Opt_nodiscard, Opt_err,
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4129fb6..dfcd111 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -187,7 +187,7 @@ enum {
 	Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_barrier, "barrier=%u"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index e043c4c..be5f8ef 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -364,7 +364,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_umask, Opt_dmask, Opt_fmask
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_umask, "umask=%o"},
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 977ed27..443e14e 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -117,7 +117,7 @@ enum {
 	Opt_kmsg_bytes, Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_kmsg_bytes, "kmsg_bytes=%u"},
 	{Opt_err, NULL}
 };
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index eacb166..0df1654 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -166,7 +166,7 @@ enum {
 	Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_mode, "mode=%o"},
 	{Opt_err, NULL}
 };
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index c75f613..d384238 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -948,7 +948,7 @@ enum {
 	Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_fast_unmount, "fast_unmount"},
 	{Opt_norm_unmount, "norm_unmount"},
 	{Opt_bulk_read, "bulk_read"},
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b27b06..9b89053 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -374,7 +374,7 @@ enum {
 	Opt_fmode, Opt_dmode
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_novrs,	"novrs"},
 	{Opt_nostrict,	"nostrict"},
 	{Opt_bs,	"bs=%u"},
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3915ade..2d9e546 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -378,7 +378,7 @@ enum {
        Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_type_old, "ufstype=old"},
 	{Opt_type_sunx86, "ufstype=sunx86"},
 	{Opt_type_sun, "ufstype=sun"},
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index b38e58d..a648692 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -123,7 +123,7 @@ enum {
 	Opt_barrier, Opt_nobarrier, Opt_err
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_err, NULL}
diff --git a/include/linux/parser.h b/include/linux/parser.h
index ea2281e..48a2514 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -25,7 +25,7 @@ typedef struct {
 	char *to;
 } substring_t;
 
-int match_token(char *, const match_table_t table, substring_t args[]);
+int match_token(char *, const struct match_token *table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
diff --git a/lib/parser.c b/lib/parser.c
index dcbaaef..a1dc87e 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -92,9 +92,9 @@ static int match_one(char *s, const char *p, substring_t args[])
 /**
  * match_token: - Find a token (and optional args) in a string
  * @s: the string to examine for token/argument pairs
- * @table: match_table_t describing the set of allowed option tokens and the
- * arguments that may be associated with them. Must be terminated with a
- * &struct match_token whose pattern is set to the NULL pointer.
+ * @table: the set of allowed option tokens (const struct match_token *)
+ * and the arguments that may be associated with them. Must be terminated
+ * by an entry with pattern set to the NULL pointer.
  * @args: array of %MAX_OPT_ARGS &substring_t elements. Used to return match
  * locations.
  *
@@ -103,7 +103,7 @@ static int match_one(char *s, const char *p, substring_t args[])
  * format identifiers which will be taken into account when matching the
  * tokens, and whose locations will be returned in the @args array.
  */
-int match_token(char *s, const match_table_t table, substring_t args[])
+int match_token(char *s, const struct match_token *table, substring_t args[])
 {
 	const struct match_token *p;
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 3723c09..9ee0914 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -51,7 +51,7 @@ enum {
 	Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_msize, "msize=%u"},
 	{Opt_legacy, "noextend"},
 	{Opt_trans, "trans=%s"},
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index aa5672b..aa7960b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -87,7 +87,7 @@ enum {
 	Opt_port, Opt_rfdno, Opt_wfdno, Opt_err,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_port, "port=%u"},
 	{Opt_rfdno, "rfdno=%u"},
 	{Opt_wfdno, "wfdno=%u"},
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 150e0c4..4034835 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -146,7 +146,7 @@ enum {
 	Opt_port, Opt_rq_depth, Opt_sq_depth, Opt_timeout, Opt_err,
 };
 
-static match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_port, "port=%u"},
 	{Opt_sq_depth, "sq=%u"},
 	{Opt_rq_depth, "rq=%u"},
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 132963a..1576fb3 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -207,7 +207,7 @@ enum {
 	Opt_nocrc,
 };
 
-static match_table_t opt_tokens = {
+static const struct match_token opt_tokens[] = {
 	{Opt_osdtimeout, "osdtimeout=%d"},
 	{Opt_osdkeepalivetimeout, "osdkeepalive=%d"},
 	{Opt_mount_timeout, "mount_timeout=%d"},
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d661afb..c98963d 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -225,7 +225,7 @@ enum {
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
 };
 
-static match_table_t policy_tokens = {
+static const struct match_token policy_tokens[] = {
 	{Opt_measure, "measure"},
 	{Opt_dont_measure, "dont_measure"},
 	{Opt_obj_user, "obj_user=%s"},
diff --git a/security/keys/encrypted.c b/security/keys/encrypted.c
index 69907a5..f41a74d 100644
--- a/security/keys/encrypted.c
+++ b/security/keys/encrypted.c
@@ -58,7 +58,7 @@ enum {
 	Opt_err = -1, Opt_new, Opt_load, Opt_update
 };
 
-static const match_table_t key_tokens = {
+static const struct match_token key_tokens[] = {
 	{Opt_new, "new"},
 	{Opt_load, "load"},
 	{Opt_update, "update"},
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index c99b936..b15e1ed 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -745,7 +745,7 @@ enum {
 	Opt_pcrinfo, Opt_pcrlock, Opt_migratable
 };
 
-static const match_table_t key_tokens = {
+static const struct match_token key_tokens[] = {
 	{Opt_new, "new"},
 	{Opt_load, "load"},
 	{Opt_update, "update"},
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f9c3764..aa9f978 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -310,7 +310,7 @@ enum {
 	Opt_labelsupport = 5,
 };
 
-static const match_table_t tokens = {
+static const struct match_token tokens[] = {
 	{Opt_context, CONTEXT_STR "%s"},
 	{Opt_fscontext, FSCONTEXT_STR "%s"},
 	{Opt_defcontext, DEFCONTEXT_STR "%s"},


