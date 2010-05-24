Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0EXS1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:27:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47168 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab0EXS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:27:35 -0400
Message-ID: <4BFAC435.4060402@vflare.org>
Date: Mon, 24 May 2010 23:53:49 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Rename ramzswap to zram in code.
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org> <1274710685-2351-3-git-send-email-ngupta@vflare.org> <201005241731.31048.arnd@arndb.de>
In-Reply-To: <201005241731.31048.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending with -M option to git format-patch. Other patches
are not affected with this option.  Thanks Arnd!)

Rename ramzswap to zram in code and also rename
files accordingly.

Automated renames in code:
 - rzs* -> zram*
 - ramzswap* -> zram*
 - RZS -> ZRAM*

(somehow git is not allowing separate commits for
file renames and renames in code).

ramzswap devices are no longer limited to handling
swap requests only. They can now handle arbitrary
I/O requests. So, renaming ramzswap files to zram
to reflect this change. Next few patches will do
similar naming changes within code and documentation.

Changes are also made to various Kconfig and Makefile
so that this patch is compilable.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ramzswap/Kconfig                   |   21 -
 drivers/staging/ramzswap/Makefile                  |    3 -
 drivers/staging/zram/Kconfig                       |   24 ++
 drivers/staging/zram/Makefile                      |    3 +
 drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
 .../{ramzswap/ramzswap.txt => zram/zram.txt}       |    0
 .../{ramzswap/ramzswap_drv.c => zram/zram_drv.c}   |  429 ++++++++++----------
 .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |   56 ++--
 .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |   16 +-
 13 files changed, 280 insertions(+), 276 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/Kconfig
 delete mode 100644 drivers/staging/ramzswap/Makefile
 create mode 100644 drivers/staging/zram/Kconfig
 create mode 100644 drivers/staging/zram/Makefile
 rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
 rename drivers/staging/{ramzswap/ramzswap.txt => zram/zram.txt} (100%)
 rename drivers/staging/{ramzswap/ramzswap_drv.c => zram/zram_drv.c} (51%)
 rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (77%)
 rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (77%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index b5c3b30..32d5300 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -117,7 +117,7 @@ source "drivers/staging/sep/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
-source "drivers/staging/ramzswap/Kconfig"
+source "drivers/staging/zram/Kconfig"
 
 source "drivers/staging/wlags49_h2/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e330dd5..cec25b0 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_RAR_REGISTER)	+= rar_register/
 obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
 obj-$(CONFIG_DX_SEP)		+= sep/
 obj-$(CONFIG_IIO)		+= iio/
-obj-$(CONFIG_RAMZSWAP)		+= ramzswap/
+obj-$(CONFIG_ZRAM)		+= zram/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
diff --git a/drivers/staging/ramzswap/Kconfig b/drivers/staging/ramzswap/Kconfig
deleted file mode 100644
index 127b3c6..0000000
--- a/drivers/staging/ramzswap/Kconfig
+++ /dev/null
@@ -1,21 +0,0 @@
-config RAMZSWAP
-	tristate "Compressed in-memory swap device (ramzswap)"
-	depends on SWAP
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
-	default n
-	help
-	  Creates virtual block devices which can (only) be used as swap
-	  disks. Pages swapped to these disks are compressed and stored in
-	  memory itself.
-
-	  See ramzswap.txt for more information.
-	  Project home: http://compcache.googlecode.com/
-
-config RAMZSWAP_STATS
-	bool "Enable ramzswap stats"
-	depends on RAMZSWAP
-	default y
-	help
-	  Enable statistics collection for ramzswap. This adds only a minimal
-	  overhead. In unsure, say Y.
diff --git a/drivers/staging/ramzswap/Makefile b/drivers/staging/ramzswap/Makefile
deleted file mode 100644
index 507d7dc..0000000
--- a/drivers/staging/ramzswap/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-ramzswap-objs	:=	ramzswap_drv.o xvmalloc.o
-
-obj-$(CONFIG_RAMZSWAP)	+=	ramzswap.o
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
new file mode 100644
index 0000000..fad9ff5
--- /dev/null
+++ b/drivers/staging/zram/Kconfig
@@ -0,0 +1,24 @@
+config ZRAM
+	tristate "Compressed in-memory block device (zram)"
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	default n
+	help
+	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
+	  Pages written to these disks are compressed and stored in memory
+	  itself. These disks allow very fast I/O and compression provides
+	  good amounts of memory savings.
+
+	  It has several use cases, for example: /tmp storage, use as swap
+	  disks and maybe many more.
+
+	  See zram.txt for more information.
+	  Project home: http://compcache.googlecode.com/
+
+config ZRAM_STATS
+	bool "Enable zram stats"
+	depends on ZRAM
+	default y
+	help
+	  Enable statistics collection for zram devices. This adds only a
+	  minimal overhead. In unsure, say Y.
diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
new file mode 100644
index 0000000..b2c087a
--- /dev/null
+++ b/drivers/staging/zram/Makefile
@@ -0,0 +1,3 @@
+zram-objs	:=	zram_drv.o xvmalloc.o
+
+obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/staging/ramzswap/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc.c
rename to drivers/staging/zram/xvmalloc.c
diff --git a/drivers/staging/ramzswap/xvmalloc.h b/drivers/staging/zram/xvmalloc.h
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc.h
rename to drivers/staging/zram/xvmalloc.h
diff --git a/drivers/staging/ramzswap/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc_int.h
rename to drivers/staging/zram/xvmalloc_int.h
diff --git a/drivers/staging/ramzswap/ramzswap.txt b/drivers/staging/zram/zram.txt
similarity index 100%
rename from drivers/staging/ramzswap/ramzswap.txt
rename to drivers/staging/zram/zram.txt
diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/zram/zram_drv.c
similarity index 51%
rename from drivers/staging/ramzswap/ramzswap_drv.c
rename to drivers/staging/zram/zram_drv.c
index 9d20d23..e962757 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -1,5 +1,5 @@
 /*
- * Compressed RAM based swap device
+ * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
@@ -12,7 +12,7 @@
  * Project home: http://compcache.googlecode.com
  */
 
-#define KMSG_COMPONENT "ramzswap"
+#define KMSG_COMPONENT "zram"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
@@ -30,31 +30,31 @@
 #include <linux/swapops.h>
 #include <linux/vmalloc.h>
 
-#include "ramzswap_drv.h"
+#include "zram_drv.h"
 
 /* Globals */
-static int ramzswap_major;
-static struct ramzswap *devices;
+static int zram_major;
+static struct zram *devices;
 
 /* Module params (documentation at end) */
 static unsigned int num_devices;
 
-static int rzs_test_flag(struct ramzswap *rzs, u32 index,
-			enum rzs_pageflags flag)
+static int zram_test_flag(struct zram *zram, u32 index,
+			enum zram_pageflags flag)
 {
-	return rzs->table[index].flags & BIT(flag);
+	return zram->table[index].flags & BIT(flag);
 }
 
-static void rzs_set_flag(struct ramzswap *rzs, u32 index,
-			enum rzs_pageflags flag)
+static void zram_set_flag(struct zram *zram, u32 index,
+			enum zram_pageflags flag)
 {
-	rzs->table[index].flags |= BIT(flag);
+	zram->table[index].flags |= BIT(flag);
 }
 
-static void rzs_clear_flag(struct ramzswap *rzs, u32 index,
-			enum rzs_pageflags flag)
+static void zram_clear_flag(struct zram *zram, u32 index,
+			enum zram_pageflags flag)
 {
-	rzs->table[index].flags &= ~BIT(flag);
+	zram->table[index].flags &= ~BIT(flag);
 }
 
 static int page_zero_filled(void *ptr)
@@ -72,50 +72,50 @@ static int page_zero_filled(void *ptr)
 	return 1;
 }
 
