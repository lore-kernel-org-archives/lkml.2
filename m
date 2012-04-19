Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2DSUN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:13:26 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51073 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2DSUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:13:24 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 01:42:59 +0530
Message-Id: <20120419201256.5411.59675.sendpatchset@codeblue>
In-Reply-To: <20120419201209.5411.43877.sendpatchset@codeblue>
References: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 2/12]  x86/ticketlock: don't inline _spin_unlock when using paravirt spinlocks
x-cbid: 12041910-6102-0000-0000-00000147F3D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 

The code size expands somewhat, and its better to just call
a function rather than inline it.

Thanks Jeremy for original version of ARCH_NOINLINE_SPIN_UNLOCK config patch, 
which is simplified.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..35eb2e4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -597,6 +597,7 @@ config PARAVIRT
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP && EXPERIMENTAL
+	select UNINLINE_SPIN_UNLOCK
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly

