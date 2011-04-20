Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1DTIkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:40:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53144 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1DTIk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:40:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
In-Reply-To: <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
Message-Id: <20110420174027.4631.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 17:40:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > btw, x86 don't have an issue. Probably it's a reason why this issue was neglected
> > long time.
> >
> > arch/x86/Kconfig
> > -------------------------------------
> > config ARCH_DISCONTIGMEM_ENABLE
> >        def_bool y
> >        depends on NUMA && X86_32
> 
> That part makes me think the best option is to make parisc do
> CONFIG_NUMA as well regardless of the historical intent was.
> 
>                         Pekka

This?

compile test only.

---
 arch/parisc/Kconfig            |    7 +++++++
 include/asm-generic/topology.h |    4 ----
 include/linux/topology.h       |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 69ff049..0bf9ae8 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -229,6 +229,12 @@ config HOTPLUG_CPU
 	default y if SMP
 	select HOTPLUG
 
+config NUMA
+	bool "NUMA support"
+	help
+	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
+	  Access).
+
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on 64BIT
@@ -236,6 +242,7 @@ config ARCH_SELECT_MEMORY_MODEL
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
 	depends on 64BIT
+	depends on NUMA
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index fc824e2..932567b 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -27,8 +27,6 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
-#ifndef	CONFIG_NUMA
-
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -60,8 +58,6 @@
 				 cpumask_of_node(pcibus_to_node(bus)))
 #endif
 
-#endif	/* CONFIG_NUMA */
-
 #if !defined(CONFIG_NUMA) || !defined(CONFIG_HAVE_MEMORYLESS_NODES)
 
 #ifndef set_numa_mem
diff --git a/include/linux/topology.h b/include/linux/topology.h
index b91a40e..e1e535b 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -209,7 +209,7 @@ int arch_update_cpu_topology(void);
 
 #ifdef CONFIG_NUMA
 #ifndef SD_NODE_INIT
-#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
+#define SD_NODE_INIT SD_ALLNODES_INIT
 #endif
 
 #endif /* CONFIG_NUMA */
-- 
1.7.3.1




