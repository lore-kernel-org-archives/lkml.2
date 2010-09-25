Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0IYUH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:07:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58272 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0IYUHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:07:55 -0400
Date: Sat, 25 Sep 2010 21:07:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix usp value in multithreaded coredumps
Message-ID: <20100925200751.GZ19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdusp() gives us the right value only for the current thread...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 842dba3..3ec3506 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -356,7 +356,7 @@ dump_elf_thread(elf_greg_t *dest, struct pt_regs *pt, struct thread_info *ti)
 	dest[27] = pt->r27;
 	dest[28] = pt->r28;
 	dest[29] = pt->gp;
-	dest[30] = rdusp();
+	dest[30] = ti == current_thread_info() ? rdusp() : ti->pcb.usp;
 	dest[31] = pt->pc;
 
 	/* Once upon a time this was the PS value.  Which is stupid
-- 
1.5.6.5

