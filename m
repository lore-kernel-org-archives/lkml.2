Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab2KVTQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:16:05 -0500
Received: from dupo.coraid.com ([208.71.232.133]:36983 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965062Ab2KVTQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:16:03 -0500
Message-Id: <cc8e118436abe953279c6ff3ca07ba94cdec3ef5.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/8] aoe: remove call to request handler from I/O completion
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 20:02:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call the request handler function in the I/O
completion routine.  The user impact of not doing it is a more
"nice" aoe driver that is less susceptible to causing soft
lockups.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 53b9869..391dd8e 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1139,8 +1139,6 @@ badrsp:
 	if (buf && --buf->nframesout == 0 && buf->resid == 0)
 		aoe_end_buf(d, buf);
 
-	aoecmd_work(d);
-
 	spin_unlock_irq(&d->lock);
 	aoedev_put(d);
 	dev_kfree_skb(skb);
-- 
1.7.1

