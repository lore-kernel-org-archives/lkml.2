Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2JWIWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:22:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43000 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2JWIWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:22:30 -0400
From: <zhanghonghui@huawei.com>
To: <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <edumazet@google.com>,
        Hans Zhang <zhanghonghui@huawei.com>
Subject: [PATCH] netlink: cleanup the unnecessary return value check
Date: Tue, 23 Oct 2012 16:21:23 +0800
Message-ID: <1350980483-4992-1-git-send-email-zhanghonghui@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.168]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Zhang <zhanghonghui@huawei.com>

It's no needed to check the return value of tab since the NULL situation
has been handled already, and the rtnl_msg_handlers[PF_UNSPEC] has been
initialized as non-NULL during the rtnetlink_init().

Signed-off-by: Hans Zhang <zhanghonghui@huawei.com>
---
 net/core/rtnetlink.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 76d4c2c..64fe3cc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -128,7 +128,7 @@ static rtnl_doit_func rtnl_get_doit(int protocol, int msgindex)
 	if (tab == NULL || tab[msgindex].doit == NULL)
 		tab = rtnl_msg_handlers[PF_UNSPEC];
 
-	return tab ? tab[msgindex].doit : NULL;
+	return tab[msgindex].doit;
 }
 
 static rtnl_dumpit_func rtnl_get_dumpit(int protocol, int msgindex)
@@ -143,7 +143,7 @@ static rtnl_dumpit_func rtnl_get_dumpit(int protocol, int msgindex)
 	if (tab == NULL || tab[msgindex].dumpit == NULL)
 		tab = rtnl_msg_handlers[PF_UNSPEC];
 
-	return tab ? tab[msgindex].dumpit : NULL;
+	return tab[msgindex].dumpit;
 }
 
 static rtnl_calcit_func rtnl_get_calcit(int protocol, int msgindex)
@@ -158,7 +158,7 @@ static rtnl_calcit_func rtnl_get_calcit(int protocol, int msgindex)
 	if (tab == NULL || tab[msgindex].calcit == NULL)
 		tab = rtnl_msg_handlers[PF_UNSPEC];
 
-	return tab ? tab[msgindex].calcit : NULL;
+	return tab[msgindex].calcit;
 }
 
 /**
-- 
1.7.1


