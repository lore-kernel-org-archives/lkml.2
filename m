Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1G2BoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:44:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab1G2Bmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:42:51 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BTX1WXh5Bu0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=fUu1YqTdU4pbmsieGHMA:9 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110729014247.692715109@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Jul 2011 21:42:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/5] x86: Do not differentiate between x86_64 and i386 with init_per_cpu
References: <20110729014215.328710900@goodmis.org>
Content-Disposition: inline; filename=0001-x86-Do-not-differentiate-between-x86_64-and-i386-wit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's nothing different between the way x86_64 and x86_32
treate init_per_cpu.

Although only x86_64 uses INIT_PER_CPU_VAR() in the head.S file,
there is still no reason to keep the macro x86_64 only.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/percpu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index a0a9779..ab86813 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -33,7 +33,7 @@
 #define PER_CPU_VAR(var)	var
 #endif	/* SMP */
 
-#ifdef CONFIG_X86_64_SMP
+#ifdef CONFIG_SMP
 #define INIT_PER_CPU_VAR(var)  init_per_cpu__##var
 #else
 #define INIT_PER_CPU_VAR(var)  var
@@ -77,7 +77,7 @@
 #define DECLARE_INIT_PER_CPU(var) \
        extern typeof(var) init_per_cpu_var(var)
 
-#ifdef CONFIG_X86_64_SMP
+#ifdef CONFIG_SMP
 #define init_per_cpu_var(var)  init_per_cpu__##var
 #else
 #define init_per_cpu_var(var)  var
-- 
1.7.5.4


