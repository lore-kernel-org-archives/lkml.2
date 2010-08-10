Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0HJCTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 22:19:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab0HJCTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 22:19:03 -0400
Date: Tue, 10 Aug 2010 12:19:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Boaz Harrosh <bharrosh@panasas.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the trivial tree with the vfs tree
Message-Id: <20100810121900.cbceb878.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
fs/exofs/inode.c between commit 21883a7d05d4c1e97943fa1a587aa2c2a3b09e8c
("exofs: New truncate sequence") from the vfs tree and commit
426d31071ac476ea62c62656b242930c17b58c00 ("fix printk typo 'faild'") from
the trivial tree.

Just context changes.  I fixed it up (see below) and can carry it for a
while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/exofs/inode.c
index eb7368e,5862ae8..0000000
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@@ -713,8 -709,8 +713,8 @@@ int exofs_write_begin(struct file *file
  		ret = simple_write_begin(file, mapping, pos, len, flags, pagep,
  					 fsdata);
  		if (ret) {
- 			EXOFS_DBGMSG("simple_write_begin faild\n");
+ 			EXOFS_DBGMSG("simple_write_begin failed\n");
 -			return ret;
 +			goto out;
  		}
  
  		page = *pagep;
@@@ -726,12 -722,9 +726,12 @@@
  		if (ret) {
  			/*SetPageError was done by _readpage. Is it ok?*/
  			unlock_page(page);
- 			EXOFS_DBGMSG("__readpage_filler faild\n");
+ 			EXOFS_DBGMSG("__readpage_filler failed\n");
  		}
  	}
 +out:
 +	if (unlikely(ret))
 +		_write_failed(mapping->host, pos + len);
  
  	return ret;
  }
