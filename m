Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab1EOKpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:45:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab1EOKpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:45:42 -0400
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 08/10] staging/mei: mei.h defining user space interface
Date: Sun, 15 May 2011 13:43:46 +0300
Message-Id: <1305456228-15265-9-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define IOCTL_MEI_CONNECT_CLIENT and its associated structure

When the user wants to connect to a ME feature/client after
it open a file descriptor to the driver, he need to use Connect
IOCTL.

This IOCTL received a struct that contains a union of 2 other structs.

1st struct - Input Parameters:
	UUID - a predefine unique that identify the ME feature, this
		 id per feature is constant all over the chipsets
		 and versions.

2nd struct Output Parameters:
	MaxMessageLen - 	maximum message length that allowed
				to be send to the feature
	ProtocolVersion ME feature current protocol version.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/mei.h |  105 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/mei.h

diff --git a/drivers/staging/mei/mei.h b/drivers/staging/mei/mei.h
new file mode 100644
index 0000000..6da7c4f
--- /dev/null
+++ b/drivers/staging/mei/mei.h
@@ -0,0 +1,105 @@
+/*
+
+  Intel Management Engine Interface (Intel MEI) Linux driver
+  Intel MEI Interface Header
+
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+
+  Copyright(c) 2003-2011 Intel Corporation. All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+	  Intel Corporation.
+	  linux-mei@linux.intel.com
+	  http://www.intel.com
+
+
+  BSD LICENSE
+
+  Copyright(c) 2003-2011 Intel Corporation. All rights reserved.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+*/
+
+
+#ifndef _LINUX_MEI_H
+#define _LINUX_MEI_H
+
+#include <linux/uuid.h>
+
+/*
+ * This IOCTL is used to associate the current file descriptor with a
+ * FW Client (given by UUID). This opens a communication channel
+ * between a host client and a FW client. From this point every read and write
+ * will communicate with the associated FW client.
+ * Only in close() (file_operation release()) the communication between
+ * the clients is disconnected
+ *
+ * The IOCTL argument is a struct with a union the contains
+ * the input parameter and the output parameter for this IOCTL.
+ *
+ * The input parameter is UUID of the FW Client.
+ * The output parameter is the properties of the FW client
+ * (FW protocol version and max message size).
+ *
+ */
+#define IOCTL_MEI_CONNECT_CLIENT \
+	_IOWR('H' , 0x01, struct mei_connect_client_data)
+
+/*
+ * Intel MEI client information struct
+ */
+struct mei_client {
+	__u32 max_msg_length;
+	__u8 protocol_version;
+	__u8 reserved[3];
+};
+
+/*
+ * IOCTL Connect Client Data structure
+ */
+struct mei_connect_client_data {
+	union {
+		uuid_le in_client_uuid;
+		struct mei_client out_client_properties;
+	};
+};
+
+#endif /* _LINUX_MEI_H  */
-- 
1.7.1

