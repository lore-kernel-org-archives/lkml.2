Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0GTErJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:47:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46835 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0GTEq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:46:59 -0400
Date: Tue, 20 Jul 2010 14:46:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20100720144657.47ad6afb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/trace/Kconfig between commit
039ca4e74a1cf60bd7487324a564ecf5c981f254 ("tracing: Remove kmemtrace
ftrace plugin") from the tip tree and commit
64166699752006f1a23a9cf7c96ae36654ccfc2c ("workqueue: temporarily remove
workqueue tracing") from the workqueues tree.

Juts context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/Kconfig
index f669092,a0d95c1f..0000000
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@@ -354,17 -371,26 +354,6 @@@ config STACK_TRACE
  
  	  Say N if unsure.
  
- config WORKQUEUE_TRACER
- 	bool "Trace workqueues"
- 	select GENERIC_TRACER
- 	help
- 	  The workqueue tracer provides some statistical information
-           about each cpu workqueue thread such as the number of the
-           works inserted and executed since their creation. It can help
-           to evaluate the amount of work each of them has to perform.
-           For example it can help a developer to decide whether he should
-           choose a per-cpu workqueue instead of a singlethreaded one.
- 
 -config KMEMTRACE
 -	bool "Trace SLAB allocations"
 -	select GENERIC_TRACER
 -	help
 -	  kmemtrace provides tracing for slab allocator functions, such as
 -	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free, etc. Collected
 -	  data is then fed to the userspace application in order to analyse
 -	  allocation hotspots, internal fragmentation and so on, making it
 -	  possible to see how well an allocator performs, as well as debug
 -	  and profile kernel code.
 -
 -	  This requires an userspace application to use. See
 -	  Documentation/trace/kmemtrace.txt for more information.
 -
 -	  Saying Y will make the kernel somewhat larger and slower. However,
 -	  if you disable kmemtrace at run-time or boot-time, the performance
 -	  impact is minimal (depending on the arch the kernel is built for).
 -
 -	  If unsure, say N.
 -
  config BLK_DEV_IO_TRACE
  	bool "Support for tracing block IO actions"
  	depends on SYSFS
