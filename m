Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0LGCWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:22:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:39156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0LGCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:22:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,308,1288594800"; 
   d="scan'208";a="865237963"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v4 1/3] Add CPER PCIe error section structure and constants definition
Date: Tue,  7 Dec 2010 10:22:29 +0800
Message-Id: <1291688551-14395-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291688551-14395-1-git-send-email-ying.huang@intel.com>
References: <1291688551-14395-1-git-send-email-ying.huang@intel.com>
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
 include/linux/cper.h |   86 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 82 insertions(+), 4 deletions(-)

--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -39,10 +39,12 @@
  * Severity difinition for error_severity in struct cper_record_header
  * and section_severity in struct cper_section_descriptor
  */
-#define CPER_SEV_RECOVERABLE			0x0
-#define CPER_SEV_FATAL				0x1
-#define CPER_SEV_CORRECTED			0x2
-#define CPER_SEV_INFORMATIONAL			0x3
+enum {
+	CPER_SEV_RECOVERABLE,
+	CPER_SEV_FATAL,
+	CPER_SEV_CORRECTED,
+	CPER_SEV_INFORMATIONAL,
+};
 
 /*
  * Validation bits difinition for validation_bits in struct
@@ -201,6 +203,47 @@
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
+#define CPER_PCIE_SLOT_SHIFT			3
+
 /*
  * All tables and structs must be byte-packed to match CPER
  * specification, since the tables are provided by the system BIOS
@@ -306,6 +349,41 @@ struct cper_sec_mem_err {
 	__u8	error_type;
 };
 
+struct cper_sec_pcie {
+	__u64		validation_bits;
+	__u32		port_type;
+	struct {
+		__u8	minor;
+		__u8	major;
+		__u8	reserved[2];
+	}		version;
+	__u16		command;
+	__u16		status;
+	__u32		reserved;
+	struct {
+		__u16	vendor_id;
+		__u16	device_id;
+		__u8	class_code[3];
+		__u8	function;
+		__u8	device;
+		__u16	segment;
+		__u8	bus;
+		__u8	secondary_bus;
+		__u16	slot;
+		__u8	reserved;
+	}		device_id;
+	struct {
+		__u32	lower;
+		__u32	upper;
+	}		serial_number;
+	struct {
+		__u16	secondary_status;
+		__u16	control;
+	}		bridge;
+	__u8	capability[60];
+	__u8	aer_info[96];
+};
+
 /* Reset to default packing */
 #pragma pack()
 
