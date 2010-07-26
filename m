Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0GZGQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:16:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52355 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0GZGQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:16:38 -0400
Date: Mon, 26 Jul 2010 11:46:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: avi@redhat.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH RFC 4/4] Add yield hypercall support in Qemu
Message-ID: <20100726061634.GD8402@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726061150.GB21699@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add yield hypercall support in Qemu.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kvm/include/linux/kvm.h        |    1 +
 kvm/include/x86/asm/kvm_para.h |    1 +
 target-i386/kvm.c              |    3 +++
 3 files changed, 5 insertions(+)

Index: qemu-kvm/kvm/include/linux/kvm.h
===================================================================
--- qemu-kvm.orig/kvm/include/linux/kvm.h
+++ qemu-kvm/kvm/include/linux/kvm.h
@@ -499,6 +499,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_PPC_SEGSTATE 43
 
 #define KVM_CAP_PCI_SEGMENT 47
+#define KVM_CAP_YIELD_HYPERCALL 55
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
Index: qemu-kvm/kvm/include/x86/asm/kvm_para.h
===================================================================
--- qemu-kvm.orig/kvm/include/x86/asm/kvm_para.h
+++ qemu-kvm/kvm/include/x86/asm/kvm_para.h
@@ -15,6 +15,7 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+#define KVM_FEATURE_YIELD              4
 
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
Index: qemu-kvm/target-i386/kvm.c
===================================================================
--- qemu-kvm.orig/target-i386/kvm.c
+++ qemu-kvm/target-i386/kvm.c
@@ -147,6 +147,9 @@ struct kvm_para_features {
 #ifdef KVM_CAP_PV_MMU
         { KVM_CAP_PV_MMU, KVM_FEATURE_MMU_OP },
 #endif
+#ifdef KVM_CAP_YIELD_HYPERCALL
+	{ KVM_CAP_YIELD_HYPERCALL, KVM_FEATURE_YIELD },
+#endif
         { -1, -1 }
 };
 
