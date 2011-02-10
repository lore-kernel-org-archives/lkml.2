Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1BJJzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:43607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab1BJJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:17 -0500
Message-Id: <849307$bgs46d@azsmga001.ch.intel.com>
Date: 10 Feb 2011 01:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="386797781"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 07/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/interface.h b/drivers/char/mei/interface.h
new file mode 100644
index 0000000..01f3667
--- /dev/null
+++ b/drivers/char/mei/interface.h
@@ -0,0 +1,134 @@
+/*
+ *
+ * Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver
+ * Copyright (c) 2003-2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+
+
+#ifndef _MEI_INTERFACE_H_
+#define _MEI_INTERFACE_H_
+
+#include <linux/mei.h>
+#include "hw.h"
+
+
+#define HBM_MINOR_VERSION                   0
+#define HBM_MAJOR_VERSION                   1
+#define HBM_TIMEOUT                         1	/* 1 second */
+
+
+#define HOST_START_REQ_CMD                  0x01
+#define HOST_START_RES_CMD                  0x81
+
+#define HOST_STOP_REQ_CMD                   0x02
+#define HOST_STOP_RES_CMD                   0x82
+
+#define ME_STOP_REQ_CMD                     0x03
+
+#define HOST_ENUM_REQ_CMD                   0x04
+#define HOST_ENUM_RES_CMD                   0x84
+
+#define HOST_CLIENT_PROPERTIES_REQ_CMD      0x05
+#define HOST_CLIENT_PROPERTIES_RES_CMD      0x85
+
+#define CLIENT_CONNECT_REQ_CMD              0x06
+#define CLIENT_CONNECT_RES_CMD              0x86
+
+#define CLIENT_DISCONNECT_REQ_CMD           0x07
+#define CLIENT_DISCONNECT_RES_CMD           0x87
+
+#define MEI_FLOW_CONTROL_CMD               0x08
+
+
+#define AMT_WD_VALUE 120	/* seconds */
+
+#define MEI_WATCHDOG_DATA_SIZE         16
+#define MEI_START_WD_DATA_SIZE         20
+#define MEI_WD_PARAMS_SIZE             4
+
+
+enum mei_stop_reason_types {
+	DRIVER_STOP_REQUEST = 0x00,
+	DEVICE_D1_ENTRY = 0x01,
+	DEVICE_D2_ENTRY = 0x02,
+	DEVICE_D3_ENTRY = 0x03,
+	SYSTEM_S1_ENTRY = 0x04,
+	SYSTEM_S2_ENTRY = 0x05,
+	SYSTEM_S3_ENTRY = 0x06,
+	SYSTEM_S4_ENTRY = 0x07,
+	SYSTEM_S5_ENTRY = 0x08
+};
+
+enum me_stop_reason_types {
+	FW_UPDATE = 0x00
+};
+
+enum client_connect_status_types {
+	CCS_SUCCESS = 0x00,
+	CCS_NOT_FOUND = 0x01,
+	CCS_ALREADY_STARTED = 0x02,
+	CCS_OUT_OF_RESOURCES = 0x03,
+	CCS_MESSAGE_SMALL = 0x04
+};
+
+enum client_disconnect_status_types {
+	CDS_SUCCESS = 0x00
+};
+
+
+/*
+ * mei interface function prototypes
+ */
+void mei_set_csr_register(struct iamt_mei_device *dev);
+void mei_csr_enable_interrupts(struct iamt_mei_device *dev);
+void mei_csr_disable_interrupts(struct iamt_mei_device *dev);
+void mei_csr_clear_his(struct iamt_mei_device *dev);
+
+void mei_read_slots(struct iamt_mei_device *dev,
+		     unsigned char *buffer, unsigned long buffer_length);
+
+int mei_write_message(struct iamt_mei_device *dev,
+			     struct mei_msg_hdr *header,
+			     unsigned char *write_buffer,
+			     unsigned long write_length);
+
+int host_buffer_is_empty(struct iamt_mei_device *dev);
+
+s32 count_full_read_slots(struct iamt_mei_device *dev);
+
+s32 count_empty_write_slots(struct iamt_mei_device *dev);
+
+int flow_ctrl_creds(struct iamt_mei_device *dev,
+				   struct mei_file_private *file_ext);
+
+int mei_send_wd(struct iamt_mei_device *dev);
+
+void flow_ctrl_reduce(struct iamt_mei_device *dev,
+			 struct mei_file_private *file_ext);
+
+int mei_send_flow_control(struct iamt_mei_device *dev,
+				 struct mei_file_private *file_ext);
+
+int mei_disconnect(struct iamt_mei_device *dev,
+			  struct mei_file_private *file_ext);
+int other_client_is_connecting(struct iamt_mei_device *dev,
+				     struct mei_file_private *file_ext);
+int mei_connect(struct iamt_mei_device *dev,
+		       struct mei_file_private *file_ext);
+
+#endif /* _MEI_INTERFACE_H_ */


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

