Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0JEU37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:29:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40281 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0JEU3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:29:21 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 11/11] staging: tidspbridge - remove dmm custom module
Date: Tue,  5 Oct 2010 15:35:44 -0500
Message-Id: <1286310944-25035-12-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286310944-25035-11-git-send-email-x0095840@ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <1286310944-25035-2-git-send-email-x0095840@ti.com>
 <1286310944-25035-3-git-send-email-x0095840@ti.com>
 <1286310944-25035-4-git-send-email-x0095840@ti.com>
 <1286310944-25035-5-git-send-email-x0095840@ti.com>
 <1286310944-25035-6-git-send-email-x0095840@ti.com>
 <1286310944-25035-7-git-send-email-x0095840@ti.com>
 <1286310944-25035-8-git-send-email-x0095840@ti.com>
 <1286310944-25035-9-git-send-email-x0095840@ti.com>
 <1286310944-25035-10-git-send-email-x0095840@ti.com>
 <1286310944-25035-11-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmm custom module is not needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    1 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 ---
 .../staging/tidspbridge/include/dspbridge/drv.h    |    6 -
 drivers/staging/tidspbridge/pmgr/dev.c             |   61 +---
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 --------------------
 drivers/staging/tidspbridge/rmgr/node.c            |   28 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   23 -
 9 files changed, 6 insertions(+), 747 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index bd36651..7c122fa 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -5,7 +5,7 @@ libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o core/dsp-mmu.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
-		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
+		pmgr/cmm.o pmgr/dbll.o
 librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 		rmgr/proc.o rmgr/pwr.o rmgr/rmm.o rmgr/strm.o rmgr/dspdrv.o \
 		rmgr/nldr.o rmgr/drv_interface.o
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index a95ff2f..f22bc12 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -47,7 +47,6 @@
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/dev.h>
 #include <dspbridge/dspapi.h>
-#include <dspbridge/dmm.h>
 #include <dspbridge/wdt.h>
 
 /*  ----------------------------------- Local */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index 357458f..9bdd48f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -27,7 +27,6 @@
 #include <dspbridge/nodedefs.h>
 #include <dspbridge/dispdefs.h>
 #include <dspbridge/dspdefs.h>
-#include <dspbridge/dmm.h>
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- This */
@@ -234,29 +233,6 @@ extern int dev_get_cmm_mgr(struct dev_object *hdev_obj,
 				  struct cmm_object **mgr);
 
 /*
- *  ======== dev_get_dmm_mgr ========
- *  Purpose:
- *      Retrieve the handle to the dynamic memory manager created for this
- *      device.
- *  Parameters:
- *      hdev_obj:     Handle to device object created with
- *                      dev_create_device().
- *      *mgr:           Ptr to location to store handle.
- *  Returns:
- *      0:        Success.
- *      -EFAULT:    Invalid hdev_obj.
- *  Requires:
- *      mgr != NULL.
- *      DEV Initialized.
- *  Ensures:
- *      0:        *mgr contains a handle to a channel manager object,
- *                      or NULL.
- *      else:           *mgr is NULL.
- */
-extern int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-				  struct dmm_object **mgr);
-
-/*
  *  ======== dev_get_cod_mgr ========
  *  Purpose:
  *      Retrieve the COD manager create for this device.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dmm.h b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
deleted file mode 100644
index 6c58335..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/dmm.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * dmm.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * The Dynamic Memory Mapping(DMM) module manages the DSP Virtual address
- * space that can be directly mapped to any MPU buffer or memory region.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef DMM_
-#define DMM_
-
-#include <dspbridge/dbdefs.h>
-
-struct dmm_object;
-
-/* DMM attributes used in dmm_create() */
-struct dmm_mgrattrs {
-	u32 reserved;
-};
-
-#define DMMPOOLSIZE      0x4000000
-
-/*
- *  ======== dmm_get_handle ========
- *  Purpose:
- *      Return the dynamic memory manager object for this device.
- *      This is typically called from the client process.
- */
-
-extern int dmm_get_handle(void *hprocessor,
-				 struct dmm_object **dmm_manager);
-
-extern int dmm_reserve_memory(struct dmm_object *dmm_mgr,
-				     u32 size, u32 *prsv_addr);
-
-extern int dmm_un_reserve_memory(struct dmm_object *dmm_mgr,
-					u32 rsv_addr);
-
-extern int dmm_map_memory(struct dmm_object *dmm_mgr, u32 addr,
-				 u32 size);
-
-extern int dmm_un_map_memory(struct dmm_object *dmm_mgr,
-				    u32 addr, u32 *psize);
-
-extern int dmm_destroy(struct dmm_object *dmm_mgr);
-
-extern int dmm_delete_tables(struct dmm_object *dmm_mgr);
-
-extern int dmm_create(struct dmm_object **dmm_manager,
-			     struct dev_object *hdev_obj,
-			     const struct dmm_mgrattrs *mgr_attrts);
-
-extern bool dmm_init(void);
-
-extern void dmm_exit(void);
-
-extern int dmm_create_tables(struct dmm_object *dmm_mgr,
-				    u32 addr, u32 size);
-
-#ifdef DSP_DMM_DEBUG
-u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr);
-#endif
-
-#endif /* DMM_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index 427f38b..75a2c9b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -108,12 +108,6 @@ struct dmm_map_object {
 	struct bridge_dma_map_info dma_info;
 };
 
