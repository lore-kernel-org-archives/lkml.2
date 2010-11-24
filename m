Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0KXT7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:59:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47191 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932079Ab0KXT66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:58:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/12] sep: Make SEP consistent
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:38:39 +0000
Message-ID: <20101124193831.16425.23315.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

SEP is initials so make it consistent in the driver, ditto DMA and DCB
Consistent capitalisation of comment leads


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |  631 +++++++++++++++++++-------------------
 1 files changed, 313 insertions(+), 318 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ff9df36..9c16558 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -92,7 +92,7 @@ static int sep_load_firmware(struct sep_device *sep)
 	int error ;
 	unsigned int work1, work2, work3;
 
-	/* set addresses and load resident */
+	/* Set addresses and load resident */
 	sep->resident_bus = sep->rar_bus;
 	sep->resident_addr = sep->rar_addr;
 
@@ -113,7 +113,7 @@ static int sep_load_firmware(struct sep_device *sep)
 	dev_dbg(&sep->pdev->dev, "resident size is %08x\n",
 		sep->resident_size);
 
-	/* set addresses for dcache (no loading needed) */
+	/* Set addresses for dcache (no loading needed) */
 	work1 = (unsigned int)sep->resident_bus;
 	work2 = (unsigned int)sep->resident_size;
 	work3 = (work1 + work2 + (1024 * 4)) & 0xfffff000;
@@ -126,7 +126,7 @@ static int sep_load_firmware(struct sep_device *sep)
 
 	sep->dcache_size = 1024 * 128;
 
-	/* set addresses and load cache */
+	/* Set addresses and load cache */
 	sep->cache_bus = sep->dcache_bus + sep->dcache_size;
 	sep->cache_addr = sep->dcache_addr + sep->dcache_size;
 
@@ -147,7 +147,7 @@ static int sep_load_firmware(struct sep_device *sep)
 	dev_dbg(&sep->pdev->dev, "cache size is %08x\n",
 		sep->cache_size);
 
-	/* set addresses and load extapp */
+	/* Set addresses and load extapp */
 	sep->extapp_bus = sep->cache_bus + (1024 * 370);
 	sep->extapp_addr = sep->cache_addr + (1024 * 370);
 
@@ -177,7 +177,7 @@ MODULE_FIRMWARE("sep/extapp.image.bin");
 
 /**
  *	sep_dump_message - dump the message that is pending
- *	@sep: sep device
+ *	@sep: SEP device
  */
 static void sep_dump_message(struct sep_device *sep)
 {
@@ -205,7 +205,7 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 		return -ENOMEM;
 	}
 	dev_dbg(&sep->pdev->dev,
-		"sep: shared_addr %x bytes @%p (bus %llx)\n",
+		"shared_addr %x bytes @%p (bus %llx)\n",
 				sep->shared_size, sep->shared_addr,
 				(unsigned long long)sep->shared_bus);
 	return 0;
@@ -249,7 +249,7 @@ static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 	struct sep_device *sep;
 
 	/*
-	 * Get the sep device structure and use it for the
+	 * Get the SEP device structure and use it for the
 	 * private_data field in filp for other methods
 	 */
 	sep = sep_dev;
@@ -274,8 +274,8 @@ end_function:
 
 /**
  *	sep_open - device open method
- *	@inode: inode of sep device
- *	@filp: file handle to sep device
+ *	@inode: inode of SEP device
+ *	@filp: file handle to SEP device
  *
  *	Open method for the SEP device. Called when userspace opens
  *	the SEP device node. 
@@ -287,7 +287,7 @@ static int sep_open(struct inode *inode, struct file *filp)
 	struct sep_device *sep;
 
 	/*
-	 * Get the sep device structure and use it for the
+	 * Get the SEP device structure and use it for the
 	 * private_data field in filp for other methods
 	 */
 	sep = sep_dev;
@@ -320,8 +320,8 @@ static int sep_singleton_release(struct inode *inode, struct file *filp)
 
 /**
  *	sep_request_daemonopen - request daemon open method
- *	@inode: inode of sep device
- *	@filp: file handle to sep device
+ *	@inode: inode of SEP device
+ *	@filp: file handle to SEP device
  *
  *	Open method for the SEP request daemon. Called when
  *	request daemon in userspace opens the SEP device node.
@@ -359,7 +359,7 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 	dev_dbg(&sep->pdev->dev, "Reques daemon release for pid %d\n",
 		current->pid);
 
-	/* clear the request_daemon_open flag */
+	/* Clear the request_daemon_open flag */
 	clear_bit(0, &sep->request_daemon_open);
 	return 0;
 }
@@ -380,12 +380,12 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 
 	sep_dump_message(sep);
 
-	/* counters are lockable region */
+	/* Counters are lockable region */
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 	sep->send_ct++;
 	sep->reply_ct++;
 
-	/* send the interrupt to SEP */
+	/* Send the interrupt to SEP */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR,
 		sep->send_ct);
 
@@ -408,13 +408,13 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
  *	sep_free_dma_table_data_handler - free DMA table
  *	@sep: pointere to struct sep_device
  *
