Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2CEOyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:54:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2CEOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:54:27 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org
Subject: [PATCH 3/7] ceph: Push file_update_time() into ceph_page_mkwrite()
Date: Mon,  5 Mar 2012 15:54:14 +0100
Message-Id: <1330959258-23211-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330959258-23211-1-git-send-email-jack@suse.cz>
References: <1330959258-23211-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Sage Weil <sage@newdream.net>
CC: ceph-devel@vger.kernel.org
Acked-by: Sage Weil <sage@newdream.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ceph/addr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 173b1d2..12b139f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1181,6 +1181,9 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size, len;
 	int ret;
 
+	/* Update time before taking page lock */
+	file_update_time(vma->vm_file);
+
 	size = i_size_read(inode);
 	if (off + PAGE_CACHE_SIZE <= size)
 		len = PAGE_CACHE_SIZE;
-- 
1.7.1

