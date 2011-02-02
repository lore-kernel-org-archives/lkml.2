Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1BBAoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:37546 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab1BBAoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960606"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: herbert@gondor.hengli.com.au, ak@linux.intel.com, lizf@cn.fujitsu.com,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [64/139] cls_cgroup: Fix crash on module unload
Message-Id: <20110202004420.C74143E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c00b2c9e79466d61979cd21af526cc6d5d0ee04f ]

Somewhere along the lines net_cls_subsys_id became a macro when
cls_cgroup is built as a module.  Not only did it make cls_cgroup
completely useless, it also causes it to crash on module unload.

This patch fixes this by removing that macro.

Thanks to Eric Dumazet for diagnosing this problem.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/cls_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.35.y/net/sched/cls_cgroup.c
===================================================================
--- linux-2.6.35.y.orig/net/sched/cls_cgroup.c
+++ linux-2.6.35.y/net/sched/cls_cgroup.c
@@ -34,8 +34,6 @@ struct cgroup_subsys net_cls_subsys = {
 	.populate	= cgrp_populate,
 #ifdef CONFIG_NET_CLS_CGROUP
 	.subsys_id	= net_cls_subsys_id,
-#else
-#define net_cls_subsys_id net_cls_subsys.subsys_id
 #endif
 	.module		= THIS_MODULE,
 };
