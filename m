Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1AFAaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:02 -0500
Received: from kroah.org ([198.145.64.141]:35748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab1AFA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:59 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002302.955285816@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [067/152] cls_cgroup: Fix crash on module unload
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/cls_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -34,8 +34,6 @@ struct cgroup_subsys net_cls_subsys = {
 	.populate	= cgrp_populate,
 #ifdef CONFIG_NET_CLS_CGROUP
 	.subsys_id	= net_cls_subsys_id,
-#else
-#define net_cls_subsys_id net_cls_subsys.subsys_id
 #endif
 	.module		= THIS_MODULE,
 };


