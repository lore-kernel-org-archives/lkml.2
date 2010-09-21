Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab0IUEER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:04:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50837 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0IUEEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:04:16 -0400
Date: Tue, 21 Sep 2010 14:04:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@MIT.EDU>
Subject: linux-next: manual merge of the block tree with the ext4 tree
Message-Id: <20100921140410.f1ba148e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/ext4/mballoc.c between commit 9c543072a9dd7cf60cbf472914a6480ffda50b27
("ext4: Check for negative error code from sb_issue_discard") from the
ext4 tree and commit 2cf6d26a354ab6362e301b5a323832b02867df47 ("block:
pass gfp_mask and flags to sb_issue_discard") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/mballoc.c
index e4f4dae,19aa0d4..0000000
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@@ -2612,8 -2566,8 +2612,8 @@@ static inline void ext4_issue_discard(s
  	discard_block = block + ext4_group_first_block_no(sb, block_group);
  	trace_ext4_discard_blocks(sb,
  			(unsigned long long) discard_block, count);
- 	ret = sb_issue_discard(sb, discard_block, count);
+ 	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
 -	if (ret == EOPNOTSUPP) {
 +	if (ret == -EOPNOTSUPP) {
  		ext4_warning(sb, "discard not supported, disabling");
  		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
  	}
