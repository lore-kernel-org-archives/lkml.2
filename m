Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1K0Feo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1K0Fel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:34:41 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org
Subject: [PATCH 32/62] afs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:12 +0800
Message-Id: <1322371662-26166-33-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/afs/fsclient.c |    8 ++++----
 fs/afs/mntpt.c    |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 2f213d1..b960ff0 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -365,10 +365,10 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call,
 		_debug("extract data");
 		if (call->count > 0) {
 			page = call->reply3;
-			buffer = kmap_atomic(page, KM_USER0);
+			buffer = kmap_atomic(page);
 			ret = afs_extract_data(call, skb, last, buffer,
 					       call->count);
-			kunmap_atomic(buffer, KM_USER0);
+			kunmap_atomic(buffer);
 			switch (ret) {
 			case 0:		break;
 			case -EAGAIN:	return 0;
@@ -411,9 +411,9 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call,
 	if (call->count < PAGE_SIZE) {
 		_debug("clear");
 		page = call->reply3;
-		buffer = kmap_atomic(page, KM_USER0);
+		buffer = kmap_atomic(page);
 		memset(buffer + call->count, 0, PAGE_SIZE - call->count);
-		kunmap_atomic(buffer, KM_USER0);
+		kunmap_atomic(buffer);
 	}
 
 	_leave(" = 0 [done]");
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index aa59184..4405561 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -200,9 +200,9 @@ static struct vfsmount *afs_mntpt_do_automount(struct dentry *mntpt)
 		if (PageError(page))
 			goto error;
 
-		buf = kmap_atomic(page, KM_USER0);
+		buf = kmap_atomic(page);
 		memcpy(devname, buf, size);
-		kunmap_atomic(buf, KM_USER0);
+		kunmap_atomic(buf);
 		page_cache_release(page);
 		page = NULL;
 	}
-- 
1.7.4.4

