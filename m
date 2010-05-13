Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0EMUBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:01:54 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39835 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0EMUBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:01:51 -0400
Date: Thu, 13 May 2010 22:01:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/20] drivers/parport: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132200410.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/parport/share.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/parport/share.c b/drivers/parport/share.c
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -282,14 +282,13 @@ struct parport *parport_register_port(un
 	int device;
 	char *name;
 
-	tmp = kmalloc(sizeof(struct parport), GFP_KERNEL);
+	tmp = kzalloc(sizeof(struct parport), GFP_KERNEL);
 	if (!tmp) {
 		printk(KERN_WARNING "parport: memory squeeze\n");
 		return NULL;
 	}
 
 	/* Init our structure */
- 	memset(tmp, 0, sizeof(struct parport));
 	tmp->base = base;
 	tmp->irq = irq;
 	tmp->dma = dma;
