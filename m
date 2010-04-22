Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0DVUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:03:06 -0400
Received: from kroah.org ([198.145.64.141]:60058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976Ab0DVUBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.620160182@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [122/139] modules: fix incorrect percpu usage
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Mainline does not need this fix, as commit
259354deaaf03d49a02dbb9975d6ec2a54675672 fixed the problem by refactoring.

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
for per cpu pointers).

Introduced by commit:

module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3

This patch should be queued for the stable branch, for kernels 2.6.29.x to
2.6.33.x.  (tested on 2.6.33.1 x86_64)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -405,7 +405,7 @@ static void percpu_modcopy(void *pcpudes
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+		memcpy(per_cpu_ptr(pcpudest, cpu), from, size);
 }
 
 #else /* ... !CONFIG_SMP */


