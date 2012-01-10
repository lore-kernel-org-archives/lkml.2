Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2AJXRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:17:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933477Ab2AJXBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:24 2012
Message-Id: <20120110215024.482323323@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Ben Myers <bpm@sgi.com>
Subject: [41/42] xfs: validate acl count
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit fa8b18edd752a8b4e9d1ee2cd615b82c93cf8bba upstream.

This prevents in-memory corruption and possible panics if the on-disk
ACL is badly corrupted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_acl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -42,6 +42,8 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)


