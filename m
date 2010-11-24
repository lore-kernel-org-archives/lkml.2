Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0KXTzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:55:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48637 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281Ab0KXTzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:55:08 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/12] sep: Fix the kernel-doc in SEP
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:34:52 +0000
Message-ID: <20101124193435.16425.42376.stgit@bob.linux.org.uk>
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

The long blurb goes at the end

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |  322 ++++++++++++++++++++++----------------
 1 files changed, 188 insertions(+), 134 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index c98cb9b..4a0bb43 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -78,9 +78,10 @@ static struct sep_device *sep_dev;
 
 /**
  *	sep_load_firmware - copy firmware cache/resident
+ *	@sep: pointer to struct sep_device we are loading
+ *
  *	This functions copies the cache and resident from their source
  *	location into destination shared memory.
- *	@sep: pointer to struct sep_device
  */
 
 static int sep_load_firmware(struct sep_device *sep)
@@ -228,10 +229,11 @@ static void sep_unmap_and_free_shared_area(struct sep_device *sep)
 
 /**
  *	sep_shared_bus_to_virt - convert bus/virt addresses
- *	Returns virtual address inside the shared area according
- *	to the bus address.
  *	@sep: pointer to struct sep_device
  *	@bus_address: address to convert
+ *
+ *	Returns virtual address inside the shared area according
+ *	to the bus address.
  */
 
 static void *sep_shared_bus_to_virt(struct sep_device *sep,
@@ -244,6 +246,8 @@ static void *sep_shared_bus_to_virt(struct sep_device *sep,
  *	open function for the singleton driver
  *	@inode_ptr struct inode *
  *	@file_ptr struct file *
+ *
+ *	Called when the user opens the singleton device interface
  */
 
 static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
@@ -252,8 +256,8 @@ static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 
 	struct sep_device *sep;
 
-	/**
-	 * get the sep device structure and use it for the
+	/*
+	 * Get the sep device structure and use it for the
 	 * private_data field in filp for other methods
 	 */
 	sep = sep_dev;
@@ -282,8 +286,7 @@ end_function:
  *	@filp: file handle to sep device
  *
  *	Open method for the SEP device. Called when userspace opens
- *	the SEP device node. Must also release the memory data pool
- *	allocations.
+ *	the SEP device node. 
  *
  *	Returns zero on success otherwise an error code.
  */
@@ -292,8 +295,8 @@ static int sep_open(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep;
 
-	/**
-	 * get the sep device structure and use it for the
+	/*
+	 * Get the sep device structure and use it for the
 	 * private_data field in filp for other methods
 	 */
 	sep = sep_dev;
@@ -301,7 +304,7 @@ static int sep_open(struct inode *inode, struct file *filp)
 
 	dev_dbg(&sep->pdev->dev, "Open for pid %d\n", current->pid);
 
-	/* anyone can open; locking takes place at transaction level */
+	/* Anyone can open; locking takes place at transaction level */
 	return 0;
 }
 
@@ -333,8 +336,7 @@ static int sep_singleton_release(struct inode *inode, struct file *filp)
  *	@filp: file handle to sep device
  *
  *	Open method for the SEP request daemon. Called when
- *	request daemon in userspace opens
- *	the SEP device node.
+ *	request daemon in userspace opens the SEP device node.
  *
  *	Returns zero on success otherwise an error code.
  */
@@ -385,9 +387,11 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 }
 
 /**
+ *	sep_req_daemon_send_reply_command_handler - poke the SEP
+ *	@sep: struct sep_device *
+ *
  *	This function raises interrupt to SEPm that signals that is has a
  *	new command from HOST
- *	@sep: struct sep_device *
  */
 static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 {
@@ -427,9 +431,10 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 
 
 /**
- *	sep_free_dma_table_data_handler - handles the request
- *	for freeing dma table for synhronic actions
+ *	sep_free_dma_table_data_handler - free DMA table
  *	@sep: pointere to struct sep_device
+ *
+ *	Handles the request to  free dma table for synchronic actions
  */
 
 static int sep_free_dma_table_data_handler(struct sep_device *sep)
@@ -531,10 +536,12 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 
 
 /**
- *	sep_request_daemon_mmap - maps the
- *	shared area to user space
+ *	sep_request_daemon_mmap - maps the shared area to user space
  *	@filp: pointer to struct file
  *	@vma: pointer to vm_area_struct
+ *
+ *	Called by the kernel when the daemon attempts an mmap() syscall
+ *	using our handle.
  */
 static int sep_request_daemon_mmap(struct file  *filp,
 	struct vm_area_struct  *vma)
@@ -577,10 +584,12 @@ end_function:
 }
 
 /**
- *	sep_request_daemon_poll -
+ *	sep_request_daemon_poll - poll implementation
  *	@sep: struct sep_device * for current sep device
  *	@filp: struct file * for open file
  *	@wait: poll_table * for poll
+ *
+ *	Called when our device is part of a poll() or select() syscall
  */
 static unsigned int sep_request_daemon_poll(struct file *filp,
 	poll_table  *wait)
@@ -689,6 +698,8 @@ static int sep_release(struct inode *inode, struct file *filp)
  *	sep_mmap -  maps the shared area to user space
  *	@filp: pointer to struct file
  *	@vma: pointer to vm_area_struct
+ *
+ *	Called on an mmap of our space via the normal sep device
  */
 static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 {
@@ -776,9 +787,12 @@ end_function:
 }
 
 /**
- *	sep_poll -
+ *	sep_poll - poll handler
  *	@filp: pointer to struct file
  *	@wait: pointer to poll_table
+ *
+ *	Called by the OS when the kernel is asked to do a poll on
+ *	a SEP file handle.
  */
 static unsigned int sep_poll(struct file *filp, poll_table *wait)
 {
@@ -792,7 +806,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 
 	dev_dbg(&sep->pdev->dev, "poll: start\n");
 
-	/* am I the process that own the transaction? */
+	/* Am I the process that owns the transaction? */
 	mutex_lock(&sep->sep_mutex);
 	if (current->pid != sep->pid_doing_transaction) {
 		dev_warn(&sep->pdev->dev, "poll; wrong pid\n");
@@ -934,10 +948,12 @@ static unsigned long sep_set_time(struct sep_device *sep)
 }
 
 /**
- *	sep_set_caller_id_handler - inserts the data into the caller id table
- *      note that this function does fall under the ioctl lock
+ *	sep_set_caller_id_handler - insert caller id entry
  *	@sep: sep device
  *	@arg: pointer to struct caller_id_struct
+ *
+ *	Inserts the data into the caller id table. Note that this function
+ *	falls under the ioctl lock
  */
 static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 {
@@ -1003,9 +1019,11 @@ end_function:
 }
 
 /**
- *	sep_set_current_caller_id - set the caller id (if exists) to the sep
- *      note that this function does fall under the ioctl lock
+ *	sep_set_current_caller_id - set the caller id
  *	@sep: pointer to struct_sep
+ *
+ *	Set the caller ID (if it exists) to the sep. Note that this
+ *	function falls under the ioctl lock
  */
 static int sep_set_current_caller_id(struct sep_device *sep)
 {
@@ -1040,10 +1058,12 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 
 /**
  *	sep_send_command_handler - kick off a command
- *      note that this function does fall under the ioctl lock
+ *	@sep: sep being signalled
+ *
  *	This function raises interrupt to SEP that signals that is has a new
  *	command from the host
- *	@sep: sep being signalled
+ *
+ *      Note that this function does fall under the ioctl lock
  */
 
 static int sep_send_command_handler(struct sep_device *sep)
@@ -1085,14 +1105,15 @@ end_function:
 }
 
 /**
- *	sep_allocate_data_pool_memory_handler -
+ *	sep_allocate_data_pool_memory_handler -allocate pool memory
+ *	@sep: pointer to struct_sep
+ *	@arg: pointer to struct alloc_struct
+ *
  *	This function handles the allocate data pool memory request
  *	This function returns calculates the bus address of the
  *	allocated memory, and the offset of this area from the mapped address.
  *	Therefore, the FVOs in user space can calculate the exact virtual
  *	address of this allocated memory
- *	@sep: pointer to struct_sep
- *	@arg: pointer to struct alloc_struct
  */
 static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	unsigned long arg)
@@ -1100,7 +1121,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	int error = 0;
 	struct alloc_struct command_args;
 
-	/* holds the allocated buffer address in the system memory pool */
+	/* Holds the allocated buffer address in the system memory pool */
 	u32 *token_addr;
 
 	dev_dbg(&sep->pdev->dev,
@@ -1112,7 +1133,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		goto end_function;
 	}
 
-	/* allocate memory */
+	/* Allocate memory */
 	if ((sep->data_pool_bytes_allocated + command_args.num_bytes) >
 		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
 		error = -ENOMEM;
@@ -1123,14 +1144,14 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		"bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
 	dev_dbg(&sep->pdev->dev,
 		"offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
-	/* set the virtual and bus address */
+	/* Set the virtual and bus address */
 	command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
 		sep->data_pool_bytes_allocated;
 
 	dev_dbg(&sep->pdev->dev,
 		"command_args.offset: %x\n", command_args.offset);
 
-	/* place in the shared area that is known by the sep */
+	/* Place in the shared area that is known by the sep */
 	token_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
 		(sep->num_of_data_allocations)*2*sizeof(u32));
@@ -1148,7 +1169,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "data pool token [0] %x\n", token_addr[0]);
 	dev_dbg(&sep->pdev->dev, "data pool token [1] %x\n", token_addr[1]);
 
-	/* write the memory back to the user space */
+	/* Write the memory back to the user space */
 	error = copy_to_user((void *)arg, (void *)&command_args,
 		sizeof(struct alloc_struct));
 	if (error) {
@@ -1175,17 +1196,18 @@ end_function:
 }
 
 /**
- *	sep_lock_kernel_pages -
- *	This function locks all the physical pages of the kernel virtual buffer
- *	and construct a basic lli  array, where each entry holds the physical
- *	page address and the size that application data holds in this page
- *	This function is used only during kernel crypto mod calls from within
- *	the kernel (when ioctl is not used)
+ *	sep_lock_kernel_pages - map kernel pages for DMA
  *	@sep: pointer to struct sep_device
  *	@kernel_virt_addr: address of data buffer in kernel
  *	@data_size: size of data
  *	@lli_array_ptr: lli array
  *	@in_out_flag: input into device or output from device
+ *
+ *	This function locks all the physical pages of the kernel virtual buffer
+ *	and construct a basic lli  array, where each entry holds the physical
+ *	page address and the size that application data holds in this page
+ *	This function is used only during kernel crypto mod calls from within
+ *	the kernel (when ioctl is not used)
  */
 static int sep_lock_kernel_pages(struct sep_device *sep,
 	u32 kernel_virt_addr,
@@ -1273,16 +1295,17 @@ end_function:
 }
 
 /**
- *	sep_lock_user_pages -
- *	This function locks all the physical pages of the application
- *	virtual buffer and construct a basic lli  array, where each entry
- *	holds the physical page address and the size that application
- *	data holds in this physical pages
+ *	sep_lock_user_pages - lock and map user pages for DMA
  *	@sep: pointer to struct sep_device
  *	@app_virt_addr: user memory data buffer
  *	@data_size: size of data buffer
  *	@lli_array_ptr: lli array
  *	@in_out_flag: input or output to device
+ *
+ *	This function locks all the physical pages of the application
+ *	virtual buffer and construct a basic lli  array, where each entry
+ *	holds the physical page address and the size that application
+ *	data holds in this physical pages
  */
 static int sep_lock_user_pages(struct sep_device *sep,
 	u32 app_virt_addr,
@@ -1505,17 +1528,16 @@ end_function:
 }
 
 /**
- *	u32 sep_calculate_lli_table_max_size -
- *	this function calculates the size of data
- *	that can be inserted into the lli
- *	table from this array the condition is that
- *	either the table is full
- *	(all etnries are entered), or there are no more
- *	entries in the lli array
+ *	u32 sep_calculate_lli_table_max_size - size the LLI table
  *	@sep: pointer to struct sep_device
  *	@lli_in_array_ptr
  *	@num_array_entries
  *	@last_table_flag
+ *
+ *	This function calculates the size of data that can be inserted into
+ *	the lli table from this array, such that either the table is full
+ *	(all entries are entered), or there are no more entries in the
+ *	lli array
  */
 static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	struct sep_lli_entry *lli_in_array_ptr,
@@ -1590,15 +1612,16 @@ end_function:
 }
 
 /**
- *	sep_build_lli_table -
- *	this functions builds ont lli table from the lli_array according to
- *	the given size of data
+ *	sep_build_lli_table - build an lli array for the given table
  *	@sep: pointer to struct sep_device
  *	@lli_array_ptr: pointer to lli array
  *	@lli_table_ptr: pointer to lli table
  *	@num_processed_entries_ptr: pointer to number of entries
  *	@num_table_entries_ptr: pointer to number of tables
  *	@table_data_size: total data size
+ *
+ *	Builds ant lli table from the lli_array according to
+ *	the given size of data
  */
 static void sep_build_lli_table(struct sep_device *sep,
 	struct sep_lli_entry	*lli_array_ptr,
@@ -1707,13 +1730,14 @@ static void sep_build_lli_table(struct sep_device *sep,
 }
 
 /**
- *	sep_shared_area_virt_to_bus -
+ *	sep_shared_area_virt_to_bus - map shared area to bus address
+ *	@sep: pointer to struct sep_device
+ *	@virt_address: virtual address to convert
+ *
  *	This functions returns the physical address inside shared area according
  *	to the virtual address. It can be either on the externa RAM device
  *	(ioremapped), or on the system RAM
  *	This implementation is for the external RAM
- *	@sep: pointer to struct sep_device
- *	@virt_address: virtual address to convert
  */
 static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 	void *virt_address)