-/* Used for DMM reserved memory accounting */
-struct dmm_rsv_object {
-	struct list_head link;
-	u32 dsp_reserved_addr;
-};
-
 /* New structure (member of process context) abstracts DMM resource info */
 struct dspheap_res_object {
 	s32 heap_allocated;	/* DMM status */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index e3c78fb..7b30267 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -34,7 +34,6 @@
 #include <dspbridge/cod.h>
 #include <dspbridge/drv.h>
 #include <dspbridge/proc.h>
-#include <dspbridge/dmm.h>
 
 /*  ----------------------------------- Resource Manager */
 #include <dspbridge/mgr.h>
@@ -75,7 +74,6 @@ struct dev_object {
 	struct msg_mgr *hmsg_mgr;	/* Message manager. */
 	struct io_mgr *hio_mgr;	/* IO manager (CHNL, msg_ctrl) */
 	struct cmm_object *hcmm_mgr;	/* SM memory manager. */
-	struct dmm_object *dmm_mgr;	/* Dynamic memory manager. */
 	struct ldr_module *module_obj;	/* Bridge Module handle. */
 	u32 word_size;		/* DSP word size: quick access. */
 	struct drv_object *hdrv_obj;	/* Driver Object */
@@ -250,9 +248,6 @@ int dev_create_device(struct dev_object **device_obj,
 			/* Instantiate the DEH module */
 			status = bridge_deh_create(&dev_obj->hdeh_mgr, dev_obj);
 		}
-		/* Create DMM mgr . */
-		status = dmm_create(&dev_obj->dmm_mgr,
-				    (struct dev_object *)dev_obj, NULL);
 	}
 	/* Add the new DEV_Object to the global list: */
 	if (!status) {
@@ -278,8 +273,6 @@ leave:
 			kfree(dev_obj->proc_list);
 			if (dev_obj->cod_mgr)
 				cod_delete(dev_obj->cod_mgr);
-			if (dev_obj->dmm_mgr)
-				dmm_destroy(dev_obj->dmm_mgr);
 			kfree(dev_obj);
 		}
 
@@ -389,11 +382,6 @@ int dev_destroy_device(struct dev_object *hdev_obj)
 			dev_obj->hcmm_mgr = NULL;
 		}
 
