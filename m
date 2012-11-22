Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205Ab2KVTTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:19:09 -0500
Received: from dupo.coraid.com ([208.71.232.133]:47926 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756197Ab2KVTTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:19:04 -0500
Message-Id: <b98e56706b65fd3fb7f51d0b5c83bc60b131c4a3.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 7/8] aoe: initialize sysminor to avoid compiler warning
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 20:06:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the minor_get and related functions use the return values
for errors, the compiler doesn't know that sysminor will always
either 1) be initialized in aoedev_by_aoeaddr by the call to
minor_get, or 2) be unused as the "goto out" is executed.

This patch avoids the compiler warning.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 88ccd6d..80b3d3e 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -383,7 +383,7 @@ aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
 	struct aoedev *d;
 	int i;
 	ulong flags;
-	ulong sysminor;
+	ulong sysminor = 0;
 
 	spin_lock_irqsave(&devlist_lock, flags);
 
-- 
1.7.1

