Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2ANS1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:27:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52235 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab2ANS1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:27:31 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Glauber Costa <glommer@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Rik van Riel <riel@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Landley <rlandley@parallels.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Paul Mackerras <paulus@samba.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 23:57:11 +0530
Message-Id: <20120114182710.8604.22277.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20120114182501.8604.68416.sendpatchset@oc5400248562.ibm.com>
References: <20120114182501.8604.68416.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V4 5/5] Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
x-cbid: 12011418-8974-0000-0000-0000053921CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation on CPUID, KVM_CAP_PVLOCK_KICK, and Hypercalls supported.

KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in
paravirtual spinlock enabled guest.

KVM_FEATURE_PVLOCK_KICK enables guest to check whether pv spinlock can
be enabled in guest. support in host is queried via
ioctl(KVM_CHECK_EXTENSION, KVM_CAP_PVLOCK_KICK)

A minimal Documentation and template is added for hypercalls.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e2a4b52..1583bc7 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1109,6 +1109,13 @@ support.  Instead it is reported via
 if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
 feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
 
+Paravirtualized ticket spinlocks can be enabled in guest by checking whether
+support exists in host via,
+
+  ioctl(KVM_CHECK_EXTENSION, KVM_CAP_PVLOCK_KICK)
+
+if this call return true, guest can use the feature.
+
 4.47 KVM_PPC_GET_PVINFO
 
 Capability: KVM_CAP_PPC_GET_PVINFO
diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 8820685..c7fc0da 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -39,6 +39,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_PVLOCK_KICK            ||     6 || guest checks this feature bit
+                                   ||       || before enabling paravirtualized
+                                   ||       || spinlock support.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
new file mode 100644
index 0000000..7872da5
--- /dev/null
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -0,0 +1,54 @@
+KVM Hypercalls Documentation
+===========================
+Template for documentation is
+The documenenation for hypercalls should inlcude
+1. Hypercall name, value.
+2. Architecture(s)
+3. Purpose
+
+
+1. KVM_HC_VAPIC_POLL_IRQ
+------------------------
+value: 1
+Architecture: x86
+Purpose:
+
+2. KVM_HC_MMU_OP
+------------------------
+value: 2
+Architecture: x86
+Purpose: Support MMU operations such as writing to PTE,
+flushing TLB, release PT.
+
+3. KVM_HC_FEATURES
+------------------------
+value: 3
+Architecture: PPC
+Purpose:
+
+4. KVM_HC_PPC_MAP_MAGIC_PAGE
+------------------------
+value: 4
+Architecture: PPC
+Purpose: To enable communication between the hypervisor and guest there is a
+new shared page that contains parts of supervisor visible register state.
+The guest can map this shared page using this hypercall.
+
+5. KVM_HC_KICK_CPU
+------------------------
+value: 5
+Architecture: x86
+Purpose: Hypercall used to wakeup a vcpu from HLT state
+
+Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
+kernel mode for an event to occur (ex: a spinlock to become available)
+can execute HLT instruction once it has busy-waited for more than a
+threshold time-interval. Execution of HLT instruction would cause
+the hypervisor to put the vcpu to sleep (unless yield_on_hlt=0) until occurence
+of an appropriate event. Another vcpu of the same guest can wakeup the sleeping
+vcpu by issuing KVM_HC_KICK_CPU hypercall, specifying APIC ID of the vcpu to be
+wokenup.
+
+TODO:
+1. more information on input and output needed?
+2. Add more detail to purpose of hypercalls.

