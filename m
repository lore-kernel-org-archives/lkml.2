Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0G3HhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:37:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51319 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0G3HhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VO4RL4ZWG38vyJW5FEdqjo/gIU0aNHfJYQ4q3XRZ6BfKfy+gO0FnVu9U0QOtOKo2+m
         +knfP5g0ZNRbk3LU04FpNDF4ckBPTdrzDym/gWeIkQh0hQLW6T74mz7obWcCDMrzLDy1
         TBgxoXfA8k6a1Ys34xsHeL9wqdoWJ8oWoZHsc=
From: Changli Gao <xiaosuo@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] act_nat: the checksum of ICMP doesn't have pseudo header
Date: Fri, 30 Jul 2010 08:04:18 +0800
Message-Id: <1280448258-1893-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after updating the value of the ICMP payload, inet_proto_csum_replace4() should
be called with zero pseudohdr.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/sched/act_nat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 24e614c..59f05ee 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -246,7 +246,7 @@ static int tcf_nat(struct sk_buff *skb, struct tc_action *a,
 			iph->saddr = new_addr;
 
 		inet_proto_csum_replace4(&icmph->checksum, skb, addr, new_addr,
-					 1);
+					 0);
 		break;
 	}
 	default:
