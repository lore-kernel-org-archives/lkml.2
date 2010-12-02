Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0LBCCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:02:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:63861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab0LBCCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="863371775"
Subject: [patch 3/3]use new macros for x86 percpu readmostly section
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
        sam@ravnborg.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:02:30 +0800
Message-ID: <1291255350.12777.117.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new macros to correctly align percpu readmostly data.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-02 09:48:44.000000000 +0800
+++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-02 09:54:24.000000000 +0800
@@ -226,7 +226,7 @@ SECTIONS
 	 * output PHDR, so the next output section - .init.text - should
 	 * start another segment - init.
 	 */
-	PERCPU_VADDR(0, :percpu)
+	PERCPU_VADDR_CACHEALIGNED(0, :percpu, INTERNODE_CACHE_BYTES)
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)
@@ -301,7 +301,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU_CACHEALIGNED(THREAD_SIZE, INTERNODE_CACHE_BYTES)
 #endif
 
 	. = ALIGN(PAGE_SIZE);


