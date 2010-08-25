Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0HYPhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:37:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16388 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0HYPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:37:28 -0400
Subject: [PATCH] cciss: fix reporting of max queue depth since init
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Wed, 25 Aug 2010 10:43:34 -0500
Message-ID: <20100825154334.4941.67993.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The ioctl path and the scsi tape path were not accounting
for their additions to the queue depth.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 31064df..eef94fa 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -297,6 +297,8 @@ static void enqueue_cmd_and_start_io(ctlr_info_t *h,
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
+	if (h->Qdepth > h->maxQsinceinit)
+		h->maxQsinceinit = h->Qdepth;
 	start_io(h);
 	spin_unlock_irqrestore(&h->lock, flags);
 }

