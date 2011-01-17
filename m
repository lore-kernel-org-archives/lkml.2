Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1AQUVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:21:21 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39701 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1AQUVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:21:19 -0500
Date: Mon, 17 Jan 2011 21:21:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Alex Elder <aelder@sgi.com>, alexelder@comcast.net
Subject: [PATCH] xfs: Do not name variables "panic"
Message-ID: <alpine.DEB.2.00.1101172119120.26600@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms that call panic() inside their BUG() macro (m68k/sun3, and
all platforms that don't set HAVE_ARCH_BUG), compilation fails with:

| fs/xfs/support/debug.c: In function ¡xfs_cmn_err¢:
| fs/xfs/support/debug.c:92: error: called object ¡panic¢ is not a function

as the local variable "panic" conflicts with the "panic()" function.
Rename the local variable to resolve this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Alex asked me to send it to you directly

 fs/xfs/support/debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index e6cf955..0df8889 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -75,11 +75,11 @@ xfs_cmn_err(
 {
 	struct va_format	vaf;
 	va_list			args;
-	int			panic = 0;
+	int			do_panic = 0;
 
 	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
 		printk(KERN_ALERT "XFS: Transforming an alert into a BUG.");
-		panic = 1;
+		do_panic = 1;
 	}
 
 	va_start(args, fmt);
@@ -89,7 +89,7 @@ xfs_cmn_err(
 	printk(KERN_ALERT "Filesystem %s: %pV", mp->m_fsname, &vaf);
 	va_end(args);
 
-	BUG_ON(panic);
+	BUG_ON(do_panic);
 }
 
 void
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
