Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2DTIDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:03:19 -0400
Received: from mail175c2.megamailservers.com ([69.49.111.75]:59590 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593Ab2DTIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:03:14 -0400
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: yong.zhang0@gmail.com
Cc: sam@ravnborg.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, daniel@gaisler.com,
        Yong Zhang <yong.zhang@windriver.com>
Subject: [PATCH 1/1] sparc32,leon: add notify_cpu_starting()
Date: Fri, 20 Apr 2012 08:28:32 +0200
Message-Id: <1334903312-18526-1-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20120420033634.GA13068@zhy>
References: <20120420033634.GA13068@zhy>
X-CSC: 0
X-CHA: v=1.1 cv=0l1ZA7H7kdVYwsUDqKdyt3M1kbawXr/ph8StbAMu7Y4= c=1 sm=1
		a=WjkYb-kDryMA:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=t7CeM3EgAAAA:8 a=pGLkceISAAAA:8 a=ebG-ZW-8AAAA:8 a=lyHDfAMR6ef2yV0YzUsA:9
		a=2e6ZYRoF4I4A:10 a=MSl-tDqOz04A:10 a=cCYF7-FHeg4A:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.4F91045B.0041,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WHL: SLR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Otherwise cpu_active_mask will not set, which lead to other issue.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 arch/sparc/kernel/leon_smp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 1210fde..160cac9 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -23,6 +23,7 @@
 #include <linux/pm.h>
 #include <linux/delay.h>
 #include <linux/gfp.h>
+#include <linux/cpu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -78,6 +79,8 @@ void __cpuinit leon_callin(void)
 	local_flush_tlb_all();
 	leon_configure_cache_smp();
 
+	notify_cpu_starting(cpuid);
+
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
-- 
1.6.1.3

