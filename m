Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0LQBEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:04:49 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:56616 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813Ab0LQBEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:04:45 -0500
From: Armando Uribe <x0095078@ti.com>
To: <omar.ramirez@ti.com>
Cc: <x0095078@ti.com>, <ohad@wizery.com>, <felipe.contreras@gmail.com>,
        <rene.sapiens@ti.com>, <nm@ti.com>, <ernesto@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 4/5] staging:tidspbridge - Remove unused typedefs
Date: Thu, 16 Dec 2010 19:18:32 -0600
Message-Id: <1292548713-27061-5-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1292548713-27061-4-git-send-email-x0095078@ti.com>
References: <1292548713-27061-1-git-send-email-x0095078@ti.com>
 <1292548713-27061-2-git-send-email-x0095078@ti.com>
 <1292548713-27061-3-git-send-email-x0095078@ti.com>
 <1292548713-27061-4-git-send-email-x0095078@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsed typedefs are removed, because of there are not
used or because previous clean ups.

Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 .../tidspbridge/include/dspbridge/dbldefs.h        |   81 --------------------
 .../tidspbridge/include/dspbridge/dblldefs.h       |   62 ---------------
 2 files changed, 0 insertions(+), 143 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbldefs.h

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
deleted file mode 100644
index 5cf9dad..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * dbldefs.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
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
-#ifndef DBLDEFS_
-#define DBLDEFS_
-
-
-/*
- *  ======== dbl_flags ========
- *  Specifies whether to load code, data, or symbols
- */
-typedef s32 dbl_flags;
-
-/*
- *  ======== dbl_alloc_fxn ========
- *  Allocate memory function.  Allocate or reserve (if reserved == TRUE)
- *  "size" bytes of memory from segment "space" and return the address in
- *  *dsp_address (or starting at *dsp_address if reserve == TRUE). Returns 0 on
- *  success, or an error code on failure.
- */
-typedef s32(*dbl_alloc_fxn) (void *hdl, s32 space, u32 size, u32 align,
-			     u32 *dsp_address, s32 seg_id, s32 req,
-			     bool reserved);
-
-/*
- *  ======== dbl_free_fxn ========
- *  Free memory function.  Free, or unreserve (if reserved == TRUE) "size"
- *  bytes of memory from segment "space"
- */
-typedef bool(*dbl_free_fxn) (void *hdl, u32 addr, s32 space, u32 size,
-			     bool reserved);
-
-/*
- *  ======== dbl_log_write_fxn ========
- *  Function to call when writing data from a section, to log the info.
- *  Can be NULL if no logging is required.
- */
-typedef int(*dbl_log_write_fxn) (void *handle,
-					struct dbl_sect_info *sect, u32 addr,
-					u32 bytes);
-
-/*
- *  ======== dbl_sym_lookup ========
- *  Symbol lookup function - Find the symbol name and return its value.
- *
- *  Parameters:
- *      handle          - Opaque handle
- *      parg            - Opaque argument.
- *      name            - Name of symbol to lookup.
- *      sym             - Location to store address of symbol structure.
- *
- *  Returns:
- *      TRUE:           Success (symbol was found).
- *      FALSE:          Failed to find symbol.
- */
-typedef bool(*dbl_sym_lookup) (void *handle, void *parg, void *rmm_handle,
-			       const char *name, struct dbl_symbol ** sym);
-
-/*
- *  ======== dbl_write_fxn ========
- *  Write memory function.  Write "n" HOST bytes of memory to segment "mtype"
- *  starting at address "dsp_address" from the buffer "buf".  The buffer is
- *  formatted as an array of words appropriate for the DSP.
- */
-typedef s32(*dbl_write_fxn) (void *hdl, u32 dsp_address, void *buf,
-			     u32 n, s32 mtype);
-
-#endif /* DBLDEFS_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index 81821e5..30e0aa0 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
@@ -348,29 +348,6 @@ typedef bool(*dbll_init_fxn) (void);
 typedef int(*dbll_load_fxn) (struct dbll_library_obj *lib,
 				    dbll_flags flags,
 				    struct dbll_attrs *attrs, u32 *entry);
-
-/*
- *  ======== dbll_load_sect ========
- *  Load a named section from an library (for overlay support).
- *  Parameters:
- *      lib             - Handle returned from dbll_open().
- *      sec_name        - Name of section to load.
- *      attrs           - Contains write function and handle to pass to it.
- *  Returns:
- *      0:        Success.
- *      -ENXIO:    Section not found.
- *      -ENOSYS:   Function not implemented.
- *  Requires:
- *      Valid lib.
- *      sec_name != NULL.
- *      attrs != NULL.
- *      attrs->write != NULL.
- *  Ensures:
- */
-typedef int(*dbll_load_sect_fxn) (struct dbll_library_obj *lib,
-					 char *sz_sect_name,
-					 struct dbll_attrs *attrs);
-
 /*
  *  ======== dbll_open ========
  *  dbll_open() returns a library handle that can be used to load/unload
@@ -421,23 +398,6 @@ typedef int(*dbll_open_fxn) (struct dbll_tar_obj *target, char *file,
 typedef int(*dbll_read_sect_fxn) (struct dbll_library_obj *lib,
 					 char *name, char *content,
 					 u32 cont_size);
-
-/*
- *  ======== dbll_set_attrs ========
- *  Set the attributes of the target.
- *  Parameters:
- *      target          - Handle returned from dbll_create().
- *      pattrs          - New attributes.
- *  Returns:
- *  Requires:
- *      DBL initialized.
- *      Valid target.
- *      pattrs != NULL.
- *  Ensures:
- */
-typedef void (*dbll_set_attrs_fxn) (struct dbll_tar_obj *target,
-				    struct dbll_attrs *attrs);
-
 /*
  *  ======== dbll_unload ========
  *  Unload library loaded with dbll_load().
@@ -452,28 +412,6 @@ typedef void (*dbll_set_attrs_fxn) (struct dbll_tar_obj *target,
  */
 typedef void (*dbll_unload_fxn) (struct dbll_library_obj *library,
 				 struct dbll_attrs *attrs);
-
-/*
- *  ======== dbll_unload_sect ========
- *  Unload a named section from an library (for overlay support).
- *  Parameters:
- *      lib             - Handle returned from dbll_open().
- *      sec_name        - Name of section to load.
- *      attrs           - Contains free() function and handle to pass to it.
- *  Returns:
- *      0:        Success.
- *      -ENXIO:    Named section not found.
- *      -ENOSYS
- *  Requires:
- *      DBL initialized.
- *      Valid lib.
- *      sec_name != NULL.
- *  Ensures:
- */
-typedef int(*dbll_unload_sect_fxn) (struct dbll_library_obj *lib,
-					   char *sz_sect_name,
-					   struct dbll_attrs *attrs);
-
 struct dbll_fxns {
 	dbll_close_fxn close_fxn;
 	dbll_create_fxn create_fxn;
-- 
1.6.3.3

