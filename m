Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0ERBrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:47:05 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37604 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0ERBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:47:03 -0400
Subject: [PATCH] numa x86_64 use generic percpu var numa_node_id
 implementation fix3  [was Re: mmotm 2010-05-14-13-33 uploaded]
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100516163754.14cf8bbb.rdunlap@xenotime.net>
References: <201005142101.o4EL1Mf2022381@imap1.linux-foundation.org>
	 <20100516163754.14cf8bbb.rdunlap@xenotime.net>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 17 May 2010 21:46:50 -0400
Message-Id: <1274147210.24007.146.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-16 at 16:37 -0700, Randy Dunlap wrote: 
> include/linux/topology.h:248: error: implicit declaration of function 'cpu_to_node'
> 
> 
> config attached.

Hmmm, i386 NUMA.

With the following patch, your config builds correctly.  !NUMA i386
still builds, as well.

Lee

Fix i386 numa build:  define cpu_to_node() stub same as
early_cpu_to_node() for i386 numa builds.  Just return node
from cpu_to_node_map[].

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 arch/x86/include/asm/topology.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc7-mmotm-100514-1333/arch/x86/include/asm/topology.h
===================================================================
--- linux-2.6.34-rc7-mmotm-100514-1333.orig/arch/x86/include/asm/topology.h	2010-05-17 08:40:47.000000000 -0400
+++ linux-2.6.34-rc7-mmotm-100514-1333/arch/x86/include/asm/topology.h	2010-05-17 10:49:08.000000000 -0400
@@ -53,10 +53,12 @@
 extern int cpu_to_node_map[];
 
 /* Returns the number of the node containing CPU 'cpu' */
-static inline int early_cpu_to_node(int cpu)
+static inline int __cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
+#define early_cpu_to_node __cpu_to_node
+#define cpu_to_node __cpu_to_node
 
 #else /* CONFIG_X86_64 */
 


