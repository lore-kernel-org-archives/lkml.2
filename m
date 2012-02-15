Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2BOX6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:58:13 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47559 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755743Ab2BOX6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:58:10 -0500
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] jffs2: Use pr_fmt and remove jffs: from formats
Date: Wed, 15 Feb 2012 15:56:45 -0800
Message-Id: <5d0bfcf32611af368a9d970af3851617bd3e41ac.1329349881.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1329349881.git.joe@perches.com>
References: <cover.1329349881.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_fmt to prefix KBUILD_MODNAME to appropriate logging messages.

Remove now unnecessary internal prefixes from formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jffs2/acl.c         |    2 ++
 fs/jffs2/background.c  |    7 ++++---
 fs/jffs2/build.c       |    6 ++++--
 fs/jffs2/compr.c       |   21 +++++++++++----------
 fs/jffs2/compr_rubin.c |    2 ++
 fs/jffs2/compr_zlib.c  |    2 ++
 fs/jffs2/debug.c       |    2 ++
 fs/jffs2/dir.c         |    2 ++
 fs/jffs2/erase.c       |    2 ++
 fs/jffs2/file.c        |    2 ++
 fs/jffs2/fs.c          |   10 ++++++----
 fs/jffs2/gc.c          |    6 ++++--
 fs/jffs2/malloc.c      |    2 ++
 fs/jffs2/nodelist.c    |    2 ++
 fs/jffs2/nodemgmt.c    |    2 ++
 fs/jffs2/read.c        |    2 ++
 fs/jffs2/readinode.c   |    2 ++
 fs/jffs2/scan.c        |    7 ++++---
 fs/jffs2/summary.c     |    5 +++--
 fs/jffs2/super.c       |   16 +++++++++-------
 fs/jffs2/symlink.c     |    2 ++
 fs/jffs2/wbuf.c        |   12 +++++++-----
 fs/jffs2/write.c       |    2 ++
 23 files changed, 80 insertions(+), 38 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 926d020..922f146 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 63dafc6..2b60ce1 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/jffs2.h>
 #include <linux/mtd/mtd.h>
@@ -48,8 +50,7 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 		ret = PTR_ERR(tsk);
 	} else {
 		/* Wait for it... */
-		jffs2_dbg(1, "JFFS2: Garbage collect thread is pid %d\n",
-			  tsk->pid);
+		jffs2_dbg(1, "Garbage collect thread is pid %d\n", tsk->pid);
 		wait_for_completion(&c->gc_thread_start);
 		ret = tsk->pid;
 	}
@@ -62,7 +63,7 @@ void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c)
 	int wait = 0;
 	spin_lock(&c->erase_completion_lock);
 	if (c->gc_task) {
-		jffs2_dbg(1, "jffs2: Killing GC task %d\n", c->gc_task->pid);
+		jffs2_dbg(1, "Killing GC task %d\n", c->gc_task->pid);
 		send_sig(SIGKILL, c->gc_task, 1);
 		wait = 1;
 	}
diff --git a/fs/jffs2/build.c b/fs/jffs2/build.c
index 3005ec4..a3750f9 100644
--- a/fs/jffs2/build.c
+++ b/fs/jffs2/build.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -307,8 +309,8 @@ static void jffs2_calc_trigger_levels(struct jffs2_sb_info *c)
 	   trying to GC to make more space. It'll be a fruitless task */
 	c->nospc_dirty_size = c->sector_size + (c->flash_size / 100);
 
-	dbg_fsbuild("JFFS2 trigger levels (size %d KiB, block size %d KiB, %d blocks)\n",
-		  c->flash_size / 1024, c->sector_size / 1024, c->nr_blocks);
+	dbg_fsbuild("trigger levels (size %d KiB, block size %d KiB, %d blocks)\n",
+		    c->flash_size / 1024, c->sector_size / 1024, c->nr_blocks);
 	dbg_fsbuild("Blocks required to allow deletion:    %d (%d KiB)\n",
 		  c->resv_blocks_deletion, c->resv_blocks_deletion*c->sector_size/1024);
 	dbg_fsbuild("Blocks required to allow writes:      %d (%d KiB)\n",
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index ee9bf23..4849a4c 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "compr.h"
 
 static DEFINE_SPINLOCK(jffs2_compressor_list_lock);
@@ -79,7 +81,7 @@ static int jffs2_selected_compress(u8 compr, unsigned char *data_in,
 
 	output_buf = kmalloc(*cdatalen, GFP_KERNEL);
 	if (!output_buf) {
-		pr_warn("JFFS2: No memory for compressor allocation. Compression failed.\n");
+		pr_warn("No memory for compressor allocation. Compression failed.\n");
 		return ret;
 	}
 	orig_slen = *datalen;
@@ -188,7 +190,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				tmp_buf = kmalloc(orig_slen, GFP_KERNEL);
 				spin_lock(&jffs2_compressor_list_lock);
 				if (!tmp_buf) {
-					pr_warn("JFFS2: No memory for compressor allocation. (%d bytes)\n",
+					pr_warn("No memory for compressor allocation. (%d bytes)\n",
 						orig_slen);
 					continue;
 				}
@@ -236,7 +238,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				cpage_out, datalen, cdatalen);
 		break;
 	default:
-		pr_err("JFFS2: unknown compression mode\n");
+		pr_err("unknown compression mode\n");
 	}
 
 	if (ret == JFFS2_COMPR_NONE) {
@@ -289,8 +291,7 @@ int jffs2_decompress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				return ret;
 			}
 		}
-		pr_warn("JFFS2 compression type 0x%02x not available\n",
-			comprtype);
+		pr_warn("compression type 0x%02x not available\n", comprtype);
 		spin_unlock(&jffs2_compressor_list_lock);
 		return -EIO;
 	}
@@ -343,7 +344,7 @@ int jffs2_unregister_compressor(struct jffs2_compressor *comp)
 
 	if (comp->usecount) {
 		spin_unlock(&jffs2_compressor_list_lock);
-		pr_warn("JFFS2: Compressor module is in use. Unregister failed.\n");
+		pr_warn("Compressor module is in use. Unregister failed.\n");
 		return -1;
 	}
 	list_del(&comp->list);
@@ -380,17 +381,17 @@ int __init jffs2_compressors_init(void)
 /* Setting default compression mode */
 #ifdef CONFIG_JFFS2_CMODE_NONE
 	jffs2_compression_mode = JFFS2_COMPR_MODE_NONE;
-	jffs2_dbg(1, "JFFS2: default compression mode: none\n");
+	jffs2_dbg(1, "default compression mode: none\n");
 #else
 #ifdef CONFIG_JFFS2_CMODE_SIZE
 	jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
-	jffs2_dbg(1, "JFFS2: default compression mode: size\n");
+	jffs2_dbg(1, "default compression mode: size\n");
 #else
 #ifdef CONFIG_JFFS2_CMODE_FAVOURLZO
 	jffs2_compression_mode = JFFS2_COMPR_MODE_FAVOURLZO;
-	jffs2_dbg(1, "JFFS2: default compression mode: favourlzo\n");
+	jffs2_dbg(1, "default compression mode: favourlzo\n");
 #else
-	jffs2_dbg(1, "JFFS2: default compression mode: priority\n");
+	jffs2_dbg(1, "default compression mode: priority\n");
 #endif
 #endif
 #endif
diff --git a/fs/jffs2/compr_rubin.c b/fs/jffs2/compr_rubin.c
index 9e7cec8..92e0644 100644
--- a/fs/jffs2/compr_rubin.c
+++ b/fs/jffs2/compr_rubin.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/jffs2.h>
diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 88529e4..0b9a1e4 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -14,6 +14,8 @@
 #error "The userspace support got too messy and was removed. Update your mkfs.jffs2"
 #endif
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/zlib.h>
 #include <linux/zutil.h>
diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
index 6cac7d6..f8a99a3 100644
--- a/fs/jffs2/debug.c
+++ b/fs/jffs2/debug.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pagemap.h>
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index a7a3c1a..b560188 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index 5f14309..e7594c6 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 5ffc356..db3889b 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/time.h>
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 0da3ca3..c47f69e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -513,11 +515,11 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 
 #ifndef CONFIG_JFFS2_FS_WRITEBUFFER
 	if (c->mtd->type == MTD_NANDFLASH) {
-		pr_err("jffs2: Cannot operate on NAND flash unless jffs2 NAND support is compiled in.\n");
+		pr_err("Cannot operate on NAND flash unless jffs2 NAND support is compiled in\n");
 		return -EINVAL;
 	}
 	if (c->mtd->type == MTD_DATAFLASH) {
-		pr_err("jffs2: Cannot operate on DataFlash unless jffs2 DataFlash support is compiled in.\n");
+		pr_err("Cannot operate on DataFlash unless jffs2 DataFlash support is compiled in\n");
 		return -EINVAL;
 	}
 #endif
@@ -531,12 +533,12 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	if ((c->sector_size * blocks) != c->flash_size) {
 		c->flash_size = c->sector_size * blocks;
-		pr_info("jffs2: Flash size not aligned to erasesize, reducing to %dKiB\n",
+		pr_info("Flash size not aligned to erasesize, reducing to %dKiB\n",
 			c->flash_size / 1024);
 	}
 
 	if (c->flash_size < 5*c->sector_size) {
-		pr_err("jffs2: Too few erase blocks (%d)\n",
+		pr_err("Too few erase blocks (%d)\n",
 		       c->flash_size / c->sector_size);
 		return -EINVAL;
 	}
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index d7936d0..ad271c7 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
@@ -88,7 +90,7 @@ again:
 		goto again;
 	} else {
 		/* Eep. All were empty */
-		jffs2_dbg(1, "jffs2: No clean, dirty _or_ erasable blocks to GC from! Where are they all?\n");
+		jffs2_dbg(1, "No clean, dirty _or_ erasable blocks to GC from! Where are they all?\n");
 		return NULL;
 	}
 
@@ -249,7 +251,7 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			mutex_unlock(&c->alloc_sem);
 			return -EAGAIN;
 		}
-		jffs2_dbg(1, "jffs2: Couldn't find erase block to garbage collect!\n");
+		jffs2_dbg(1, "Couldn't find erase block to garbage collect!\n");
 		spin_unlock(&c->erase_completion_lock);
 		mutex_unlock(&c->alloc_sem);
 		return -EIO;
diff --git a/fs/jffs2/malloc.c b/fs/jffs2/malloc.c
index c082868..4f47aa2 100644
--- a/fs/jffs2/malloc.c
+++ b/fs/jffs2/malloc.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c
index fc16761..975a1f5 100644
--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 563a5f6..6784d1e 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
 #include <linux/compiler.h>
diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index 925ec65..0b042b1 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/crc32.h>
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 3093ac4..dc0437e 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index 078cede..7654e87 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -218,15 +220,14 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 		case BLK_STATE_ALLDIRTY:
 			/* Nothing valid - not even a clean marker. Needs erasing. */
 			/* For now we just put it on the erasing list. We'll start the erases later */
