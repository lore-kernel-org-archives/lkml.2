Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab0EVGcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 02:32:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42072 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0EVGcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 02:32:16 -0400
Date: Sat, 22 May 2010 15:45:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       Curt Wohlgemuth <curtw@google.com>
Subject: linux-next: manual merge of the ext4 tree with the ext3 tree
Message-Id: <20100522154515.38a2281b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

Today's linux-next merge of the ext4 tree got a conflict in
fs/ext4/super.c between commits c3d0adcbfef01b69c455ae21aea1ca78ede127db
("quota: move remount handling into the filesystem") and
96bfb05b3177d4d381c136a2c3f44b63cec97f7b ("quota: kill the vfs_dq_off and
vfs_dq_quota_on_remount wrappers") from the ext3 tree and commit
c4cbd7f1cf34e045668b70fa84b0acb217acb807 ("ext4: Print mount options in
when mounting and add a remount message") from the ext4 tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/super.c
index 381e5a9,2e8790e..0000000
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@@ -3721,8 -3716,9 +3724,11 @@@ static int ext4_remount(struct super_bl
  #endif
  	unlock_super(sb);
  	unlock_kernel();
 +	if (enable_quota)
 +		dquot_resume(sb, -1);
+ 
+ 	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
+ 	kfree(orig_data);
  	return 0;
  
  restore_opts:
