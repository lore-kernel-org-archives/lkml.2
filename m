Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0IWDoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:44:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39908 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0IWDoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:44:16 -0400
Date: Thu, 23 Sep 2010 13:44:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: linux-next: manual merge of the tip tree with the slab tree
Message-Id: <20100923134414.7aa7f696.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/percpu.h between commit
6fc80ef491b981f59233beaf6aeaccc0c947031d ("percpu: use percpu allocator
on UP too") from the slab tree and commit
8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57 ("percpu: Add {get,put}
_cpu_ptr") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/percpu.h
index aeeeef1,0eb5083..0000000
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@@ -39,8 -39,19 +39,17 @@@
  	preempt_enable();				\
  } while (0)
  
+ #define get_cpu_ptr(var) ({				\
+ 	preempt_disable();				\
+ 	this_cpu_ptr(var); })
+ 
+ #define put_cpu_ptr(var) do {				\
+ 	(void)(var);					\
+ 	preempt_enable();				\
+ } while (0)
+ 
 -#ifdef CONFIG_SMP
 -
  /* minimum unit size, also is the maximum supported allocation size */
 -#define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(64 << 10)
 +#define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(32 << 10)
  
  /*
   * Percpu allocator can serve percpu allocations before slab is
