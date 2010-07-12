Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0GLW4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39463 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0GLW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:23 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 03/11] staging: tidspbridge: remove std.h
Date: Mon, 12 Jul 2010 17:56:01 -0500
Message-Id: <1278975369-7687-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

std.h introduces _TI_ _FLOAT_ _FIXED_ _TARGET_ ARG_TO_INT ARG_TO_PTR
which are no longer being used anywhere. we dont really need the
custom std.h header. remove it from the repo. where we need types,
introduce standard types.h

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |    3 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    3 +-
 drivers/staging/tidspbridge/core/io_sm.c           |    2 +-
 drivers/staging/tidspbridge/core/msg_sm.c          |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 +-
 drivers/staging/tidspbridge/core/wdt.c             |    2 +-
 drivers/staging/tidspbridge/gen/gb.c               |    2 +-
 drivers/staging/tidspbridge/gen/gh.c               |    2 +-
 drivers/staging/tidspbridge/gen/gs.c               |    2 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |    2 +-
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |    1 -
 .../tidspbridge/include/dspbridge/rmstypes.h       |    4 -
 .../staging/tidspbridge/include/dspbridge/std.h    |   90 --------------------
 drivers/staging/tidspbridge/pmgr/chnl.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/cod.c             |    3 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/dmm.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    2 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    2 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/staging/tidspbridge/rmgr/disp.c            |    2 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    2 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |    3 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    3 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    2 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |    2 +-
 drivers/staging/tidspbridge/rmgr/rmm.c             |    3 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |    3 +-
 drivers/staging/tidspbridge/services/cfg.c         |    3 +-
 drivers/staging/tidspbridge/services/services.c    |    3 +-
 35 files changed, 41 insertions(+), 127 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/std.h

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 714b6f7..b669bc0 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -42,11 +42,12 @@
  *          !LST_Empty(pchnl->pio_completions) ==> pchnl->sync_event is set.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index abaa595..6f9ea05 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -16,13 +16,14 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <plat/dmtimer.h>
 #include <plat/mcbsp.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 #include <dspbridge/cfg.h>
 #include <dspbridge/drv.h>
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 1503968..280b22d 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -23,13 +23,13 @@
  * which may cause timeouts and/or failure of the sync_wait_on_event
  * function.
  */
+#include <linux/types.h>
 
 /* Host OS */
 #include <dspbridge/host_os.h>
 #include <linux/workqueue.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /* Trace & Debug */
diff --git a/drivers/staging/tidspbridge/core/msg_sm.c b/drivers/staging/tidspbridge/core/msg_sm.c
index 7c6d6cc..7b7a4be 100644
--- a/drivers/staging/tidspbridge/core/msg_sm.c
+++ b/drivers/staging/tidspbridge/core/msg_sm.c
@@ -15,9 +15,9 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 25c1271..d067de9 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -16,6 +16,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <linux/mm.h>
@@ -23,7 +24,6 @@
 #include <plat/control.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index dd1afe7..2126f59 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -15,8 +15,8 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 #include <dspbridge/dspdeh.h>
 #include <dspbridge/dev.h>
diff --git a/drivers/staging/tidspbridge/gen/gb.c b/drivers/staging/tidspbridge/gen/gb.c
index d007233..06eb3d3 100644
--- a/drivers/staging/tidspbridge/gen/gb.c
+++ b/drivers/staging/tidspbridge/gen/gb.c
@@ -15,9 +15,9 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <linux/types.h>
 /*  ----------------------------------- This */
 #include <dspbridge/gs.h>
diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
index 44fad88..f72d943 100644
--- a/drivers/staging/tidspbridge/gen/gh.c
+++ b/drivers/staging/tidspbridge/gen/gh.c
@@ -14,7 +14,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <dspbridge/std.h>
+#include <linux/types.h>
 
 #include <dspbridge/host_os.h>
 
diff --git a/drivers/staging/tidspbridge/gen/gs.c b/drivers/staging/tidspbridge/gen/gs.c
index 3d091b9..9fc6144 100644
--- a/drivers/staging/tidspbridge/gen/gs.c
+++ b/drivers/staging/tidspbridge/gen/gs.c
@@ -16,8 +16,8 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 #include <linux/types.h>
 
diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index 070761b..e2c005d 100644
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -15,12 +15,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
index 9462a96..b408cad 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 
 #include <dspbridge/dbtype.h>	/* GPP side type definitions */
-#include <dspbridge/std.h>	/* DSP/BIOS type definitions */
 #include <dspbridge/rms_sh.h>	/* Types shared between GPP and DSP */
 
 #define PG_SIZE4K 4096
diff --git a/drivers/staging/tidspbridge/include/dspbridge/rmstypes.h b/drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
index 3c31f5e..83c0f1d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
@@ -19,10 +19,6 @@
 #ifndef RMSTYPES_
 #define RMSTYPES_
 #include <linux/types.h>
-/*
- *  DSP-side definitions.
- */
-#include <dspbridge/std.h>
 typedef u32 rms_word;
 
 #endif /* RMSTYPES_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/std.h b/drivers/staging/tidspbridge/include/dspbridge/std.h
