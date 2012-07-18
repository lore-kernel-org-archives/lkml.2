Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2GRKiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:38:54 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51587 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GRKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:38:52 -0400
Subject: [PATCH RESEND] PPC Hardware Breakpoints: Fix incorrect pointer
 access
To: fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        prasad.krishnan@gmail.com
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        emachado@linux.vnet.ibm.com
Date: Wed, 18 Jul 2012 16:08:18 +0530
Message-ID: <20120718103818.7720.52927.stgit@localhost.localdomain>
In-Reply-To: <20120706113058.8600.30142.stgit@localhost.localdomain>
References: <20120706113058.8600.30142.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12071810-2000-0000-0000-0000084F9282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If arch_validate_hwbkpt_settings() fails, bp->ctx won't be valid and the
kernel panics. Add a check to fix this.

Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 2bc0584..f3a82dd 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -111,7 +111,7 @@ void arch_unregister_hw_breakpoint(struct perf_event *bp)
 	 * and the single_step_dabr_instruction(), then cleanup the breakpoint
 	 * restoration variables to prevent dangling pointers.
 	 */
-	if (bp->ctx->task)
+	if (bp->ctx && bp->ctx->task)
 		bp->ctx->task->thread.last_hit_ubp = NULL;
 }
 

