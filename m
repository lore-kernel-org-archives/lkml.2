Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab0GAUvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:51:24 -0400
Received: from kroah.org ([198.145.64.141]:47500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab0GAUuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:20 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.706303719@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 070/164] exofs: confusion between kmap() and kmap_atomic() api
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit ddf08f4b90a413892bbb9bb2e8a57aed991cd47d upstream.

For kmap_atomic() we call kunmap_atomic() on the returned pointer.
That's different from kmap() and kunmap() and so it's easy to get them
backwards.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exofs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -608,7 +608,7 @@ int exofs_make_empty(struct inode *inode
 	de->inode_no = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
 	exofs_set_de_type(de, inode);
-	kunmap_atomic(page, KM_USER0);
+	kunmap_atomic(kaddr, KM_USER0);
 	err = exofs_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);


