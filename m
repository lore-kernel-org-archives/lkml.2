Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0KEDJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:19 -0400
Received: from mail.perches.com ([173.55.12.10]:4203 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab0KEDJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:11 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 46/49] net/netfilter: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:10 -0700
Message-Id: <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/x_tables.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8046350..89e8895 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -753,12 +753,11 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 
 	size = sizeof(void **) * nr_cpu_ids;
 	if (size > PAGE_SIZE)
-		i->jumpstack = vmalloc(size);
+		i->jumpstack = vzalloc(size);
 	else
-		i->jumpstack = kmalloc(size, GFP_KERNEL);
+		i->jumpstack = kzalloc(size, GFP_KERNEL);
 	if (i->jumpstack == NULL)
 		return -ENOMEM;
-	memset(i->jumpstack, 0, size);
 
 	i->stacksize *= xt_jumpstack_multiplier;
 	size = sizeof(void *) * i->stacksize;
-- 
1.7.3.1.g432b3.dirty

