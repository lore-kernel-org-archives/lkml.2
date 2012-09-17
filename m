Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2IQAvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab2IQAvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:36 -0400
Message-Id: <20120917003630.555864759@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 031/135] fuse: fix retrieve length
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit c9e67d483776d8d2a5f3f70491161b205930ffe1 upstream.

In some cases fuse_retrieve() would return a short byte count if offset was
non-zero.  The data returned was correct, though.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 7df2b5e..f4246cf 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1576,6 +1576,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 		req->pages[req->num_pages] = page;
 		req->num_pages++;
 
+		offset = 0;
 		num -= this_num;
 		total_len += this_num;
 		index++;


