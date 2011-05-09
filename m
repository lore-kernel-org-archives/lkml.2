Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1EJIdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:33:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42595
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756107Ab1EJIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 191/206] Staging: hv: Get rid of logging.h
Date: Mon,  9 May 2011 14:57:53 -0700
Message-Id: <1304978288-22999-191-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of logging.h

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/logging.h |   98 ------------------------------------------
 1 files changed, 0 insertions(+), 98 deletions(-)
 delete mode 100644 drivers/staging/hv/logging.h

diff --git a/drivers/staging/hv/logging.h b/drivers/staging/hv/logging.h
deleted file mode 100644
index 1799951..0000000
--- a/drivers/staging/hv/logging.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-
-#ifndef _LOGGING_H_
-#define _LOGGING_H_
-
-#define LOWORD(dw) ((unsigned short)(dw))
-#define HIWORD(dw) ((unsigned short)(((unsigned int) (dw) >> 16) & 0xFFFF))
-
-/* #include <linux/init.h> */
-/* #include <linux/module.h> */
-
-
-#define VMBUS				0x0001
-#define STORVSC				0x0002
-#define NETVSC				0x0004
-#define INPUTVSC			0x0008
-#define BLKVSC				0x0010
-#define VMBUS_DRV			0x0100
-#define STORVSC_DRV			0x0200
-#define NETVSC_DRV			0x0400
-#define INPUTVSC_DRV		0x0800
-#define BLKVSC_DRV			0x1000
-
-#define ALL_MODULES			(VMBUS		|\
-							STORVSC		|\
-							NETVSC		|\
-							INPUTVSC	|\
-							BLKVSC		|\
-							VMBUS_DRV	|\
-							STORVSC_DRV	|\
-							NETVSC_DRV	|\
-							INPUTVSC_DRV|\
-							BLKVSC_DRV)
-
-/* Logging Level */
-#define ERROR_LVL				3
-#define WARNING_LVL				4
-#define INFO_LVL				6
-#define DEBUG_LVL				7
-#define DEBUG_LVL_ENTEREXIT			8
-#define DEBUG_RING_LVL				9
-
-extern unsigned int vmbus_loglevel;
-
-#define DPRINT(mod, lvl, fmt, args...) do {\
-	if ((mod & (HIWORD(vmbus_loglevel))) &&	\
-	    (lvl <= LOWORD(vmbus_loglevel)))	\
-		printk(KERN_DEBUG #mod": %s() " fmt "\n", __func__, ## args);\
-	} while (0)
-
-#define DPRINT_DBG(mod, fmt, args...) do {\
-	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
-	    (DEBUG_LVL <= LOWORD(vmbus_loglevel)))	\
-		printk(KERN_DEBUG #mod": %s() " fmt "\n", __func__, ## args);\
-	} while (0)
-
-#define DPRINT_INFO(mod, fmt, args...) do {\
-	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
-	    (INFO_LVL <= LOWORD(vmbus_loglevel)))	\
-		printk(KERN_INFO #mod": " fmt "\n", ## args);\
-	} while (0)
-
-#define DPRINT_WARN(mod, fmt, args...) do {\
-	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
-	    (WARNING_LVL <= LOWORD(vmbus_loglevel)))	\
-		printk(KERN_WARNING #mod": WARNING! " fmt "\n", ## args);\
-	} while (0)
-
-#define DPRINT_ERR(mod, fmt, args...) do {\
-	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
-	    (ERROR_LVL <= LOWORD(vmbus_loglevel)))	\
-		printk(KERN_ERR #mod": %s() ERROR!! " fmt "\n",	\
-		       __func__, ## args);\
-	} while (0)
-
-#endif /* _LOGGING_H_ */
-- 
1.7.4.1

