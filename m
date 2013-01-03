Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3ACMUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:20:33 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46205 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab3ACMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:22 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH -v2 21/26] net/sched: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:17 +0900
Message-Id: <1357215562-6288-22-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netem@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: netdev@vger.kernel.org
---

* Change from v1
- leave net_random() callers as-is because that is a useful indirection

 net/sched/sch_choke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index cc37dd5..ef53ab8 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -80,7 +80,7 @@ struct choke_sched_data {
 /* deliver a random number between 0 and N - 1 */
 static u32 random_N(unsigned int N)
 {
-	return reciprocal_divide(random32(), N);
+	return reciprocal_divide(prandom_u32(), N);
 }
 
 /* number of elements in queue including holes */
-- 
1.7.11.7

