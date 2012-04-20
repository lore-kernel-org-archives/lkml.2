Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2DTH4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:56:40 -0400
Received: from mail176c2.megamailservers.com ([69.49.111.76]:46254 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106Ab2DTH4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:56:39 -0400
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: davem@davemloft.net
Cc: konrad@gaisler.com, yong.zhang0@gmail.com, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, daniel@gaisler.com
Subject: [PATCH] sparc32,leon: add notify_cpu_starting()
Date: Fri, 20 Apr 2012 09:46:35 +0200
Message-Id: <1334907995-6971-1-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20120420.030607.1891260321280604674.davem@davemloft.net>
References: <20120420.030607.1891260321280604674.davem@davemloft.net>
X-CSC: 0
X-CHA: v=1.1 cv=r1DLTJ6I4WNtNSDbWOfumzxcbMy5NL/NTCl1I6dcIeE= c=1 sm=1
		a=KMaK_M7OBq0A:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=pGLkceISAAAA:8 a=ebG-ZW-8AAAA:8 a=z61PzK8tF3umnaiE55kA:9
		a=MSl-tDqOz04A:10 a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.4F9116A7.0015,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WHL: SLR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise cpu_active_mask will not set, which lead to other issue.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 arch/sparc/kernel/leon_smp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 6173f4d..356dfc4 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -79,6 +79,8 @@ void __cpuinit leon_callin(void)
 	local_flush_tlb_all();
 	leon_configure_cache_smp();
 
+	notify_cpu_starting(cpuid);
+
 	/* Get our local ticker going. */
 	register_percpu_ce(cpuid);
 
-- 
1.6.1.3

