Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab0EMT7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:59:42 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39755 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab0EMT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:59:38 -0400
Date: Thu, 13 May 2010 21:59:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/20] arch/arm/mach-davinci: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132159170.6282@ask.diku.dk>
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
 arch/arm/mach-davinci/dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -1419,12 +1419,11 @@ static int __init edma_probe(struct plat
 			goto fail1;
 		}
 
-		edma_cc[j] = kmalloc(sizeof(struct edma), GFP_KERNEL);
+		edma_cc[j] = kzalloc(sizeof(struct edma), GFP_KERNEL);
 		if (!edma_cc[j]) {
 			status = -ENOMEM;
 			goto fail1;
 		}
-		memset(edma_cc[j], 0, sizeof(struct edma));
 
 		edma_cc[j]->num_channels = min_t(unsigned, info[j].n_channel,
 							EDMA_MAX_DMACH);
