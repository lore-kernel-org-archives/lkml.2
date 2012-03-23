Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2CWEcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:32:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40164 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2CWEct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:32:49 -0400
MIME-Version: 1.0
Message-ID: <1332477103-4595-1-git-send-email-yinghai@kernel.org>
Date: Thu, 22 Mar 2012 21:31:43 -0700 (PDT)
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: Fix excessive MSR print out when show_msr is not
 specified
X-Mailer: git-send-email 1.7.7
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F6BFCC9.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave found:
| During bootup, I now have 162 messages like this..
| [    0.227346]  MSR0000001b: 00000000fee00900
| [    0.227465]  MSR00000021: 0000000000000001
| [    0.227584]  MSR0000002a: 00000000c1c81400
| commit 21c3fcf3e39353d4f21d50e257cc74f3204b1988 looks suspect.
| It claims that it will only print these out if show_msr= is passed,
| but that doesn't seem to be the case.

Fix it by changing to the version that check index.

Reported-and-tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ade9c79..b240323 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk(KERN_CONT "\n");
 
-	__print_cpu_msr();
+	print_cpu_msr(c);
 }
 
 void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
