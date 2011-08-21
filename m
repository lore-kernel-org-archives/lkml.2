Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1HUAui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 20:50:38 -0400
Received: from mx.treblig.org ([80.68.94.177]:39724 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab1HUAue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 20:50:34 -0400
Date: Sun, 21 Aug 2011 01:50:31 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Cc: nicolas.ferre@atmel.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
Subject: [PATCH] Fix missing 'cnt' in ?: in dmatest
Message-ID: <20110821005031.GB10377@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 01:41:43 up 184 days,  2:14,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  On the latest tree my compiler has started giving the warning:

drivers/dma/dmatest.c:575:28: warning: the omitted middle operand in ?: will always be ?true?, suggest explicit middle operand [-Wparentheses]

The following patch fixes the missing middle clause with the same
fix that Nicolas Ferre used in the similar clauses.
(There seems to have been a race between him fixing that and
the extra clause going in a little later).

I don't actually know the dmatest code/structures, nor do I own
any hardware to test it on (assuming it needs a DMA engine);
 but this patch builds, the existing code is almost certainly
wrong and the fix is the same as the corresponding lines above it.

(WTH is x=y?:z legal C anyway?)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

---
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 765f5ff..1b0ec9d 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -572,7 +572,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	}
 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_PQ);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
