Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1I1KBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:01:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43303 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1I1KBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:01:19 -0400
Date: Wed, 28 Sep 2011 20:01:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20110928200114.f9976eddc3d14bd831ddabed@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

fs/direct-io.c: In function '__blockdev_direct_IO':
fs/direct-io.c:1327:2: error: implicit declaration of function 'prefetch'

Caused by commit 30ddb4d48213 ("dio: optimize cache misses in the
submission path").

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 19:58:28 +1000
Subject: [PATCH] dio: using prefetch requires including prefetch.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/direct-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index a05ca05..8d22849 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -36,6 +36,7 @@
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <linux/atomic.h>
+#include <linux/prefetch.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
