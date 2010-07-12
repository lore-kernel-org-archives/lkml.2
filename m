Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0GLW4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56970 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab0GLW4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 02/11] staging: tidspbridge: no need for custom NULL
Date: Mon, 12 Jul 2010 17:56:00 -0500
Message-Id: <1278975369-7687-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel has it's own NULL define, we dont need to introduce our own
custom NULL type!

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/dynload/header.h       |    4 ----
 drivers/staging/tidspbridge/hw/GlobalTypes.h       |    9 ---------
 .../staging/tidspbridge/include/dspbridge/dbtype.h |    8 --------
 .../staging/tidspbridge/include/dspbridge/std.h    |    4 ----
 4 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/header.h b/drivers/staging/tidspbridge/dynload/header.h
index 04623f1..5b50a15 100644
--- a/drivers/staging/tidspbridge/dynload/header.h
+++ b/drivers/staging/tidspbridge/dynload/header.h
@@ -14,10 +14,6 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#ifndef NULL
-#define NULL 0
-#endif
-
 #include <linux/string.h>
 #define DL_STRCMP  strcmp
 
diff --git a/drivers/staging/tidspbridge/hw/GlobalTypes.h b/drivers/staging/tidspbridge/hw/GlobalTypes.h
index ba045eb..2f8e69b 100644
--- a/drivers/staging/tidspbridge/hw/GlobalTypes.h
+++ b/drivers/staging/tidspbridge/hw/GlobalTypes.h
@@ -20,15 +20,6 @@
 #define _GLOBALTYPES_H
 
 /*
- * Definition: NULL
- *
- * DESCRIPTION:  Invalid pointer
- */
-#ifndef NULL
-#define NULL	(void *)0
-#endif
-
-/*
  * Definition: RET_CODE_BASE
  *
  * DESCRIPTION:  Base value for return code offsets
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h b/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
index 0b2cb93..ca5eaf8 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
@@ -42,14 +42,6 @@
 #endif
 
 /*===========================================================================*/
-/*  NULL    (Definition is language specific) */
-/*===========================================================================*/
-
-#ifndef NULL
-#define NULL    ((void *)0)	/* Null pointer. */
-#endif
-
-/*===========================================================================*/
 /*  NULL character   (normally used for string termination) */
 /*===========================================================================*/
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/std.h b/drivers/staging/tidspbridge/include/dspbridge/std.h
index 7e09fec..ca2827d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/std.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/std.h
@@ -74,10 +74,6 @@
 
 typedef s32(*fxn) (void);	/* generic function type */
 
-#ifndef NULL
-#define NULL 0
-#endif
-
 /*
  * These macros are used to cast 'Arg' types to 's32' or 'Ptr'.
  * These macros were added for the 55x since Arg is not the same
-- 
1.6.3.3

