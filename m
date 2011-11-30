Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1K3JAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:00:36 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53369 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab1K3JAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:00:34 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 14:30:19 +0530
Message-Id: <20111130090019.23386.95844.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V3 3/4] kvm guest : Added configuration support to enable debug information for KVM Guests
x-cbid: 11113009-8974-0000-0000-000003C566CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added configuration support to enable debug information
for KVM Guests in debugfs
    
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5d8152d..526e3ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -561,6 +561,15 @@ config KVM_GUEST
 	  This option enables various optimizations for running under the KVM
 	  hypervisor.
 
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST && DEBUG_FS
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+   	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT

