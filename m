Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424446Ab2LGGTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:19:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423102Ab2LGGTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:19:49 -0500
Date: Fri, 7 Dec 2012 09:19:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] aoe: use after free in aoedev_by_aoeaddr()
Message-ID: <20121207061943.GC18220@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return NULL on failure instead of returning a freed pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e66ccbf..98f2965 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -461,6 +461,7 @@ aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
 	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
 	if (!d->targets) {
 		kfree(d);
+		d = NULL;
 		goto out;
 	}
 	d->ntargets = NTARGETS;
