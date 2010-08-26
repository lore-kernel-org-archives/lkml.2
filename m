Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0HZSud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:33 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:16652 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0HZSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:27 -0400
Subject: [PATCH 13/13] cciss: remove some superfluous tests from
	cciss_bigpassthru()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:35 -0500
Message-ID: <20100826185635.9067.39029.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a7ec339..d3ce357 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1582,28 +1582,19 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	}
 	c->cmd_type = CMD_IOCTL_PEND;
 	c->Header.ReplyQueue = 0;
-
-	if (ioc->buf_size > 0) {
-		c->Header.SGList = sg_used;
-		c->Header.SGTotal = sg_used;
-	} else {
-		c->Header.SGList = 0;
-		c->Header.SGTotal = 0;
-	}
+	c->Header.SGList = sg_used;
+	c->Header.SGTotal = sg_used;
 	c->Header.LUN = ioc->LUN_info;
 	c->Header.Tag.lower = c->busaddr;
 
 	c->Request = ioc->Request;
-	if (ioc->buf_size > 0) {
-		for (i = 0; i < sg_used; i++) {
-			temp64.val =
-			    pci_map_single(h->pdev, buff[i], buff_size[i],
+	for (i = 0; i < sg_used; i++) {
+		temp64.val = pci_map_single(h->pdev, buff[i], buff_size[i],
 				    PCI_DMA_BIDIRECTIONAL);
-			c->SG[i].Addr.lower = temp64.val32.lower;
-			c->SG[i].Addr.upper = temp64.val32.upper;
-			c->SG[i].Len = buff_size[i];
-			c->SG[i].Ext = 0;	/* we are not chaining */
-		}
+		c->SG[i].Addr.lower = temp64.val32.lower;
+		c->SG[i].Addr.upper = temp64.val32.upper;
+		c->SG[i].Len = buff_size[i];
+		c->SG[i].Ext = 0;	/* we are not chaining */
 	}
 	c->waiting = &wait;
 	enqueue_cmd_and_start_io(h, c);