-static void ramzswap_set_disksize(struct ramzswap *rzs, size_t totalram_bytes)
+static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
 {
-	if (!rzs->disksize) {
+	if (!zram->disksize) {
 		pr_info(
 		"disk size not provided. You can use disksize_kb module "
 		"param to specify size.\nUsing default: (%u%% of RAM).\n",
 		default_disksize_perc_ram
 		);
-		rzs->disksize = default_disksize_perc_ram *
+		zram->disksize = default_disksize_perc_ram *
 					(totalram_bytes / 100);
 	}
 
-	if (rzs->disksize > 2 * (totalram_bytes)) {
+	if (zram->disksize > 2 * (totalram_bytes)) {
 		pr_info(
-		"There is little point creating a ramzswap of greater than "
+		"There is little point creating a zram of greater than "
 		"twice the size of memory since we expect a 2:1 compression "
-		"ratio. Note that ramzswap uses about 0.1%% of the size of "
-		"the swap device when not in use so a huge ramzswap is "
+		"ratio. Note that zram uses about 0.1%% of the size of "
+		"the swap device when not in use so a huge zram is "
 		"wasteful.\n"
 		"\tMemory Size: %zu kB\n"
 		"\tSize you selected: %zu kB\n"
 		"Continuing anyway ...\n",
-		totalram_bytes >> 10, rzs->disksize
+		totalram_bytes >> 10, zram->disksize
 		);
 	}
 
-	rzs->disksize &= PAGE_MASK;
+	zram->disksize &= PAGE_MASK;
 }
 
-static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
-			struct ramzswap_ioctl_stats *s)
+static void zram_ioctl_get_stats(struct zram *zram,
+			struct zram_ioctl_stats *s)
 {
-	s->disksize = rzs->disksize;
+	s->disksize = zram->disksize;
 
-#if defined(CONFIG_RAMZSWAP_STATS)
+#if defined(CONFIG_ZRAM_STATS)
 	{
-	struct ramzswap_stats *rs = &rzs->stats;
+	struct zram_stats *rs = &zram->stats;
 	size_t succ_writes, mem_used;
 	unsigned int good_compress_perc = 0, no_compress_perc = 0;
 
-	mem_used = xv_get_total_size_bytes(rzs->mem_pool)
+	mem_used = xv_get_total_size_bytes(zram->mem_pool)
 			+ (rs->pages_expand << PAGE_SHIFT);
-	succ_writes = rzs_stat64_read(rzs, &rs->num_writes) -
-			rzs_stat64_read(rzs, &rs->failed_writes);
+	succ_writes = zram_stat64_read(zram, &rs->num_writes) -
+			zram_stat64_read(zram, &rs->failed_writes);
 
 	if (succ_writes && rs->pages_stored) {
 		good_compress_perc = rs->good_compress * 100
@@ -124,12 +124,12 @@ static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 					/ rs->pages_stored;
 	}
 
-	s->num_reads = rzs_stat64_read(rzs, &rs->num_reads);
-	s->num_writes = rzs_stat64_read(rzs, &rs->num_writes);
-	s->failed_reads = rzs_stat64_read(rzs, &rs->failed_reads);
-	s->failed_writes = rzs_stat64_read(rzs, &rs->failed_writes);
-	s->invalid_io = rzs_stat64_read(rzs, &rs->invalid_io);
-	s->notify_free = rzs_stat64_read(rzs, &rs->notify_free);
+	s->num_reads = zram_stat64_read(zram, &rs->num_reads);
+	s->num_writes = zram_stat64_read(zram, &rs->num_writes);
+	s->failed_reads = zram_stat64_read(zram, &rs->failed_reads);
+	s->failed_writes = zram_stat64_read(zram, &rs->failed_writes);
+	s->invalid_io = zram_stat64_read(zram, &rs->invalid_io);
+	s->notify_free = zram_stat64_read(zram, &rs->notify_free);
 	s->pages_zero = rs->pages_zero;
 
 	s->good_compress_pct = good_compress_perc;
@@ -141,34 +141,34 @@ static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 	s->compr_data_size = rs->compr_size;
 	s->mem_used_total = mem_used;
 	}
-#endif /* CONFIG_RAMZSWAP_STATS */
+#endif /* CONFIG_ZRAM_STATS */
 }
 
-static void ramzswap_free_page(struct ramzswap *rzs, size_t index)
+static void zram_free_page(struct zram *zram, size_t index)
 {
 	u32 clen;
 	void *obj;
 
-	struct page *page = rzs->table[index].page;
-	u32 offset = rzs->table[index].offset;
+	struct page *page = zram->table[index].page;
+	u32 offset = zram->table[index].offset;
 
 	if (unlikely(!page)) {
 		/*
 		 * No memory is allocated for zero filled pages.
 		 * Simply clear zero page flag.
 		 */
-		if (rzs_test_flag(rzs, index, RZS_ZERO)) {
-			rzs_clear_flag(rzs, index, RZS_ZERO);
-			rzs_stat_dec(&rzs->stats.pages_zero);
+		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
+			zram_clear_flag(zram, index, ZRAM_ZERO);
+			zram_stat_dec(&zram->stats.pages_zero);
 		}
 		return;
 	}
 
-	if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED))) {
+	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
 		clen = PAGE_SIZE;
 		__free_page(page);
-		rzs_clear_flag(rzs, index, RZS_UNCOMPRESSED);
-		rzs_stat_dec(&rzs->stats.pages_expand);
+		zram_clear_flag(zram, index, ZRAM_UNCOMPRESSED);
+		zram_stat_dec(&zram->stats.pages_expand);
 		goto out;
 	}
 
