Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2ASBbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:31:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56954 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2ASBbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:31:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAFR8uecgfQiCWXcb9hBjhpJ=+Dn2AjNEMzU+eqX1QpJKZMAGjw@mail.gmail.com>
References: <CAFR8uecgfQiCWXcb9hBjhpJ=+Dn2AjNEMzU+eqX1QpJKZMAGjw@mail.gmail.com>
Date: Wed, 18 Jan 2012 20:31:03 -0500
Message-ID: <CAFR8uedLDNpU7+S+GnTJ0bG0q=JEH_W+LsQRgSsfH2AAcg3vgw@mail.gmail.com>
Subject: Re: [PATCH] Update magic.h with some pseudofs magic.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        dwmw2@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3071ce307d7a8e04b6d78487
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3071ce307d7a8e04b6d78487
Content-Type: text/plain; charset=ISO-8859-1

[ This time with linux-kernel ml. Sorry for the duplicate ].

While looking at bdevfs noticed that magic.h is not up to date with
some pseudofs magic. This patch updates it.

Signed-off-by: Muthukumar R <muthur@gmail.com>

-------
 drivers/mtd/mtdchar.c     |    2 +-
 fs/binfmt_misc.c          |    3 ++-
 fs/block_dev.c            |    3 ++-
 fs/pipe.c                 |    1 +
 include/linux/magic.h     |   18 ++++++++++++------
 include/linux/pipe_fs_i.h |    2 --
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 50c6a1e..c57ae92 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -31,13 +31,13 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/blkpg.h>
+#include <linux/magic.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/map.h>

 #include <asm/uaccess.h>

-#define MTD_INODE_FS_MAGIC 0x11307854
 static DEFINE_MUTEX(mtd_mutex);
 static struct vfsmount *mtd_inode_mnt __read_mostly;

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a9198df..88eb813 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/magic.h>
 #include <linux/binfmts.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
@@ -699,7 +700,7 @@ static int bm_fill_super(struct super_block * sb,
void * data, int silent)
 		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err = simple_fill_super(sb, 0x42494e4d, bm_files);
+	int err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
 		sb->s_op = &s_ops;
 	return err;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0e575d1..cfd4c13 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/blkpg.h>
+#include <linux/magic.h>
 #include <linux/buffer_head.h>
 #include <linux/swap.h>
 #include <linux/pagevec.h>
@@ -506,7 +507,7 @@ static const struct super_operations bdev_sops = {
 static struct dentry *bd_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, 0x62646576);
