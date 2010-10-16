Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0JPBRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:17:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0JPBRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:17:10 -0400
Date: Fri, 15 Oct 2010 21:17:09 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, viro@zeniv.linux.org.uk
Subject: [PATCH 2/4] m32r: get_user takes an lvalue, not a pointer
Message-ID: <20101016011709.GT8332@bombadil.infradead.org>
References: <20101016010952.GQ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016010952.GQ8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index cc36fe1..a08697f 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -256,7 +256,7 @@ give_sigsegv:
 static int prev_insn(struct pt_regs *regs)
 {
 	u16 inst;
-	if (get_user(&inst, (u16 __user *)(regs->bpc - 2)))
+	if (get_user(inst, (u16 __user *)(regs->bpc - 2)))
 		return -EFAULT;
 	if ((inst & 0xfff0) == 0x10f0)	/* trap ? */
 		regs->bpc -= 2;
-- 
1.7.3.1

