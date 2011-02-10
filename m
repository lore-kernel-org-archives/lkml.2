Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1BJJ4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:56:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:7779 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab1BJJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:30 -0500
Message-Id: <0d30dc$l1ditu@orsmga001.jf.intel.com>
Date: 10 Feb 2011 01:55:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="706137027"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 11/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/mei.h b/drivers/char/mei/mei.h
new file mode 100644
index 0000000..7114a87
--- /dev/null
+++ b/drivers/char/mei/mei.h
@@ -0,0 +1,166 @@
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
+#ifndef _MEI_H_
+#define _MEI_H_
+
+#include <linux/interrupt.h>
+#include "hw.h"
+
+
+#define CONNECT_TIMEOUT        15	/* HPS definition */
+#define INIT_CLIENTS_TIMEOUT   15	/* HPS definition */
+
+extern const struct guid mei_pthi_guid;
+extern const struct guid mei_wd_guid;
+extern const u8 mei_start_wd_params[];
+extern const u8 mei_stop_wd_params[];
+extern const u8 mei_wd_state_independence_msg[3][4];
+
+
+/*
+ * mei device ID
+ */
+#define    MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
+#define    MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
+#define    MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
+#define    MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
+
+#define    MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
+#define    MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
+
+#define    MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
+#define    MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
+#define    MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
+#define    MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
+#define    MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
+
+#define    MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
+
+#define    MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
+
+#define    MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
+
+#define    MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
+#define    MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
+
+#define    MEI_DEV_ID_CPT_1	 0x1C3A    /* Cougerpoint */
+#define    MEI_DEV_ID_PBG_1	 0x1D3A    /* PBG */
+
+
+/*
+ * mei init function prototypes
+ */
+struct iamt_mei_device *init_mei_device(struct pci_dev *pdev);
+void mei_reset(struct iamt_mei_device *dev, int interrupts);
+int mei_hw_init(struct iamt_mei_device *dev);
+int mei_task_initialize_clients(void *data);
+int mei_initialize_clients(struct iamt_mei_device *dev);
+struct mei_file_private *mei_alloc_file_private(struct file *file);
+int mei_disconnect_host_client(struct iamt_mei_device *dev,
+				struct mei_file_private *file_ext);
+void mei_initialize_list(struct io_mei_list *list,
+			  struct iamt_mei_device *dev);
+void mei_flush_list(struct io_mei_list *list,
+		     struct mei_file_private *file_ext);
+void mei_flush_queues(struct iamt_mei_device *dev,
+		       struct mei_file_private *file_ext);
+
+void mei_remove_client_from_file_list(struct iamt_mei_device *dev,
+				       u8 host_client_id);
+void mei_check_asf_mode(struct iamt_mei_device *dev);
+void host_start_message(struct iamt_mei_device *dev);
+void host_enum_clients_message(struct iamt_mei_device *dev);
+void allocate_me_clients_storage(struct iamt_mei_device *dev);
+void host_client_properties(struct iamt_mei_device *dev);
+void host_init_wd(struct iamt_mei_device *dev);
+void host_init_iamthif(struct iamt_mei_device *dev);
+
+/*
+ *  interrupt functions prototype
+ */
+irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id);
+irqreturn_t  mei_interrupt_thread_handler(int irq, void *dev_id);
+void mei_wd_timer(struct work_struct *work);
+
+/*
+ *  input output function prototype
+ */
+int mei_ioctl_get_version(struct iamt_mei_device *dev, int if_num,
+			   struct mei_message_data __user *u_msg,
+			   struct mei_message_data k_msg,
+			   struct mei_file_private *file_ext);
+
+int mei_ioctl_connect_client(struct iamt_mei_device *dev, int if_num,
+			      struct mei_message_data __user *u_msg,
+			      struct mei_message_data k_msg,
+			      struct file *file);
+
+int mei_ioctl_wd(struct iamt_mei_device *dev, int if_num,
+		  struct mei_message_data k_msg,
+		  struct mei_file_private *file_ext);
+
+int mei_ioctl_bypass_wd(struct iamt_mei_device *dev, int if_num,
+		  struct mei_message_data k_msg,
+		  struct mei_file_private *file_ext);
+
+int mei_start_read(struct iamt_mei_device *dev, int if_num,
+		    struct mei_file_private *file_ext);
+
+int pthi_write(struct iamt_mei_device *dev,
+	       struct mei_cb_private *priv_cb);
+
+int pthi_read(struct iamt_mei_device *dev, int if_num, struct file *file,
+	      char __user *ubuf, size_t length, loff_t *offset);
+
+struct mei_cb_private *find_pthi_read_list_entry(
+			struct iamt_mei_device *dev,
+			struct file *file);
+
+void run_next_iamthif_cmd(struct iamt_mei_device *dev);
+
+void mei_free_cb_private(struct mei_cb_private *priv_cb);
+
+/**
+ * mei_fe_same_id - tells if file private data have same id
+ *
+ * @fe1: private data of 1. file object
+ * @fe2: private data of 2. file object
+ *
+ * returns !=0 - if ids are the same, 0 - if differ.
+ */
+static inline int mei_fe_same_id(const struct mei_file_private *fe1,
+				  const struct mei_file_private *fe2)
+{
+	return ((fe1->host_client_id == fe2->host_client_id)
+		&& (fe1->me_client_id == fe2->me_client_id));
+}
+#endif /* _MEI_H_ */


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