+	return mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, BDEVFS_MAGIC);
 }

 static struct file_system_type bd_type = {
diff --git a/fs/pipe.c b/fs/pipe.c
index a932ced..c2f4490 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/log2.h>
 #include <linux/mount.h>
+#include <linux/magic.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/uio.h>
 #include <linux/highmem.h>
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 2d4beab..b4a8d44 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -9,7 +9,6 @@
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
 #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong
endianess */
 #define DEBUGFS_MAGIC          0x64626720
-#define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
 #define RAMFS_MAGIC		0x858458f6	/* some random number */
@@ -27,7 +26,6 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
-#define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C

 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
@@ -40,7 +38,6 @@
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
 #define NFS_SUPER_MAGIC		0x6969
 #define OPENPROM_SUPER_MAGIC	0x9fa1
-#define PROC_SUPER_MAGIC	0x9fa0
 #define QNX4_SUPER_MAGIC	0x002f		/* qnx4 fs detection */

 #define REISERFS_SUPER_MAGIC	0x52654973	/* used by gcc */
@@ -51,15 +48,24 @@
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"

 #define SMB_SUPER_MAGIC		0x517B
-#define USBDEVICE_SUPER_MAGIC	0x9fa2
 #define CGROUP_SUPER_MAGIC	0x27e0eb

-#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA

 #define STACK_END_MAGIC		0x57AC6E9D

+#define V9FS_MAGIC		0x01021997
+
+#define BDEVFS_MAGIC            0x62646576
+#define BINFMTFS_MAGIC          0x42494e4d
 #define DEVPTS_SUPER_MAGIC	0x1cd1
+#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
+#define PIPEFS_MAGIC            0x50495045
+#define PROC_SUPER_MAGIC	0x9fa0
 #define SOCKFS_MAGIC		0x534F434B
-#define V9FS_MAGIC		0x01021997
+#define SYSFS_MAGIC		0x62656572
+#define USBDEVICE_SUPER_MAGIC	0x9fa2
+#define MTD_INODE_FS_MAGIC      0x11307854
+#define ANON_INODE_FS_MAGIC	0x09041934
+

 #endif /* __LINUX_MAGIC_H__ */
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 77257c9..6d626ff 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_PIPE_FS_I_H
 #define _LINUX_PIPE_FS_I_H

-#define PIPEFS_MAGIC 0x50495045
-
 #define PIPE_DEF_BUFFERS	16

 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */

--20cf3071ce307d7a8e04b6d78487
Content-Type: text/x-patch; charset=US-ASCII; name="magic.diff"
Content-Disposition: attachment; filename="magic.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxjef3oc0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbXRkL210ZGNoYXIuYyBiL2RyaXZlcnMvbXRkL210ZGNoYXIu
YwppbmRleCA1MGM2YTFlLi5jNTdhZTkyIDEwMDY0NAotLS0gYS9kcml2ZXJzL210ZC9tdGRjaGFy
LmMKKysrIGIvZHJpdmVycy9tdGQvbXRkY2hhci5jCkBAIC0zMSwxMyArMzEsMTMgQEAKICNpbmNs
dWRlIDxsaW51eC9jb21wYXQuaD4KICNpbmNsdWRlIDxsaW51eC9tb3VudC5oPgogI2luY2x1ZGUg
PGxpbnV4L2Jsa3BnLmg+CisjaW5jbHVkZSA8bGludXgvbWFnaWMuaD4KICNpbmNsdWRlIDxsaW51
eC9tdGQvbXRkLmg+CiAjaW5jbHVkZSA8bGludXgvbXRkL3BhcnRpdGlvbnMuaD4KICNpbmNsdWRl
IDxsaW51eC9tdGQvbWFwLmg+CiAKICNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgogCi0jZGVmaW5l
IE1URF9JTk9ERV9GU19NQUdJQyAweDExMzA3ODU0CiBzdGF0aWMgREVGSU5FX01VVEVYKG10ZF9t
dXRleCk7CiBzdGF0aWMgc3RydWN0IHZmc21vdW50ICptdGRfaW5vZGVfbW50IF9fcmVhZF9tb3N0
bHk7CiAKZGlmZiAtLWdpdCBhL2ZzL2JpbmZtdF9taXNjLmMgYi9mcy9iaW5mbXRfbWlzYy5jCmlu
ZGV4IGE5MTk4ZGYuLjg4ZWI4MTMgMTAwNjQ0Ci0tLSBhL2ZzL2JpbmZtdF9taXNjLmMKKysrIGIv
ZnMvYmluZm10X21pc2MuYwpAQCAtMTksNiArMTksNyBAQAogI2luY2x1ZGUgPGxpbnV4L21vZHVs
ZS5oPgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KICNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPgor
I2luY2x1ZGUgPGxpbnV4L21hZ2ljLmg+CiAjaW5jbHVkZSA8bGludXgvYmluZm10cy5oPgogI2lu
Y2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNsdWRlIDxsaW51eC9jdHlwZS5oPgpAQCAtNjk5LDcg
KzcwMCw3IEBAIHN0YXRpYyBpbnQgYm1fZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKiBz
Yiwgdm9pZCAqIGRhdGEsIGludCBzaWxlbnQpCiAJCVszXSA9IHsicmVnaXN0ZXIiLCAmYm1fcmVn
aXN0ZXJfb3BlcmF0aW9ucywgU19JV1VTUn0sCiAJCS8qIGxhc3Qgb25lICovIHsiIn0KIAl9Owot
CWludCBlcnIgPSBzaW1wbGVfZmlsbF9zdXBlcihzYiwgMHg0MjQ5NGU0ZCwgYm1fZmlsZXMpOwor
CWludCBlcnIgPSBzaW1wbGVfZmlsbF9zdXBlcihzYiwgQklORk1URlNfTUFHSUMsIGJtX2ZpbGVz
KTsKIAlpZiAoIWVycikKIAkJc2ItPnNfb3AgPSAmc19vcHM7CiAJcmV0dXJuIGVycjsKZGlmZiAt
LWdpdCBhL2ZzL2Jsb2NrX2Rldi5jIGIvZnMvYmxvY2tfZGV2LmMKaW5kZXggMGU1NzVkMS4uY2Zk
NGMxMyAxMDA2NDQKLS0tIGEvZnMvYmxvY2tfZGV2LmMKKysrIGIvZnMvYmxvY2tfZGV2LmMKQEAg
LTE2LDYgKzE2LDcgQEAKICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KICNpbmNsdWRlIDxsaW51
eC9tb2R1bGUuaD4KICNpbmNsdWRlIDxsaW51eC9ibGtwZy5oPgorI2luY2x1ZGUgPGxpbnV4L21h
Z2ljLmg+CiAjaW5jbHVkZSA8bGludXgvYnVmZmVyX2hlYWQuaD4KICNpbmNsdWRlIDxsaW51eC9z
d2FwLmg+CiAjaW5jbHVkZSA8bGludXgvcGFnZXZlYy5oPgpAQCAtNTA2LDcgKzUwNyw3IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgc3VwZXJfb3BlcmF0aW9ucyBiZGV2X3NvcHMgPSB7CiBzdGF0aWMg
c3RydWN0IGRlbnRyeSAqYmRfbW91bnQoc3RydWN0IGZpbGVfc3lzdGVtX3R5cGUgKmZzX3R5cGUs
CiAJaW50IGZsYWdzLCBjb25zdCBjaGFyICpkZXZfbmFtZSwgdm9pZCAqZGF0YSkKIHsKLQlyZXR1
cm4gbW91bnRfcHNldWRvKGZzX3R5cGUsICJiZGV2OiIsICZiZGV2X3NvcHMsIE5VTEwsIDB4NjI2
NDY1NzYpOworCXJldHVybiBtb3VudF9wc2V1ZG8oZnNfdHlwZSwgImJkZXY6IiwgJmJkZXZfc29w
cywgTlVMTCwgQkRFVkZTX01BR0lDKTsKIH0KIAogc3RhdGljIHN0cnVjdCBmaWxlX3N5c3RlbV90
eXBlIGJkX3R5cGUgPSB7CmRpZmYgLS1naXQgYS9mcy9waXBlLmMgYi9mcy9waXBlLmMKaW5kZXgg
YTkzMmNlZC4uYzJmNDQ5MCAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisrKyBiL2ZzL3BpcGUuYwpA
QCAtMTMsNiArMTMsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CiAjaW5jbHVkZSA8bGludXgv
bG9nMi5oPgogI2luY2x1ZGUgPGxpbnV4L21vdW50Lmg+CisjaW5jbHVkZSA8bGludXgvbWFnaWMu
aD4KICNpbmNsdWRlIDxsaW51eC9waXBlX2ZzX2kuaD4KICNpbmNsdWRlIDxsaW51eC91aW8uaD4K
ICNpbmNsdWRlIDxsaW51eC9oaWdobWVtLmg+CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21h
Z2ljLmggYi9pbmNsdWRlL2xpbnV4L21hZ2ljLmgKaW5kZXggMmQ0YmVhYi4uYjRhOGQ0NCAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9saW51eC9tYWdpYy5oCisrKyBiL2luY2x1ZGUvbGludXgvbWFnaWMu
aApAQCAtOSw3ICs5LDYgQEAKICNkZWZpbmUgQ1JBTUZTX01BR0lDCQkweDI4Y2QzZDQ1CS8qIHNv
bWUgcmFuZG9tIG51bWJlciAqLwogI2RlZmluZSBDUkFNRlNfTUFHSUNfV0VORAkweDQ1M2RjZDI4
CS8qIG1hZ2ljIG51bWJlciB3aXRoIHRoZSB3cm9uZyBlbmRpYW5lc3MgKi8KICNkZWZpbmUgREVC
VUdGU19NQUdJQyAgICAgICAgICAweDY0NjI2NzIwCi0jZGVmaW5lIFNZU0ZTX01BR0lDCQkweDYy
NjU2NTcyCiAjZGVmaW5lIFNFQ1VSSVRZRlNfTUFHSUMJMHg3MzYzNjY3MwogI2RlZmluZSBTRUxJ
TlVYX01BR0lDCQkweGY5N2NmZjhjCiAjZGVmaW5lIFJBTUZTX01BR0lDCQkweDg1ODQ1OGY2CS8q
IHNvbWUgcmFuZG9tIG51bWJlciAqLwpAQCAtMjcsNyArMjYsNiBAQAogI2RlZmluZSBIUEZTX1NV
UEVSX01BR0lDCTB4Zjk5NWU4NDkKICNkZWZpbmUgSVNPRlNfU1VQRVJfTUFHSUMJMHg5NjYwCiAj
ZGVmaW5lIEpGRlMyX1NVUEVSX01BR0lDCTB4NzJiNgotI2RlZmluZSBBTk9OX0lOT0RFX0ZTX01B
R0lDCTB4MDkwNDE5MzQKICNkZWZpbmUgUFNUT1JFRlNfTUFHSUMJCTB4NjE2NTY3NkMKIAogI2Rl
ZmluZSBNSU5JWF9TVVBFUl9NQUdJQwkweDEzN0YJCS8qIG1pbml4IHYxIGZzLCAxNCBjaGFyIG5h
bWVzICovCkBAIC00MCw3ICszOCw2IEBACiAjZGVmaW5lIE5DUF9TVVBFUl9NQUdJQwkJMHg1NjRj
CQkvKiBHdWVzcywgd2hhdCAweDU2NGMgaXMgOi0pICovCiAjZGVmaW5lIE5GU19TVVBFUl9NQUdJ
QwkJMHg2OTY5CiAjZGVmaW5lIE9QRU5QUk9NX1NVUEVSX01BR0lDCTB4OWZhMQotI2RlZmluZSBQ
Uk9DX1NVUEVSX01BR0lDCTB4OWZhMAogI2RlZmluZSBRTlg0X1NVUEVSX01BR0lDCTB4MDAyZgkJ
LyogcW54NCBmcyBkZXRlY3Rpb24gKi8KIAogI2RlZmluZSBSRUlTRVJGU19TVVBFUl9NQUdJQwkw
eDUyNjU0OTczCS8qIHVzZWQgYnkgZ2NjICovCkBAIC01MSwxNSArNDgsMjQgQEAKICNkZWZpbmUg
UkVJU0VSMkZTX0pSX1NVUEVSX01BR0lDX1NUUklORwkiUmVJc0VyM0ZzIgogCiAjZGVmaW5lIFNN
Ql9TVVBFUl9NQUdJQwkJMHg1MTdCCi0jZGVmaW5lIFVTQkRFVklDRV9TVVBFUl9NQUdJQwkweDlm
YTIKICNkZWZpbmUgQ0dST1VQX1NVUEVSX01BR0lDCTB4MjdlMGViCiAKLSNkZWZpbmUgRlVURVhG
U19TVVBFUl9NQUdJQwkweEJBRDFERUEKIAogI2RlZmluZSBTVEFDS19FTkRfTUFHSUMJCTB4NTdB
QzZFOUQKIAorI2RlZmluZSBWOUZTX01BR0lDCQkweDAxMDIxOTk3CisKKyNkZWZpbmUgQkRFVkZT
X01BR0lDICAgICAgICAgICAgMHg2MjY0NjU3NgorI2RlZmluZSBCSU5GTVRGU19NQUdJQyAgICAg
ICAgICAweDQyNDk0ZTRkCiAjZGVmaW5lIERFVlBUU19TVVBFUl9NQUdJQwkweDFjZDEKKyNkZWZp
bmUgRlVURVhGU19TVVBFUl9NQUdJQwkweEJBRDFERUEKKyNkZWZpbmUgUElQRUZTX01BR0lDICAg
ICAgICAgICAgMHg1MDQ5NTA0NQorI2RlZmluZSBQUk9DX1NVUEVSX01BR0lDCTB4OWZhMAogI2Rl
ZmluZSBTT0NLRlNfTUFHSUMJCTB4NTM0RjQzNEIKLSNkZWZpbmUgVjlGU19NQUdJQwkJMHgwMTAy
MTk5NworI2RlZmluZSBTWVNGU19NQUdJQwkJMHg2MjY1NjU3MgorI2RlZmluZSBVU0JERVZJQ0Vf
U1VQRVJfTUFHSUMJMHg5ZmEyCisjZGVmaW5lIE1URF9JTk9ERV9GU19NQUdJQyAgICAgIDB4MTEz
MDc4NTQKKyNkZWZpbmUgQU5PTl9JTk9ERV9GU19NQUdJQwkweDA5MDQxOTM0CisKIAogI2VuZGlm
IC8qIF9fTElOVVhfTUFHSUNfSF9fICovCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3BpcGVf
ZnNfaS5oIGIvaW5jbHVkZS9saW51eC9waXBlX2ZzX2kuaAppbmRleCA3NzI1N2M5Li42ZDYyNmZm
IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3BpcGVfZnNfaS5oCisrKyBiL2luY2x1ZGUvbGlu
dXgvcGlwZV9mc19pLmgKQEAgLTEsOCArMSw2IEBACiAjaWZuZGVmIF9MSU5VWF9QSVBFX0ZTX0lf
SAogI2RlZmluZSBfTElOVVhfUElQRV9GU19JX0gKIAotI2RlZmluZSBQSVBFRlNfTUFHSUMgMHg1
MDQ5NTA0NQotCiAjZGVmaW5lIFBJUEVfREVGX0JVRkZFUlMJMTYKIAogI2RlZmluZSBQSVBFX0JV
Rl9GTEFHX0xSVQkweDAxCS8qIHBhZ2UgaXMgb24gdGhlIExSVSAqLwo=
--20cf3071ce307d7a8e04b6d78487--
