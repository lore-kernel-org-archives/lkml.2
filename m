Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1GYNKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:10:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61408 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1GYNKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:10:36 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] proc/softirqs: only show state for online cpus
Date: Mon, 25 Jul 2011 21:10:18 +0800
Message-Id: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like /proc/interrupts, no need to output data for nobody.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/softirqs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
index 62604be..2b32b46 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -11,13 +11,13 @@ static int show_softirqs(struct seq_file *p, void *v)
 	int i, j;
 
 	seq_puts(p, "                    ");
-	for_each_possible_cpu(i)
+	for_each_online_cpu(i)
 		seq_printf(p, "CPU%-8d", i);
 	seq_putc(p, '\n');
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
 		seq_printf(p, "%12s:", softirq_to_name[i]);
-		for_each_possible_cpu(j)
+		for_each_online_cpu(j)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
 		seq_putc(p, '\n');
 	}
-- 
1.7.4.1