-		if (dev_obj->dmm_mgr) {
-			dmm_destroy(dev_obj->dmm_mgr);
-			dev_obj->dmm_mgr = NULL;
-		}
-
 		/* Call the driver's bridge_dev_destroy() function: */
 		/* Require of DevDestroy */
 		if (dev_obj->hbridge_context) {
@@ -474,32 +462,6 @@ int dev_get_cmm_mgr(struct dev_object *hdev_obj,
 }
 
 /*
- *  ======== dev_get_dmm_mgr ========
- *  Purpose:
- *      Retrieve the handle to the dynamic memory manager created for this
- *      device.
- */
-int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-			   struct dmm_object **mgr)
-{
-	int status = 0;
-	struct dev_object *dev_obj = hdev_obj;
-
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(mgr != NULL);
-
-	if (hdev_obj) {
-		*mgr = dev_obj->dmm_mgr;
-	} else {
-		*mgr = NULL;
-		status = -EFAULT;
-	}
-
-	DBC_ENSURE(!status || (mgr != NULL && *mgr == NULL));
-	return status;
-}
-
-/*
  *  ======== dev_get_cod_mgr ========
  *  Purpose:
  *      Retrieve the COD manager create for this device.
@@ -751,10 +713,8 @@ void dev_exit(void)
 
 	refs--;
 
-	if (refs == 0) {
+	if (refs == 0)
 		cmm_exit();
-		dmm_exit();
-	}
 
 	DBC_ENSURE(refs >= 0);
 }
@@ -766,25 +726,12 @@ void dev_exit(void)
  */
 bool dev_init(void)
 {
-	bool cmm_ret, dmm_ret, ret = true;
+	bool ret = true;
 
 	DBC_REQUIRE(refs >= 0);
 
-	if (refs == 0) {
-		cmm_ret = cmm_init();
-		dmm_ret = dmm_init();
-
-		ret = cmm_ret && dmm_ret;
-
-		if (!ret) {
-			if (cmm_ret)
-				cmm_exit();
-
-			if (dmm_ret)
-				dmm_exit();
-
-		}
-	}
+	if (refs == 0)
+		ret = cmm_init();
 
 	if (ret)
 		refs++;
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
deleted file mode 100644
index 8685233..0000000
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ /dev/null
@@ -1,533 +0,0 @@
-/*
- * dmm.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * The Dynamic Memory Manager (DMM) module manages the DSP Virtual address
- * space that can be directly mapped to any MPU buffer or memory region
- *
- * Notes:
- *   Region: Generic memory entitiy having a start address and a size
- *   Chunk:  Reserved region
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-#include <linux/types.h>
-
-/*  ----------------------------------- Host OS */
-#include <dspbridge/host_os.h>
-
-/*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/dbdefs.h>
-
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
-/*  ----------------------------------- OS Adaptation Layer */
-#include <dspbridge/sync.h>
-
-/*  ----------------------------------- Platform Manager */
-#include <dspbridge/dev.h>
-#include <dspbridge/proc.h>
-
-/*  ----------------------------------- This */
-#include <dspbridge/dmm.h>
-
-/*  ----------------------------------- Defines, Data Structures, Typedefs */
-#define DMM_ADDR_VIRTUAL(a) \
-	(((struct map_page *)(a) - virtual_mapping_table) * PG_SIZE4K +\
-	dyn_mem_map_beg)
-#define DMM_ADDR_TO_INDEX(a) (((a) - dyn_mem_map_beg) / PG_SIZE4K)
-
-/* DMM Mgr */
-struct dmm_object {
-	/* Dmm Lock is used to serialize access mem manager for
-	 * multi-threads. */
-	spinlock_t dmm_lock;	/* Lock to access dmm mgr */
-};
-
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
-struct map_page {
-	u32 region_size:15;
-	u32 mapped_size:15;
-	u32 reserved:1;
-	u32 mapped:1;
-};
-
-/*  Create the free list */
-static struct map_page *virtual_mapping_table;
-static u32 free_region;		/* The index of free region */
-static u32 free_size;
-static u32 dyn_mem_map_beg;	/* The Beginning of dynamic memory mapping */
-static u32 table_size;		/* The size of virt and phys pages tables */
-
-/*  ----------------------------------- Function Prototypes */
-static struct map_page *get_region(u32 addr);
-static struct map_page *get_free_region(u32 len);
-static struct map_page *get_mapped_region(u32 addrs);
-
-/*  ======== dmm_create_tables ========
- *  Purpose:
- *      Create table to hold the information of physical address
- *      the buffer pages that is passed by the user, and the table
- *      to hold the information of the virtual memory that is reserved
- *      for DSP.
- */
-int dmm_create_tables(struct dmm_object *dmm_mgr, u32 addr, u32 size)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	int status = 0;
-
-	status = dmm_delete_tables(dmm_obj);
-	if (!status) {
-		dyn_mem_map_beg = addr;
-		table_size = PG_ALIGN_HIGH(size, PG_SIZE4K) / PG_SIZE4K;
-		/*  Create the free list */
-		virtual_mapping_table = __vmalloc(table_size *
-				sizeof(struct map_page), GFP_KERNEL |
-				__GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
-		if (virtual_mapping_table == NULL)
-			status = -ENOMEM;
-		else {
-			/* On successful allocation,
-			 * all entries are zero ('free') */
-			free_region = 0;
-			free_size = table_size * PG_SIZE4K;
-			virtual_mapping_table[0].region_size = table_size;
-		}
-	}
-
-	if (status)
-		pr_err("%s: failure, status 0x%x\n", __func__, status);
-
-	return status;
-}
-
-/*
- *  ======== dmm_create ========
- *  Purpose:
- *      Create a dynamic memory manager object.
- */
-int dmm_create(struct dmm_object **dmm_manager,
-		      struct dev_object *hdev_obj,
-		      const struct dmm_mgrattrs *mgr_attrts)
-{
-	struct dmm_object *dmm_obj = NULL;
-	int status = 0;
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(dmm_manager != NULL);
-
-	*dmm_manager = NULL;
-	/* create, zero, and tag a cmm mgr object */
-	dmm_obj = kzalloc(sizeof(struct dmm_object), GFP_KERNEL);
-	if (dmm_obj != NULL) {
-		spin_lock_init(&dmm_obj->dmm_lock);
-		*dmm_manager = dmm_obj;
-	} else {
-		status = -ENOMEM;
-	}
-
-	return status;
-}
-
-/*
- *  ======== dmm_destroy ========
- *  Purpose:
- *      Release the communication memory manager resources.
- */
-int dmm_destroy(struct dmm_object *dmm_mgr)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	int status = 0;
-
-	DBC_REQUIRE(refs > 0);
-	if (dmm_mgr) {
-		status = dmm_delete_tables(dmm_obj);
-		if (!status)
-			kfree(dmm_obj);
-	} else
-		status = -EFAULT;
-
-	return status;
-}
-
-/*
- *  ======== dmm_delete_tables ========
- *  Purpose:
- *      Delete DMM Tables.
- */
-int dmm_delete_tables(struct dmm_object *dmm_mgr)
-{
-	int status = 0;
-
-	DBC_REQUIRE(refs > 0);
-	/* Delete all DMM tables */
-	if (dmm_mgr)
-		vfree(virtual_mapping_table);
-	else
-		status = -EFAULT;
-	return status;
-}
-
-/*
- *  ======== dmm_exit ========
- *  Purpose:
- *      Discontinue usage of module; free resources when reference count
- *      reaches 0.
- */
-void dmm_exit(void)
-{
-	DBC_REQUIRE(refs > 0);
-
-	refs--;
-}
-
-/*
- *  ======== dmm_get_handle ========
- *  Purpose:
- *      Return the dynamic memory manager object for this device.
- *      This is typically called from the client process.
- */
-int dmm_get_handle(void *hprocessor, struct dmm_object **dmm_manager)
-{
-	int status = 0;
-	struct dev_object *hdev_obj;
-
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(dmm_manager != NULL);
-	if (hprocessor != NULL)
-		status = proc_get_dev_object(hprocessor, &hdev_obj);
-	else
-		hdev_obj = dev_get_first();	/* default */
-
-	if (!status)
-		status = dev_get_dmm_mgr(hdev_obj, dmm_manager);
-
-	return status;
-}
-
-/*
- *  ======== dmm_init ========
- *  Purpose:
- *      Initializes private state of DMM module.
- */
-bool dmm_init(void)
-{
-	bool ret = true;
-
-	DBC_REQUIRE(refs >= 0);
-
-	if (ret)
-		refs++;
-
-	DBC_ENSURE((ret && (refs > 0)) || (!ret && (refs >= 0)));
-
-	virtual_mapping_table = NULL;
-	table_size = 0;
-
-	return ret;
-}
-
-/*
- *  ======== dmm_map_memory ========
- *  Purpose:
- *      Add a mapping block to the reserved chunk. DMM assumes that this block
- *  will be mapped in the DSP/IVA's address space. DMM returns an error if a
- *  mapping overlaps another one. This function stores the info that will be
- *  required later while unmapping the block.
- */
-int dmm_map_memory(struct dmm_object *dmm_mgr, u32 addr, u32 size)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	int status = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-	/* Find the Reserved memory chunk containing the DSP block to
-	 * be mapped */
-	chunk = (struct map_page *)get_region(addr);
-	if (chunk != NULL) {
-		/* Mark the region 'mapped', leave the 'reserved' info as-is */
-		chunk->mapped = true;
-		chunk->mapped_size = (size / PG_SIZE4K);
-	} else
-		status = -ENOENT;
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s dmm_mgr %p, addr %x, size %x\n\tstatus %x, "
-		"chunk %p", __func__, dmm_mgr, addr, size, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== dmm_reserve_memory ========
- *  Purpose:
- *      Reserve a chunk of virtually contiguous DSP/IVA address space.
- */
-int dmm_reserve_memory(struct dmm_object *dmm_mgr, u32 size,
-			      u32 *prsv_addr)
-{
-	int status = 0;
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *node;
-	u32 rsv_addr = 0;
-	u32 rsv_size = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-
-	/* Try to get a DSP chunk from the free list */
-	node = get_free_region(size);
-	if (node != NULL) {
-		/*  DSP chunk of given size is available. */
-		rsv_addr = DMM_ADDR_VIRTUAL(node);
-		/* Calculate the number entries to use */
-		rsv_size = size / PG_SIZE4K;
-		if (rsv_size < node->region_size) {
-			/* Mark remainder of free region */
-			node[rsv_size].mapped = false;
-			node[rsv_size].reserved = false;
-			node[rsv_size].region_size =
-			    node->region_size - rsv_size;
-			node[rsv_size].mapped_size = 0;
-		}
-		/*  get_region will return first fit chunk. But we only use what
-		   is requested. */
-		node->mapped = false;
-		node->reserved = true;
-		node->region_size = rsv_size;
-		node->mapped_size = 0;
-		/* Return the chunk's starting address */
-		*prsv_addr = rsv_addr;
-	} else
-		/*dSP chunk of given size is not available */
-		status = -ENOMEM;
-
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s dmm_mgr %p, size %x, prsv_addr %p\n\tstatus %x, "
-		"rsv_addr %x, rsv_size %x\n", __func__, dmm_mgr, size,
-		prsv_addr, status, rsv_addr, rsv_size);
-
-	return status;
-}
-
-/*
- *  ======== dmm_un_map_memory ========
- *  Purpose:
- *      Remove the mapped block from the reserved chunk.
- */
-int dmm_un_map_memory(struct dmm_object *dmm_mgr, u32 addr, u32 *psize)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	int status = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-	chunk = get_mapped_region(addr);
-	if (chunk == NULL)
-		status = -ENOENT;
-
-	if (!status) {
-		/* Unmap the region */
-		*psize = chunk->mapped_size * PG_SIZE4K;
-		chunk->mapped = false;
-		chunk->mapped_size = 0;
-	}
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s: dmm_mgr %p, addr %x, psize %p\n\tstatus %x, "
-		"chunk %p\n", __func__, dmm_mgr, addr, psize, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== dmm_un_reserve_memory ========
- *  Purpose:
- *      Free a chunk of reserved DSP/IVA address space.
- */
-int dmm_un_reserve_memory(struct dmm_object *dmm_mgr, u32 rsv_addr)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	u32 i;
-	int status = 0;
-	u32 chunk_size;
-
-	spin_lock(&dmm_obj->dmm_lock);
-
-	/* Find the chunk containing the reserved address */
-	chunk = get_mapped_region(rsv_addr);
-	if (chunk == NULL)
-		status = -ENOENT;
-
-	if (!status) {
-		/* Free all the mapped pages for this reserved region */
-		i = 0;
-		while (i < chunk->region_size) {
-			if (chunk[i].mapped) {
-				/* Remove mapping from the page tables. */
-				chunk_size = chunk[i].mapped_size;
-				/* Clear the mapping flags */
-				chunk[i].mapped = false;
-				chunk[i].mapped_size = 0;
-				i += chunk_size;
-			} else
-				i++;
-		}
-		/* Clear the flags (mark the region 'free') */
-		chunk->reserved = false;
-		/* NOTE: We do NOT coalesce free regions here.
-		 * Free regions are coalesced in get_region(), as it traverses
-		 *the whole mapping table
-		 */
-	}
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s: dmm_mgr %p, rsv_addr %x\n\tstatus %x chunk %p",
-		__func__, dmm_mgr, rsv_addr, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== get_region ========
- *  Purpose:
- *      Returns a region containing the specified memory region
- */
-static struct map_page *get_region(u32 addr)
-{
-	struct map_page *curr_region = NULL;
-	u32 i = 0;
-
-	if (virtual_mapping_table != NULL) {
-		/* find page mapped by this address */
-		i = DMM_ADDR_TO_INDEX(addr);
-		if (i < table_size)
-			curr_region = virtual_mapping_table + i;
-	}
-
-	dev_dbg(bridge, "%s: curr_region %p, free_region %d, free_size %d\n",
-		__func__, curr_region, free_region, free_size);
-	return curr_region;
-}
-
-/*
- *  ======== get_free_region ========
- *  Purpose:
- *  Returns the requested free region
- */
-static struct map_page *get_free_region(u32 len)
-{
-	struct map_page *curr_region = NULL;
-	u32 i = 0;
-	u32 region_size = 0;
-	u32 next_i = 0;
-
-	if (virtual_mapping_table == NULL)
-		return curr_region;
-	if (len > free_size) {
-		/* Find the largest free region
-		 * (coalesce during the traversal) */
-		while (i < table_size) {
-			region_size = virtual_mapping_table[i].region_size;
-			next_i = i + region_size;
-			if (virtual_mapping_table[i].reserved == false) {
-				/* Coalesce, if possible */
-				if (next_i < table_size &&
-				    virtual_mapping_table[next_i].reserved
-				    == false) {
-					virtual_mapping_table[i].region_size +=
-					    virtual_mapping_table
-					    [next_i].region_size;
-					continue;
-				}
-				region_size *= PG_SIZE4K;
-				if (region_size > free_size) {
-					free_region = i;
-					free_size = region_size;
-				}
-			}
-			i = next_i;
-		}
-	}
-	if (len <= free_size) {
-		curr_region = virtual_mapping_table + free_region;
-		free_region += (len / PG_SIZE4K);
-		free_size -= len;
-	}
-	return curr_region;
-}
-
-/*
- *  ======== get_mapped_region ========
- *  Purpose:
- *  Returns the requestedmapped region
- */
-static struct map_page *get_mapped_region(u32 addrs)
-{
-	u32 i = 0;
-	struct map_page *curr_region = NULL;
-
-	if (virtual_mapping_table == NULL)
-		return curr_region;
-
-	i = DMM_ADDR_TO_INDEX(addrs);
-	if (i < table_size && (virtual_mapping_table[i].mapped ||
-			       virtual_mapping_table[i].reserved))
-		curr_region = virtual_mapping_table + i;
-	return curr_region;
-}
-
-#ifdef DSP_DMM_DEBUG
-u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr)
-{
-	struct map_page *curr_node = NULL;
-	u32 i;
-	u32 freemem = 0;
-	u32 bigsize = 0;
-
-	spin_lock(&dmm_mgr->dmm_lock);
-
-	if (virtual_mapping_table != NULL) {
-		for (i = 0; i < table_size; i +=
-		     virtual_mapping_table[i].region_size) {
-			curr_node = virtual_mapping_table + i;
-			if (curr_node->reserved) {
-				/*printk("RESERVED size = 0x%x, "
-				   "Map size = 0x%x\n",
-				   (curr_node->region_size * PG_SIZE4K),
-				   (curr_node->mapped == false) ? 0 :
-				   (curr_node->mapped_size * PG_SIZE4K));
-				 */
-			} else {
-/*				printk("UNRESERVED size = 0x%x\n",
-					(curr_node->region_size * PG_SIZE4K));
- */
-				freemem += (curr_node->region_size * PG_SIZE4K);
-				if (curr_node->region_size > bigsize)
-					bigsize = curr_node->region_size;
-			}
-		}
-	}
-	spin_unlock(&dmm_mgr->dmm_lock);
-	printk(KERN_INFO "Total DSP VA FREE memory = %d Mbytes\n",
-	       freemem / (1024 * 1024));
-	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes \n",
-	       (((table_size * PG_SIZE4K) - freemem)) / (1024 * 1024));
-	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes \n\n",
-	       (bigsize * PG_SIZE4K / (1024 * 1024)));
-
-	return 0;
-}
-#endif
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index ccb1811..a660247 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -56,7 +56,6 @@
 /*  ----------------------------------- This */
 #include <dspbridge/nodepriv.h>
 #include <dspbridge/node.h>
