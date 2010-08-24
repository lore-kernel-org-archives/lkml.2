Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab0HXXM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:12:57 -0400
Received: from kroah.org ([198.145.64.141]:41223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550Ab0HXXC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:56 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.330288368@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [070/114] pkt_sched: Fix sch_sfq vs tc_modify_qdisc oops
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 41065fba846e795b31b17e4dec01cb904d56c6cd ]

sch_sfq as a classful qdisc needs the .leaf handler. Otherwise, there
is an oops possible in tc_modify_qdisc()/check_loop().

Fixes commit 7d2681a6ff4f9ab5e48d02550b4c6338f1638998

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_sfq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -497,6 +497,11 @@ nla_put_failure:
 	return -1;
 }
 
+static struct Qdisc *sfq_leaf(struct Qdisc *sch, unsigned long arg)
+{
+	return NULL;
+}
+
 static unsigned long sfq_get(struct Qdisc *sch, u32 classid)
 {
 	return 0;
@@ -560,6 +565,7 @@ static void sfq_walk(struct Qdisc *sch,
 }
 
 static const struct Qdisc_class_ops sfq_class_ops = {
+	.leaf		=	sfq_leaf,
 	.get		=	sfq_get,
 	.tcf_chain	=	sfq_find_tcf,
 	.bind_tcf	=	sfq_bind,