@@ -176,16 +176,16 @@ static void ramzswap_free_page(struct ramzswap *rzs, size_t index)
 	clen = xv_get_object_size(obj) - sizeof(struct zobj_header);
 	kunmap_atomic(obj, KM_USER0);
 
-	xv_free(rzs->mem_pool, page, offset);
+	xv_free(zram->mem_pool, page, offset);
 	if (clen <= PAGE_SIZE / 2)
-		rzs_stat_dec(&rzs->stats.good_compress);
+		zram_stat_dec(&zram->stats.good_compress);
 
 out:
-	rzs->stats.compr_size -= clen;
-	rzs_stat_dec(&rzs->stats.pages_stored);
+	zram->stats.compr_size -= clen;
+	zram_stat_dec(&zram->stats.pages_stored);
 
-	rzs->table[index].page = NULL;
-	rzs->table[index].offset = 0;
+	zram->table[index].page = NULL;
+	zram->table[index].offset = 0;
 }
 
 static void handle_zero_page(struct page *page, u32 index)
@@ -199,14 +199,14 @@ static void handle_zero_page(struct page *page, u32 index)
 	flush_dcache_page(page);
 }
 
-static void handle_uncompressed_page(struct ramzswap *rzs,
+static void handle_uncompressed_page(struct zram *zram,
 				struct page *page, u32 index)
 {
 	unsigned char *user_mem, *cmem;
 
 	user_mem = kmap_atomic(page, KM_USER0);
-	cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
-			rzs->table[index].offset;
+	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+			zram->table[index].offset;
 
 	memcpy(user_mem, cmem, PAGE_SIZE);
 	kunmap_atomic(user_mem, KM_USER0);
@@ -215,14 +215,14 @@ static void handle_uncompressed_page(struct ramzswap *rzs,
 	flush_dcache_page(page);
 }
 
-static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
+static int zram_read(struct zram *zram, struct bio *bio)
 {
 
 	int i;
 	u32 index;
 	struct bio_vec *bvec;
 
-	rzs_stat64_inc(rzs, &rzs->stats.num_reads);
+	zram_stat64_inc(zram, &zram->stats.num_reads);
 
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	bio_for_each_segment(bvec, bio, i) {
@@ -234,13 +234,13 @@ static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
 
 		page = bvec->bv_page;
 
-		if (rzs_test_flag(rzs, index, RZS_ZERO)) {
+		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
 			handle_zero_page(page, index);
 			continue;
 		}
 
 		/* Requested page is not present in compressed area */
-		if (unlikely(!rzs->table[index].page)) {
+		if (unlikely(!zram->table[index].page)) {
 			pr_debug("Read before write on swap device: "
 				"sector=%lu, size=%u",
 				(ulong)(bio->bi_sector), bio->bi_size);
@@ -249,16 +249,16 @@ static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
 		}
 
 		/* Page is stored uncompressed since it's incompressible */
-		if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED))) {
-			handle_uncompressed_page(rzs, page, index);
+		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
+			handle_uncompressed_page(zram, page, index);
 			continue;
 		}
 
 		user_mem = kmap_atomic(page, KM_USER0);
 		clen = PAGE_SIZE;
 
-		cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
-				rzs->table[index].offset;
+		cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+				zram->table[index].offset;
 
 		ret = lzo1x_decompress_safe(
 			cmem + sizeof(*zheader),
@@ -272,7 +272,7 @@ static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
 		if (unlikely(ret != LZO_E_OK)) {
 			pr_err("Decompression failed! err=%d, page=%u\n",
 				ret, index);
-			rzs_stat64_inc(rzs, &rzs->stats.failed_reads);
+			zram_stat64_inc(zram, &zram->stats.failed_reads);
 			goto out;
 		}
 
@@ -289,13 +289,13 @@ out:
 	return 0;
 }
 
-static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
+static int zram_write(struct zram *zram, struct bio *bio)
 {
 	int i;
 	u32 index;
 	struct bio_vec *bvec;
 
-	rzs_stat64_inc(rzs, &rzs->stats.num_writes);
+	zram_stat64_inc(zram, &zram->stats.num_writes);
 
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
@@ -308,36 +308,36 @@ static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
 		unsigned char *user_mem, *cmem, *src;
 
 		page = bvec->bv_page;
-		src = rzs->compress_buffer;
+		src = zram->compress_buffer;
 
 		/*
 		 * System overwrites unused sectors. Free memory associated
 		 * with this sector now.
 		 */
-		if (rzs->table[index].page ||
-				rzs_test_flag(rzs, index, RZS_ZERO))
-			ramzswap_free_page(rzs, index);
+		if (zram->table[index].page ||
+				zram_test_flag(zram, index, ZRAM_ZERO))
+			zram_free_page(zram, index);
 
-		mutex_lock(&rzs->lock);
+		mutex_lock(&zram->lock);
 
 		user_mem = kmap_atomic(page, KM_USER0);
 		if (page_zero_filled(user_mem)) {
 			kunmap_atomic(user_mem, KM_USER0);
-			mutex_unlock(&rzs->lock);
-			rzs_stat_inc(&rzs->stats.pages_zero);
-			rzs_set_flag(rzs, index, RZS_ZERO);
+			mutex_unlock(&zram->lock);
+			zram_stat_inc(&zram->stats.pages_zero);
+			zram_set_flag(zram, index, ZRAM_ZERO);
 			continue;
 		}
 
 		ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
-					rzs->compress_workmem);
+					zram->compress_workmem);
 
 		kunmap_atomic(user_mem, KM_USER0);
 
 		if (unlikely(ret != LZO_E_OK)) {
-			mutex_unlock(&rzs->lock);
+			mutex_unlock(&zram->lock);
 			pr_err("Compression failed! err=%d\n", ret);
-			rzs_stat64_inc(rzs, &rzs->stats.failed_writes);
+			zram_stat64_inc(zram, &zram->stats.failed_writes);
 			goto out;
 		}
 
@@ -350,40 +350,41 @@ static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
 			clen = PAGE_SIZE;
 			page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
 			if (unlikely(!page_store)) {
-				mutex_unlock(&rzs->lock);
+				mutex_unlock(&zram->lock);
 				pr_info("Error allocating memory for "
 					"incompressible page: %u\n", index);
-				rzs_stat64_inc(rzs, &rzs->stats.failed_writes);
+				zram_stat64_inc(zram,
+					&zram->stats.failed_writes);
 				goto out;
 			}
 
 			offset = 0;
-			rzs_set_flag(rzs, index, RZS_UNCOMPRESSED);
-			rzs_stat_inc(&rzs->stats.pages_expand);
-			rzs->table[index].page = page_store;
+			zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
+			zram_stat_inc(&zram->stats.pages_expand);
+			zram->table[index].page = page_store;
 			src = kmap_atomic(page, KM_USER0);
 			goto memstore;
 		}
 
