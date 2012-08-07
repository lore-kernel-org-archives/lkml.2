Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807Ab2HGXDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:03:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030731Ab2HGWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 082/109] sch_sfb: Fix missing NULL check
Date: Tue,  7 Aug 2012 15:35:41 -0700
Message-Id: <20120807222050.289944679@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 7ac2908e4b2edaec60e9090ddb4d9ceb76c05e7d ]

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44461

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -570,6 +570,8 @@ static int sfb_dump(struct Qdisc *sch, s
 
 	sch->qstats.backlog = q->qdisc->qstats.backlog;
 	opts = nla_nest_start(skb, TCA_OPTIONS);
+	if (opts == NULL)
+		goto nla_put_failure;
 	NLA_PUT(skb, TCA_SFB_PARMS, sizeof(opt), &opt);
 	return nla_nest_end(skb, opts);
 


