Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0JNXSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:34095 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab0JNXSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:48 -0400
Subject: [PATCH v4 5/6] x86: update iomem_resource end based on CPU physical
	address capabilities
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
Date: Thu, 14 Oct 2010 17:18:47 -0600
Message-ID: <20101014231847.536.8000.stgit@bob.kio>
In-Reply-To: <20101014231804.536.62138.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The iomem_resource map reflects the available physical address space.
We statically initialize the end to -1, i.e., 0xffffffff_ffffffff, but
of course we can only use as much as the CPU can address.

This patch updates the end based on the CPU capabilities, so we don't
mistakenly allocate space that isn't usable, as we're likely to do when
allocating from the top-down.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c3a4fbb..922b5a1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -788,6 +788,7 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */

