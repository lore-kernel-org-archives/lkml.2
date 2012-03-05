Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2CEOyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:54:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2CEOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:54:27 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/7] fs: Push file_update_time() into __block_page_mkwrite()
Date: Mon,  5 Mar 2012 15:54:13 +0100
Message-Id: <1330959258-23211-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330959258-23211-1-git-send-email-jack@suse.cz>
References: <1330959258-23211-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a30db7..5294a33 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2300,6 +2300,12 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	loff_t size;
 	int ret;
 
+	/*
+	 * Update file times before taking page lock. We may end up failing the
+	 * fault so this update may be superfluous but who really cares...
+	 */
+	file_update_time(vma->vm_file);
+
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
-- 
1.7.1

