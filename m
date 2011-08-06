Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1HFBYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:24:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1HFBXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:23:55 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=w7TswGi0ltMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=qnNuaUrLFfN5m4AW824A:9 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110806012353.546183789@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 21:11:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4 v2] x86: Nuke the supervisor_stack field in i386 thread_info
References: <20110806011102.721109343@goodmis.org>
Content-Disposition: inline; filename=0001-x86-Nuke-the-supervisor_stack-field-in-i386-thread_i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Nothing references the supervisor_stack in the thread_info field,
and it does not exist in x86_64. To make the two more the same,
it is being removed.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/thread_info.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1f2e61e..625910f 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -38,7 +38,6 @@ struct thread_info {
 	unsigned long           previous_esp;   /* ESP of the previous stack in
 						   case of nested (IRQ) stacks
 						*/
-	__u8			supervisor_stack[0];
 #endif
 	int			uaccess_err;
 };
-- 
1.7.5.4


