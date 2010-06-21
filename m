Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0FUJbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:31:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:9000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab0FUJbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:31:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="809869421"
Subject: [PATCH V2 5/5] ara virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 21 Jun 2010 17:31:49 +0800
Message-Id: <1277112709.2096.513.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 5th patch is applied to the latest qemu-kvm tree.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup qemu-kvm_0621/kvm/include/linux/kvm.h qemu-kvm_0621_perf/kvm/include/linux/kvm.h
--- qemu-kvm_0621/kvm/include/linux/kvm.h	2010-06-21 11:00:28.000000000 +0800
+++ qemu-kvm_0621_perf/kvm/include/linux/kvm.h	2010-06-21 13:23:51.537999849 +0800
@@ -530,6 +530,7 @@ struct kvm_enable_cap {
 #ifdef __KVM_HAVE_XCRS
 #define KVM_CAP_XCRS 56
 #endif
+#define KVM_CAP_PV_PERF 57
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff -Nraup qemu-kvm_0621/kvm/include/x86/asm/kvm_para.h qemu-kvm_0621_perf/kvm/include/x86/asm/kvm_para.h
--- qemu-kvm_0621/kvm/include/x86/asm/kvm_para.h	2010-06-21 11:00:28.000000000 +0800
+++ qemu-kvm_0621_perf/kvm/include/x86/asm/kvm_para.h	2010-06-21 13:27:04.375999849 +0800
@@ -15,6 +15,7 @@
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
+#define KVM_FEATURE_PV_PERF		4
 
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
diff -Nraup qemu-kvm_0621/target-i386/kvm.c qemu-kvm_0621_perf/target-i386/kvm.c
--- qemu-kvm_0621/target-i386/kvm.c	2010-06-21 11:00:29.000000000 +0800
+++ qemu-kvm_0621_perf/target-i386/kvm.c	2010-06-21 13:00:14.136999850 +0800
@@ -150,6 +150,9 @@ struct kvm_para_features {
 #ifdef KVM_CAP_PV_MMU
         { KVM_CAP_PV_MMU, KVM_FEATURE_MMU_OP },
 #endif
+#ifdef KVM_CAP_PV_PERF
+        { KVM_CAP_PV_PERF, KVM_FEATURE_PV_PERF },
+#endif
         { -1, -1 }
 };


