Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0JNXS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:58 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:26941 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0JNXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:54 -0400
Subject: [PATCH v4 6/6] x86: allocate space within a region top-down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Oct 2010 17:18:52 -0600
Message-ID: <20101014231852.536.42958.stgit@bob.kio>
In-Reply-To: <20101014231804.536.62138.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Request that allocate_resource() use available space from high addresses
first, rather than the default of using low addresses first.

The most common place this makes a difference is when we move or assign
new PCI device resources.  Low addresses are generally scarce, so it's
better to use high addresses when possible.  This follows Windows practice
for PCI allocation.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 922b5a1..0fe76df 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -788,6 +788,7 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	resource_alloc_from_bottom = 0;
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();

