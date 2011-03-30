Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108Ab1C3VJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:25259 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095Ab1C3VJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238528"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sandeen@redhat.com, jack@suse.cz, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [211/275] ext3: Always set dx_node's fake_dirent explicitly.
Message-Id: <20110330210735.D5E243E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext3/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/ext3/namei.c
===================================================================
--- linux-2.6.35.y.orig/fs/ext3/namei.c	2011-03-29 22:50:34.061386873 -0700
+++ linux-2.6.35.y/fs/ext3/namei.c	2011-03-29 23:03:02.652232306 -0700
@@ -1550,8 +1550,8 @@
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)
