Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2AJUKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:10:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab2AJUKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:10:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 12:08:51 2012
Message-Id: <20120110200851.542342130@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 12:07:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        Ben Myers <bpm@sgi.com>
Subject: [20/20] xfs: fix acl count validation in xfs_acl_from_disk()
In-Reply-To: <20120110200902.GA5674@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -37,7 +37,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
 	struct xfs_acl_entry *ace;
-	int count, i;
+	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
 	if (count > XFS_ACL_MAX_ENTRIES)