- *	Handles the request to  free dma table for synchronic actions
+ *	Handles the request to  free DMA table for synchronic actions
  */
 static int sep_free_dma_table_data_handler(struct sep_device *sep)
 {
 	int count;
 	int dcb_counter;
-	/* pointer to the current dma_resource struct */
+	/* Pointer to the current dma_resource struct */
 	struct sep_dma_resource *dma;
 
 	dev_dbg(&sep->pdev->dev, "sep_free_dma_table_data_handler start\n");
@@ -422,7 +422,7 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 	for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
 		dma = &sep->dma_res_arr[dcb_counter];
 
-		/* unmap and free input map array */
+		/* Unmap and free input map array */
 		if (dma->in_map_array) {
 			for (count = 0; count < dma->in_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
@@ -433,7 +433,7 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 			kfree(dma->in_map_array);
 		}
 
-		/* unmap output map array, DON'T free it yet */
+		/* Unmap output map array, DON'T free it yet */
 		if (dma->out_map_array) {
 			for (count = 0; count < dma->out_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
@@ -444,7 +444,7 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 			kfree(dma->out_map_array);
 		}
 
-		/* free page cache for output */
+		/* Free page cache for output */
 		if (dma->in_page_array) {
 			for (count = 0; count < dma->in_num_pages; count++) {
 				flush_dcache_page(dma->in_page_array[count]);
@@ -463,7 +463,7 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 			kfree(dma->out_page_array);
 		}
 
-		/* reset all the values */
+		/* Reset all the values */
 		dma->in_page_array = 0;
 		dma->out_page_array = 0;
 		dma->in_num_pages = 0;
@@ -503,7 +503,7 @@ static int sep_request_daemon_mmap(struct file  *filp,
 		goto end_function;
 	}
 
-	/* get physical address */
+	/* Get physical address */
 	bus_address = sep->shared_bus;
 
 	dev_dbg(&sep->pdev->dev, "bus_address is %08lx\n",
@@ -524,7 +524,7 @@ end_function:
 
 /**
  *	sep_request_daemon_poll - poll implementation
- *	@sep: struct sep_device * for current sep device
+ *	@sep: struct sep_device * for current SEP device
  *	@filp: struct file * for open file
  *	@wait: poll_table * for poll
  *
@@ -547,7 +547,7 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 						sep->send_ct, sep->reply_ct);
 
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-	/* check if the data is ready */
+	/* Check if the data is ready */
 	if (sep->send_ct == sep->reply_ct) {
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
@@ -555,13 +555,13 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 		dev_dbg(&sep->pdev->dev,
 			"daemon poll: data check (GPR2) is %x\n", retval2);
 
-		/* check if PRINT request */
+		/* Check if PRINT request */
 		if ((retval2 >> 30) & 0x1) {
 			dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
 			mask |= POLLIN;
 			goto end_function;
 		}
-		/* check if NVS request */
+		/* Check if NVS request */
 		if (retval2 >> 31) {
 			dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
 			mask |= POLLPRI | POLLWRNORM;
@@ -591,7 +591,7 @@ static int sep_release(struct inode *inode, struct file *filp)
 	dev_dbg(&sep->pdev->dev, "Release for pid %d\n", current->pid);
 
 	mutex_lock(&sep->sep_mutex);
-	/* is this the process that has a transaction open?
+	/* Is this the process that has a transaction open?
 	 * If so, lets reset pid_doing_transaction to 0 and
 	 * clear the in use flags, and then wake up sep_event
 	 * so that other processes can do transactions
@@ -614,7 +614,7 @@ static int sep_release(struct inode *inode, struct file *filp)
  *	@filp: pointer to struct file
  *	@vma: pointer to vm_area_struct
  *
- *	Called on an mmap of our space via the normal sep device
+ *	Called on an mmap of our space via the normal SEP device
  */
 static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 {
@@ -636,8 +636,8 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	/*
 	 * The pid_doing_transaction indicates that this process
 	 * now owns the facilities to performa a transaction with
-	 * the sep. While this process is performing a transaction,
-	 * no other process who has the sep device open can perform
+	 * the SEP. While this process is performing a transaction,
+	 * no other process who has the SEP device open can perform
 	 * any transactions. This method allows more than one process
 	 * to have the device open at any given time, which provides
 	 * finer granularity for device utilization by multiple
@@ -647,12 +647,12 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	sep->pid_doing_transaction = current->pid;
 	mutex_unlock(&sep->sep_mutex);
 
-	/* zero the pools and the number of data pool alocation pointers */
+	/* Zero the pools and the number of data pool alocation pointers */
 	sep->data_pool_bytes_allocated = 0;
 	sep->num_of_data_allocations = 0;
 
 	/*
-	 * check that the size of the mapped range is as the size of the message
+	 * Check that the size of the mapped range is as the size of the message
 	 * shared area
 	 */
 	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
@@ -662,7 +662,7 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
 
-	/* get bus address */
+	/* Get bus address */
 	bus_addr = sep->shared_bus;
 
 	dev_dbg(&sep->pdev->dev,
@@ -678,13 +678,13 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	goto end_function;
 
 end_function_with_error:
-	/* clear the bit */
+	/* Clear the bit */
 	clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
 	mutex_lock(&sep->sep_mutex);
 	sep->pid_doing_transaction = 0;
 	mutex_unlock(&sep->sep_mutex);
 
-	/* raise event for stuck contextes */
+	/* Raise event for stuck contextes */
 
 	dev_warn(&sep->pdev->dev, "mmap error - waking up event\n");
 	wake_up(&sep->event);
@@ -722,14 +722,14 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	}
 	mutex_unlock(&sep->sep_mutex);
 
-	/* check if send command or send_reply were activated previously */
+	/* Check if send command or send_reply were activated previously */
 	if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
 		dev_warn(&sep->pdev->dev, "poll; lock bit set\n");
 		mask = POLLERR;
 		goto end_function;
 	}
 
-	/* add the event to the polling wait table */
+	/* Add the event to the polling wait table */
 	dev_dbg(&sep->pdev->dev, "poll: calling wait sep_event\n");
 
 	poll_wait(filp, &sep->event, wait);
@@ -737,7 +737,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
 		sep->send_ct, sep->reply_ct);
 
-	/* check if error occured during poll */
+	/* Check if error occured during poll */
 	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	if (retval2 != 0x0) {
 		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
@@ -753,25 +753,24 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 		dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
 			retval);
 
-		/* check if printf request  */
+		/* Check if printf request  */
 		if ((retval >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "poll: sep printf request\n");
+			dev_dbg(&sep->pdev->dev, "poll: SEP printf request\n");
 			wake_up(&sep->event_request_daemon);
 			goto end_function;
 		}
 
-		/* check if the this is sep reply or request */
+		/* Check if the this is SEP reply or request */
 		if (retval >> 31) {
-			dev_dbg(&sep->pdev->dev, "poll: sep request\n");
+			dev_dbg(&sep->pdev->dev, "poll: SEP request\n");
 			wake_up(&sep->event_request_daemon);
 		} else {
 			dev_dbg(&sep->pdev->dev, "poll: normal return\n");
-			/* in case it is again by send_reply_comand */
+			/* In case it is again by send_reply_comand */
 			clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
 			sep_dump_message(sep);
 			dev_dbg(&sep->pdev->dev,
-				"poll; sep reply POLLIN | POLLRDNORM\n");
-
+				"poll; SEP reply POLLIN | POLLRDNORM\n");
 			mask |= POLLIN | POLLRDNORM;
 		}
 	} else {
@@ -803,19 +802,19 @@ static u32 *sep_time_address(struct sep_device *sep)
  *	@sep: the SEP we are setting the time for
  *
  *	Calculates time and sets it at the predefined address.
- *	Called with the sep mutex held.
+ *	Called with the SEP mutex held.
  */
 static unsigned long sep_set_time(struct sep_device *sep)
 {
 	struct timeval time;
-	u32 *time_addr;	/* address of time as seen by the kernel */
+	u32 *time_addr;	/* Address of time as seen by the kernel */
 
 
-	dev_dbg(&sep->pdev->dev, "sep:sep_set_time start\n");
+	dev_dbg(&sep->pdev->dev, "sep_set_time start\n");
 
 	do_gettimeofday(&time);
 
-	/* set value in the SYSTEM MEMORY offset */
+	/* Set value in the SYSTEM MEMORY offset */
 	time_addr = sep_time_address(sep);
 
 	time_addr[0] = SEP_TIME_VAL_TOKEN;
@@ -830,7 +829,7 @@ static unsigned long sep_set_time(struct sep_device *sep)
 
 /**
  *	sep_set_caller_id_handler - insert caller id entry
- *	@sep: sep device
+ *	@sep: SEP device
  *	@arg: pointer to struct caller_id_struct
  *
  *	Inserts the data into the caller id table. Note that this function
@@ -858,7 +857,7 @@ static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 		goto end_function;
 	}
 
-	/* copy the data */
+	/* Copy the data */
 	if (copy_from_user(&command_args, (void __user *)arg,
 		sizeof(command_args))) {
 		error = -EFAULT;
@@ -894,9 +893,9 @@ end_function:
 
 /**
  *	sep_set_current_caller_id - set the caller id
- *	@sep: pointer to struct_sep
+ *	@sep: pointer to struct_sep_device
  *
- *	Set the caller ID (if it exists) to the sep. Note that this
+ *	Set the caller ID (if it exists) to the SEP. Note that this
  *	function falls under the ioctl lock
  */
 static int sep_set_current_caller_id(struct sep_device *sep)
@@ -906,7 +905,7 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id start\n");
 	dev_dbg(&sep->pdev->dev, "current process is %d\n", current->pid);
 
-	/* zero the previous value */
+	/* Zero the previous value */
 	memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
 					0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
 
@@ -926,7 +925,7 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 
 /**
  *	sep_send_command_handler - kick off a command
- *	@sep: sep being signalled
+ *	@sep: SEP being signalled
  *
  *	This function raises interrupt to SEP that signals that is has a new
  *	command from the host
@@ -946,13 +945,13 @@ static int sep_send_command_handler(struct sep_device *sep)
 	}
 	sep_set_time(sep);
 
-	/* only Medfield has caller id */
+	/* Only Medfield has caller id */
 	if (sep->mrst == 0)
 		sep_set_current_caller_id(sep);
 
 	sep_dump_message(sep);
 
-	/* update counter */
+	/* Update counter */
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 	sep->send_ct++;
 	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
@@ -961,7 +960,7 @@ static int sep_send_command_handler(struct sep_device *sep)
 		"sep_send_command_handler send_ct %lx reply_ct %lx\n",
 						sep->send_ct, sep->reply_ct);
 
-	/* send interrupt to SEP */
+	/* Send interrupt to SEP */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
 
 end_function:
@@ -971,7 +970,7 @@ end_function:
 
 /**
  *	sep_allocate_data_pool_memory_handler -allocate pool memory
- *	@sep: pointer to struct_sep
+ *	@sep: pointer to struct sep_device
  *	@arg: pointer to struct alloc_struct
  *
  *	This function handles the allocate data pool memory request
@@ -1016,7 +1015,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev,
 		"command_args.offset: %x\n", command_args.offset);
 
-	/* Place in the shared area that is known by the sep */
+	/* Place in the shared area that is known by the SEP */
 	token_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
 		(sep->num_of_data_allocations)*2*sizeof(u32));
@@ -1043,7 +1042,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		goto end_function;
 	}
 
-	/* update the allocation */
+	/* Update the allocation */
 	sep->data_pool_bytes_allocated += command_args.num_bytes;
 	sep->num_of_data_allocations += 1;
 
@@ -1079,9 +1078,9 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 
 {
 	int error = 0;
-	/* array of lli */
+	/* Array of lli */
 	struct sep_lli_entry *lli_array;
-	/* map array */
+	/* Map array */
 	struct sep_dma_map *map_array;
 
 	dev_dbg(&sep->pdev->dev,
@@ -1110,7 +1109,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 
 
 	/*
-	 * set the start address of the first page - app data may start not at
+	 * Set the start address of the first page - app data may start not at
 	 * the beginning of the page
 	 */
 	lli_array[0].bus_address = (u32)map_array[0].dma_addr;
@@ -1121,7 +1120,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 		(unsigned long)lli_array[0].bus_address,
 		lli_array[0].block_size);
 
-	/* set the output parameters */
+	/* Set the output parameters */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
 		*lli_array_ptr = lli_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 1;
@@ -1168,25 +1167,25 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	int error = 0;
 	u32 count;
 	int result;
-	/* the the page of the end address of the user space buffer */
+	/* The the page of the end address of the user space buffer */
 	u32 end_page;
-	/* the page of the start address of the user space buffer */
+	/* The page of the start address of the user space buffer */
 	u32 start_page;
-	/* the range in pages */
+	/* The range in pages */
 	u32 num_pages;
-	/* array of pointers to page */
+	/* Array of pointers to page */
 	struct page **page_array;
-	/* array of lli */
+	/* Array of lli */
 	struct sep_lli_entry *lli_array;
-	/* map array */
+	/* Map array */
 	struct sep_dma_map *map_array;
-	/* direction of the DMA mapping for locked pages */
+	/* Direction of the DMA mapping for locked pages */
 	enum dma_data_direction	dir;
 
 	dev_dbg(&sep->pdev->dev,
 		"sep_lock_user_pages start\n");
 
-	/* set start and end pages  and num pages */
+	/* Set start and end pages  and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
@@ -1199,7 +1198,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "starting page_array malloc\n");
 
-	/* allocate array of pages structure pointers */
+	/* Allocate array of pages structure pointers */
 	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
 	if (!page_array) {
 		error = -ENOMEM;
@@ -1223,7 +1222,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "starting get_user_pages\n");
 
-	/* convert the application virtual address into a set of physical */
+	/* Convert the application virtual address into a set of physical */
 	down_read(&current->mm->mmap_sem);
 	result = get_user_pages(current, current->mm, app_virt_addr,
 		num_pages,
@@ -1232,7 +1231,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	up_read(&current->mm->mmap_sem);
 
-	/* check the number of pages locked - if not all then exit with error */
+	/* Check the number of pages locked - if not all then exit with error */
 	if (result != num_pages) {
 		dev_warn(&sep->pdev->dev,
 			"not all pages locked by get_user_pages\n");
@@ -1242,26 +1241,25 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
 
-	/* set direction */
+	/* Set direction */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG)
 		dir = DMA_TO_DEVICE;
 	else
 		dir = DMA_FROM_DEVICE;
 
 	/*
-	 * fill the array using page array data and
-	 * map the pages - this action
-	 * will also flush the cache as needed
+	 * Fill the array using page array data and
+	 * map the pages - this action will also flush the cache as needed
 	 */
 	for (count = 0; count < num_pages; count++) {
-		/* fill the map array */
+		/* Fill the map array */
 		map_array[count].dma_addr =
 			dma_map_page(&sep->pdev->dev, page_array[count],
 			0, PAGE_SIZE, /*dir*/DMA_BIDIRECTIONAL);
 
 		map_array[count].size = PAGE_SIZE;
 
-		/* fill the lli array entry */
+		/* Fill the lli array entry */
 		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
 		lli_array[count].block_size = PAGE_SIZE;
 
@@ -1270,11 +1268,11 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			count, lli_array[count].block_size);
 	}
 
-	/* check the offset for the first page */
+	/* Check the offset for the first page */
 	lli_array[0].bus_address =
 		lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
 
-	/* check that not all the data is in the first page only */
+	/* Check that not all the data is in the first page only */
 	if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
 		lli_array[0].block_size = data_size;
 	else
@@ -1286,7 +1284,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		(unsigned long)lli_array[count].bus_address,
 		lli_array[count].block_size);
 
-	/* check the size of the last page */
+	/* Check the size of the last page */
 	if (num_pages > 1) {
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
@@ -1299,7 +1297,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			lli_array[count].block_size);
 	}
 
-	/* set output params acording to the in_out flag */
+	/* Set output params acording to the in_out flag */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
 		*lli_array_ptr = lli_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
@@ -1319,14 +1317,14 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	goto end_function;
 
 end_function_with_error3:
-	/* free lli array */
+	/* Free lli array */
 	kfree(lli_array);
 
 end_function_with_error2:
 	kfree(map_array);
 
 end_function_with_error1:
-	/* free page array */
+	/* Free page array */
 	kfree(page_array);
 
 end_function:
@@ -1352,15 +1350,15 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	u32 *last_table_flag)
 {
 	u32 counter;
-	/* table data size */
+	/* Table data size */
 	u32 table_data_size = 0;
-	/* data size for the next table */
+	/* Data size for the next table */
 	u32 next_table_data_size;
 
 	*last_table_flag = 0;
 
 	/*
-	 * calculate the data in the out lli table till we fill the whole
+	 * Calculate the data in the out lli table till we fill the whole
 	 * table or till the data has ended
 	 */
 	for (counter = 0;
@@ -1369,20 +1367,19 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 		table_data_size += lli_in_array_ptr[counter].block_size;
 
 	/*
-	 * check if we reached the last entry,
+	 * Check if we reached the last entry,
 	 * meaning this ia the last table to build,
 	 * and no need to check the block alignment
 	 */
 	if (counter == num_array_entries) {
-		/* set the last table flag */
+		/* Set the last table flag */
 		*last_table_flag = 1;
 		goto end_function;
 	}
 
 	/*
-	 * calculate the data size of the next table.
-	 * Stop if no entries left or
-	 * if data size is more the DMA restriction
+	 * Calculate the data size of the next table.
+	 * Stop if no entries left or if data size is more the DMA restriction
 	 */
 	next_table_data_size = 0;
 	for (; counter < num_array_entries; counter++) {
@@ -1392,7 +1389,7 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	}
 
 	/*
-	 * check if the next table data size is less then DMA rstriction.
+	 * Check if the next table data size is less then DMA rstriction.
 	 * if it is - recalculate the current table size, so that the next
 	 * table data size will be adaquete for DMA
 	 */
@@ -1427,23 +1424,23 @@ static void sep_build_lli_table(struct sep_device *sep,
 	u32 *num_table_entries_ptr,
 	u32 table_data_size)
 {
-	/* current table data size */
+	/* Current table data size */
 	u32 curr_table_data_size;
-	/* counter of lli array entry */
+	/* Counter of lli array entry */
 	u32 array_counter;
 
 	dev_dbg(&sep->pdev->dev, "sep_build_lli_table start\n");
 
-	/* init currrent table data size and lli array entry counter */
+	/* Init currrent table data size and lli array entry counter */
 	curr_table_data_size = 0;
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
 
 	dev_dbg(&sep->pdev->dev, "table_data_size is %x\n", table_data_size);
 
-	/* fill the table till table size reaches the needed amount */
+	/* Fill the table till table size reaches the needed amount */
 	while (curr_table_data_size < table_data_size) {
-		/* update the number of entries in table */
+		/* Update the number of entries in table */
 		(*num_table_entries_ptr)++;
 
 		lli_table_ptr->bus_address =
@@ -1461,24 +1458,24 @@ static void sep_build_lli_table(struct sep_device *sep,
 		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
-		/* check for overflow of the table data */
+		/* Check for overflow of the table data */
 		if (curr_table_data_size > table_data_size) {
 			dev_dbg(&sep->pdev->dev,
 				"curr_table_data_size too large\n");
 
-			/* update the size of block in the table */
+			/* Update the size of block in the table */
 			lli_table_ptr->block_size -=
 			cpu_to_le32((curr_table_data_size - table_data_size));
 
-			/* update the physical address in the lli array */
+			/* Update the physical address in the lli array */
 			lli_array_ptr[array_counter].bus_address +=
 			cpu_to_le32(lli_table_ptr->block_size);
 
-			/* update the block size left in the lli array */
+			/* Update the block size left in the lli array */
 			lli_array_ptr[array_counter].block_size =
 				(curr_table_data_size - table_data_size);
 		} else
-			/* advance to the next entry in the lli_array */
+			/* Advance to the next entry in the lli_array */
 			array_counter++;
 
 		dev_dbg(&sep->pdev->dev,
@@ -1488,11 +1485,11 @@ static void sep_build_lli_table(struct sep_device *sep,
 			"lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
-		/* move to the next entry in table */
+		/* Move to the next entry in table */
 		lli_table_ptr++;
 	}
 
-	/* set the info entry to default */
+	/* Set the info entry to default */
 	lli_table_ptr->bus_address = 0xffffffff;
 	lli_table_ptr->block_size = 0;
 
@@ -1502,7 +1499,7 @@ static void sep_build_lli_table(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
 						lli_table_ptr->block_size);
 
-	/* set the output parameter */
+	/* Set the output parameter */
 	*num_processed_entries_ptr += array_counter;
 
 	dev_dbg(&sep->pdev->dev, "num_processed_entries_ptr is %x\n",
@@ -1578,7 +1575,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 		dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
 							num_table_entries);
 
-		/* print entries of the table (without info entry) */
+		/* Print entries of the table (without info entry) */
 		for (entries_count = 0; entries_count < num_table_entries;
 			entries_count++, lli_table_ptr++) {
 
@@ -1591,7 +1588,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 				(unsigned long)lli_table_ptr->bus_address,
 				lli_table_ptr->block_size);
 		}
-		/* point to the info entry */
+		/* Point to the info entry */
 		lli_table_ptr--;
 
 		dev_dbg(&sep->pdev->dev,
@@ -1642,7 +1639,7 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_empty_lli_table start\n");
 
-	/* find the area for new table */
+	/* Find the area for new table */
 	lli_table_ptr =
 		(struct sep_lli_entry *)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
@@ -1656,18 +1653,18 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 	lli_table_ptr->bus_address = 0xFFFFFFFF;
 	lli_table_ptr->block_size = 0;
 
-	/* set the output parameter value */
+	/* Set the output parameter value */
 	*lli_table_addr_ptr = sep->shared_bus +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 		sep->num_lli_tables_created *
 		sizeof(struct sep_lli_entry) *
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
 
-	/* set the num of entries and table data size for empty table */
+	/* Set the num of entries and table data size for empty table */
 	*num_entries_ptr = 2;
 	*table_data_size_ptr = 0;
 
-	/* update the number of created tables */
+	/* Update the number of created tables */
 	sep->num_lli_tables_created++;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_empty_lli_table start\n");
@@ -1686,7 +1683,7 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
  *
  *	This function prepares only input DMA table for synhronic symmetric
  *	operations (HASH)
- *	Note that all bus addresses that are passed to the sep
+ *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_dma_table(struct sep_device *sep,
@@ -1699,54 +1696,54 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	bool is_kva)
 {
 	int error = 0;
-	/* pointer to the info entry of the table - the last entry */
+	/* Pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_entry_ptr;
-	/* array of pointers to page */
+	/* Array of pointers to page */
 	struct sep_lli_entry *lli_array_ptr;
-	/* points to the first entry to be processed in the lli_in_array */
+	/* Points to the first entry to be processed in the lli_in_array */
 	u32 current_entry = 0;
-	/* num entries in the virtual buffer */
+	/* Num entries in the virtual buffer */
 	u32 sep_lli_entries = 0;
-	/* lli table pointer */
+	/* Lli table pointer */
 	struct sep_lli_entry *in_lli_table_ptr;
-	/* the total data in one table */
+	/* The total data in one table */
 	u32 table_data_size = 0;
-	/* flag for last table */
+	/* Flag for last table */
 	u32 last_table_flag = 0;
-	/* number of entries in lli table */
+	/* Number of entries in lli table */
 	u32 num_entries_in_table = 0;
-	/* next table address */
+	/* Next table address */
 	u32 lli_table_alloc_addr = 0;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table start\n");
 	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
 	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
 
-	/* initialize the pages pointers */
+	/* Initialize the pages pointers */
 	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = 0;
 	sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 0;
 
-	/* set the kernel address for first table to be allocated */
+	/* Set the kernel address for first table to be allocated */
 	lli_table_alloc_addr = (u32)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
 	if (data_size == 0) {
-		/* special case  - create meptu table - 2 entries, zero data */
+		/* Special case  - create meptu table - 2 entries, zero data */
 		sep_prepare_empty_lli_table(sep, lli_table_ptr,
 				num_entries_ptr, table_data_size_ptr);
 		goto update_dcb_counter;
 	}
 
-	/* check if the pages are in Kernel Virtual Address layout */
+	/* Check if the pages are in Kernel Virtual Address layout */
 	if (is_kva == true)
-		/* lock the pages in the kernel */
+		/* Lock the pages in the kernel */
 		error = sep_lock_kernel_pages(sep, app_virt_addr,
 			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
 	else
 		/*
-		 * lock the pages of the user buffer
+		 * Lock the pages of the user buffer
 		 * and translate them to pages
 		 */
 		error = sep_lock_user_pages(sep, app_virt_addr,
@@ -1763,10 +1760,10 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 
 	sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
 
-	/* loop till all the entries in in array are not processed */
+	/* Loop till all the entries in in array are not processed */
 	while (current_entry < sep_lli_entries) {
 
-		/* set the new input and output tables */
+		/* Set the new input and output tables */
 		in_lli_table_ptr =
 			(struct sep_lli_entry *)lli_table_alloc_addr;
 
@@ -1783,17 +1780,17 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 
 		}
 
-		/* update the number of created tables */
+		/* Update the number of created tables */
 		sep->num_lli_tables_created++;
 
-		/* calculate the maximum size of data for input table */
+		/* Calculate the maximum size of data for input table */
 		table_data_size = sep_calculate_lli_table_max_size(sep,
 			&lli_array_ptr[current_entry],
 			(sep_lli_entries - current_entry),
 			&last_table_flag);
 
 		/*
-		 * if this is not the last table -
+		 * If this is not the last table -
 		 * then allign it to the block size
 		 */
 		if (!last_table_flag)
@@ -1803,14 +1800,14 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 		dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
 							table_data_size);
 
-		/* construct input lli table */
+		/* Construct input lli table */
 		sep_build_lli_table(sep, &lli_array_ptr[current_entry],
 			in_lli_table_ptr,
 			&current_entry, &num_entries_in_table, table_data_size);
 
 		if (info_entry_ptr == 0) {
 
-			/* set the output parameters to physical addresses */
+			/* Set the output parameters to physical addresses */
 			*lli_table_ptr = sep_shared_area_virt_to_bus(sep,
 				in_lli_table_ptr);
 			*num_entries_ptr = num_entries_in_table;
@@ -1821,7 +1818,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 				(unsigned long)*lli_table_ptr);
 
 		} else {
-			/* update the info entry of the previous in table */
+			/* Update the info entry of the previous in table */
 			info_entry_ptr->bus_address =
 				sep_shared_area_virt_to_bus(sep,
 							in_lli_table_ptr);
@@ -1829,23 +1826,23 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 				((num_entries_in_table) << 24) |
 				(table_data_size);
 		}
-		/* save the pointer to the info entry of the current tables */
+		/* Save the pointer to the info entry of the current tables */
 		info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
 	}
-	/* print input tables */
+	/* Print input tables */
 	sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
 		sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
 		*num_entries_ptr, *table_data_size_ptr);
-	/* the array of the pages */
+	/* The array of the pages */
 	kfree(lli_array_ptr);
 
 update_dcb_counter:
-	/* update dcb counter */
+	/* Update DCB counter */
 	sep->nr_dcb_creat++;
 	goto end_function;
 
 end_function_error:
-	/* free all the allocated resources */
+	/* Free all the allocated resources */
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
 	kfree(lli_array_ptr);
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
@@ -1857,7 +1854,7 @@ end_function:
 }
 /**
  *	sep_construct_dma_tables_from_lli - prepare AES/DES mappings
- *	@sep: pointer to struct_sep
+ *	@sep: pointer to struct sep_device
  *	@lli_in_array:
  *	@sep_in_lli_entries:
  *	@lli_out_array:
@@ -1869,10 +1866,10 @@ end_function:
  *	@out_num_entries_ptr
  *	@table_data_size_ptr
  *
- *	This function creates the input and output dma tables for
+ *	This function creates the input and output DMA tables for
  *	symmetric operations (AES/DES) according to the block
  *	size from LLI arays
- *	Note that all bus addresses that are passed to the sep
+ *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_construct_dma_tables_from_lli(
@@ -1888,56 +1885,56 @@ static int sep_construct_dma_tables_from_lli(
 	u32	*out_num_entries_ptr,
 	u32	*table_data_size_ptr)
 {
-	/* points to the area where next lli table can be allocated */
+	/* Points to the area where next lli table can be allocated */
 	u32 lli_table_alloc_addr = 0;
-	/* input lli table */
+	/* Input lli table */
 	struct sep_lli_entry *in_lli_table_ptr = 0;
-	/* output lli table */
+	/* Output lli table */
 	struct sep_lli_entry *out_lli_table_ptr = 0;
-	/* pointer to the info entry of the table - the last entry */
+	/* Pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_in_entry_ptr = 0;
-	/* pointer to the info entry of the table - the last entry */
+	/* Pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_out_entry_ptr = 0;
-	/* points to the first entry to be processed in the lli_in_array */
+	/* Points to the first entry to be processed in the lli_in_array */
 	u32 current_in_entry = 0;
-	/* points to the first entry to be processed in the lli_out_array */
+	/* Points to the first entry to be processed in the lli_out_array */
 	u32 current_out_entry = 0;
-	/* max size of the input table */
+	/* Max size of the input table */
 	u32 in_table_data_size = 0;
-	/* max size of the output table */
+	/* Max size of the output table */
 	u32 out_table_data_size = 0;
-	/* flag te signifies if this is the last tables build */
+	/* Flag te signifies if this is the last tables build */
 	u32 last_table_flag = 0;
-	/* the data size that should be in table */
+	/* The data size that should be in table */
 	u32 table_data_size = 0;
-	/* number of etnries in the input table */
+	/* Number of etnries in the input table */
 	u32 num_entries_in_table = 0;
-	/* number of etnries in the output table */
+	/* Number of etnries in the output table */
 	u32 num_entries_out_table = 0;
 
 	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli start\n");
 
-	/* initiate to point after the message area */
+	/* Initiate to point after the message area */
 	lli_table_alloc_addr = (u32)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 		(sep->num_lli_tables_created *
 		(sizeof(struct sep_lli_entry) *
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)));
 
-	/* loop till all the entries in in array are not processed */
+	/* Loop till all the entries in in array are not processed */
 	while (current_in_entry < sep_in_lli_entries) {
-		/* set the new input and output tables */
+		/* Set the new input and output tables */
 		in_lli_table_ptr =
 			(struct sep_lli_entry *)lli_table_alloc_addr;
 
 		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
 			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
 
-		/* set the first output tables */
+		/* Set the first output tables */
 		out_lli_table_ptr =
 			(struct sep_lli_entry *)lli_table_alloc_addr;
 
-		/* check if the DMA table area limit was overrun */
+		/* Check if the DMA table area limit was overrun */
 		if ((lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
 			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
 			((u32)sep->shared_addr +
@@ -1948,20 +1945,20 @@ static int sep_construct_dma_tables_from_lli(
 			return -ENOMEM;
 		}
 
-		/* update the number of the lli tables created */
+		/* Update the number of the lli tables created */
 		sep->num_lli_tables_created += 2;
 
 		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
 			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
 
-		/* calculate the maximum size of data for input table */
+		/* Calculate the maximum size of data for input table */
 		in_table_data_size =
 			sep_calculate_lli_table_max_size(sep,
 			&lli_in_array[current_in_entry],
 			(sep_in_lli_entries - current_in_entry),
 			&last_table_flag);
 
-		/* calculate the maximum size of data for output table */
+		/* Calculate the maximum size of data for output table */
 		out_table_data_size =
 			sep_calculate_lli_table_max_size(sep,
 			&lli_out_array[current_out_entry],
@@ -1980,7 +1977,7 @@ static int sep_construct_dma_tables_from_lli(
 
 		if (!last_table_flag) {
 			/*
-			 * if this is not the last table,
+			 * If this is not the last table,
 			 * then must check where the data is smallest
 			 * and then align it to the block size
 			 */
@@ -1988,7 +1985,7 @@ static int sep_construct_dma_tables_from_lli(
 				table_data_size = out_table_data_size;
 
 			/*
-			 * now calculate the table size so that
+			 * Now calculate the table size so that
 			 * it will be module block size
 			 */
 			table_data_size = (table_data_size / block_size) *
@@ -1998,23 +1995,23 @@ static int sep_construct_dma_tables_from_lli(
 		dev_dbg(&sep->pdev->dev, "table_data_size is %x\n",
 							table_data_size);
 
-		/* construct input lli table */
+		/* Construct input lli table */
 		sep_build_lli_table(sep, &lli_in_array[current_in_entry],
 			in_lli_table_ptr,
 			&current_in_entry,
 			&num_entries_in_table,
 			table_data_size);
 
-		/* construct output lli table */
+		/* Construct output lli table */
 		sep_build_lli_table(sep, &lli_out_array[current_out_entry],
 			out_lli_table_ptr,
 			&current_out_entry,
 			&num_entries_out_table,
 			table_data_size);
 
-		/* if info entry is null - this is the first table built */
+		/* If info entry is null - this is the first table built */
 		if (info_in_entry_ptr == 0) {
-			/* set the output parameters to physical addresses */
+			/* Set the output parameters to physical addresses */
 			*lli_table_in_ptr =
 			sep_shared_area_virt_to_bus(sep, in_lli_table_ptr);
 
@@ -2034,7 +2031,7 @@ static int sep_construct_dma_tables_from_lli(
 			"output lli_table_out_ptr is %08lx\n",
 				(unsigned long)*lli_table_out_ptr);
 		} else {
-			/* update the info entry of the previous in table */
+			/* Update the info entry of the previous in table */
 			info_in_entry_ptr->bus_address =
 				sep_shared_area_virt_to_bus(sep,
 				in_lli_table_ptr);
@@ -2043,7 +2040,7 @@ static int sep_construct_dma_tables_from_lli(
 				((num_entries_in_table) << 24) |
 				(table_data_size);
 
-			/* update the info entry of the previous in table */
+			/* Update the info entry of the previous in table */
 			info_out_entry_ptr->bus_address =
 				sep_shared_area_virt_to_bus(sep,
 				out_lli_table_ptr);
@@ -2063,7 +2060,7 @@ static int sep_construct_dma_tables_from_lli(
 				info_out_entry_ptr->block_size);
 		}
 
-		/* save the pointer to the info entry of the current tables */
+		/* Save the pointer to the info entry of the current tables */
 		info_in_entry_ptr = in_lli_table_ptr +
 			num_entries_in_table - 1;
 		info_out_entry_ptr = out_lli_table_ptr +
@@ -2080,14 +2077,14 @@ static int sep_construct_dma_tables_from_lli(
 			(unsigned long)info_out_entry_ptr);
 	}
 
-	/* print input tables */
+	/* Print input tables */
 	sep_debug_print_lli_tables(sep,
 	(struct sep_lli_entry *)
 	sep_shared_area_bus_to_virt(sep, *lli_table_in_ptr),
 	*in_num_entries_ptr,
 	*table_data_size_ptr);
 
-	/* print output tables */
+	/* Print output tables */
 	sep_debug_print_lli_tables(sep,
 	(struct sep_lli_entry *)
 	sep_shared_area_bus_to_virt(sep, *lli_table_out_ptr),
@@ -2114,7 +2111,7 @@ static int sep_construct_dma_tables_from_lli(
  *	This function builds input and output DMA tables for synhronic
  *	symmetric operations (AES, DES, HASH). It also checks that each table
  *	is of the modular block size
- *	Note that all bus addresses that are passed to the sep
+ *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_output_dma_table(struct sep_device *sep,
@@ -2131,15 +2128,15 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 
 {
 	int error = 0;
-	/* array of pointers of page */
+	/* Array of pointers of page */
 	struct sep_lli_entry *lli_in_array;
-	/* array of pointers of page */
+	/* Array of pointers of page */
 	struct sep_lli_entry *lli_out_array;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_input_output_dma_table start\n");
 
 	if (data_size == 0) {
-		/* prepare empty table for input and output */
+		/* Prepare empty table for input and output */
 		sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
 			in_num_entries_ptr, table_data_size_ptr);
 
@@ -2149,11 +2146,11 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		goto update_dcb_counter;
 	}
 
-	/* initialize the pages pointers */
+	/* Initialize the pages pointers */
 	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = 0;
 	sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = 0;
 
-	/* lock the pages of the buffer and translate them to pages */
+	/* Lock the pages of the buffer and translate them to pages */
 	if (is_kva == true) {
 		error = sep_lock_kernel_pages(sep, app_virt_in_addr,
 			data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
@@ -2200,7 +2197,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
-	/* call the fucntion that creates table from the lli arrays */
+	/* Call the fucntion that creates table from the lli arrays */
 	error = sep_construct_dma_tables_from_lli(sep, lli_in_array,
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages,
 		lli_out_array,
@@ -2218,9 +2215,9 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	kfree(lli_in_array);
 
 update_dcb_counter:
-	/* update dcb counter */
+	/* Update DCB counter */
 	sep->nr_dcb_creat++;
-	/* fall through - free the lli entry arrays */
+	/* Fall through - free the lli entry arrays */
 	dev_dbg(&sep->pdev->dev, "in_num_entries_ptr is %08x\n",
 						*in_num_entries_ptr);
 	dev_dbg(&sep->pdev->dev, "out_num_entries_ptr is %08x\n",
@@ -2259,10 +2256,10 @@ end_function:
  *	@isapplet: bool; to indicate external app
  *	@is_kva: bool; kernel buffer; only used for kernel crypto module
  *
- *	This function prepares the linked dma tables and puts the
- *	address for the linked list of tables inta a dcb (data control
- *	block) the address of which is known by the sep hardware
- *	Note that all bus addresses that are passed to the sep
+ *	This function prepares the linked DMA tables and puts the
+ *	address for the linked list of tables inta a DCB (data control
+ *	block) the address of which is known by the SEP hardware
+ *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
@@ -2275,36 +2272,36 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	bool		is_kva)
 {
 	int error = 0;
-	/* size of tail */
+	/* Size of tail */
 	u32 tail_size = 0;
-	/* address of the created dcb table */
+	/* Address of the created DCB table */
 	struct sep_dcblock *dcb_table_ptr = 0;
-	/* the physical address of the first input DMA table */
+	/* The physical address of the first input DMA table */
 	dma_addr_t in_first_mlli_address = 0;
-	/* number of entries in the first input DMA table */
+	/* Number of entries in the first input DMA table */
 	u32  in_first_num_entries = 0;
-	/* the physical address of the first output DMA table */
+	/* The physical address of the first output DMA table */
 	dma_addr_t  out_first_mlli_address = 0;
-	/* number of entries in the first output DMA table */
+	/* Number of entries in the first output DMA table */
 	u32  out_first_num_entries = 0;
-	/* data in the first input/output table */
+	/* Data in the first input/output table */
 	u32  first_data_size = 0;
 
 	dev_dbg(&sep->pdev->dev, "prepare_input_output_dma_table_in_dcb start\n");
 
 	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
-		/* No more DCBS to allocate */
-		dev_warn(&sep->pdev->dev, "no more dcb's available\n");
+		/* No more DCBs to allocate */
+		dev_warn(&sep->pdev->dev, "no more DCBs available\n");
 		error = -ENOSPC;
 		goto end_function;
 	}
 
-	/* allocate new DCB */
+	/* Allocate new DCB */
 	dcb_table_ptr = (struct sep_dcblock *)(sep->shared_addr +
 		SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES +
 		(sep->nr_dcb_creat * sizeof(struct sep_dcblock)));
 
-	/* set the default values in the dcb */
+	/* Set the default values in the DCB */
 	dcb_table_ptr->input_mlli_address = 0;
 	dcb_table_ptr->input_mlli_num_entries = 0;
 	dcb_table_ptr->input_mlli_data_size = 0;
@@ -2324,7 +2321,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			}
 			if (tail_block_size)
 				/*
-				 * case the tail size should be
+				 * Case the tail size should be
 				 * bigger than the real block size
 				 */
 				tail_size = tail_block_size +
@@ -2332,7 +2329,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 						tail_block_size) % block_size);
 		}
 
-		/* check if there is enough data for dma operation */
+		/* Check if there is enough data for DMA operation */
 		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
 			if (is_kva == true) {
 				memcpy(dcb_table_ptr->tail_data,
@@ -2348,7 +2345,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 			dcb_table_ptr->tail_data_size = data_in_size;
 
-			/* set the output user-space address for mem2mem op */
+			/* Set the output user-space address for mem2mem op */
 			if (app_out_address)
 				dcb_table_ptr->out_vr_tail_pt =
 							(u32)app_out_address;
@@ -2367,7 +2364,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 					(void *)(app_in_address + data_in_size -
 					tail_size), tail_size);
 			} else {
-				/* we have tail data - copy it to dcb */
+				/* We have tail data - copy it to DCB */
 				if (copy_from_user(dcb_table_ptr->tail_data,
 					(void *)(app_in_address +
 					data_in_size - tail_size), tail_size)) {
@@ -2393,9 +2390,9 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			data_in_size = (data_in_size - tail_size);
 		}
 	}
-	/* check if we need to build only input table or input/output */
+	/* Check if we need to build only input table or input/output */
 	if (app_out_address) {
-		/* prepare input/output tables */
+		/* Prepare input/output tables */
 		error = sep_prepare_input_output_dma_table(sep,
 			app_in_address,
 			app_out_address,
@@ -2408,7 +2405,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			&first_data_size,
 			is_kva);
 	} else {
-		/* prepare input tables */
+		/* Prepare input tables */
 		error = sep_prepare_input_dma_table(sep,
 			app_in_address,
 			data_in_size,
@@ -2420,11 +2417,11 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	}
 
 	if (error) {
-		dev_warn(&sep->pdev->dev, "prepare dma table call failed from prepare dcb call\n");
+		dev_warn(&sep->pdev->dev, "prepare DMA table call failed from prepare DCB call\n");
 		goto end_function;
 	}
 
-	/* set the dcb values */
+	/* Set the DCB values */
 	dcb_table_ptr->input_mlli_address = in_first_mlli_address;
 	dcb_table_ptr->input_mlli_num_entries = in_first_num_entries;
 	dcb_table_ptr->input_mlli_data_size = first_data_size;
@@ -2441,7 +2438,7 @@ end_function:
 
 
 /**
- *	sep_create_sync_dma_tables_handler - create sync dma tables
+ *	sep_create_sync_dma_tables_handler - create sync DMA tables
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to struct bld_syn_tab_struct
  *
@@ -2454,7 +2451,7 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 {
 	int error = 0;
 
-	/* command arguments */
+	/* Command arguments */
 	struct bld_syn_tab_struct command_args;
 
 	dev_dbg(&sep->pdev->dev,
@@ -2475,7 +2472,7 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "block_size is %u\n",
 						command_args.block_size);
 
-	/* validate user parameters */
+	/* Validate user parameters */
 	if (!command_args.app_in_address) {
 		error = -EINVAL;
 		goto end_function;
@@ -2501,7 +2498,7 @@ end_function:
  *	@isapplet: indicates external application (used for kernel access)
  *	@is_kva: indicates kernel addresses (only used for kernel crypto)
  *
- *	This function frees the dma tables and dcb block
+ *	This function frees the DMA tables and DCB
  */
 static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	bool is_kva)
@@ -2514,12 +2511,12 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb start\n");
 
 	if (isapplet == true) {
-		/* set pointer to first dcb table */
+		/* Set pointer to first DCB table */
 		dcb_table_ptr = (struct sep_dcblock *)
 			(sep->shared_addr +
 			SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
 
-		/* go over each dcb and see if tail pointer must be updated */
+		/* Go over each DCB and see if tail pointer must be updated */
 		for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
 			if (dcb_table_ptr->out_vr_tail_pt) {
 				if (is_kva == true) {
@@ -2533,14 +2530,14 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 						dcb_table_ptr->tail_data_size);
 				}
 				if (error_temp) {
-					/* release the dma resource */
+					/* Release the DMA resource */
 					error = -EFAULT;
 					break;
 				}
 			}
 		}
 	}
-	/* free the output pages, if any */
+	/* Free the output pages, if any */
 	sep_free_dma_table_data_handler(sep);
 
 	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb end\n");
@@ -2579,7 +2576,7 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep,
 		(u32)static_pool_addr[1],
 		(u32)command_args.static_virt_address);
 
-	/* send the parameters to user application */
+	/* Send the parameters to user application */
 	if (copy_to_user((void __user *) arg, &command_args,
 		sizeof(struct stat_pool_addr_struct)))
 		return -EFAULT;
@@ -2600,14 +2597,14 @@ static int sep_start_handler(struct sep_device *sep)
 
 	dev_dbg(&sep->pdev->dev, "sep_start_handler start\n");
 
-	/* wait in polling for message from SEP */
+	/* Wait in polling for message from SEP */
 	do
 		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	while (!reg_val);
 
-	/* check the value */
+	/* Check the value */
 	if (reg_val == 0x1)
-		/* fatal error - read error status from GPRO */
+		/* Fatal error - read error status from GPRO */
 		error = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR);
 	dev_dbg(&sep->pdev->dev, "sep_start_handler end\n");
 	return error;
@@ -2619,7 +2616,7 @@ static int sep_start_handler(struct sep_device *sep)
  *	@length: buffer size
  *
  *	This function performs a checksum for messages that are sent
- *	to the sep
+ *	to the SEP.
  */
 static u32 sep_check_sum_calc(u8 *data, u32 length)
 {
@@ -2651,7 +2648,7 @@ static u32 sep_check_sum_calc(u8 *data, u32 length)
  *	Handles the request for SEP initialization
  *	Note that this will go away for Medfield once the SCU
  *	SEP initialization is complete
- *	Also note that the message to the sep has components
+ *	Also note that the message to the SEP has components
  *	from user space as well as components written by the driver
  *	This is becuase the portions of the message that pertain to
  *	physical addresses must be set by the driver after the message
@@ -2670,7 +2667,7 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 
 	dev_dbg(&sep->pdev->dev, "sep_init_handler start\n");
 
-	/* make sure that we have not initialized already */
+	/* Make sure that we have not initialized already */
 	reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 
 	if (reg_val != 0x2) {
@@ -2679,13 +2676,13 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	/* only root can initialize */
+	/* Only root can initialize */
 	if (!capable(CAP_SYS_ADMIN)) {
 		error = -EACCES;
 		goto end_function;
 	}
 
-	/* copy in the parameters */
+	/* Copy in the parameters */
 	error = copy_from_user(&command_args, (void __user *)arg,
 		sizeof(struct init_struct));
 
@@ -2694,14 +2691,14 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	/* validate parameters */
+	/* Validate parameters */
 	if (!command_args.message_addr || !command_args.sep_sram_addr ||
 		command_args.message_size_in_words > 14) {
 		error = -EINVAL;
 		goto end_function;
 	}
 
-	/* copy in the sep init message */
+	/* Copy in the SEP init message */
 	addr_hold = (unsigned long)command_args.message_addr;
 	error = copy_from_user(message_buff,
 		(void __user *)addr_hold,
@@ -2712,16 +2709,16 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	/* load resident, cache, and extapp firmware */
+	/* Load resident, cache, and extapp firmware */
 	error = sep_load_firmware(sep);
 
 	if (error) {
 		dev_warn(&sep->pdev->dev,
-			"init; copy sep init message failed %x\n", error);
+			"init; copy SEP init message failed %x\n", error);
 		goto end_function;
 	}
 
-	/* compute the base address */
+	/* Compute the base address */
 	new_base_addr = sep->shared_bus;
 
 	if (sep->resident_bus < new_base_addr)
@@ -2733,7 +2730,7 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	if (sep->dcache_bus < new_base_addr)
 		new_base_addr = sep->dcache_bus;
 
-	/* put physical addresses in sep message */
+	/* Put physical addresses in SEP message */
 	message_buff[3] = (u32)new_base_addr;
 	message_buff[4] = (u32)sep->shared_bus;
 	message_buff[6] = (u32)sep->resident_bus;
@@ -2745,16 +2742,16 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		sep_check_sum_calc((u8 *)message_buff,
 		command_args.message_size_in_words*sizeof(u32));
 
-	/* debug print of message */
+	/* Debug print of message */
 	for (counter = 0; counter < command_args.message_size_in_words;
 								counter++)
-		dev_dbg(&sep->pdev->dev, "init; sep message word %d is %x\n",
+		dev_dbg(&sep->pdev->dev, "init; SEP message word %d is %x\n",
 			counter, message_buff[counter]);
 
-	/* tell the sep the sram address */
+	/* Tell the SEP the sram address */
 	sep_write_reg(sep, HW_SRAM_ADDR_REG_ADDR, command_args.sep_sram_addr);
 
-	/* push the message to the sep */
+	/* Push the message to the SEP */
 	for (counter = 0; counter < command_args.message_size_in_words;
 								counter++) {
 		sep_write_reg(sep, HW_SRAM_DATA_REG_ADDR,
@@ -2762,10 +2759,10 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		sep_wait_sram_write(sep);
 	}
 
-	/* signal sep that message is ready and to init */
+	/* Signal SEP that message is ready and to init */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x1);
 
-	/* wait for acknowledge */
+	/* Wait for acknowledge */
 	dev_dbg(&sep->pdev->dev, "init; waiting for msg response\n");
 
 	do
@@ -2782,10 +2779,10 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	}
 	dev_dbg(&sep->pdev->dev, "init; end CC INIT, reg_val is %x\n", reg_val);
 
-	/* signal sep to zero the GPR3 */
+	/* Signal SEP to zero the GPR3 */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x10);
 
-	/* wait for response */
+	/* Wait for response */
 	dev_dbg(&sep->pdev->dev, "init; waiting for zero set response\n");
 
 	do
@@ -2807,25 +2804,25 @@ static int sep_end_transaction_handler(struct sep_device *sep)
 {
 	dev_dbg(&sep->pdev->dev, "sep_end_transaction_handler start\n");
 
-	/* clear the data pool pointers Token */
+	/* Clear the data pool pointers Token */
 	memset((void *)(sep->shared_addr +
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
 		0, sep->num_of_data_allocations*2*sizeof(u32));
 
-	/* check that all the dma resources were freed */
+	/* Check that all the DMA resources were freed */
 	sep_free_dma_table_data_handler(sep);
 
 	clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
 
 	/*
-	 * we are now through with the transaction. Let's
+	 * We are now through with the transaction. Let's
 	 * allow other processes who have the device open
 	 * to perform transactions
 	 */
 	mutex_lock(&sep->sep_mutex);
 	sep->pid_doing_transaction = 0;
 	mutex_unlock(&sep->sep_mutex);
-	/* raise event for stuck contextes */
+	/* Raise event for stuck contextes */
 	wake_up(&sep->event);
 
 	dev_dbg(&sep->pdev->dev, "waking up event\n");
@@ -2844,9 +2841,8 @@ static int sep_end_transaction_handler(struct sep_device *sep)
  */
 static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 {
-	/* error */
 	int error;
-	/* command arguments */
+	/* Command arguments */
 	struct build_dcb_struct command_args;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler start\n");
@@ -2912,24 +2908,24 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	unsigned long arg)
 {
 	int error = 0;
-	/* command args */
+	/* Command args */
 	struct rar_hndl_to_bus_struct command_args;
 	struct RAR_buffer rar_buf;
-	/* bus address */
+	/* Bus address */
 	dma_addr_t  rar_bus = 0;
-	/* holds the RAR address in the system memory offset */
+	/* Holds the RAR address in the system memory offset */
 	u32 *rar_addr;
 
 	dev_dbg(&sep->pdev->dev, "sep_rar_prepare_output_msg_handler start\n");
 
-	/* copy the data */
+	/* Copy the data */
 	if (copy_from_user(&command_args, (void __user *)arg,
 						sizeof(command_args))) {
 		error = -EFAULT;
 		goto end_function;
 	}
 
-	/* call to translation function only if user handle is not NULL */
+	/* Call to translation function only if user handle is not NULL */
 	if (command_args.rar_handle) {
 		memset(&rar_buf, 0, sizeof(rar_buf));
 		rar_buf.info.handle = (u32)command_args.rar_handle;
@@ -2943,11 +2939,11 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	}
 	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
 
-	/* set value in the SYSTEM MEMORY offset */
+	/* Set value in the SYSTEM MEMORY offset */
 	rar_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
 
-	/* copy the physical address to the System Area for the sep */
+	/* Copy the physical address to the System Area for the SEP */
 	rar_addr[0] = SEP_RAR_VAL_TOKEN;
 	rar_addr[1] = rar_bus;
 
@@ -2961,19 +2957,19 @@ end_function:
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
  *
- *	This function tells the sep where the extapp is located
+ *	This function tells the SEP where the extapp is located
  */
 static int sep_realloc_ext_cache_handler(struct sep_device *sep,
 	unsigned long arg)
 {
-	/* holds the new ext cache address in the system memory offset */
+	/* Holds the new ext cache address in the system memory offset */
 	u32 *system_addr;
 
-	/* set value in the SYSTEM MEMORY offset */
+	/* Set value in the SYSTEM MEMORY offset */
 	system_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES);
 
-	/* copy the physical address to the System Area for the sep */
+	/* Copy the physical address to the System Area for the SEP */
 	system_addr[0] = SEP_EXT_CACHE_ADDR_VAL_TOKEN;
 	dev_dbg(&sep->pdev->dev, "ext cache init; system addr 0 is %x\n",
 							system_addr[0]);
@@ -3025,7 +3021,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCFREEDCB is %x\n", SEP_IOCFREEDCB);
 
-	/* make sure we own this device */
+	/* Make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
@@ -3037,48 +3033,48 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	mutex_unlock(&sep->sep_mutex);
 
-	/* check that the command is for sep device */
+	/* Check that the command is for SEP device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
 		error = -ENOTTY;
 		goto end_function;
 	}
 
-	/* lock to prevent the daemon to interfere with operation */
+	/* Lock to prevent the daemon to interfere with operation */
 	mutex_lock(&sep->ioctl_mutex);
 
 	switch (cmd) {
 	case SEP_IOCSENDSEPCOMMAND:
-		/* send command to SEP */
+		/* Send command to SEP */
 		error = sep_send_command_handler(sep);
 		break;
 	case SEP_IOCALLOCDATAPOLL:
-		/* allocate data pool */
+		/* Allocate data pool */
 		error = sep_allocate_data_pool_memory_handler(sep, arg);
 		break;
 	case SEP_IOCCREATESYMDMATABLE:
-		/* create dma table for synhronic operation */
+		/* Create DMA table for synhronic operation */
 		error = sep_create_sync_dma_tables_handler(sep, arg);
 		break;
 	case SEP_IOCFREEDMATABLEDATA:
-		/* free the pages */
+		/* Free the pages */
 		error = sep_free_dma_table_data_handler(sep);
 		break;
 	case SEP_IOCSEPSTART:
-		/* start command to sep */
-		if (sep->pdev->revision == 0) /* only for old chip */
+		/* Start command to SEP */
+		if (sep->pdev->revision == 0) /* Only for old chip */
 			error = sep_start_handler(sep);
 		else
-			error = -EPERM; /* not permitted on new chip */
+			error = -EPERM; /* Not permitted on new chip */
 		break;
 	case SEP_IOCSEPINIT:
-		/* init command to sep */
-		if (sep->pdev->revision == 0) /* only for old chip */
+		/* Init command to SEP */
+		if (sep->pdev->revision == 0) /* Only for old chip */
 			error = sep_init_handler(sep, arg);
 		else
-			error = -EPERM; /* not permitted on new chip */
+			error = -EPERM; /* Not permitted on new chip */
 		break;
 	case SEP_IOCGETSTATICPOOLADDR:
-		/* get the physical and virtual addresses of the static pool */
+		/* Get the physical and virtual addresses of the static pool */
 		error = sep_get_static_pool_addr_handler(sep, arg);
 		break;
 	case SEP_IOCENDTRANSACTION:
@@ -3087,10 +3083,10 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case SEP_IOCREALLOCEXTCACHE:
 		if (sep->mrst)
 			error = -ENODEV;
-		if (sep->pdev->revision == 0) /* only for old chip */
+		if (sep->pdev->revision == 0) /* Only for old chip */
 			error = sep_realloc_ext_cache_handler(sep, arg);
 		else
-			error = -EPERM; /* not permitted on new chip */
+			error = -EPERM; /* Not permitted on new chip */
 		break;
 	case SEP_IOCRARPREPAREMESSAGE:
 		error = sep_rar_prepare_output_msg_handler(sep, arg);
@@ -3123,20 +3119,19 @@ end_function:
  */
 static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 {
-	/* error */
 	long error = 0;
 	struct sep_device *sep = filp->private_data;
 
 	dev_dbg(&sep->pdev->dev, "singleton_ioctl start\n");
 	dev_dbg(&sep->pdev->dev, "cmd is %x\n", cmd);
 
-	/* check that the command is for sep device */
+	/* Check that the command is for the SEP device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
 		error =  -ENOTTY;
 		goto end_function;
 	}
 
-	/* make sure we own this device */
+	/* Make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
@@ -3182,23 +3177,23 @@ static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 	dev_dbg(&sep->pdev->dev, "daemon ioctl: start\n");
 	dev_dbg(&sep->pdev->dev, "daemon ioctl: cmd is %x\n", cmd);
 
-	/* check that the command is for sep device */
+	/* Check that the command is for SEP device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
 		error = -ENOTTY;
 		goto end_function;
 	}
 
-	/* only one process can access ioctl at any given time */
+	/* Only one process can access ioctl at any given time */
 	mutex_lock(&sep->ioctl_mutex);
 
 	switch (cmd) {
 	case SEP_IOCSENDSEPRPLYCOMMAND:
-		/* send reply command to SEP */
+		/* Send reply command to SEP */
 		error = sep_req_daemon_send_reply_command_handler(sep);
 		break;
 	case SEP_IOCENDTRANSACTION:
 		/*
-		 * end req daemon transaction, do nothing
+		 * End req daemon transaction, do nothing
 		 * will be removed upon update in middleware
 		 * API library
 		 */
@@ -3217,7 +3212,7 @@ end_function:
 }
 
 /**
- *	sep_inthandler - Interrupt Handler
+ *	sep_inthandler - interrupt handler
  *	@irq: interrupt
  *	@dev_id: device id
  */
@@ -3228,12 +3223,12 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 	u32 reg_val, reg_val2 = 0;
 	struct sep_device *sep = dev_id;
 
-	/* read the IRR register to check if this is SEP interrupt */
+	/* Read the IRR register to check if this is SEP interrupt */
 	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
 	dev_dbg(&sep->pdev->dev, "SEP Interrupt - reg is %08x\n", reg_val);
 
 	if (reg_val & (0x1 << 13)) {
-		/* lock and update the counter of reply messages */
+		/* Lock and update the counter of reply messages */
 		spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 		sep->reply_ct++;
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
@@ -3241,7 +3236,7 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
 					sep->send_ct, sep->reply_ct);
 
-		/* is this printf or daemon request? */
+		/* Is this printf or daemon request? */
 		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
 		dev_dbg(&sep->pdev->dev,
 			"SEP Interrupt - reg2 is %08x\n", reg_val2);
@@ -3253,11 +3248,11 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 			dev_dbg(&sep->pdev->dev, "int: daemon request\n");
 			wake_up(&sep->event_request_daemon);
 		} else {
-			dev_dbg(&sep->pdev->dev, "int: sep reply\n");
+			dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
 			wake_up(&sep->event);
 		}
 	} else {
-		dev_dbg(&sep->pdev->dev, "int: not sep interrupt\n");
+		dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
 		int_error = IRQ_NONE;
 	}
 	if (int_error == IRQ_HANDLED)
@@ -3329,20 +3324,20 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	int error = 0;
 	struct sep_device *sep;
 
-	pr_debug("Sep pci probe starting\n");
+	pr_debug("SEP pci probe starting\n");
 	if (sep_dev != NULL) {
 		dev_warn(&pdev->dev, "only one SEP supported.\n");
 		return -EBUSY;
 	}
 
-	/* enable the device */
+	/* Enable the device */
 	error = pci_enable_device(pdev);
 	if (error) {
 		dev_warn(&pdev->dev, "error enabling pci device\n");
 		goto end_function;
 	}
 
-	/* allocate the sep_device structure for this device */
+	/* Allocate the sep_device structure for this device */
 	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
 	if (sep_dev == NULL) {
 		dev_warn(&pdev->dev,
@@ -3351,7 +3346,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	}
 
 	/*
-	 * we're going to use another variable for actually
+	 * We're going to use another variable for actually
 	 * working with the device; this way, if we have
 	 * multiple devices in the future, it would be easier
 	 * to make appropriate changes
@@ -3366,7 +3361,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	dev_dbg(&sep->pdev->dev, "PCI obtained, device being prepared\n");
 	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
 
-	/* set up our register area */
+	/* Set up our register area */
 	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
 	if (!sep->reg_physical_addr) {
 		dev_warn(&sep->pdev->dev, "Error getting register start\n");
@@ -3395,7 +3390,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		(unsigned long long)sep->reg_physical_end,
 		sep->reg_addr);
 
-	/* allocate the shared area */
+	/* Allocate the shared area */
 	sep->shared_size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
 		SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES +
 		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
@@ -3404,11 +3399,11 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	if (sep_map_and_alloc_shared_area(sep)) {
 		error = -ENOMEM;
-		/* allocation failed */
+		/* Allocation failed */
 		goto end_function_error;
 	}
 
-	/* the next section depends on type of unit */
+	/* The next section depends on type of unit */
 	if (sep->mrst) {
 		error = register_rar(RAR_TYPE_IMAGE, &sep_callback,
 			(unsigned long)sep);
@@ -3435,14 +3430,14 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	dev_dbg(&sep->pdev->dev, "about to write IMR and ICR REG_ADDR\n");
 
-	/* clear ICR register */
+	/* Clear ICR register */
 	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
 
-	/* set the IMR register - open only GPR 2 */
+	/* Set the IMR register - open only GPR 2 */
 	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
 
 	dev_dbg(&sep->pdev->dev, "about to call request_irq\n");
-	/* get the interrupt line */
+	/* Get the interrupt line */
 	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
 		"sep_driver", sep);
 
@@ -3455,7 +3450,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	goto end_function;
 
 end_function_deallocate_sep_shared_area:
-	/* de-allocate shared area */
+	/* De-allocate shared area */
 	sep_unmap_and_free_shared_area(sep);
 
 end_function_error:
@@ -3475,7 +3470,7 @@ static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
 
 MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
 
-/* field for registering driver to PCI device */
+/* Field for registering driver to PCI device */
 static struct pci_driver sep_pci_driver = {
 	.name = "sep_sec_driver",
 	.id_table = sep_pci_id_tbl,
@@ -3483,7 +3478,7 @@ static struct pci_driver sep_pci_driver = {
 	/* FIXME: remove handler */
 };
 
-/* file operation for singleton sep operations */
+/* File operation for singleton SEP operations */
 static const struct file_operations singleton_file_operations = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = sep_singleton_ioctl,
@@ -3493,7 +3488,7 @@ static const struct file_operations singleton_file_operations = {
 	.mmap = sep_mmap,
 };
 
-/* file operation for daemon operations */
+/* File operation for daemon operations */
 static const struct file_operations daemon_file_operations = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = sep_request_daemon_ioctl,
@@ -3503,7 +3498,7 @@ static const struct file_operations daemon_file_operations = {
 	.mmap = sep_request_daemon_mmap,
 };
 
-/* the files operations structure of the driver */
+/* The files operations structure of the driver */
 static const struct file_operations sep_file_operations = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = sep_ioctl,
@@ -3526,19 +3521,19 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 
 	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
 
-	/* send the new SHARED MESSAGE AREA to the SEP */
+	/* Send the new SHARED MESSAGE AREA to the SEP */
 	dev_dbg(&sep->pdev->dev, "sending %08llx to sep\n",
 				(unsigned long long)sep->shared_bus);
 
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
 
-	/* poll for SEP response */
+	/* Poll for SEP response */
 	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
 	while (ret_val != 0xffffffff && ret_val != sep->shared_bus)
 		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
-	/* check the return value (register) */
+	/* Check the return value (register) */
 	if (ret_val != sep->shared_bus) {
 		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
 		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
@@ -3574,7 +3569,7 @@ static int sep_register_driver_to_fs(struct sep_device *sep)
 
 	ret_val = misc_register(&sep->miscdev_sep);
 	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for sep %x\n",
+		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
 			ret_val);
 		return ret_val;
 	}
@@ -3611,7 +3606,7 @@ static int __init sep_init(void)
 	int ret_val = 0;
 	struct sep_device *sep = NULL;
 
-	pr_debug("Sep driver: Init start\n");
+	pr_debug("SEP driver: Init start\n");
 
 	ret_val = pci_register_driver(&sep_pci_driver);
 	if (ret_val) {
@@ -3628,14 +3623,14 @@ static int __init sep_init(void)
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
 
-	/* new chip requires share area reconfigure */
-	if (sep->pdev->revision == 4) { /* only for new chip */
+	/* The new chip requires ashared area reconfigure */
+	if (sep->pdev->revision == 4) { /* Only for new chip */
 		ret_val = sep_reconfig_shared_area(sep);
 		if (ret_val)
 			goto end_function_unregister_pci;
 	}
 
-	/* register driver to fs */
+	/* Register driver to fs */
 	ret_val = sep_register_driver_to_fs(sep);
 	if (ret_val) {
 		dev_warn(&sep->pdev->dev, "error registering device to file\n");
@@ -3665,18 +3660,18 @@ static void __exit sep_exit(void)
 	sep = sep_dev;
 	pr_debug("Exit start\n");
 
-	/* unregister from fs */
+	/* Unregister from fs */
 	misc_deregister(&sep->miscdev_sep);
 	misc_deregister(&sep->miscdev_singleton);
 	misc_deregister(&sep->miscdev_daemon);
 
-	/* free the irq */
+	/* Free the irq */
 	free_irq(sep->pdev->irq, sep);
 
-	/* unregister the driver */
+	/* Unregister the driver */
 	pci_unregister_driver(&sep_pci_driver);
 
-	/* free shared area  */
+	/* Free the shared area  */
 	if (sep_dev) {
 		sep_unmap_and_free_shared_area(sep_dev);
 		dev_dbg(&sep->pdev->dev,

