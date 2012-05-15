Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517Ab2EOCjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:39:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53502 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965348Ab2EOCRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 133/179] cciss: do not attempt to read from a write-only register
Date: Mon, 14 May 2012 22:13:49 -0400
Message-ID: <1337048075-6132-134-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 07d0c38e7d84f911c72058a124c7f17b3c779a65 upstream.

Most smartarrays will tolerate it, but some new ones don't.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Note: this is a regression caused by commit 1ddd5049
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/cciss.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 37a2d4f..759cbd9 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -173,7 +173,7 @@ static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c)
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
-- 
1.7.9.6

