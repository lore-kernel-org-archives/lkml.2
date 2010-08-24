Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0HXW7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:33 -0400
Received: from kroah.org ([198.145.64.141]:40513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010Ab0HXW7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:22 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:17 2010
Message-Id: <20100824224217.213782597@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [60/91] pkt_sched: Fix sch_sfq vs tcf_bind_filter oops
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit eb4a5527b1f0d581ac217c80ef3278ed5e38693c ]

Since there was added ->tcf_chain() method without ->bind_tcf() to
sch_sfq class options, there is oops when a filter is added with
the classid parameter.

Fixes commit 7d2681a6ff4f9ab5e48d02550b4c6338f1638998
netdev thread: null pointer at cls_api.c

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Reported-by: Franchoze Eric <franchoze@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_sfq.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -502,6 +502,12 @@ static unsigned long sfq_get(struct Qdis
 	return 0;
 }
 
+static unsigned long sfq_bind(struct Qdisc *sch, unsigned long parent,
+			      u32 classid)
+{
+	return 0;
+}
+
 static struct tcf_proto **sfq_find_tcf(struct Qdisc *sch, unsigned long cl)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
@@ -556,6 +562,7 @@ static void sfq_walk(struct Qdisc *sch,
 static const struct Qdisc_class_ops sfq_class_ops = {
 	.get		=	sfq_get,
 	.tcf_chain	=	sfq_find_tcf,
+	.bind_tcf	=	sfq_bind,
 	.dump		=	sfq_dump_class,
 	.dump_stats	=	sfq_dump_class_stats,
 	.walk		=	sfq_walk,


