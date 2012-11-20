Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2KTPTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:19:52 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2KTPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:15 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 03/11] xen: Introduce architecture independent data for kexec/kdump
Date: Tue, 20 Nov 2012 16:04:45 +0100
Message-Id: <1353423893-23125-4-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.415109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce architecture independent constants and structures
required by Xen kexec/kdump implementation.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 include/xen/interface/xen.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 886a5d8..09c16ab 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -57,6 +57,7 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+#define __HYPERVISOR_kexec_op             37
 #define __HYPERVISOR_tmem_op              38
 
 /* Architecture-specific hypercall definitions. */
@@ -231,7 +232,39 @@ DEFINE_GUEST_HANDLE_STRUCT(mmuext_op);
 #define VMASST_TYPE_pae_extended_cr3     3
 #define MAX_VMASST_TYPE 3
 
+/*
+ * Commands to HYPERVISOR_kexec_op().
+ */
+#define KEXEC_CMD_kexec			0
+#define KEXEC_CMD_kexec_load		1
+#define KEXEC_CMD_kexec_unload		2
+#define KEXEC_CMD_kexec_get_range	3
+
+/*
+ * Memory ranges for kdump (utilized by HYPERVISOR_kexec_op()).
+ */
+#define KEXEC_RANGE_MA_CRASH		0
+#define KEXEC_RANGE_MA_XEN		1
+#define KEXEC_RANGE_MA_CPU		2
+#define KEXEC_RANGE_MA_XENHEAP		3
+#define KEXEC_RANGE_MA_BOOT_PARAM	4
+#define KEXEC_RANGE_MA_EFI_MEMMAP	5
+#define KEXEC_RANGE_MA_VMCOREINFO	6
+
 #ifndef __ASSEMBLY__
+struct xen_kexec_exec {
+	int type;
+};
+
+struct xen_kexec_range {
+	int range;
+	int nr;
+	unsigned long size;
+	unsigned long start;
+};
+
+extern unsigned long xen_vmcoreinfo_maddr;
+extern unsigned long xen_vmcoreinfo_max_size;
 
 typedef uint16_t domid_t;
 
-- 
1.5.6.5

