Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030625Ab2HQD0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:26:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030548Ab2HQD0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:49 -0400
Message-Id: <20120817030244.131904656@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/37] sch_sfb: Fix missing NULL check
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 7ac2908e4b2edaec60e9090ddb4d9ceb76c05e7d ]

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44461

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_sfb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 17859ea..351a69b 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -559,6 +559,8 @@ static int sfb_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 	sch->qstats.backlog = q->qdisc->qstats.backlog;
 	opts = nla_nest_start(skb, TCA_OPTIONS);
+	if (opts == NULL)
+		goto nla_put_failure;
 	NLA_PUT(skb, TCA_SFB_PARMS, sizeof(opt), &opt);
 	return nla_nest_end(skb, opts);
 


