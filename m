Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658Ab0J2TC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:02:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761556Ab0J2TBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:01:38 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=lKuogNbRRC4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=h_Q_XURScSPOJS4K8E8A:9 a=jTxQ5EFQqrtrV9rrwKcA:7 a=8j8AS1cmeOYq-PitJLQG3hLKAvUA:4 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029190135.983681125@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 15:00:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5/7] jump_label: Fix unaligned traps on sparc.
References: <20101029190050.674141729@goodmis.org>
Content-Disposition: inline; filename=0005-jump_label-Fix-unaligned-traps-on-sparc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

The vmlinux.lds.h knobs to emit the __jump_table section in the main
kernel image takes care to align the section, but this doesn't help
for the __jump_table section that gets emitted into modules.

Fix the resulting lack of section alignment by explicitly specifying
it in the assembler.

Signed-off-by: David S. Miller <davem@davemloft.net>
LKML-Reference: <20101023.110624.226758370.davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sparc/include/asm/jump_label.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 62e66d7..d95cf44 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -14,6 +14,7 @@
 			 "nop\n\t"				\
 			 "nop\n\t"				\
 			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".align 4\n\t"				\
 			 ".word 1b, %l[" #label "], %c0\n\t"	\
 			 ".popsection \n\t"			\
 			 : :  "i" (key) :  : label);\
-- 
1.7.1


