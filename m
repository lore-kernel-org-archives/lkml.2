Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0HKX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:20 -0400
Received: from kroah.org ([198.145.64.141]:43543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759185Ab0HKX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:57 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.784972419@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [079/111] Btrfs: apply updated fallocate i_size fix
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 23b5c50945f2294add0137799400329c0ebba290 upstream.

This version of the i_size fix for fallocate makes sure we only update
the i_size when the current fallocate is really operating outside of
i_size.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5798,7 +5798,9 @@ static int prealloc_file_range(struct in
 		inode->i_ctime = CURRENT_TIME;
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-		    cur_offset > inode->i_size) {
+			(actual_len > inode->i_size) &&
+			(cur_offset > inode->i_size)) {
+
 			if (cur_offset > actual_len)
 				i_size  = actual_len;
 			else


