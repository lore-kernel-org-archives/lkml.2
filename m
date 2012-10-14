Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2JNOm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46378 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515Ab2JNOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:54 -0400
Message-Id: <20121014143547.555141066@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 102/147] drivers/dma/dmaengine.c: lower the priority of failed to get dma
 channel message
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 0eb5a35801df3c438ce3fc91310a415ea4452c00 upstream.

Do the same as commit a03a202e95fd ("dmaengine: failure to get a
specific DMA channel is not critical") to get rid of the following
messages during kernel boot:

  dmaengine_get: failed to get dma1chan0: (-22)
  dmaengine_get: failed to get dma1chan1: (-22)
  dmaengine_get: failed to get dma1chan2: (-22)
  dmaengine_get: failed to get dma1chan3: (-22)
  ..

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: also apply changes to this logging statement
 from commit 634332502366 ('dmaengine: Cleanup logging messages')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -564,8 +564,8 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("dmaengine: failed to get %s: (%d)\n",
-				       dma_chan_name(chan), err);
+				pr_debug("%s: failed to get %s: (%d)\n",
+				       __func__, dma_chan_name(chan), err);
 		}
 	}
 