-		if (xv_malloc(rzs->mem_pool, clen + sizeof(*zheader),
-				&rzs->table[index].page, &offset,
+		if (xv_malloc(zram->mem_pool, clen + sizeof(*zheader),
+				&zram->table[index].page, &offset,
 				GFP_NOIO | __GFP_HIGHMEM)) {
-			mutex_unlock(&rzs->lock);
+			mutex_unlock(&zram->lock);
 			pr_info("Error allocating memory for compressed "
 				"page: %u, size=%zu\n", index, clen);
-			rzs_stat64_inc(rzs, &rzs->stats.failed_writes);
+			zram_stat64_inc(zram, &zram->stats.failed_writes);
 			goto out;
 		}
 
 memstore:
-		rzs->table[index].offset = offset;
+		zram->table[index].offset = offset;
 
-		cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
-				rzs->table[index].offset;
+		cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
+				zram->table[index].offset;
 
 #if 0
 		/* Back-reference needed for memory defragmentation */
-		if (!rzs_test_flag(rzs, index, RZS_UNCOMPRESSED)) {
+		if (!zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)) {
 			zheader = (struct zobj_header *)cmem;
 			zheader->table_idx = index;
 			cmem += sizeof(*zheader);
@@ -393,16 +394,16 @@ memstore:
 		memcpy(cmem, src, clen);
 
 		kunmap_atomic(cmem, KM_USER1);
-		if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED)))
+		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
 			kunmap_atomic(src, KM_USER0);
 
 		/* Update stats */
