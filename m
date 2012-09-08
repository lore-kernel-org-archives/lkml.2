Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2IHJ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 05:59:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17316 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2IHJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 05:59:31 -0400
Date: Sat, 8 Sep 2012 12:59:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] aoe: cleanup an allocation a bit
Message-ID: <20120908095921.GD608@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed this recently so we can just use kzalloc() here instead of
kcalloc(1, ...).  Kernel style prefers sizeof(*t) over sizeof *t.  The
kfree(t) is a no-op now as well so that can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only applies to linux-next.

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 5461faa..c0adbbd 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1255,9 +1255,8 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 			"aoe: device addtgt failure; too many targets\n");
 		return NULL;
 	}
-	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	t = kzalloc(sizeof(*t), GFP_ATOMIC);
 	if (!t) {
-		kfree(t);
 		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
 		return NULL;
 	}
