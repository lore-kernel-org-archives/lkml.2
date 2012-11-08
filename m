Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2KHQnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:43:06 -0500
Received: from dupo.coraid.com ([208.71.232.133]:45787 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323Ab2KHQnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:43:02 -0500
Message-Id: <c1516a2232d4f382040f76b72f9b488f2aeb7d15.1352316179.git.ecashin@coraid.com>
In-Reply-To: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/8] aoe: err device: include MAC addresses for unexpected responses
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 11:42:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index f849fa2..6ea27fd 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1204,12 +1204,14 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			spin_unlock_irqrestore(&d->lock, flags);
 			aoedev_put(d);
 			snprintf(ebuf, sizeof(ebuf),
-				 "%15s e%d.%d    tag=%08x@%08lx\n",
+				 "%15s e%d.%d    tag=%08x@%08lx s=%pm d=%pm\n",
 				 "unexpected rsp",
 				 get_unaligned_be16(&h->major),
 				 h->minor,
 				 get_unaligned_be32(&h->tag),
-				 jiffies);
+				 jiffies,
+				 h->src,
+				 h->dst);
 			aoechr_error(ebuf);
 			return skb;
 		}
-- 
1.7.1

