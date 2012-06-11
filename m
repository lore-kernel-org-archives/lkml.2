Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2FKOs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:48:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FKOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:48:55 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging "sep" Fix typos found while reading.
Date: Mon, 11 Jun 2012 07:48:46 -0700
Message-Id: <1339426126-10539-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "sep"

 drivers/staging/sep/sep_crypto.c        |   18 +++++++-------
 drivers/staging/sep/sep_driver_api.h    |    8 +++---
 drivers/staging/sep/sep_driver_config.h |    4 +-
 drivers/staging/sep/sep_main.c          |   36 +++++++++++++++---------------
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 1cc790e..302448c 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -807,7 +807,7 @@ end_function:
  *	@size: size of parameter to copy (in bytes)
  *	@max_size: size to move up offset; SEP mesg is in word sizes
  *	@msg_offset: pointer to current offset (is updated)
- *	@byte_array: flag ti indicate wheter endian must be changed
+ *	@byte_array: flag ti indicate whether endian must be changed
  *	Copies data into the message area from caller
  */
 static void sep_write_msg(struct this_task_ctx *ta_ctx, void *in_addr,
@@ -855,7 +855,7 @@ static void sep_make_header(struct this_task_ctx *ta_ctx, u32 *msg_offset,
  *	@size: size of parameter to copy (in bytes)
  *	@max_size: size to move up offset; SEP mesg is in word sizes
  *	@msg_offset: pointer to current offset (is updated)
- *	@byte_array: flag ti indicate wheter endian must be changed
+ *	@byte_array: flag ti indicate whether endian must be changed
  *	Copies data out of the message area to caller
  */
 static void sep_read_msg(struct this_task_ctx *ta_ctx, void *in_addr,
@@ -990,7 +990,7 @@ static void sep_clear_out(struct this_task_ctx *ta_ctx)
 		/**
 		 * The following unlocks the sep and makes it available
 		 * to any other application
-		 * First, null out crypto entries in sep before relesing it
+		 * First, null out crypto entries in sep before releasing it
 		 */
 		ta_ctx->sep_used->current_hash_req = NULL;
 		ta_ctx->sep_used->current_cypher_req = NULL;
@@ -1001,7 +1001,7 @@ static void sep_clear_out(struct this_task_ctx *ta_ctx)
 
 		ta_ctx->call_status.status = 0;
 
-		/* Remove anything confidentail */
+		/* Remove anything confidential */
 		memset(ta_ctx->sep_used->shared_addr, 0,
 			SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
 
@@ -1207,7 +1207,7 @@ static int sep_crypto_block_data(struct ablkcipher_request *req)
 		req->nbytes, ta_ctx->walk.blocksize, &new_sg, 1);
 
 	if (int_error < 0) {
-		dev_warn(&ta_ctx->sep_used->pdev->dev, "oddball page eerror\n");
+		dev_warn(&ta_ctx->sep_used->pdev->dev, "oddball page error\n");
 		return -ENOMEM;
 	} else if (int_error == 1) {
 		ta_ctx->src_sg = new_sg;
@@ -1870,7 +1870,7 @@ static u32 hash_update_post_op(struct sep_device *sep)
 		sizeof(struct sep_hash_private_context));
 
 	/**
-	 * Following is only for finup; if we just completd the
+	 * Following is only for finup; if we just completed the
 	 * data portion of finup, we now need to kick off the
 	 * finish portion of finup.
 	 */
@@ -2011,7 +2011,7 @@ static u32 hash_digest_post_op(struct sep_device *sep)
 }
 
 /**
- * The sep_finish function is the function that is schedule (via tasket)
+ * The sep_finish function is the function that is scheduled (via tasklet)
  * by the interrupt service routine when the SEP sends and interrupt
  * This is only called by the interrupt handler as a tasklet.
  */
@@ -2249,7 +2249,7 @@ static void sep_hash_update(void *data)
 	head_len = (block_size - int_ctx->prev_update_bytes) % block_size;
 	tail_len = (req->nbytes - head_len) % block_size;
 
-	/* Make sure all pages are even block */
+	/* Make sure all pages are an even block */
 	int_error = sep_oddball_pages(ta_ctx->sep_used, req->src,
 		req->nbytes,
 		block_size, &new_sg, 1);
@@ -2482,7 +2482,7 @@ static void sep_hash_digest(void *data)
 	dev_dbg(&ta_ctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
 	dev_dbg(&ta_ctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
 
-	/* Make sure all pages are even block */
+	/* Make sure all pages are an even block */
 	int_error = sep_oddball_pages(ta_ctx->sep_used, req->src,
 		req->nbytes,
 		block_size, &new_sg, 1);
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 8b797d5..7ee1c3b 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -91,7 +91,7 @@ struct sep_dcblock {
 };
 
 /*
-	command structure for building dcb block (currently for ext app only
+	command structure for building dcb block (currently for ext app only)
 */
 struct build_dcb_struct {
 	/* address value of the data in */
@@ -234,7 +234,7 @@ struct sep_dma_context {
 	u32 dmatables_len;
 	/* size of input data */
 	u32 input_data_len;
-	/* secure dma use (for imr memory restriced area in output */
+	/* secure dma use (for imr memory restricted area in output) */
 	bool secure_dma;
 	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
 	/* Scatter gather for kernel crypto */
@@ -347,10 +347,10 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 /**
  * sep_free_dma_table_data_handler - free DMA table
- * @sep: pointere to struct sep_device
+ * @sep: pointer to struct sep_device
  * @dma_ctx: dma context
  *
- * Handles the request to  free DMA table for synchronic actions
+ * Handles the request to free DMA table for synchronic actions
  */
 int sep_free_dma_table_data_handler(struct sep_device *sep,
 					   struct sep_dma_context **dma_ctx);
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 9d9fc7c..7d7c7ab 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -43,7 +43,7 @@
 #define SEP_DRIVER_POLLING_MODE                         0
 
 /* flag which defines if the shared area address should be
-	reconfiged (send to SEP anew) during init of the driver */
+	reconfigured (send to SEP anew) during init of the driver */
 #define SEP_DRIVER_RECONFIG_MESSAGE_AREA                0
 
 /* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
@@ -166,7 +166,7 @@ held by the process (struct file) */
 	(SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES + \
 	SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES)
 
-/* synhronic dma tables area offset */
+/* synchronic dma tables area offset */
 #define SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES \
 	(SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES + \
 	SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES)
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index df1d13e..cfaf2b5 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -94,7 +94,7 @@
 #endif
 
 /**
- * Currenlty, there is only one SEP device per platform;
+ * Currently, there is only one SEP device per platform;
  * In event platforms in the future have more than one SEP
  * device, this will be a linked list
  */
@@ -106,7 +106,7 @@ struct sep_device *sep_dev;
  * @sep: SEP device
  * @sep_queue_info: pointer to status queue
  *
- * This function will removes information about transaction from the queue.
+ * This function will remove information about transaction from the queue.
  */
 void sep_queue_status_remove(struct sep_device *sep,
 				      struct sep_queue_info **queue_elem)
@@ -294,7 +294,7 @@ int sep_wait_transaction(struct sep_device *sep)
 end_function_setpid:
 	/*
 	 * The pid_doing_transaction indicates that this process
-	 * now owns the facilities to performa a transaction with
+	 * now owns the facilities to perform a transaction with
 	 * the SEP. While this process is performing a transaction,
 	 * no other process who has the SEP device open can perform
 	 * any transactions. This method allows more than one process
@@ -447,10 +447,10 @@ static int sep_open(struct inode *inode, struct file *filp)
 
 /**
  * sep_free_dma_table_data_handler - free DMA table
- * @sep: pointere to struct sep_device
+ * @sep: pointer to struct sep_device
  * @dma_ctx: dma context
  *
- * Handles the request to  free DMA table for synchronic actions
+ * Handles the request to free DMA table for synchronic actions
  */
 int sep_free_dma_table_data_handler(struct sep_device *sep,
 					   struct sep_dma_context **dma_ctx)
@@ -540,7 +540,7 @@ int sep_free_dma_table_data_handler(struct sep_device *sep,
 		 * don't have a page array; the page array is generated
 		 * only in the lock_user_pages, which is not called
 		 * for kernel crypto, which is what the sg (scatter gather
-		 * is used for exclusively
+		 * is used for exclusively)
 		 */
 		if (dma->src_sg) {
 			dma_unmap_sg(&sep->pdev->dev, dma->src_sg,
@@ -1227,7 +1227,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	/* Map array */
 	struct sep_dma_map *map_array;
 
-	/* Set start and end pages  and num pages */
+	/* Set start and end pages and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
@@ -1431,7 +1431,7 @@ static int sep_lli_table_secure_dma(struct sep_device *sep,
 	/* Array of lli */
 	struct sep_lli_entry *lli_array;
 
-	/* Set start and end pages  and num pages */
+	/* Set start and end pages and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
@@ -1601,7 +1601,7 @@ end_function:
  * @num_table_entries_ptr: pointer to number of tables
  * @table_data_size: total data size
  *
- * Builds ant lli table from the lli_array according to
+ * Builds an lli table from the lli_array according to
  * the given size of data
  */
 static void sep_build_lli_table(struct sep_device *sep,
@@ -1700,7 +1700,7 @@ static void sep_build_lli_table(struct sep_device *sep,
  * @virt_address: virtual address to convert
  *
  * This functions returns the physical address inside shared area according
- * to the virtual address. It can be either on the externa RAM device
+ * to the virtual address. It can be either on the external RAM device
  * (ioremapped), or on the system RAM
  * This implementation is for the external RAM
  */
@@ -1724,7 +1724,7 @@ static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
  *
  * This functions returns the virtual address inside shared area
  * according to the physical address. It can be either on the
- * externa RAM device (ioremapped), or on the system RAM
+ * external RAM device (ioremapped), or on the system RAM
  * This implementation is for the external RAM
  */
 static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
@@ -1890,9 +1890,9 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
  * @lli_table_ptr:
  * @num_entries_ptr:
  * @table_data_size_ptr:
- * @is_kva: set for kernel data (kernel cryptio call)
+ * @is_kva: set for kernel data (kernel crypt io call)
  *
- * This function prepares only input DMA table for synhronic symmetric
+ * This function prepares only input DMA table for synchronic symmetric
  * operations (HASH)
  * Note that all bus addresses that are passed to the SEP
  * are in 32 bit format; the SEP is a 32 bit device
@@ -2173,9 +2173,9 @@ static int sep_construct_dma_tables_from_lli(
 	u32 last_table_flag = 0;
 	/* The data size that should be in table */
 	u32 table_data_size = 0;
-	/* Number of etnries in the input table */
+	/* Number of entries in the input table */
 	u32 num_entries_in_table = 0;
-	/* Number of etnries in the output table */
+	/* Number of entries in the output table */
 	u32 num_entries_out_table = 0;
 
 	if (!dma_ctx) {
@@ -2400,7 +2400,7 @@ static int sep_construct_dma_tables_from_lli(
  * @table_data_size_ptr:
  * @is_kva: set for kernel data; used only for kernel crypto module
  *
- * This function builds input and output DMA tables for synhronic
+ * This function builds input and output DMA tables for synchronic
  * symmetric operations (AES, DES, HASH). It also checks that each table
  * is of the modular block size
  * Note that all bus addresses that are passed to the SEP
@@ -2554,7 +2554,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		" is (hex) %x\n", current->pid,
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
-	/* Call the fucntion that creates table from the lli arrays */
+	/* Call the function that creates table from the lli arrays */
 	dev_dbg(&sep->pdev->dev, "[PID%d] calling create table from lli\n",
 					current->pid);
 	error = sep_construct_dma_tables_from_lli(
@@ -3661,7 +3661,7 @@ static ssize_t sep_read(struct file *filp,
 		goto end_function;
 	}
 
-	/* Checks that user has called necessarry apis */
+	/* Checks that user has called necessary apis */
 	if (0 == test_bit(SEP_FASTCALL_WRITE_DONE_OFFSET,
 			&call_status->status)) {
 		dev_warn(&sep->pdev->dev,
-- 
1.7.5.4

