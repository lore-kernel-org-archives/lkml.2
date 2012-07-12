Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2GLTT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:19:57 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56790 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab2GLTTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:19:50 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 13 Jul 2012 00:47:39 +0530
Message-Id: <20120712191733.30440.48744.sendpatchset@codeblue>
In-Reply-To: <20120712191712.30440.68944.sendpatchset@codeblue>
References: <20120712191712.30440.68944.sendpatchset@codeblue>
Subject: [PATCH RFC V3 1/3] kvm/config: Add config to support ple or cpu relax optimzation
x-cbid: 12071209-6102-0000-0000-000001DEBD22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 arch/s390/kvm/Kconfig |    1 +
 arch/x86/kvm/Kconfig  |    1 +
 virt/kvm/Kconfig      |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 78eb984..a6e2677 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	depends on HAVE_KVM && EXPERIMENTAL
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a28f338..45c044f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -37,6 +37,7 @@ config KVM
 	select TASK_DELAY_ACCT
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
+	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 28694f4..d01b24b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -21,3 +21,6 @@ config KVM_ASYNC_PF
 
 config HAVE_KVM_MSI
        bool
+
+config HAVE_KVM_CPU_RELAX_INTERCEPT
+       bool

