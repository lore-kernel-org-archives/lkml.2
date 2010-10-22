Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0JVXyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0JVXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HOH7RXisfL88ndsjlngcvnXirQFvMpZCc8HiRDgwkWvVpR0RRB6sOspsVPszu6QMK4
         OqXtr2RGF7mEtohbxRgkT93m9CwTwBMnhzmKJNDIKiEN4pvHEsuks7osRjk1jxeFTZKd
         FdzeNP92aePoKnNAkWRMA/Ee7shEVfqJ40nXs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maximlevitky@gmail.com>
Subject: [PATCH 01/29] memstick: core: header cleanups
Date: Sat, 23 Oct 2010 01:53:29 +0200
Message-Id: <1287791637-10329-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Replace the __attribute__((packed)) with __packed
* Add struct mspro_cmdex_argument, argument for MS_TPC_EX_SET_CMD
* Increase size of inline buffer in memstick_request to 32
because thats the size of registers and someone might need to read them
all. That structure is allocated one per memstick host, so its size
doesn't matter.

* Add comments about few members of memstick_request

Signed-off-by: Maxim Levitsky <maximlevitky@gmail.com>
---
 include/linux/memstick.h |   50 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 690c35a..5479f7d 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -45,14 +45,14 @@ struct ms_status_register {
 #define MEMSTICK_STATUS1_DTER 0x20
 #define MEMSTICK_STATUS1_FB1  0x40
 #define MEMSTICK_STATUS1_MB   0x80
-} __attribute__((packed));
+} __packed;
 
 struct ms_id_register {
 	unsigned char type;
 	unsigned char if_mode;
 	unsigned char category;
 	unsigned char class;
-} __attribute__((packed));
+} __packed;
 
 struct ms_param_register {
 	unsigned char system;
@@ -68,7 +68,7 @@ struct ms_param_register {
 #define MEMSTICK_CP_OVERWRITE 0x80
 
 	unsigned char page_address;
-} __attribute__((packed));
+} __packed;
 
 struct ms_extra_data_register {
 	unsigned char  overwrite_flag;
@@ -84,7 +84,7 @@ struct ms_extra_data_register {
 #define MEMSTICK_MANAGEMENT_SCMS0  0x20
 
 	unsigned short logical_address;
-} __attribute__((packed));
+} __packed;
 
 struct ms_register {
 	struct ms_status_register     status;
@@ -92,7 +92,7 @@ struct ms_register {
 	unsigned char                 reserved[8];
 	struct ms_param_register      param;
 	struct ms_extra_data_register extra_data;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_param_register {
 	unsigned char  system;
@@ -103,7 +103,7 @@ struct mspro_param_register {
 	__be16 data_count;
 	__be32 data_address;
 	unsigned char  tpc_param;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_info_register {
 	unsigned char version;
@@ -111,20 +111,28 @@ struct mspro_io_info_register {
 	unsigned char current_req;
 	unsigned char card_opt_info;
 	unsigned char rdy_wait_time;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_func_register {
 	unsigned char func_enable;
 	unsigned char func_select;
 	unsigned char func_intmask;
 	unsigned char transfer_mode;
-} __attribute__((packed));
+} __packed;
 
 struct mspro_io_cmd_register {
 	unsigned short tpc_param;
 	unsigned short data_count;
 	unsigned int   data_address;
-} __attribute__((packed));
+} __packed;
+
+
+struct mspro_cmdex_argument {
+	unsigned char  command;
+	__be16 data_count;
+	__be32 data_address;
+} __packed;
+
 
 struct mspro_register {
 	struct ms_status_register     status;
@@ -138,14 +146,14 @@ struct mspro_register {
 	struct mspro_io_cmd_register  io_cmd;
 	unsigned char                 io_int;
 	unsigned char                 io_int_func;
-} __attribute__((packed));
+} __packed;
 
 struct ms_register_addr {
 	unsigned char r_offset;
 	unsigned char r_length;
 	unsigned char w_offset;
 	unsigned char w_length;
-} __attribute__((packed));
+} __packed;
 
 enum memstick_tpc {
 	MS_TPC_READ_MG_STATUS   = 0x01,
@@ -236,6 +244,24 @@ struct memstick_device_id {
 #define MEMSTICK_CLASS_WP             0x03
 };
 
+/* IO request that host driver gets from memtick core
+ *
+ * Note about the 'need_card_int' flag:
+
+ * In serial mode that flag _hints_ the host driver to wait till card
+ * raises the INT signal, so that core could spare sending redundant
+ * MS_TPC_GET_INT requests.
+ *
+ * In _parallel_ mode, that flag must be honored,
+ * and besides waiting, the host driver must read the INT register
+ * (via data lines)
+ *
+ * In addition to that if hardware is 'smart', and is able to read
+ * the INT register even in serial mode by sending MS_TPC_GET_INT
+ * by itself (This capablility is indicated by host via
+ * MEMSTICK_CAP_AUTO_GET_INT),
+ * then the serial mode behavier must match the parallel.
+ */
 struct memstick_request {
 	unsigned char tpc;
 	unsigned char data_dir:1,
@@ -247,7 +273,7 @@ struct memstick_request {
 		struct scatterlist sg;
 		struct {
 			unsigned char data_len;
-			unsigned char data[15];
+			unsigned char data[32];
 		};
 	};
 };
-- 
1.7.1