-			jffs2_dbg(1, "JFFS2: Erase block at 0x%08x is not formatted. It will be erased\n",
+			jffs2_dbg(1, "Erase block at 0x%08x is not formatted. It will be erased\n",
 				  jeb->offset);
 			list_add(&jeb->list, &c->erase_pending_list);
 			c->nr_erasing_blocks++;
 			break;
 
 		case BLK_STATE_BADBLOCK:
-			jffs2_dbg(1, "JFFS2: Block at 0x%08x is bad\n",
-				  jeb->offset);
+			jffs2_dbg(1, "Block at 0x%08x is bad\n", jeb->offset);
 			list_add(&jeb->list, &c->bad_list);
 			c->bad_size += c->sector_size;
 			c->free_size -= c->sector_size;
diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index 0789e4e..c522d09 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
@@ -811,8 +813,7 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 
 	sum_ofs = jeb->offset + c->sector_size - jeb->free_size;
 
-	dbg_summary("JFFS2: writing out data to flash to pos : 0x%08x\n",
-		    sum_ofs);
+	dbg_summary("writing out data to flash to pos : 0x%08x\n", sum_ofs);
 
 	ret = jffs2_flash_writev(c, vecs, 2, sum_ofs, &retlen, 0);
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 9e3ba7f..f9916f3 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -214,7 +216,7 @@ static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
 						JFFS2_COMPR_MODE_FORCEZLIB;
 #endif
 			else {
-				pr_err("JFFS2 Error: unknown compressor \"%s\"",
+				pr_err("Error: unknown compressor \"%s\"\n",
 				       name);
 				kfree(name);
 				return -EINVAL;
@@ -223,7 +225,7 @@ static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
 			c->mount_opts.override_compr = true;
 			break;
 		default:
-			pr_err("JFFS2 Error: unrecognized mount option '%s' or missing value\n",
+			pr_err("Error: unrecognized mount option '%s' or missing value\n",
 			       p);
 			return -EINVAL;
 		}
@@ -371,7 +373,7 @@ static int __init init_jffs2_fs(void)
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);
 
-	pr_info("JFFS2 version 2.2."
+	pr_info("version 2.2."
 #ifdef CONFIG_JFFS2_FS_WRITEBUFFER
 	       " (NAND)"
 #endif
@@ -386,22 +388,22 @@ static int __init init_jffs2_fs(void)
 						SLAB_MEM_SPREAD),
 					     jffs2_i_init_once);
 	if (!jffs2_inode_cachep) {
-		pr_err("JFFS2 error: Failed to initialise inode cache\n");
+		pr_err("error: Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = jffs2_compressors_init();
 	if (ret) {
-		pr_err("JFFS2 error: Failed to initialise compressors\n");
+		pr_err("error: Failed to initialise compressors\n");
 		goto out;
 	}
 	ret = jffs2_create_slab_caches();
 	if (ret) {
-		pr_err("JFFS2 error: Failed to initialise slab caches\n");
+		pr_err("error: Failed to initialise slab caches\n");
 		goto out_compressors;
 	}
 	ret = register_filesystem(&jffs2_fs_type);
 	if (ret) {
-		pr_err("JFFS2 error: Failed to register filesystem\n");
+		pr_err("error: Failed to register filesystem\n");
 		goto out_slab;
 	}
 	return 0;
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index 56eeed5..6e56333 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 89a6ec0..74d9be1 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
@@ -1135,7 +1137,7 @@ int jffs2_write_nand_badblock(struct jffs2_sb_info *c, struct jffs2_eraseblock *
 	if( ++jeb->bad_count < MAX_ERASE_FAILURES)
 		return 0;
 
-	pr_warn("JFFS2: marking eraseblock at %08x as bad\n", bad_offset);
+	pr_warn("marking eraseblock at %08x as bad\n", bad_offset);
 	ret = mtd_block_markbad(c->mtd, bad_offset);
 
 	if (ret) {
@@ -1161,7 +1163,7 @@ int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 		return -EINVAL;
 	}
 
-	jffs2_dbg(1, "JFFS2 using OOB on NAND\n");
+	jffs2_dbg(1, "using OOB on NAND\n");
 
 	c->oobavail = oinfo->oobavail;
 
@@ -1228,7 +1230,7 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
-		pr_warn("JFFS2 flash size adjusted to %dKiB\n", c->flash_size);
+		pr_warn("flash size adjusted to %dKiB\n", c->flash_size);
 	};
 
 	c->wbuf_ofs = 0xFFFFFFFF;
@@ -1245,7 +1247,7 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 	}
 #endif
 
-	pr_info("JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n",
+	pr_info("write-buffering enabled buffer (%d) erasesize (%d)\n",
 		c->wbuf_pagesize, c->sector_size);
 
 	return 0;
@@ -1304,7 +1306,7 @@ int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
 	if (!c->wbuf)
 		return -ENOMEM;
 
-	pr_info("JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n",
+	pr_info("write-buffering enabled buffer (%d) erasesize (%d)\n",
 		c->wbuf_pagesize, c->sector_size);
 
 	return 0;
diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index d98b220..b634de4 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/crc32.h>
-- 
1.7.8.111.gad25c.dirty