-#include <dspbridge/dmm.h>
 
 /* Static/Dynamic Loader includes */
 #include <dspbridge/dbll.h>
@@ -317,10 +316,6 @@ int node_allocate(struct proc_object *hprocessor,
 	u32 mapped_addr = 0;
 	u32 map_attrs = 0x0;
 	struct dsp_processorstate proc_state;
-#ifdef DSP_DMM_DEBUG
-	struct dmm_object *dmm_mgr;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-#endif
 
 	void *node_res;
 
@@ -430,16 +425,6 @@ int node_allocate(struct proc_object *hprocessor,
 	if (status)
 		goto func_cont;
 
-#ifdef DSP_DMM_DEBUG
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = DSP_EHANDLE;
-		goto func_cont;
-	}
-
-	dmm_mem_map_dump(dmm_mgr);
-#endif
-
 	map_attrs |= DSP_MAPLITTLEENDIAN;
 	map_attrs |= DSP_MAPELEMSIZE32;
 	map_attrs |= DSP_MAPVIRTUALADDR;
@@ -2499,11 +2484,7 @@ static void delete_node(struct node_object *hnode,
 	struct stream_chnl stream;
 	struct node_msgargs node_msg_args;
 	struct node_taskargs task_arg_obj;
-#ifdef DSP_DMM_DEBUG
-	struct dmm_object *dmm_mgr;
-	struct proc_object *p_proc_object =
-	    (struct proc_object *)hnode->hprocessor;
-#endif
+
 	int status;
 	if (!hnode)
 		goto func_end;
@@ -2564,13 +2545,6 @@ static void delete_node(struct node_object *hnode,
 			status = proc_un_map(hnode->hprocessor, (void *)
 					     task_arg_obj.udsp_heap_addr,
 					     pr_ctxt);
-#ifdef DSP_DMM_DEBUG
-			status = dmm_get_handle(p_proc_object, &dmm_mgr);
-			if (dmm_mgr)
-				dmm_mem_map_dump(dmm_mgr);
-			else
-				status = DSP_EHANDLE;
-#endif
 		}
 	}
 	if (node_type != NODE_MESSAGE) {
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 429f354..7a15a02 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -39,7 +39,6 @@
 #include <dspbridge/cod.h>
 #include <dspbridge/dev.h>
 #include <dspbridge/procpriv.h>
-#include <dspbridge/dmm.h>
 
 /*  ----------------------------------- Resource Manager */
 #include <dspbridge/mgr.h>
@@ -1078,7 +1077,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 	s32 cnew_envp;		/* "  " in new_envp[] */
 	s32 nproc_id = 0;	/* Anticipate MP version. */
 	struct dcd_manager *hdcd_handle;
-	struct dmm_object *dmm_mgr;
 	u32 dw_ext_end;
 	u32 proc_id;
 	int brd_state;
@@ -1269,25 +1267,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 			if (!status)
 				status = cod_get_sym_value(cod_mgr, EXTEND,
 							   &dw_ext_end);
-
-			/* Reset DMM structs and add an initial free chunk */
-			if (!status) {
-				status =
-				    dev_get_dmm_mgr(p_proc_object->hdev_obj,
-						    &dmm_mgr);
-				if (dmm_mgr) {
-					/* Set dw_ext_end to DMM START u8
-					 * address */
-					dw_ext_end =
-					    (dw_ext_end + 1) * DSPWORDSIZE;
-					/* DMM memory is from EXT_END */
-					status = dmm_create_tables(dmm_mgr,
-								   dw_ext_end,
-								   DMMPOOLSIZE);
-				} else {
-					status = -EFAULT;
-				}
-			}
 		}
 	}
 	/* Restore the original argv[0] */
@@ -1390,7 +1369,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		map_obj->dsp_addr = (va_align |
 					((u32)pmpu_addr & (PG_SIZE4K - 1)));
 		*pp_map_addr = (void *)map_obj->dsp_addr;
-		pr_err("%s: mapped address %x\n", __func__, *pp_map_addr);
 	} else {
 		remove_mapping_information(pr_ctxt, va_align);
 	}
@@ -1633,7 +1611,6 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
 	u32 va_align;
-	u32 size_align;
 
 	va_align = PG_ALIGN_LOW((u32) map_addr, PG_SIZE4K);
 	if (!p_proc_object) {
-- 
1.6.3.3

