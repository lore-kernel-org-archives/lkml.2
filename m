Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1GUSQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:16:18 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:3018 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1GUSQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:16:08 -0400
Subject: [PATCH] hpsa: do not attempt to read from a write-only register
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Thu, 21 Jul 2011 13:16:05 -0500
Message-ID: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Most smartarrays tolerate it, but a few new ones don't.
Without this change some newer Smart Arrays will lock up
and i/o will grind to a halt.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6d8dcd4..7f53cea 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -214,7 +214,7 @@ static void SA5_submit_command(struct ctlr_info *h,
 	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;

