Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab1D2TJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:09:38 -0400
Received: from kroah.org ([198.145.64.141]:50188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667Ab1D2S6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.365838835@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [08/55] nfsd4: Fix filp leak
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit a96e5b90804be8b540d30f4a1453fc87f95b3149 upstream.

23fcf2ec93fb8573a653408316af599939ff9a8e (nfsd4: fix oops on lock failure)

The above patch breaks free path for stp->st_file. If stp was inserted
into sop->so_stateids, we have to free stp->st_file refcount. Because
stp->st_file refcount itself is taken whether or not any refcounts are
taken on the stp->st_file->fi_fds[].

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -403,8 +403,8 @@ static void free_generic_stateid(struct
 	if (stp->st_access_bmap) {
 		oflag = nfs4_access_bmap_to_omode(stp);
 		nfs4_file_put_access(stp->st_file, oflag);
-		put_nfs4_file(stp->st_file);
 	}
+	put_nfs4_file(stp->st_file);
 	kmem_cache_free(stateid_slab, stp);
 }
 