-		rzs->stats.compr_size += clen;
-		rzs_stat_inc(&rzs->stats.pages_stored);
+		zram->stats.compr_size += clen;
+		zram_stat_inc(&zram->stats.pages_stored);
 		if (clen <= PAGE_SIZE / 2)
-			rzs_stat_inc(&rzs->stats.good_compress);
+			zram_stat_inc(&zram->stats.good_compress);
 
-		mutex_unlock(&rzs->lock);
+		mutex_unlock(&zram->lock);
 		index++;
 	}
 
@@ -418,10 +419,10 @@ out:
 /*
  * Check if request is within bounds and page aligned.
  */
-static inline int valid_io_request(struct ramzswap *rzs, struct bio *bio)
+static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
 	if (unlikely(
-		(bio->bi_sector >= (rzs->disksize >> SECTOR_SHIFT)) ||
+		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
 		(bio->bi_sector & (SECTORS_PER_PAGE - 1)) ||
 		(bio->bi_size & (PAGE_SIZE - 1)))) {
 
@@ -433,160 +434,160 @@ static inline int valid_io_request(struct ramzswap *rzs, struct bio *bio)
 }
 
 /*
- * Handler function for all ramzswap I/O requests.
+ * Handler function for all zram I/O requests.
  */
-static int ramzswap_make_request(struct request_queue *queue, struct bio *bio)
+static int zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	int ret = 0;
-	struct ramzswap *rzs = queue->queuedata;
+	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!rzs->init_done)) {
+	if (unlikely(!zram->init_done)) {
 		bio_io_error(bio);
 		return 0;
 	}
 
-	if (!valid_io_request(rzs, bio)) {
-		rzs_stat64_inc(rzs, &rzs->stats.invalid_io);
+	if (!valid_io_request(zram, bio)) {
+		zram_stat64_inc(zram, &zram->stats.invalid_io);
 		bio_io_error(bio);
 		return 0;
 	}
 
 	switch (bio_data_dir(bio)) {
 	case READ:
-		ret = ramzswap_read(rzs, bio);
+		ret = zram_read(zram, bio);
 		break;
 
 	case WRITE:
-		ret = ramzswap_write(rzs, bio);
+		ret = zram_write(zram, bio);
 		break;
 	}
 
 	return ret;
 }
 
-static void reset_device(struct ramzswap *rzs)
+static void reset_device(struct zram *zram)
 {
 	size_t index;
 
 	/* Do not accept any new I/O request */
-	rzs->init_done = 0;
+	zram->init_done = 0;
 
 	/* Free various per-device buffers */
-	kfree(rzs->compress_workmem);
-	free_pages((unsigned long)rzs->compress_buffer, 1);
+	kfree(zram->compress_workmem);
+	free_pages((unsigned long)zram->compress_buffer, 1);
 
-	rzs->compress_workmem = NULL;
-	rzs->compress_buffer = NULL;
+	zram->compress_workmem = NULL;
+	zram->compress_buffer = NULL;
 
-	/* Free all pages that are still in this ramzswap device */
-	for (index = 0; index < rzs->disksize >> PAGE_SHIFT; index++) {
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
 		struct page *page;
 		u16 offset;
 
-		page = rzs->table[index].page;
-		offset = rzs->table[index].offset;
+		page = zram->table[index].page;
+		offset = zram->table[index].offset;
 
 		if (!page)
 			continue;
 
-		if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED)))
+		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
 			__free_page(page);
 		else
-			xv_free(rzs->mem_pool, page, offset);
+			xv_free(zram->mem_pool, page, offset);
 	}
 
-	vfree(rzs->table);
-	rzs->table = NULL;
+	vfree(zram->table);
+	zram->table = NULL;
 
-	xv_destroy_pool(rzs->mem_pool);
-	rzs->mem_pool = NULL;
+	xv_destroy_pool(zram->mem_pool);
+	zram->mem_pool = NULL;
 
 	/* Reset stats */
-	memset(&rzs->stats, 0, sizeof(rzs->stats));
+	memset(&zram->stats, 0, sizeof(zram->stats));
 
-	rzs->disksize = 0;
+	zram->disksize = 0;
 }
 
