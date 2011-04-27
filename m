Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1D0Ka6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:30:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:23595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab1D0KaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,273,1301900400"; 
   d="scan'208";a="739084287"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 6/8] staging/mei: Header file contain the Userland API, (IOCTL and its struct)
Date: Wed, 27 Apr 2011 13:27:35 +0300
Message-Id: <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 include/linux/mei.h |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mei.h

diff --git a/include/linux/mei.h b/include/linux/mei.h
new file mode 100644
index 0000000..6da7c4f
--- /dev/null
+++ b/include/linux/mei.h
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

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

