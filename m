Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1LEMAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:00:44 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51376 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1LEMAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:00:42 -0500
Message-ID: <1323086434.4555.35.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix comment and string typo 'bufer'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 05 Dec 2011 13:00:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed one of these (string) typos while looking at an LZMA
compressed kernel image. I decided to fix all these typos.

1) The fix of drivers/scsi/gdth.h is not checkpatch clean (whitespace
error). It would be silly to fix that error for just this line (that
same whitespace error is repeated very often in that file).

2) Eyeball tested only.

3) There's a similar typo in drivers/net/ethernet/sis/sis900.h, but that
needs compile testing, just to be safe. Perhaps I'll send a patch for
that file later.

 drivers/media/rc/ene_ir.c                  |    2 +-
 drivers/media/rc/ene_ir.h                  |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c |    2 +-
 drivers/scsi/gdth.h                        |    2 +-
 drivers/usb/musb/cppi_dma.c                |    2 +-
 drivers/video/bf54x-lq043fb.c              |    2 +-
 drivers/video/bfin-t350mcqb-fb.c           |    2 +-
 fs/ext4/inode.c                            |    2 +-
 fs/jbd/checkpoint.c                        |    2 +-
 fs/jbd2/checkpoint.c                       |    2 +-
 fs/xfs/xfs_buf.c                           |    2 +-
 lib/decompress_bunzip2.c                   |    4 ++--
 lib/decompress_unlzma.c                    |    2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index cf10ecf..860c112 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -324,7 +324,7 @@ static int ene_rx_get_sample_reg(struct ene_device *dev)
 		return dev->extra_buf2_address + r_pointer;
 	}
 
-	dbg("attempt to read beyong ring bufer end");
+	dbg("attempt to read beyond ring buffer end");
 	return 0;
 }
 
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index fd108d9..6f978e8 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -227,7 +227,7 @@ struct ene_device {
 
 	/* TX buffer */
 	unsigned *tx_buffer;			/* input samples buffer*/
-	int tx_pos;				/* position in that bufer */
+	int tx_pos;				/* position in that buffer */
 	int tx_len;				/* current len of tx buffer */
 	int tx_done;				/* done transmitting */
 						/* one more sample pending*/
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 8d5d55a..39b9de7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -684,7 +684,7 @@ out:
 	/*
 	 * Update our accounting state to incorporate the new Free List
 	 * buffers, tell the hardware about them and return the number of
-	 * bufers which we were able to allocate.
+	 * buffers which we were able to allocate.
 	 */
 	cred = fl->avail - cred;
 	fl->pend_cred += cred;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index d969855..d3e4d7c 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -359,7 +359,7 @@ typedef struct {
     u32     cmd_buff_addr2;     /* physical address of cmd buffer 1 */   
     u32     cmd_buff_u_addr2;   /* reserved for 64 bit addressing */
     u32     cmd_buff_indx2;     /* cmd buf addr1 unique identifier */
-    u32     cmd_buff_size;      /* size of each cmd bufer in bytes */
+    u32     cmd_buff_size;      /* size of each cmd buffer in bytes */
     u32     reserved1;
     u32     reserved2;
 } __attribute__((packed)) gdth_perf_modes;
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 318fb4e..53be7ae 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -513,7 +513,7 @@ static inline int cppi_autoreq_update(struct cppi_channel *rx,
 		if (!(val & MUSB_RXCSR_H_REQPKT)) {
 			val |= MUSB_RXCSR_H_REQPKT | MUSB_RXCSR_H_WZC_BITS;
 			musb_writew(regs, MUSB_RXCSR, val);
-			/* flush writebufer */
+			/* flush writebuffer */
 			val = musb_readw(regs, MUSB_RXCSR);
 		}
 	}
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 56720fb..46b03f5 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich <hennerich@blackfin.uclinux.org>
  *
  * Created:
- * Description:  ADSP-BF54x Framebufer driver
+ * Description:  ADSP-BF54x Framebuffer driver
  *
  *
  * Modified:
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index d5e1267..7a0c05f 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich <hennerich@blackfin.uclinux.org>
  *
  * Created:
- * Description:  Blackfin LCD Framebufer driver
+ * Description:  Blackfin LCD Framebuffer driver
  *
  *
  * Modified:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..952d5b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1878,7 +1878,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
  * a[0] = 'a';
  * truncate(f, 4096);
  * we have in the page first buffer_head mapped via page_mkwrite call back
- * but other bufer_heads would be unmapped but dirty(dirty done via the
+ * but other buffer_heads would be unmapped but dirty (dirty done via the
  * do_wp_page). So writepage should write the first block. If we modify
  * the mmap area beyond 1024 we will again get a page_fault and the
  * page_mkwrite callback will do the block allocation and mark the
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index f94fc48..5d1a00a 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -537,7 +537,7 @@ int cleanup_journal_tail(journal_t *journal)
  * them.
  *
  * Called with j_list_lock held.
- * Returns number of bufers reaped (for debug)
+ * Returns number of buffers reaped (for debug)
  */
 
 static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 16a698b..d49d202 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -565,7 +565,7 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
  *
  * Called with the journal locked.
  * Called with j_list_lock held.
- * Returns number of bufers reaped (for debug)
+ * Returns number of buffers reaped (for debug)
  */
 
 static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cf0ac05..33e06d2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1370,7 +1370,7 @@ restart:
 			goto restart;
 		}
 		/*
-		 * clear the LRU reference count so the bufer doesn't get
+		 * clear the LRU reference count so the buffer doesn't get
 		 * ignored in xfs_buf_rele().
 		 */
 		atomic_set(&bp->b_lru_ref, 0);
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a7b80c1..3380297 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -691,7 +691,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 		outbuf = malloc(BZIP2_IOBUF_SIZE);
 
 	if (!outbuf) {
-		error("Could not allocate output bufer");
+		error("Could not allocate output buffer");
 		return RETVAL_OUT_OF_MEMORY;
 	}
 	if (buf)
@@ -699,7 +699,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 	else
 		inbuf = malloc(BZIP2_IOBUF_SIZE);
 	if (!inbuf) {
-		error("Could not allocate input bufer");
+		error("Could not allocate input buffer");
 		i = RETVAL_OUT_OF_MEMORY;
 		goto exit_0;
 	}
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 476c65a..32adb73 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -562,7 +562,7 @@ STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
 	else
 		inbuf = malloc(LZMA_IOBUF_SIZE);
 	if (!inbuf) {
-		error("Could not allocate input bufer");
+		error("Could not allocate input buffer");
 		goto exit_0;
 	}
 
-- 
1.7.7.3

