Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab2GFLbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:31:17 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42833 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab2GFLbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:31:12 -0400
Subject: [PATCH] PPC Hardware Breakpoints: Fix incorrect pointer access
To: fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        prasad.krishnan@gmail.com
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        emachado@linux.vnet.ibm.com
Date: Fri, 06 Jul 2012 17:00:58 +0530
Message-ID: <20120706113058.8600.30142.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12070611-5816-0000-0000-000003798CB9
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
 

