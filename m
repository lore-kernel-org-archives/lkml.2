Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1APNOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:14:34 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:33361 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1APNO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:14:29 -0500
Date: Sun, 16 Jan 2011 14:14:25 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
cc: xfs@oss.sgi.com, Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH] xfs: Do not name variables "panic"
Message-ID: <alpine.DEB.2.00.1101161409150.24311@ayla.of.borg>
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
---
m68k/sun3: http://kisskb.ellerman.id.au/kisskb/buildresult/3779006/
None of the !HAVE_ARCH_BUG archs (h8300, m32r, m68knommu, microblaze, score,
tile, xtensa) seems to be covered by linux-next

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
