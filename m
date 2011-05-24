Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1EXDmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:42:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34235 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab1EXDmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:42:05 -0400
Date: Tue, 24 May 2011 13:42:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (tile tree
 related)
Message-Id: <20110524134203.62d859c0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/include/asm/siginfo.h:19,
                 from include/linux/signal.h:5,
                 from include/linux/sched.h:73,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/compat.h:401: error: expected ')' before 'ctx_id'
include/linux/compat.h:406: error: expected ')' before 'ctx_id'

Caused by commit be84cb43833e ("compat: fixes to allow working with tile arch").

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 May 2011 13:28:54 +1000
Subject: [PATCH] compat: include aio_abi.h for aio_context_t

fixes this build error on sparc64 (at least):

In file included from arch/sparc/include/asm/siginfo.h:19,
                 from include/linux/signal.h:5,
                 from include/linux/sched.h:73,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/compat.h:401: error: expected ')' before 'ctx_id'
include/linux/compat.h:406: error: expected ')' before 'ctx_id'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/compat.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 644e1a4..ddcb7db 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -13,6 +13,7 @@
 #include <linux/socket.h>
 #include <linux/if.h>
 #include <linux/fs.h>
+#include <linux/aio_abi.h>	/* for aio_context_t */
 
 #include <asm/compat.h>
 #include <asm/siginfo.h>
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
