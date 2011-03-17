Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1CQQm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:42:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1CQQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:42:25 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=01NgLs0ohDAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=ZinbF3C8ry2xIi5dHagA:9 a=ziopsANK_EirX6SLZIe2SPu49doA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317164223.478456189@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 12:41:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/4] jump label: Add _ASM_ALIGN for x86 and x86_64
References: <20110317164148.550876008@goodmis.org>
Content-Disposition: inline; filename=0003-jump-label-Add-_ASM_ALIGN-for-x86-and-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

The linker should not be adding holes to word size aligned pointers, but
out of paranoia we are explicitly specifying that alignment. I have not
seen any holes in the jump label section in practice.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/jump_label.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f217cee..a32b18c 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,6 +16,7 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
 	asm goto("1:"
 		JUMP_LABEL_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
 		".popsection \n\t"
 		: :  "i" (key) : : l_yes);
-- 
1.7.2.3


