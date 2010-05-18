Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0ERDEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:04:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54674 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0ERDEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:04:05 -0400
Date: Tue, 18 May 2010 13:04:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the block tree with the vfs tree
Message-Id: <20100518130401.f6286112.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/fs-writeback.c between commit 1c9539ad0dd1c3c3964ea35d5a355a0ed19c39c7
("fs-writeback.c: bitfields should be unsigned") from the vfs tree and
commit e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback: fix
WB_SYNC_NONE writeback from umount") from the block tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/fs-writeback.c
index 24e85ce,0f62957..0000000
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@@ -42,9 -42,10 +42,10 @@@ struct wb_writeback_args 
  	long nr_pages;
  	struct super_block *sb;
  	enum writeback_sync_modes sync_mode;
 -	int for_kupdate:1;
 -	int range_cyclic:1;
 -	int for_background:1;
 -	int sb_pinned:1;
 +	unsigned int for_kupdate:1;
 +	unsigned int range_cyclic:1;
 +	unsigned int for_background:1;
++	unsigned int sb_pinned:1;
  };
  
  /*
