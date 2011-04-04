Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1DDTTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:19:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1DDTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:18:35 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=nTbpr5Ojj3MA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=NEbeXOUqkpw6tpVCP_4A:9 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110404191833.040858028@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 04 Apr 2011 15:16:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5/6] jump label: Add _ASM_ALIGN for x86 and x86_64
References: <20110404191654.006849945@goodmis.org>
Content-Disposition: inline; filename=0005-jump-label-Add-_ASM_ALIGN-for-x86-and-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

The linker should not be adding holes to word size aligned pointers, but
out of paranoia we are explicitly specifying that alignment. I have not
seen any holes in the jump label section in practice.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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


