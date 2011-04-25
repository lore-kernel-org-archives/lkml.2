Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1DYUvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:51:47 -0400
Received: from 1wt.eu ([62.212.114.60]:34118 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1DYUY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:29 -0400
Message-Id: <20110425200237.121465866@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 095/173] ext3: Always set dx_nodes fake_dirent explicitly.
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit d7433142b63d727b5a217c37b1a1468b116a9771 upstream.

(crossport of 1f7bebb9e911d870fa8f997ddff838e82b5715ea
by Andreas Schlick <schlick@lavabit.com>)

When ext3_dx_add_entry() has to split an index node, it has to ensure that
name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
won't recognise it as an intermediate htree node and consider the htree to
be corrupted.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1550,8 +1550,8 @@ static int ext3_dx_add_entry(handle_t *h
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)


