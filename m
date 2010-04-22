Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0DVT7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:48 -0400
Received: from kroah.org ([198.145.64.141]:59425 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0DVT7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.000383691@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Fleming <matt@console-pimps.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [012/139] sh: Enable the mmu in start_secondary()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Fleming <matt@console-pimps.org>

commit 4bea3418c737891894b9d3d3e9f8bbd67d66fa38 upstream.

For the boot, enable_mmu() is called from setup_arch() but we don't call
setup_arch() for any of the other cpus. So turn on the non-boot cpu's
mmu inside of start_secondary().

I noticed this bug on an SMP board when trying to map I/O memory
(smsc911x registers) into the kernel address space. Since the Address
Translation bit in MMUCR wasn't set, accessing the virtual address where
the smsc911x registers were supposedly mapped actually performed a
physical address access.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -69,6 +69,7 @@ asmlinkage void __cpuinit start_secondar
 	unsigned int cpu;
 	struct mm_struct *mm = &init_mm;
 
+	enable_mmu();
 	atomic_inc(&mm->mm_count);
 	atomic_inc(&mm->mm_users);
 	current->active_mm = mm;


