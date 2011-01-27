Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1A0DOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:14:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1A0DOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Jt0MNExRSAXVBUKZzOHg2+l9rYMHhELuyKu989Q24MQnwZoCUqhJl1iKXDp/T1Wni1
         EPlPC2mL9YzWlLB8qBOg==
Date: Wed, 26 Jan 2011 19:14:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/4] x86: only compile 8237A if CONFIG_ISA_DMA_API is
 enabled
In-Reply-To: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1101261913060.7809@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8237A utilizes the interface provided by CONFIG_ISA_DMA_API, specifically
claim_dma_lock() and release_dma_lock().  Thus, there's a strict
dependency on the config option and the module should only be loaded if
the kernel supports ISA-style DMA.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -41,12 +41,13 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
-obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
+obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
+obj-$(CONFIG_ISA_DMA_API)	+= i8237.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