@@ -1731,13 +1755,14 @@ static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 }
 
 /**
- *	sep_shared_area_bus_to_virt -
+ *	sep_shared_area_bus_to_virt - map shared area bus address to kernel
+ *	@sep: pointer to struct sep_device
+ *	@bus_address: bus address to convert
+ *
  *	This functions returns the virtual address inside shared area
  *	according to the physical address. It can be either on the
  *	externa RAM device (ioremapped), or on the system RAM
  *	This implementation is for the external RAM
- *	@sep: pointer to struct sep_device
- *	@bus_address: bus address to convert
  */
 
 static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
@@ -1754,13 +1779,13 @@ static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
 }
 
 /**
- *	sep_debug_print_lli_tables -
- *	this function goes over the list of the print created tables and
- *	prints all the data
+ *	sep_debug_print_lli_tables - dump LLI table
  *	@sep: pointer to struct sep_device
  *	@lli_table_ptr: pointer to sep_lli_entry
  *	@num_table_entries: number of entries
  *	@table_data_size: total data size
+ *
+ *	Walk the the list of the print created tables and print all the data
  */
 static void sep_debug_print_lli_tables(struct sep_device *sep,
 	struct sep_lli_entry *lli_table_ptr,
@@ -1831,12 +1856,14 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 
 
 /**
- *	sep_prepare_empty_lli_table -
- *	This function creates empty lli tables when there is no data
+ *	sep_prepare_empty_lli_table - create a blank LLI table
  *	@sep: pointer to struct sep_device
  *	@lli_table_addr_ptr: pointer to lli table
  *	@num_entries_ptr: pointer to number of entries
  *	@table_data_size_ptr: point to table data size
+ *
+ *	This function creates empty lli tables when there is no data
+
  */
 static void sep_prepare_empty_lli_table(struct sep_device *sep,
 		dma_addr_t *lli_table_addr_ptr,
@@ -1881,11 +1908,7 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 }
 
 /**
- *	sep_prepare_input_dma_table -
- *	This function prepares only input DMA table for synhronic symmetric
- *	operations (HASH)
- *	Note that all bus addresses that are passed to the sep
- *	are in 32 bit format; the SEP is a 32 bit device
+ *	sep_prepare_input_dma_table - prepare input DMA mappings
  *	@sep: pointer to struct sep_device
  *	@data_size:
  *	@block_size:
@@ -1893,6 +1916,11 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
  *	@num_entries_ptr:
  *	@table_data_size_ptr:
  *	@is_kva: set for kernel data (kernel cryptio call)
+ *
+ *	This function prepares only input DMA table for synhronic symmetric
+ *	operations (HASH)
+ *	Note that all bus addresses that are passed to the sep
+ *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_dma_table(struct sep_device *sep,
 	unsigned long app_virt_addr,
@@ -2099,12 +2127,7 @@ end_function:
 
 }
 /**
- *	sep_construct_dma_tables_from_lli -
- *	This function creates the input and output dma tables for
- *	symmetric operations (AES/DES) according to the block
- *	size from LLI arays
- *	Note that all bus addresses that are passed to the sep
- *	are in 32 bit format; the SEP is a 32 bit device
+ *	sep_construct_dma_tables_from_lli - prepare AES/DES mappings
  *	@sep: pointer to struct_sep
  *	@lli_in_array:
  *	@sep_in_lli_entries:
@@ -2116,6 +2139,12 @@ end_function:
  *	@in_num_entries_ptr
  *	@out_num_entries_ptr
  *	@table_data_size_ptr
+ *
+ *	This function creates the input and output dma tables for
+ *	symmetric operations (AES/DES) according to the block
+ *	size from LLI arays
+ *	Note that all bus addresses that are passed to the sep
+ *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_construct_dma_tables_from_lli(
 	struct sep_device *sep,
@@ -2358,12 +2387,7 @@ static int sep_construct_dma_tables_from_lli(
 }
 
 /**
- *	sep_prepare_input_output_dma_table -
- *	This function builds input and output DMA tables for synhronic
- *	symmetric operations (AES, DES, HASH). It also checks that each table
- *	is of the modular block size
- *	Note that all bus addresses that are passed to the sep
- *	are in 32 bit format; the SEP is a 32 bit device
+ *	sep_prepare_input_output_dma_table - prepare DMA I/O table
  *	@app_virt_in_addr:
  *	@app_virt_out_addr:
  *	@data_size:
@@ -2374,6 +2398,12 @@ static int sep_construct_dma_tables_from_lli(
  *	@out_num_entries_ptr:
  *	@table_data_size_ptr:
  *	@is_kva: set for kernel data; used only for kernel crypto module
+ *
+ *	This function builds input and output DMA tables for synhronic
+ *	symmetric operations (AES, DES, HASH). It also checks that each table
+ *	is of the modular block size
+ *	Note that all bus addresses that are passed to the sep
+ *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	unsigned long app_virt_in_addr,
@@ -2522,12 +2552,7 @@ end_function:
 }
 
 /**
- *	sep_prepare_input_output_dma_table_in_dcb -
- *	This function prepares the linked dma tables and puts the
- *	address for the linked list of tables inta a dcb (data control
- *	block) the address of which is known by the sep hardware
- *	Note that all bus addresses that are passed to the sep
- *	are in 32 bit format; the SEP is a 32 bit device
+ *	sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
  *	@app_in_address: unsigned long; for data buffer in (user space)
  *	@app_out_address: unsigned long; for data buffer out (user space)
  *	@data_in_size: u32; for size of data
@@ -2535,6 +2560,12 @@ end_function:
  *	@tail_block_size: u32; for size of tail block
  *	@isapplet: bool; to indicate external app
  *	@is_kva: bool; kernel buffer; only used for kernel crypto module
+ *
+ *	This function prepares the linked dma tables and puts the
+ *	address for the linked list of tables inta a dcb (data control
+ *	block) the address of which is known by the sep hardware
+ *	Note that all bus addresses that are passed to the sep
+ *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	u32  app_in_address,
@@ -2737,14 +2768,14 @@ end_function:
 
 
 /**
- *	sep_create_sync_dma_tables_handler -
- *	this function handles tha request for creation of the DMA table
- *	for the synchronic symmetric operations (AES,DES)
- *	Note that all bus addresses that are passed to the sep
- *	are in 32 bit format; the SEP is a 32 bit device
+ *	sep_create_sync_dma_tables_handler - create sync dma tables
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to struct bld_syn_tab_struct
-*/
+ *
+ *	Handle the request for creation of the DMA tables for the synchronic
+ *	symmetric operations (AES,DES). Note that all bus addresses that are
+ *	passed to the SEP are in 32 bit format; the SEP is a 32 bit device
+ */
 static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 						unsigned long arg)
 {
@@ -2799,11 +2830,12 @@ end_function:
 }
 
 /**
- *	sep_free_dma_tables_and_dcb -
- *	This function frees the dma tables and dcb block
+ *	sep_free_dma_tables_and_dcb - free DMA tables and DCBs
  *	@sep: pointer to struct sep_device
  *	@isapplet: indicates external application (used for kernel access)
  *	@is_kva: indicates kernel addresses (only used for kernel crypto)
+ *
+ *	This function frees the dma tables and dcb block
  */
 static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	bool is_kva)
@@ -2858,11 +2890,12 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 }
 
 /**
- *	sep_get_static_pool_addr_handler -
- *	this function sets the bus and virtual addresses of the static pool
- *	and returns the virtual address
+ *	sep_get_static_pool_addr_handler - get static pool address
  *	@sep: pointer to struct sep_device
  *	@arg: parameters from user space application
+ *
+ *	This function sets the bus and virtual addresses of the static pool
+ *	and returns the virtual address
  */
 static int sep_get_static_pool_addr_handler(struct sep_device *sep,
 	unsigned long arg)
@@ -2901,8 +2934,7 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep,
 }
 
 /**
- *	sep_start_handler -
- *	This function starts the sep device
+ *	sep_start_handler - start device
  *	@sep: pointer to struct sep_device
  */
 static int sep_start_handler(struct sep_device *sep)
@@ -2926,11 +2958,12 @@ static int sep_start_handler(struct sep_device *sep)
 }
 
 /**
- *	ep_check_sum_calc -
- *	This function performs a checsum for messages that are sent
+ *	ep_check_sum_calc - checksum messages
+ *	@data: buffer to checksum
+ *	@length: buffer size
+ *
+ *	This function performs a checksum for messages that are sent
  *	to the sep
- *	@data:
- *	@length:
  */
 static u32 sep_check_sum_calc(u8 *data, u32 length)
 {
@@ -2956,17 +2989,18 @@ static u32 sep_check_sum_calc(u8 *data, u32 length)
 
 /**
  *	sep_init_handler -
- *	this function handles the request for SEP initialization
+ *	@sep: pointer to struct sep_device
+ *	@arg: parameters from user space application
+ *
+ *	Handles the request for SEP initialization
  *	Note that this will go away for Medfield once the SCU
  *	SEP initialization is complete
  *	Also note that the message to the sep has components
  *	from user space as well as components written by the driver
- *	This is becuase the portions of the message that partain to
+ *	This is becuase the portions of the message that pertain to
  *	physical addresses must be set by the driver after the message
  *	leaves custody of the user space application for security
  *	reasons.
- *	@sep: pointer to struct sep_device
- *	@arg: parameters from user space application
  */
 static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 {
@@ -3127,9 +3161,10 @@ end_function:
 }
 
 /**
- *	sep_end_transaction_handler -
- *	This API handles the end transaction request
+ *	sep_end_transaction_handler - end transaction
  *	@sep: pointer to struct sep_device
+ *
+ *	This API handles the end transaction request
  */
 static int sep_end_transaction_handler(struct sep_device *sep)
 {
@@ -3163,11 +3198,12 @@ static int sep_end_transaction_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_prepare_dcb_handler -
- *	This function will retrieve the RAR buffer physical addresses, type
- *	& size corresponding to the RAR handles provided in the buffers vector.
+ *	sep_prepare_dcb_handler - prepare a control block 
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
+ *
+ *	This function will retrieve the RAR buffer physical addresses, type
+ *	& size corresponding to the RAR handles provided in the buffers vector.
  */
 
 static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
@@ -3211,10 +3247,11 @@ end_function:
 }
 
 /**
- *	sep_free_dcb_handler -
- *	this function frees the DCB resources
- *	and updates the needed user-space buffers
+ *	sep_free_dcb_handler - free control block resources
  *	@sep: pointer to struct sep_device
+ *
+ *	This function frees the DCB resources and updates the needed
+ *	user-space buffers.
  */
 static int sep_free_dcb_handler(struct sep_device *sep)
 {
@@ -3230,11 +3267,12 @@ static int sep_free_dcb_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_rar_prepare_output_msg_handler -
- *	This function will retrieve the RAR buffer physical addresses, type
- *	& size corresponding to the RAR handles provided in the buffers vector.
+ *	sep_rar_prepare_output_msg_handler - prepare an output message 
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
+ *
+ *	This function will retrieve the RAR buffer physical addresses, type
+ *	& size corresponding to the RAR handles provided in the buffers vector.
  */
 
 static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
@@ -3300,10 +3338,11 @@ end_function:
 }
 
 /**
- *	sep_realloc_ext_cache_handler -
- *	This function tells the sep where the extapp is located
+ *	sep_realloc_ext_cache_handler - report location of extcache
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
+ *
+ *	This function tells the sep where the extapp is located
  */
 static int sep_realloc_ext_cache_handler(struct sep_device *sep,
 	unsigned long arg)
@@ -3332,6 +3371,8 @@ static int sep_realloc_ext_cache_handler(struct sep_device *sep,
  *	@filp: pointer to struct file
  *	@cmd: command
  *	@arg: pointer to argument structure
+ *
+ *	Implement the ioctl methods availble on the SEP device.
  */
 static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
@@ -3462,6 +3503,8 @@ end_function:
  *	@filp: pointer to struct file
  *	@cmd: command
  *	@arg: pointer to argument structure
+ *
+ *	Implement the additional ioctls for the singleton device
  */
 static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 {
@@ -3522,6 +3565,7 @@ end_function:
  *	@filp: pointer to struct file
  *	@cmd: command
  *	@arg: pointer to argument structure
+ *
  *	Called by the request daemon to perform ioctls on the daemon device
  */
 
@@ -3643,10 +3687,11 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 }
 
 /**
- *	sep_callback -
+ *	sep_callback - RAR callback
+ *	@sep_context_pointer: pointer to struct sep_device
+ *
  *	Function that is called by rar_register when it is ready with
  *	a region (only for Moorestown)
- *	@sep_context_pointer: pointer to struct sep_device
  */
 static int sep_callback(unsigned long sep_context_pointer)
 {
@@ -3696,10 +3741,12 @@ end_function:
 }
 
 /**
- *	sep_probe -
- *	Function that is activated on the successful probe of the SEP device
+ *	sep_probe - probe a matching PCI device
  *	@pdev: pci_device
  *	@end: pci_device_id
+ *
+ *	Attempt to set up and configure a SEP device that has been
+ *	discovered by the PCI layer.
  */
 static int __devinit sep_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
@@ -3904,10 +3951,11 @@ static const struct file_operations sep_file_operations = {
 };
 
 /**
- *	sep_reconfig_shared_area -
- *	reconfig the shared area between HOST and SEP - needed in case
- *	the DX_CC_Init function was called before OS loading
+ *	sep_reconfig_shared_area - reconfigure shared area
  *	@sep: pointer to struct sep_device
+ *
+ *	Reconfig the shared area between HOST and SEP - needed in case
+ *	the DX_CC_Init function was called before OS loading.
  */
 static int sep_reconfig_shared_area(struct sep_device *sep)
 {
@@ -3948,9 +3996,10 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 }
 
 /**
- *	sep_register_driver_to_fs -
- *	This function registers the driver to the file system
+ *	sep_register_driver_to_fs - register misc devices
  *	@sep: pointer to struct sep_device
+ *
+ *	This function registers the driver to the file system
  */
 static int sep_register_driver_to_fs(struct sep_device *sep)
 {
@@ -4000,7 +4049,9 @@ static int sep_register_driver_to_fs(struct sep_device *sep)
 }
 
 /**
- *	sep_init - init function; this is the first thing called on boot
+ *	sep_init - init function
+ *
+ *	Module load time. Register the PCI device driver.
  */
 static int __init sep_init(void)
 {
@@ -4051,7 +4102,10 @@ end_function:
 
 
 /**
- *	sep_exit - called to unload driver (never called on static compile)
+ *	sep_exit - called to unload driver 
+ *
+ *	Drop the misc devices then remove and unmap the various resources
+ *	that are not released by the driver remove method.
  */
 static void __exit sep_exit(void)
 {