deleted file mode 100644
index ca2827d..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/std.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * std.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2008 Texas Instruments, Inc.
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
-#ifndef STD_
-#define STD_
-
-#include <linux/types.h>
-
-/*
- *  ======== _TI_ ========
- *  _TI_ is defined for all TI targets
- */
-#if defined(_29_) || defined(_30_) || defined(_40_) || defined(_50_) || \
-    defined(_54_) || defined(_55_) || defined(_6x_) || defined(_80_) || \
-    defined(_28_) || defined(_24_)
-#define _TI_	1
-#endif
-
-/*
- *  ======== _FLOAT_ ========
- *  _FLOAT_ is defined for all targets that natively support floating point
- */
-#if defined(_SUN_) || defined(_30_) || defined(_40_) || defined(_67_) || \
-    defined(_80_)
-#define _FLOAT_	1
-#endif
-
-/*
- *  ======== _FIXED_ ========
- *  _FIXED_ is defined for all fixed point target architectures
- */
-#if defined(_29_) || defined(_50_) || defined(_54_) || defined(_55_) || \
-    defined(_62_) || defined(_64_) || defined(_28_)
-#define _FIXED_	1
-#endif
-
-/*
- *  ======== _TARGET_ ========
- *  _TARGET_ is defined for all target architectures (as opposed to
- *  host-side software)
- */
-#if defined(_FIXED_) || defined(_FLOAT_)
-#define _TARGET_ 1
-#endif
-
-/*
- *  8, 16, 32-bit type definitions
- *
- *  Sm*	- 8-bit type
- *  Md* - 16-bit type
- *  Lg* - 32-bit type
- *
- *  *s32 - signed type
- *  *u32 - unsigned type
- *  *Bits - unsigned type (bit-maps)
- */
-
-/*
- *  Aliases for standard C types
- */
-
-typedef s32(*fxn) (void);	/* generic function type */
-
-/*
- * These macros are used to cast 'Arg' types to 's32' or 'Ptr'.
- * These macros were added for the 55x since Arg is not the same
- * size as s32 and Ptr in 55x large model.
- */
-#if defined(_28l_) || defined(_55l_)
-#define ARG_TO_INT(A)	((s32)((long)(A) & 0xffff))
-#define ARG_TO_PTR(A)	((Ptr)(A))
-#else
-#define ARG_TO_INT(A)	((s32)(A))
-#define ARG_TO_PTR(A)	((Ptr)(A))
-#endif
-
-#endif /* STD_ */
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index bc969d8..9007bfd 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -17,11 +17,11 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 711d206..8300f97 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -29,9 +29,9 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index a9b0491..d2c8e69 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -20,13 +20,14 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 3a50071..fccf369 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -13,12 +13,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 2c31f31..4509468 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -15,12 +15,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index e211ec5..11bd2b5 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -20,12 +20,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 7597210..8555aad 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -16,12 +16,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index c6ad203..9f687e0 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -15,12 +15,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/pmgr/msg.c b/drivers/staging/tidspbridge/pmgr/msg.c
index 64f1cb4..7dec2ab 100644
--- a/drivers/staging/tidspbridge/pmgr/msg.c
+++ b/drivers/staging/tidspbridge/pmgr/msg.c
@@ -15,12 +15,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 4fe96bf..169bb15 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -22,12 +22,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 /*  ----------------------------------- Trace & Debug */
 #include <dspbridge/dbc.h>
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index 7195415..eedf32a 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -16,12 +16,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 72e2804..112ac87 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -15,12 +15,12 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/types.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 27db842..6dbac3b 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -19,6 +19,7 @@
 /*  ----------------------------------- Host OS */
 
 #include <dspbridge/host_os.h>
+#include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 
@@ -32,7 +33,6 @@
 #include <linux/cdev.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/dspdrv.c b/drivers/staging/tidspbridge/rmgr/dspdrv.c
index 19a7471..2fddbbb 100644
--- a/drivers/staging/tidspbridge/rmgr/dspdrv.c
+++ b/drivers/staging/tidspbridge/rmgr/dspdrv.c
@@ -17,10 +17,10 @@
  */
 
 /*  ----------------------------------- Host OS */
+#include <linux/types.h>
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidspbridge/rmgr/mgr.c
index b1a68ac..a7bc93b 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -18,8 +18,9 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 53fd371..f59a981 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -16,9 +16,10 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 #include <dspbridge/host_os.h>
 
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 #include <dspbridge/dbc.h>
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 9a46edc..928079e 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -16,11 +16,11 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index d138d11..c912572 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -16,13 +16,13 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
 /* ------------------------------------ Host OS */
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/rmm.c b/drivers/staging/tidspbridge/rmgr/rmm.c
index ff33080..042d32b 100644
--- a/drivers/staging/tidspbridge/rmgr/rmm.c
+++ b/drivers/staging/tidspbridge/rmgr/rmm.c
@@ -37,8 +37,9 @@
  *  been allocated, and not yet freed.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index e537ee8..d31422d 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -16,11 +16,12 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 8ae64f4..699792c 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -16,8 +16,9 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
diff --git a/drivers/staging/tidspbridge/services/services.c b/drivers/staging/tidspbridge/services/services.c
index 23be95c..6a7dd6f 100644
--- a/drivers/staging/tidspbridge/services/services.c
+++ b/drivers/staging/tidspbridge/services/services.c
@@ -16,10 +16,11 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/types.h>
+
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
 
 /*  ----------------------------------- Trace & Debug */
-- 
1.6.3.3

