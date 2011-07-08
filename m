Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1GHT64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:58:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31377 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1GHT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:58:55 -0400
Subject: [PATCH] cciss: do not attempt to read from a write-only register
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 08 Jul 2011 14:58:53 -0500
Message-ID: <20110708195853.3594.38970.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Most smartarrays will tolerate it, but some new ones don't.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 16b4d58..c049548 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -223,7 +223,7 @@ static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c)
 			h->ctlr, c->busaddr);
 #endif /* CCISS_DEBUG */
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;

