Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0KXBRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:17:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:27535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0KXBR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:17:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,245,1288594800"; 
   d="scan'208";a="860781793"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 1/3] Add CPER PCIe error section structure and constants definition
Date: Wed, 24 Nov 2010 09:16:52 +0800
Message-Id: <1290561414-13313-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290561414-13313-1-git-send-email-ying.huang@intel.com>
References: <1290561414-13313-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some machine, PCIe error is reported via APEI (ACPI Platform Error
Interface).  The error data is passed from firmware to Linux via CPER
PCIe error section structure.

This patch adds CPER PCIe error section structure and constants
definition.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/cper.h |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -201,6 +201,67 @@
 	UUID_LE(0x036F84E1, 0x7F37, 0x428c, 0xA7, 0x9E, 0x57, 0x5F,	\
 		0xDF, 0xAA, 0x84, 0xEC)
 
+#define CPER_PROC_VALID_TYPE			0x0001
+#define CPER_PROC_VALID_ISA			0x0002
+#define CPER_PROC_VALID_ERROR_TYPE		0x0004
+#define CPER_PROC_VALID_OPERATION		0x0008
+#define CPER_PROC_VALID_FLAGS			0x0010
+#define CPER_PROC_VALID_LEVEL			0x0020
+#define CPER_PROC_VALID_VERSION			0x0040
+#define CPER_PROC_VALID_BRAND_INFO		0x0080
+#define CPER_PROC_VALID_ID			0x0100
+#define CPER_PROC_VALID_TARGET_ADDRESS		0x0200
+#define CPER_PROC_VALID_REQUESTOR_ID		0x0400
+#define CPER_PROC_VALID_RESPONDER_ID		0x0800
+#define CPER_PROC_VALID_IP			0x1000
+
+#define CPER_MEM_VALID_ERROR_STATUS		0x0001
+#define CPER_MEM_VALID_PHYSICAL_ADDRESS		0x0002
+#define CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK	0x0004
+#define CPER_MEM_VALID_NODE			0x0008
+#define CPER_MEM_VALID_CARD			0x0010
+#define CPER_MEM_VALID_MODULE			0x0020
+#define CPER_MEM_VALID_BANK			0x0040
+#define CPER_MEM_VALID_DEVICE			0x0080
+#define CPER_MEM_VALID_ROW			0x0100
+#define CPER_MEM_VALID_COLUMN			0x0200
+#define CPER_MEM_VALID_BIT_POSITION		0x0400
+#define CPER_MEM_VALID_REQUESTOR_ID		0x0800
+#define CPER_MEM_VALID_RESPONDER_ID		0x1000
+#define CPER_MEM_VALID_TARGET_ID		0x2000
+#define CPER_MEM_VALID_ERROR_TYPE		0x4000
+
+#define CPER_PCIE_VALID_PORT_TYPE		0x0001
+#define CPER_PCIE_VALID_VERSION			0x0002
+#define CPER_PCIE_VALID_COMMAND_STATUS		0x0004
+#define CPER_PCIE_VALID_DEVICE_ID		0x0008
+#define CPER_PCIE_VALID_SERIAL_NUMBER		0x0010
+#define CPER_PCIE_VALID_BRIDGE_CONTROL_STATUS	0x0020
+#define CPER_PCIE_VALID_CAPABILITY		0x0040
+#define CPER_PCIE_VALID_AER_INFO		0x0080
+
+#define CPER_PCIE_VERSION_MINOR			0
+#define CPER_PCIE_VERSION_MAJOR			1
+
+#define CPER_PCIE_COMMAND_REG			0
+#define CPER_PCIE_STATUS_REG			1
+
+#define CPER_PCIE_DEVID_VENDOR_ID		0
+#define CPER_PCIE_DEVID_DEVICE_ID		2
+#define CPER_PCIE_DEVID_CLASS_CODE		4
+#define CPER_PCIE_DEVID_FUNC			7
+#define CPER_PCIE_DEVID_DEV			8
+#define CPER_PCIE_DEVID_SEGMENT			9
+#define CPER_PCIE_DEVID_BUS_PRIMARY		11
+#define CPER_PCIE_DEVID_BUS_SECONDARY		12
+#define CPER_PCIE_DEVID_SLOT			13
+
+#define CPER_PCIE_SERIAL_NUMBER_LOW		0
+#define CPER_PCIE_SERIAL_NUMBER_HIGH		1
+
+#define CPER_PCIE_BRIDGE_SECONDARY_STATUS_REG	0
+#define CPER_PCIE_BRIDGE_CONTROL_REG		1
+
 /*
  * All tables and structs must be byte-packed to match CPER
  * specification, since the tables are provided by the system BIOS
@@ -306,6 +367,19 @@ struct cper_sec_mem_err {
 	__u8	error_type;
 };
 
+struct cper_sec_pcie {
+	__u64	validation_bits;
+	__u32	port_type;
+	__u8	version[4];
+	__u16	command_status[2];
+	__u32	reserved;
+	__u8	device_id[16];
+	__u32	serial_number[2];
+	__u16	bridge_control_status[2];
+	__u8	capability[60];
+	__u8	aer_info[96];
+};
+
 /* Reset to default packing */
 #pragma pack()
 
