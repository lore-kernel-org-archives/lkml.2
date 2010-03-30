Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0C3XWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:22:31 -0400
Received: from kroah.org ([198.145.64.141]:46560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab0C3XV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:26 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:36 2010
Message-Id: <20100330224836.278595019@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [116/156] sparc64: Properly truncate pt_regs framepointer in perf callback.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 9e8307ecaf9f8c8b5b3b22145021204c4e73114a ]

For 32-bit processes, we save the full 64-bits of the regs in pt_regs.

But unlike when the userspace actually does load and store
instructions, the top 32-bits don't get automatically truncated by the
cpu in kernel mode (because the kernel doesn't execute with PSTATE_AM
address masking enabled).

So we have to do it by hand.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1337,7 +1337,7 @@ static void perf_callchain_user_32(struc
 	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->tpc);
 
-	ufp = regs->u_regs[UREG_I6];
+	ufp = regs->u_regs[UREG_I6] & 0xffffffffUL;
 	do {
 		struct sparc_stackf32 *usf, sf;
 		unsigned long pc;


