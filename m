Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab2AJW72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:59:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933371Ab2AJW7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:21 2012
Message-Id: <20120110214621.688787495@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        Ben Myers <bpm@sgi.com>
Subject: [40/40] xfs: fix acl count validation in xfs_acl_from_disk()
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 093019cf1b18dd31b2c3b77acce4e000e2cbc9ce upstream.

Commit fa8b18ed didn't prevent the integer overflow and possible
memory corruption.  "count" can go negative and bypass the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -39,7 +39,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
 	struct xfs_acl_entry *ace;
-	int count, i;
+	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
 	if (count > XFS_ACL_MAX_ENTRIES)


