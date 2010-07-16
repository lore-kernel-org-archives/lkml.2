Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab0GPWAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:00:07 -0400
Received: from prod-mail-xrelay03.akamai.com ([96.6.114.84]:48527 "EHLO
	prod-mail-xrelay03.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab0GPWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:00:05 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 18:00:05 EDT
Message-ID: <4C40D470.3010100@akamai.com>
Date: Fri, 16 Jul 2010 14:51:44 -0700
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@elte.hu, peterz@infradead.org
CC: linux-kernel@vger.kernel.org, juhlenko@akamai.com
Subject: [PATCH] trivial: Use correct macro to display sched_child_runs_first
 in /proc/sched_debug
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-       PN(sysctl_sched_child_runs_first);
+       P(sysctl_sched_child_runs_first);
        P(sysctl_sched_features);
 #undef PN
 #undef P
