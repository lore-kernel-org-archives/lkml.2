Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2ENV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:56:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58110 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab2ENVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:55:58 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2] net: codel: fix build errors
Date: Mon, 14 May 2012 23:57:06 +0200
Message-Id: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build error:

net/sched/sch_fq_codel.c: In function 'fq_codel_dump_stats':
net/sched/sch_fq_codel.c:464:3: error: unknown field 'qdisc_stats' specified in initializer
net/sched/sch_fq_codel.c:464:3: warning: missing braces around initializer
net/sched/sch_fq_codel.c:464:3: warning: (near initialization for 'st.<anonymous>')
net/sched/sch_fq_codel.c:465:3: error: unknown field 'qdisc_stats' specified in initializer
net/sched/sch_fq_codel.c:465:3: warning: excess elements in struct initializer
net/sched/sch_fq_codel.c:465:3: warning: (near initialization for 'st')
net/sched/sch_fq_codel.c:466:3: error: unknown field 'qdisc_stats' specified in initializer
net/sched/sch_fq_codel.c:466:3: warning: excess elements in struct initializer
net/sched/sch_fq_codel.c:466:3: warning: (near initialization for 'st')
net/sched/sch_fq_codel.c:467:3: error: unknown field 'qdisc_stats' specified in initializer
net/sched/sch_fq_codel.c:467:3: warning: excess elements in struct initializer
net/sched/sch_fq_codel.c:467:3: warning: (near initialization for 'st')
make[1]: *** [net/sched/sch_fq_codel.o] Error 1

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/sched/sch_fq_codel.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index a7b3754..337ff20 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -461,13 +461,14 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct tc_fq_codel_xstats st = {
 		.type				= TCA_FQ_CODEL_XSTATS_QDISC,
-		.qdisc_stats.maxpacket		= q->cstats.maxpacket,
-		.qdisc_stats.drop_overlimit	= q->drop_overlimit,
-		.qdisc_stats.ecn_mark		= q->cstats.ecn_mark,
-		.qdisc_stats.new_flow_count	= q->new_flow_count,
 	};
 	struct list_head *pos;
 
+	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
+	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
+	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
+	st.qdisc_stats.new_flow_count = q->new_flow_count;
+
 	list_for_each(pos, &q->new_flows)
 		st.qdisc_stats.new_flows_len++;
 
-- 
1.7.8.6

