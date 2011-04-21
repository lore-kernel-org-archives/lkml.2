Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1DUCjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DUChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:40 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=HJ98c1LhD-4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=LSFlVAIeZbhsac92jw8A:9 a=qXRMMd_4zsY7bQctDZwA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023739.243651696@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 09/11] ftrace/x86: Do not trace .discard.text section
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-x86-Do-not-trace-.discard.text-section.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The section called .discard.text has tracing attached to it and is
currently ignored by ftrace. But it does include a call to the mcount
stub. Adding a notrace to the code keeps gcc from adding the useless
mcount caller to it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/setup.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index db8aa19..647d8a0 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -88,7 +88,7 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard.text) __used			\
+	static void __section(.discard.text) __used notrace		\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
-- 
1.7.2.3


