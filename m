Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2GPI1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:27:48 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38333 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2GPI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:27:44 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 16 Jul 2012 13:55:00 +0530
Message-Id: <20120716082500.23477.26086.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com>
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V4 1/3] kvm/config: Add config to support ple or cpu relax optimzation
x-cbid: 12071523-3568-0000-0000-00000224065B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Suggested-by: Avi Kivity <avi@redhat.com>
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

