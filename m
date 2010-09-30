Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0I3UGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:06:24 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:33464 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0I3UGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:06:23 -0400
Date: Thu, 30 Sep 2010 22:06:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Miklos Szeredi <mszeredi@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        fuse-devel@lists.sourceforge.net,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] fuse: Initialize total_len in fuse_retrieve()
Message-ID: <alpine.DEB.2.00.1009302205420.3131@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/fuse/dev.c:1357: warning: ¡total_len¢ may be used uninitialized in this
function

Initialize total_len to zero, else its value will be undefined.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/fuse/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index d367af1..cde755c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1354,7 +1354,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 	loff_t file_size;
 	unsigned int num;
 	unsigned int offset;
-	size_t total_len;
+	size_t total_len = 0;
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
