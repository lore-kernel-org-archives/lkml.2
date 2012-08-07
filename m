Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab2HGHnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:43:11 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58054 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2HGHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:42:47 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 <x86@kernel.org>
Date: Tue, 07 Aug 2012 13:09:59 +0530
Message-Id: <20120807073959.20169.86246.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
References: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH 1/3] Documentation/kvm : Add documentation on hypercalls
x-cbid: 12080707-1396-0000-0000-000001AD15DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ,
and Peter (HPA) for suggesting hypercall ABI addition.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
TODO: We need to add history details of each hypercall as suggested by HPA,
which I could not trace easily. Hope it is easy for hypercall authors

 Documentation/virtual/kvm/hypercalls.txt |   66 ++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/virtual/kvm/hypercalls.txt

diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
new file mode 100644
index 0000000..ea113b5
--- /dev/null
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -0,0 +1,66 @@
+Linux KVM Hypercall:
+===================
+X86:
+ KVM Hypercalls have a three-byte sequence of either the vmcall or the vmmcall
+ instruction. The hypervisor can replace it with instructions that are
+ guaranteed to be supported.
+
+ Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
+ The hypercall number should be placed in rax and the return value will be
+ placed in rax.  No other registers will be clobbered unless explicitly stated
+ by the particular hypercall.
+
+S390:
+  R2-R7 are used for parameters 1-6. In addition, R1 is used for hypercall
+  number. The return value is written to R2.
+
+  S390 uses diagnose instruction as hypercall (0x500) along with hypercall
+  number in R1.
+
+ PowerPC:
+  It uses R3-R10 and hypercall number in R11. R4-R11 are used as output registers.
+  Return value is placed in R3.
+
+  KVM hypercalls uses 4 byte opcode, that are patched with 'hypercall-instructions'
+  property inside the device tree's /hypervisor node.
+  For more information refer to Documentation/virtual/kvm/ppc-pv.txt
+
+KVM Hypercalls Documentation
+===========================
+The template for each hypercall is:
+1. Hypercall name.
+2. Architecture(s)
+3. Status (deprecated, obsolete, active)
+4. Purpose
+
+1. KVM_HC_VAPIC_POLL_IRQ
+------------------------
+Architecture: x86
+Status: active
+Purpose: Trigger guest exit so that the host can check for pending
+interrupts on reentry.
+
+2. KVM_HC_MMU_OP
+------------------------
+Architecture: x86
+Status: deprecated.
+Purpose: Support MMU operations such as writing to PTE,
+flushing TLB, release PT.
+
+3. KVM_HC_FEATURES
+------------------------
+Architecture: PPC
+Status: active
+Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
+used to enumerate which hypercalls are available. On PPC, either device tree
+based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
+mechanism (which is this hypercall) can be used.
+
+4. KVM_HC_PPC_MAP_MAGIC_PAGE
+------------------------
+Architecture: PPC
+Status: active
+Purpose: To enable communication between the hypervisor and guest there is a
+shared page that contains parts of supervisor visible register state.
+The guest can map this shared page to access its supervisor register through
+memory using this hypercall.

