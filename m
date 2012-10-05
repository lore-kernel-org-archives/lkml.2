Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2JEP6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:58:15 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36648
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab2JEP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:58:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <akpm@linux-foundation.org>
CC: <mingo@kernel.org>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] sysctl: Fix 'defined but not used' warning
Date: Fri, 5 Oct 2012 12:57:48 -0300
Message-ID: <1349452668-8601-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 4ae834f767(sched/numa: Implement NUMA home-node selection code)
building a kernel with CONFIG_SMP disabled causes the following warning:

kernel/sysctl.c:259:12: warning: 'min_sched_tunable_scaling' defined but not used [-Wunused-variable]
kernel/sysctl.c:260:12: warning: 'max_sched_tunable_scaling' defined but not used [-Wunused-variable]

Annotate theses variables as '__maybe_unused'.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index af25d0c..4bf02e4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -256,8 +256,8 @@ static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
-static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
-static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
+static int __maybe_unused min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
+static int __maybe_unused max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
 #endif
 
 #ifdef CONFIG_COMPACTION
-- 
1.7.9.5


