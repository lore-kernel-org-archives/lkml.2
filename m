Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966552Ab0GSTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:31:23 -0400
Received: from prod-mail-xrelay04.akamai.com ([96.6.114.79]:52736 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965813Ab0GSTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:31:22 -0400
From: Josh Hunt <johunt@akamai.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, juhlenko@akamai.com,
        efault@gmx.de
Subject: [PATCH] trivial: Use correct macro to display sched_child_runs_first in /proc/sched_debug
Date: Mon, 19 Jul 2010 12:31:16 -0700
Message-Id: <1279567876-25418-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100717101748.GA14106@elte.hu>
References: <20100717101748.GA14106@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending via git.

The sched_child_runs_first value in /proc/sched_debug is currently
displayed using a macro meant to split ns time values. This patch uses
the correct macro to display it as a plain decimal value.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 3556539..2e1b0d1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -332,7 +332,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_child_runs_first);
+	P(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
 #undef P
-- 
1.7.0.4

