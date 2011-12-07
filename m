Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1LGQTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:19:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab1LGQTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:19:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:28 2011
Message-Id: <20111207160828.239796453@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:29 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com,
        Christoph Hellwig <hch@lst.de>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [69/80] xfs: validate acl count
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit fa8b18edd752a8b4e9d1ee2cd615b82c93cf8bba upstream.

This prevents in-memory corruption and possible panics if the on-disk
ACL is badly corrupted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_acl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -42,6 +42,8 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)


