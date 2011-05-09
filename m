Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1EJIax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:30:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42615
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754190Ab1EJIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 201/206] Staging: hv: Get rid of vmbus_channel_interface.h
Date: Mon,  9 May 2011 14:58:03 -0700
Message-Id: <1304978288-22999-201-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of vmbus_channel_interface.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_channel_interface.h |   89 --------------------------
 1 files changed, 0 insertions(+), 89 deletions(-)
 delete mode 100644 drivers/staging/hv/vmbus_channel_interface.h

diff --git a/drivers/staging/hv/vmbus_channel_interface.h b/drivers/staging/hv/vmbus_channel_interface.h
deleted file mode 100644
index 20ae258..0000000
--- a/drivers/staging/hv/vmbus_channel_interface.h
+++ /dev/null
@@ -1,89 +0,0 @@
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
-#ifndef __VMBUSCHANNELINTERFACE_H
-#define __VMBUSCHANNELINTERFACE_H
-
-/*
- * A revision number of vmbus that is used for ensuring both ends on a
- * partition are using compatible versions.
- */
-#define VMBUS_REVISION_NUMBER		13
-
-/* Make maximum size of pipe payload of 16K */
-#define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
-
-/* Define PipeMode values. */
-#define VMBUS_PIPE_TYPE_BYTE		0x00000000
-#define VMBUS_PIPE_TYPE_MESSAGE		0x00000004
-
-/* The size of the user defined data buffer for non-pipe offers. */
-#define MAX_USER_DEFINED_BYTES		120
-
-/* The size of the user defined data buffer for pipe offers. */
-#define MAX_PIPE_USER_DEFINED_BYTES	116
-
-/*
- * At the center of the Channel Management library is the Channel Offer. This
- * struct contains the fundamental information about an offer.
- */
-struct vmbus_channel_offer {
-	struct hv_guid if_type;
-	struct hv_guid if_instance;
-	u64 int_latency; /* in 100ns units */
-	u32 if_revision;
-	u32 server_ctx_size;	/* in bytes */
-	u16 chn_flags;
-	u16 mmio_megabytes;		/* in bytes * 1024 * 1024 */
-
-	union {
-		/* Non-pipes: The user has MAX_USER_DEFINED_BYTES bytes. */
-		struct {
-			unsigned char user_def[MAX_USER_DEFINED_BYTES];
-		} std;
-
-		/*
-		 * Pipes:
-		 * The following sructure is an integrated pipe protocol, which
-		 * is implemented on top of standard user-defined data. Pipe
-		 * clients have MAX_PIPE_USER_DEFINED_BYTES left for their own
-		 * use.
-		 */
-		struct {
-			u32  pipe_mode;
-			unsigned char user_def[MAX_PIPE_USER_DEFINED_BYTES];
-		} pipe;
-	} u;
-	u32 padding;
-} __packed;
-
-/* Server Flags */
-#define VMBUS_CHANNEL_ENUMERATE_DEVICE_INTERFACE	1
-#define VMBUS_CHANNEL_SERVER_SUPPORTS_TRANSFER_PAGES	2
-#define VMBUS_CHANNEL_SERVER_SUPPORTS_GPADLS		4
-#define VMBUS_CHANNEL_NAMED_PIPE_MODE			0x10
-#define VMBUS_CHANNEL_LOOPBACK_OFFER			0x100
-#define VMBUS_CHANNEL_PARENT_OFFER			0x200
-#define VMBUS_CHANNEL_REQUEST_MONITORED_NOTIFICATION	0x400
-
-#endif
-- 
1.7.4.1

