Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1G2HBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:01:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab1G2HBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:01:46 -0400
Date: Fri, 29 Jul 2011 17:01:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (probably
 moduleh tree related)
Message-Id: <20110729170142.4cd1979127a0d5d864297db3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/dma/iovlock.c:28:0:
include/linux/dmaengine.h: In function '__dma_cap_zero':
include/linux/dmaengine.h:736:2: error: implicit declaration of function 'bitmap_zero'
In file included from include/linux/nodemask.h:95:0,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from drivers/dma/iovlock.c:29:
include/linux/bitmap.h: At top level:
include/linux/bitmap.h:159:20: warning: conflicting types for 'bitmap_zero'
include/linux/bitmap.h:159:20: error: static declaration of 'bitmap_zero' follows non-static declaration
include/linux/dmaengine.h:736:2: note: previous implicit declaration of 'bitmap_zero' was here

Presumably caused by some include file no longer being implicitly
included.

I have added the folllowing patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 16:55:11 +1000
Subject: [PATCH] dmaengine.h needs bitmap.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/dmaengine.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8fbf40e..c90b17f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/uio.h>
 #include <linux/dma-direction.h>
+#include <linux/bitmap.h>
 
 struct scatterlist;
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
