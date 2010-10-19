Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0JSQEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:34512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab0JSQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:04:44 -0400
Message-ID: <4CBDC19A.60709@kernel.org>
Date: Tue, 19 Oct 2010 18:04:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] net/neighbour: cancel_delayed_work() + flush_scheduled_work()
 -> cancel_delayed_work_sync()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 16:04:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is going away.  Prepare for it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/core/neighbour.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/net/core/neighbour.c
===================================================================
--- work.orig/net/core/neighbour.c
+++ work/net/core/neighbour.c
@@ -1486,8 +1486,7 @@ int neigh_table_clear(struct neigh_table
 	struct neigh_table **tp;

 	/* It is not clean... Fix it to unload IPv6 module safely */
-	cancel_delayed_work(&tbl->gc_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
 	pneigh_queue_purge(&tbl->proxy_queue);
 	neigh_ifdown(tbl, NULL);