-static int ramzswap_ioctl_init_device(struct ramzswap *rzs)
+static int zram_ioctl_init_device(struct zram *zram)
 {
 	int ret;
 	size_t num_pages;
 
-	if (rzs->init_done) {
+	if (zram->init_done) {
 		pr_info("Device already initialized!\n");
 		return -EBUSY;
 	}
 
-	ramzswap_set_disksize(rzs, totalram_pages << PAGE_SHIFT);
+	zram_set_disksize(zram, totalram_pages << PAGE_SHIFT);
 
-	rzs->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!rzs->compress_workmem) {
+	zram->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (!zram->compress_workmem) {
 		pr_err("Error allocating compressor working memory!\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	rzs->compress_buffer = (void *)__get_free_pages(__GFP_ZERO, 1);
-	if (!rzs->compress_buffer) {
+	zram->compress_buffer = (void *)__get_free_pages(__GFP_ZERO, 1);
+	if (!zram->compress_buffer) {
 		pr_err("Error allocating compressor buffer space\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	num_pages = rzs->disksize >> PAGE_SHIFT;
-	rzs->table = vmalloc(num_pages * sizeof(*rzs->table));
-	if (!rzs->table) {
-		pr_err("Error allocating ramzswap address table\n");
+	num_pages = zram->disksize >> PAGE_SHIFT;
+	zram->table = vmalloc(num_pages * sizeof(*zram->table));
+	if (!zram->table) {
+		pr_err("Error allocating zram address table\n");
 		/* To prevent accessing table entries during cleanup */
-		rzs->disksize = 0;
+		zram->disksize = 0;
 		ret = -ENOMEM;
 		goto fail;
 	}
-	memset(rzs->table, 0, num_pages * sizeof(*rzs->table));
+	memset(zram->table, 0, num_pages * sizeof(*zram->table));
 
-	set_capacity(rzs->disk, rzs->disksize >> SECTOR_SHIFT);
+	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 
-	/* ramzswap devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, rzs->disk->queue);
+	/* zram devices sort of resembles non-rotational disks */
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
-	rzs->mem_pool = xv_create_pool();
-	if (!rzs->mem_pool) {
+	zram->mem_pool = xv_create_pool();
+	if (!zram->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	rzs->init_done = 1;
+	zram->init_done = 1;
 
 	pr_debug("Initialization done!\n");
 	return 0;
 
 fail:
-	reset_device(rzs);
+	reset_device(zram);
 
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
 
-static int ramzswap_ioctl_reset_device(struct ramzswap *rzs)
+static int zram_ioctl_reset_device(struct zram *zram)
 {
-	if (rzs->init_done)
-		reset_device(rzs);
+	if (zram->init_done)
+		reset_device(zram);
 
 	return 0;
 }
 
-static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
+static int zram_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	int ret = 0;
 	size_t disksize_kb;
 
-	struct ramzswap *rzs = bdev->bd_disk->private_data;
+	struct zram *zram = bdev->bd_disk->private_data;
 
 	switch (cmd) {
-	case RZSIO_SET_DISKSIZE_KB:
-		if (rzs->init_done) {
+	case ZRAMIO_SET_DISKSIZE_KB:
+		if (zram->init_done) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -595,14 +596,14 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 			ret = -EFAULT;
 			goto out;
 		}
-		rzs->disksize = disksize_kb << 10;
+		zram->disksize = disksize_kb << 10;
 		pr_info("Disk size set to %zu kB\n", disksize_kb);
 		break;
 
-	case RZSIO_GET_STATS:
+	case ZRAMIO_GET_STATS:
 	{
-		struct ramzswap_ioctl_stats *stats;
-		if (!rzs->init_done) {
+		struct zram_ioctl_stats *stats;
+		if (!zram->init_done) {
 			ret = -ENOTTY;
 			goto out;
 		}
@@ -611,7 +612,7 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 			ret = -ENOMEM;
 			goto out;
 		}
-		ramzswap_ioctl_get_stats(rzs, stats);
+		zram_ioctl_get_stats(zram, stats);
 		if (copy_to_user((void *)arg, stats, sizeof(*stats))) {
 			kfree(stats);
 			ret = -EFAULT;
@@ -620,11 +621,11 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 		kfree(stats);
 		break;
 	}
-	case RZSIO_INIT:
-		ret = ramzswap_ioctl_init_device(rzs);
+	case ZRAMIO_INIT:
+		ret = zram_ioctl_init_device(zram);
 		break;
 
-	case RZSIO_RESET:
+	case ZRAMIO_RESET:
 		/* Do not reset an active device! */
 		if (bdev->bd_holders) {
 			ret = -EBUSY;
@@ -635,7 +636,7 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 		if (bdev)
 			fsync_bdev(bdev);
 
-		ret = ramzswap_ioctl_reset_device(rzs);
+		ret = zram_ioctl_reset_device(zram);
 		break;
 
 	default:
@@ -647,90 +648,90 @@ out:
 	return ret;
 }
 
-void ramzswap_slot_free_notify(struct block_device *bdev, unsigned long index)
+void zram_slot_free_notify(struct block_device *bdev, unsigned long index)
 {
-	struct ramzswap *rzs;
+	struct zram *zram;
 
-	rzs = bdev->bd_disk->private_data;
-	ramzswap_free_page(rzs, index);
-	rzs_stat64_inc(rzs, &rzs->stats.notify_free);
+	zram = bdev->bd_disk->private_data;
+	zram_free_page(zram, index);
+	zram_stat64_inc(zram, &zram->stats.notify_free);
 
 	return;
 }
 
-static const struct block_device_operations ramzswap_devops = {
-	.ioctl = ramzswap_ioctl,
-	.swap_slot_free_notify = ramzswap_slot_free_notify,
+static const struct block_device_operations zram_devops = {
+	.ioctl = zram_ioctl,
+	.swap_slot_free_notify = zram_slot_free_notify,
 	.owner = THIS_MODULE
 };
 
-static int create_device(struct ramzswap *rzs, int device_id)
+static int create_device(struct zram *zram, int device_id)
 {
 	int ret = 0;
 
-	mutex_init(&rzs->lock);
-	spin_lock_init(&rzs->stat64_lock);
+	mutex_init(&zram->lock);
+	spin_lock_init(&zram->stat64_lock);
 
-	rzs->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!rzs->queue) {
+	zram->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	blk_queue_make_request(rzs->queue, ramzswap_make_request);
-	rzs->queue->queuedata = rzs;
+	blk_queue_make_request(zram->queue, zram_make_request);
+	zram->queue->queuedata = zram;
 
 	 /* gendisk structure */
-	rzs->disk = alloc_disk(1);
-	if (!rzs->disk) {
-		blk_cleanup_queue(rzs->queue);
+	zram->disk = alloc_disk(1);
+	if (!zram->disk) {
+		blk_cleanup_queue(zram->queue);
 		pr_warning("Error allocating disk structure for device %d\n",
 			device_id);
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	rzs->disk->major = ramzswap_major;
-	rzs->disk->first_minor = device_id;
-	rzs->disk->fops = &ramzswap_devops;
-	rzs->disk->queue = rzs->queue;
-	rzs->disk->private_data = rzs;
-	snprintf(rzs->disk->disk_name, 16, "ramzswap%d", device_id);
+	zram->disk->major = zram_major;
+	zram->disk->first_minor = device_id;
+	zram->disk->fops = &zram_devops;
+	zram->disk->queue = zram->queue;
+	zram->disk->private_data = zram;
+	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-	/* Actual capacity set using RZSIO_SET_DISKSIZE_KB ioctl */
-	set_capacity(rzs->disk, 0);
+	/* Actual capacity set using ZRAMIO_SET_DISKSIZE_KB ioctl */
+	set_capacity(zram->disk, 0);
 
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
 	 */
-	blk_queue_physical_block_size(rzs->disk->queue, PAGE_SIZE);
-	blk_queue_logical_block_size(rzs->disk->queue, PAGE_SIZE);
-	blk_queue_io_min(rzs->disk->queue, PAGE_SIZE);
-	blk_queue_io_opt(rzs->disk->queue, PAGE_SIZE);
+	blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
+	blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
+	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
+	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
 
-	add_disk(rzs->disk);
+	add_disk(zram->disk);
 
-	rzs->init_done = 0;
+	zram->init_done = 0;
 
 out:
 	return ret;
 }
 
-static void destroy_device(struct ramzswap *rzs)
+static void destroy_device(struct zram *zram)
 {
-	if (rzs->disk) {
-		del_gendisk(rzs->disk);
-		put_disk(rzs->disk);
+	if (zram->disk) {
+		del_gendisk(zram->disk);
+		put_disk(zram->disk);
 	}
 
-	if (rzs->queue)
-		blk_cleanup_queue(rzs->queue);
+	if (zram->queue)
+		blk_cleanup_queue(zram->queue);
 }
 
-static int __init ramzswap_init(void)
+static int __init zram_init(void)
 {
 	int ret, dev_id;
 
@@ -741,8 +742,8 @@ static int __init ramzswap_init(void)
 		goto out;
 	}
 
-	ramzswap_major = register_blkdev(0, "ramzswap");
-	if (ramzswap_major <= 0) {
+	zram_major = register_blkdev(0, "zram");
+	if (zram_major <= 0) {
 		pr_warning("Unable to get major number\n");
 		ret = -EBUSY;
 		goto out;
@@ -755,7 +756,7 @@ static int __init ramzswap_init(void)
 
 	/* Allocate the device array and initialize each one */
 	pr_info("Creating %u devices ...\n", num_devices);
-	devices = kzalloc(num_devices * sizeof(struct ramzswap), GFP_KERNEL);
+	devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
 	if (!devices) {
 		ret = -ENOMEM;
 		goto unregister;
@@ -773,36 +774,36 @@ free_devices:
 	while (dev_id)
 		destroy_device(&devices[--dev_id]);
 unregister:
-	unregister_blkdev(ramzswap_major, "ramzswap");
+	unregister_blkdev(zram_major, "zram");
 out:
 	return ret;
 }
 
-static void __exit ramzswap_exit(void)
+static void __exit zram_exit(void)
 {
 	int i;
-	struct ramzswap *rzs;
+	struct zram *zram;
 
 	for (i = 0; i < num_devices; i++) {
-		rzs = &devices[i];
+		zram = &devices[i];
 
-		destroy_device(rzs);
-		if (rzs->init_done)
-			reset_device(rzs);
+		destroy_device(zram);
+		if (zram->init_done)
+			reset_device(zram);
 	}
 
-	unregister_blkdev(ramzswap_major, "ramzswap");
+	unregister_blkdev(zram_major, "zram");
 
 	kfree(devices);
 	pr_debug("Cleanup done!\n");
 }
 
 module_param(num_devices, uint, 0);
-MODULE_PARM_DESC(num_devices, "Number of ramzswap devices");
+MODULE_PARM_DESC(num_devices, "Number of zram devices");
 
-module_init(ramzswap_init);
-module_exit(ramzswap_exit);
+module_init(zram_init);
+module_exit(zram_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
-MODULE_DESCRIPTION("Compressed RAM Based Swap Device");
+MODULE_DESCRIPTION("Compressed RAM Block Device");
diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/zram/zram_drv.h
similarity index 77%
rename from drivers/staging/ramzswap/ramzswap_drv.h
rename to drivers/staging/zram/zram_drv.h
index 63c3042..e324e29 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -1,5 +1,5 @@
 /*
- * Compressed RAM based swap device
+ * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
@@ -12,13 +12,13 @@
  * Project home: http://compcache.googlecode.com
  */
 
-#ifndef _RAMZSWAP_DRV_H_
-#define _RAMZSWAP_DRV_H_
+#ifndef _ZRAM_DRV_H_
+#define _ZRAM_DRV_H_
 
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 
-#include "ramzswap_ioctl.h"
+#include "zram_ioctl.h"
 #include "xvmalloc.h"
 
 /*
@@ -41,7 +41,7 @@ struct zobj_header {
 
 /*-- Configurable parameters */
 
-/* Default ramzswap disk size: 25% of total RAM */
+/* Default zram disk size: 25% of total RAM */
 static const unsigned default_disksize_perc_ram = 25;
 
 /*
@@ -63,15 +63,15 @@ static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 
-/* Flags for ramzswap pages (table[page_no].flags) */
-enum rzs_pageflags {
+/* Flags for zram pages (table[page_no].flags) */
+enum zram_pageflags {
 	/* Page is stored uncompressed */
-	RZS_UNCOMPRESSED,
+	ZRAM_UNCOMPRESSED,
 
 	/* Page consists entirely of zeros */
-	RZS_ZERO,
+	ZRAM_ZERO,
 
-	__NR_RZS_PAGEFLAGS,
+	__NR_ZRAM_PAGEFLAGS,
 };
 
 /*-- Data structures */
@@ -87,12 +87,12 @@ struct table {
 	u8 flags;
 } __attribute__((aligned(4)));
 
-struct ramzswap_stats {
+struct zram_stats {
 	/* basic stats */
 	size_t compr_size;	/* compressed size of pages stored -
 				 * needed to enforce memlimit */
 	/* more stats */
-#if defined(CONFIG_RAMZSWAP_STATS)
+#if defined(CONFIG_ZRAM_STATS)
 	u64 num_reads;		/* failed + successful */
 	u64 num_writes;		/* --do-- */
 	u64 failed_reads;	/* should NEVER! happen */
@@ -106,7 +106,7 @@ struct ramzswap_stats {
 #endif
 };
 
-struct ramzswap {
+struct zram {
 	struct xv_pool *mem_pool;
 	void *compress_workmem;
 	void *compress_buffer;
@@ -123,45 +123,45 @@ struct ramzswap {
 	 */
 	size_t disksize;	/* bytes */
 
-	struct ramzswap_stats stats;
+	struct zram_stats stats;
 };
 
 /*-- */
 
 /* Debugging and Stats */
-#if defined(CONFIG_RAMZSWAP_STATS)
-static void rzs_stat_inc(u32 *v)
+#if defined(CONFIG_ZRAM_STATS)
+static void zram_stat_inc(u32 *v)
 {
 	*v = *v + 1;
 }
 
-static void rzs_stat_dec(u32 *v)
+static void zram_stat_dec(u32 *v)
 {
 	*v = *v - 1;
 }
 
-static void rzs_stat64_inc(struct ramzswap *rzs, u64 *v)
+static void zram_stat64_inc(struct zram *zram, u64 *v)
 {
-	spin_lock(&rzs->stat64_lock);
+	spin_lock(&zram->stat64_lock);
 	*v = *v + 1;
-	spin_unlock(&rzs->stat64_lock);
+	spin_unlock(&zram->stat64_lock);
 }
 
-static u64 rzs_stat64_read(struct ramzswap *rzs, u64 *v)
+static u64 zram_stat64_read(struct zram *zram, u64 *v)
 {
 	u64 val;
 
-	spin_lock(&rzs->stat64_lock);
+	spin_lock(&zram->stat64_lock);
 	val = *v;
-	spin_unlock(&rzs->stat64_lock);
+	spin_unlock(&zram->stat64_lock);
 
 	return val;
 }
 #else
-#define rzs_stat_inc(v)
-#define rzs_stat_dec(v)
-#define rzs_stat64_inc(r, v)
-#define rzs_stat64_read(r, v)
-#endif /* CONFIG_RAMZSWAP_STATS */
+#define zram_stat_inc(v)
+#define zram_stat_dec(v)
+#define zram_stat64_inc(r, v)
+#define zram_stat64_read(r, v)
+#endif /* CONFIG_ZRAM_STATS */
 
 #endif
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/zram/zram_ioctl.h
similarity index 77%
rename from drivers/staging/ramzswap/ramzswap_ioctl.h
rename to drivers/staging/zram/zram_ioctl.h
index db94bcb..eefefea 100644
--- a/drivers/staging/ramzswap/ramzswap_ioctl.h
+++ b/drivers/staging/zram/zram_ioctl.h
@@ -1,5 +1,5 @@
 /*
- * Compressed RAM based swap device
+ * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
@@ -12,10 +12,10 @@
  * Project home: http://compcache.googlecode.com
  */
 
-#ifndef _RAMZSWAP_IOCTL_H_
-#define _RAMZSWAP_IOCTL_H_
+#ifndef _ZRAM_IOCTL_H_
+#define _ZRAM_IOCTL_H_
 
-struct ramzswap_ioctl_stats {
+struct zram_ioctl_stats {
 	u64 disksize;		/* user specified or equal to backing swap
 				 * size (if present) */
 	u64 num_reads;		/* failed + successful */
@@ -34,9 +34,9 @@ struct ramzswap_ioctl_stats {
 	u64 mem_used_total;
 } __attribute__ ((packed, aligned(4)));
 
-#define RZSIO_SET_DISKSIZE_KB	_IOW('z', 0, size_t)
-#define RZSIO_GET_STATS		_IOR('z', 1, struct ramzswap_ioctl_stats)
-#define RZSIO_INIT		_IO('z', 2)
-#define RZSIO_RESET		_IO('z', 3)
+#define ZRAMIO_SET_DISKSIZE_KB	_IOW('z', 0, size_t)
+#define ZRAMIO_GET_STATS	_IOR('z', 1, struct zram_ioctl_stats)
+#define ZRAMIO_INIT		_IO('z', 2)
+#define ZRAMIO_RESET		_IO('z', 3)
 
 #endif
-- 
1.6.6.1

