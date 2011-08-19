Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1HSVbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:31:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11583 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1HSVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:31:35 -0400
Date: Fri, 19 Aug 2011 23:32:08 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 1/3] Make it safe to pass a NULL pointer to ntfs_free()
In-Reply-To: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1108192331210.31857@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/ntfs/malloc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
index a44b14c..d833e37 100644
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -85,6 +85,8 @@ static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
 
 static inline void ntfs_free(void *addr)
 {
+	if (!addr)
+		return;
 	if (!is_vmalloc_addr(addr)) {
 		kfree(addr);
 		/* free_page((unsigned long)addr); */
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

