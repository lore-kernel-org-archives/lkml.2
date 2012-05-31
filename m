Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2EaICi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:02:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53432 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2EaIC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:02:26 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Date: Thu, 31 May 2012 13:31:16 +0530
Message-Id: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH] Documentation/kvm : Add documentation on Hypercalls
x-cbid: 12053108-9574-0000-0000-000002FDE15E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 

Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ 

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
new file mode 100644
index 0000000..c79335a
--- /dev/null
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -0,0 +1,46 @@
+KVM Hypercalls Documentation
+===========================
+The template for each hypercall is:
+1. Hypercall name, value.
+2. Architecture(s)
+3. Status (deprecated, obsolete, active)
+4. Purpose
+
+1. KVM_HC_VAPIC_POLL_IRQ
+------------------------
+Value: 1
+Architecture: x86
+Purpose: Trigger guest exit so that the host can check for pending
+interrupts on reentry.
+
+2. KVM_HC_MMU_OP
+------------------------
+Value: 2
+Architecture: x86
+Status: deprecated.
+Purpose: Support MMU operations such as writing to PTE,
+flushing TLB, release PT.
+
+3. KVM_HC_FEATURES
+------------------------
+Value: 3
+Architecture: PPC
+Status: active
+Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
+used to enumerate which hypercalls are available. On PPC, either device tree
+based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
+mechanism (which is this hypercall) can be used.
+
+4. KVM_HC_PPC_MAP_MAGIC_PAGE
+------------------------
+Value: 4
+Architecture: PPC
+Status: active
+Purpose: To enable communication between the hypervisor and guest there is a
+shared page that contains parts of supervisor visible register state.
+The guest can map this shared page to access its supervisor register through
+memory using this hypercall.
+
+TODO:
+1. more information on input and output needed?
+2. Add more detail to purpose of hypercalls.

