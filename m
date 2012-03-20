Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030204Ab2CTQ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab2CTQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:58:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: checking wrong bit in afs_readpages()
To: torvalds@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 20 Mar 2012 16:58:06 +0000
Message-ID: <20120320165806.26231.8187.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We should be testing "if (vnode->flags & (1 << 4))" instead of
"if (vnode->flags & 4) {".  The current test checks if the data was
modified instead of deleted.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 14d89fa..8f6e923 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -251,7 +251,7 @@ static int afs_readpages(struct file *file, struct address_space *mapping,
 	ASSERT(key != NULL);
 
 	vnode = AFS_FS_I(mapping->host);
-	if (vnode->flags & AFS_VNODE_DELETED) {
+	if (test_bit(AFS_VNODE_DELETED, &vnode->flags)) {
 		_leave(" = -ESTALE");
 		return -ESTALE;
 	}

