Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab0HLAfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:35:54 -0400
Received: from kroah.org ([198.145.64.141]:43421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952Ab0HKX6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:37 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.250559959@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [062/111] Btrfs: align offsets for btrfs_ordered_update_i_size
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <yanzheng@21cn.com>

commit a038fab0cb873c75d6675e2bcffce8a3935bdce7 upstream.

Some callers of btrfs_ordered_update_i_size can now pass in
a NULL for the ordered extent to update against.  This makes
sure we properly align the offset they pass in when deciding
how much to bump the on disk i_size.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/ordered-data.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -626,6 +626,8 @@ int btrfs_ordered_update_i_size(struct i
 
 	if (ordered)
 		offset = entry_end(ordered);
+	else
+		offset = ALIGN(offset, BTRFS_I(inode)->root->sectorsize);
 
 	mutex_lock(&tree->mutex);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;


