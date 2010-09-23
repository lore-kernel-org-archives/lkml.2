Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0IWD4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:56:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51959 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0IWD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:12 -0400
X-Authority-Analysis: v=1.1 cv=Yii9LXZpONf3Dl4H+sCjsa4WyoNNo7yi1hAau1xJxWE= c=1 sm=0 a=OH4P6Vyk5zwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=pwsdpWdunBGejvBF99AA:9 a=ANnCjv-Ezp0JhyDLwZHWqHPhiNwA:4 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035610.079283484@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 11/11] jump label/x86/sparc64: Remove !CC_OPTIMIZE_FOR_SIZE config conditions
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0011-jump-label-x86-sparc64-Remove-CC_OPTIMIZE_FOR_SIZE-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The !CC_OPTIMIZE_FOR_SIZE was added to enable the jump label functionality
because Jason noticed that the gcc option would not optimize the labels
and may even hurt performance.

But this is a gcc problem not a kernel one. Removing this condition should
add motivation to the gcc developers to actually fix it.

Cc: Jason Baron <jbaron@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sparc/Kconfig |    2 +-
 arch/x86/Kconfig   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a81b04e..9212cd4 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,7 +30,7 @@ config SPARC
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
+	select HAVE_ARCH_JUMP_LABEL
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index afcd663..b431a08 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -59,7 +59,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
-	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
+	select HAVE_ARCH_JUMP_LABEL
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
-- 
1.7.1


