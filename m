Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2HGQNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:13:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:53128 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2HGQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:12:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] uprobes: probe definiton can only start with 'p' and '-'
Date: Tue,  7 Aug 2012 18:12:31 +0200
Message-Id: <1344355952-2382-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'r' and ' ' is not supported according to current code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/trace/trace_uprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..f3c3811 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -189,7 +189,7 @@ static int create_trace_uprobe(int argc, char **argv)
 	if (argv[0][0] == '-')
 		is_delete = true;
 	else if (argv[0][0] != 'p') {
-		pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
+		pr_info("Probe definition must be started with 'p' or '-'.\n");
 		return -EINVAL;
 	}
 
-- 
1.7.10.4

