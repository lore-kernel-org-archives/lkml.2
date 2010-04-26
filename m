Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0DZVls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:41:48 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9260 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0DZVlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:41:47 -0400
Subject: Re: mmotm 2010-04-22-16-38 uploaded
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <31157.1271987879@localhost>
References: <201004230006.o3N06DNO019315@imap1.linux-foundation.org>
	 <31157.1271987879@localhost>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 26 Apr 2010 17:41:19 -0400
Message-Id: <1272318079.16810.44.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 21:57 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 22 Apr 2010 16:38:55 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-04-22-16-38 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Found this in numa-introduce-numa_mem_id-effective-local-memory-node-id.patch:
> 
> +#ifndef cpu_to_mem
> +#define cpu_to_mem(cpu)                (void)(cpu),0)
> +#endif
> 
> The resulting paren mismatch causes an error cascade in 2 other patches:
> 
> numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
> 
> causes build errors:

Thanks, Valdis.  I encountered this error and thought I fixed it before
submitting the series.  Apparently I submitted a stale patch.

Attached patch fixes the problem.

Lee


========================================
Fix to numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
in mmotm 100422-1638

Add missing parenthesis to !NUMA stub cpu_to_mem() definition

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 include/asm-generic/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.34-rc5-mmotm-100422-1638/include/asm-generic/topology.h
===================================================================
--- linux-2.6.34-rc5-mmotm-100422-1638.orig/include/asm-generic/topology.h
+++ linux-2.6.34-rc5-mmotm-100422-1638/include/asm-generic/topology.h
@@ -35,7 +35,7 @@
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #endif
 #ifndef cpu_to_mem
-#define cpu_to_mem(cpu)		(void)(cpu),0)
+#define cpu_to_mem(cpu)		((void)(cpu),0)
 #endif
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)



