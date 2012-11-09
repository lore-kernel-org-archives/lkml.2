Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2KIASE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:18:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:56750 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753523Ab2KIASD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:18:03 -0500
Message-Id: <a9c04c2664148dae99208fdd69ee20f6a4b68120.1352410985.git.ecashin@coraid.com>
In-Reply-To: <cover.1352410985.git.ecashin@coraid.com>
References: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/8] aoe: avoid running request handler on plugged queue
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com, axboe@kernel.dk
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:17:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling the request handler directly on a plugged queue defeats
the performance improvements provided by the plugging mechanism.
Use the __blk_run_queue function instead of calling the request
handler directly, so that we don't interfere with the block
layer's ability to plug the queue.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index c491fba..3ce01f6 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -925,7 +925,7 @@ aoe_end_request(struct aoedev *d, struct request *rq, int fastfail)
 
 	/* cf. http://lkml.org/lkml/2006/10/31/28 */
 	if (!fastfail)
-		q->request_fn(q);
+		__blk_run_queue(q);
 }
 
 static void
-- 
1.7.1

