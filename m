Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0CQFxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0CQFx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:53:29 -0400
Date: Wed, 17 Mar 2010 01:53:26 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       David Miller <davem@davemloft.net>
Message-Id: <20100317055707.5013.72217.sendpatchset@localhost.localdomain>
Subject: [Patch] netpoll: allow spaces in its parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It would be nice if we allow spaces in netconsole parameters,
otherwise we get weird results if there are spaces in it.

After this patch, we will allow things like:
 "netconsole= @192.168.0.1/eth0 , 66666@192.168.0.2/".

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>

---
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 7aa6972..bf3b2f0 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -629,6 +629,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 	char *cur=opt, *delim;
 
 	if (*cur != '@') {
+		cur = skip_spaces(cur);
 		if ((delim = strchr(cur, '@')) == NULL)
 			goto parse_failed;
 		*delim = 0;
@@ -651,12 +652,14 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 		if ((delim = strchr(cur, ',')) == NULL)
 			goto parse_failed;
 		*delim = 0;
+		strim(cur);
 		strlcpy(np->dev_name, cur, sizeof(np->dev_name));
 		cur = delim;
 	}
 	cur++;
 
 	if (*cur != '@') {
+		cur = skip_spaces(cur);
 		/* dst port */
 		if ((delim = strchr(cur, '@')) == NULL)
 			goto parse_failed;
