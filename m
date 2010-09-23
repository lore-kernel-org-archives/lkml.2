Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0IWD5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:57:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0IWD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:10 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=AuCcDOf1grYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Y2tRHbnCLq0pdARIQQsA:9 a=krFwBfiDufjDjbe0unvFaZ1we4MA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035609.843192443@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 10/11] jump label: Remove duplicate structure for x86
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0010-jump-label-Remove-duplicate-structure-for-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The structure in the x86 jump label code uses the typedef jump_label_t,
which is defined by the #ifdef arch type. The structure does not need
to be duplicated there.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/jump_label.h |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index b4a2cb4..f52d42e 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -23,18 +23,10 @@
 #endif /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
-
 typedef u64 jump_label_t;
-
-struct jump_entry {
-	jump_label_t code;
-	jump_label_t target;
-	jump_label_t key;
-};
-
 #else
-
 typedef u32 jump_label_t;
+#endif
 
 struct jump_entry {
 	jump_label_t code;
@@ -43,5 +35,3 @@ struct jump_entry {
 };
 
 #endif
-
-#endif
-- 
1.7.1


