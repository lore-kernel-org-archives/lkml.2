Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1LFUWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:22:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44443 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1LFUWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:22:07 -0500
Date: Tue, 6 Dec 2011 12:22:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de
cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [patch resend] x86: use the same node_distance for 32 and 64-bit
In-Reply-To: <20111205124449.GG3143@elte.hu>
Message-ID: <alpine.DEB.2.00.1112061220310.28251@chino.kir.corp.google.com>
References: <201109191603.15560.hartleys@visionengravers.com> <alpine.DEB.2.00.1109191748170.8943@chino.kir.corp.google.com> <alpine.DEB.2.00.1110141325010.24783@chino.kir.corp.google.com> <20111205124449.GG3143@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
		
The node_distance function is not x86 64-bit specific.  Having the #ifdef
around the extern function declaration and the #define causes the default
node_distance macro to be used in asm-generic/topology.h. This also causes
a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:

warning: symbol '__node_distance' was not declared. Should it be static?

Remove the #ifdef to fix both issues.

Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/topology.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
-#endif
 
 #else /* !CONFIG_NUMA */
 
