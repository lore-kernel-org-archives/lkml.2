Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab0J1N45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:56:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab0J1N4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:56:49 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=9bO2NKCsKEIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=h_Q_XURScSPOJS4K8E8A:9 a=jTxQ5EFQqrtrV9rrwKcA:7 a=r7bHOPg9cuSOS9xH1SYdABj4ylMA:4 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028135648.361390264@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 09:55:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6/8] jump_label: Fix unaligned traps on sparc.
References: <20101028135548.055490014@goodmis.org>
Content-Disposition: inline; filename=0006-jump_label-Fix-unaligned-traps-on-sparc.patch
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
index 9aa82d7..8ae160a 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -15,6 +15,7 @@
 			 "nop\n\t"				\
 			 "nop\n\t"				\
 			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".align 4\n\t"				\
 			 ".word 1b, %l[" #label "], %c0\n\t"	\
 			 ".popsection \n\t"			\
 			 : :  "i" (key) :  : label);\
-- 
1.7.1


