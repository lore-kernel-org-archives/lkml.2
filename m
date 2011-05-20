Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab1ETGch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:32:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41934 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab1ETGcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:32:35 -0400
Date: Fri, 20 May 2011 16:32:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110520163233.abcabd67.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/udlfb.c: In function 'dlfb_compress_hline':
drivers/video/udlfb.c:421: error: implicit declaration of function 'prefetch_range'

Presumably caused by commit e66eed651fd1 ("list: remove prefetching from
regular list iterators").  We need to include preempt.h explictly, now.

I have included this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 16:29:01 +1000
Subject: [PATCH] udlfb: include prefetch.h explicitly

Commit e66eed651fd1 ("list: remove prefetching from
regular list iterators") removed the include of prefetch.h from list.h,
so we need to include it explicitly, now.

fixes this build error on powerpc:

drivers/video/udlfb.c: In function 'dlfb_compress_hline':
drivers/video/udlfb.c:421: error: implicit declaration of function 'prefetch_range'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/udlfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 68041d9..4c299cc 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -28,6 +28,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/prefetch.h>
 #include <video/udlfb.h>
 #include "edid.h"
 
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
