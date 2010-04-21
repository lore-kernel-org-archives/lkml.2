Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0DUVTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:19:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:37328 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755531Ab0DUVTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:19:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+rQU5PBgmrxRYFw7n38Se/ipWJi/fWu5/YBdX6Dl
	/uE0rg8qYE8G5J
From: Peter Huewe <PeterHuewe@gmx.de>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Subject: [PATCH 2/2] arch/avr32: fix build failure caused by wrong prototype
Date: Wed, 21 Apr 2010 23:19:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004212319.39033.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure[1] introduced by 1d8393171
which had the static keyword as a leftover.

Kernelversion: linux-next-20100421

References:
[1]http://kisskb.ellerman.id.au/kisskb/buildresult/2448162/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/avr32/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index dd5b882..5e73c25 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -28,7 +28,7 @@ static struct pt_regs *get_user_regs(struct task_struct *tsk)
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
-static void user_enable_single_step(struct task_struct *tsk)
+void user_enable_single_step(struct task_struct *tsk)
 {
 	pr_debug("user_enable_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
 		 tsk->pid, task_pt_regs(tsk)->pc, task_pt_regs(tsk)->sr);
-- 
1.6.4.4

