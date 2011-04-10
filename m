Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1DJKIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 06:08:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50237 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab1DJKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 06:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=cwcK9xRqJ2U74H6vxFGxLfA8uPnS2x5mJ3x6PZM8U6m87cxctAwDeXSK4cysUFnBtx
         B1VEik42qxgetSdyq2pgrsvZ4WNg0E7onMYzcj527z88WLJd/OHqpEcL1njDh9kQqYMa
         IDyt11rxA60JXH+SgdzkxXwdeoMrvtadLpxow=
Date: Sun, 10 Apr 2011 18:08:18 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: petr@vandrovec.name, viro@zeniv.linux.org.uk, arnd@arndb.de,
        npiggin@kernel.dk, jens.axboe@oracle.com, greg@kroah.com,
        akpm@linux-foundation.org, joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]initialize the array of fs/ncpfs/inode.c
Message-ID: <20110410100816.GB4953@gmail.com>
Mail-Followup-To: petr@vandrovec.name, viro@zeniv.linux.org.uk,
	arnd@arndb.de, npiggin@kernel.dk, jens.axboe@oracle.com,
	greg@kroah.com, akpm@linux-foundation.org, joe@perches.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
	When i compile the linux-2.6.38.2, some warnings happened
to me. One of them is like following.

fs/ncpfs/inode.c: In function 'ncp_fill_super':
fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[1u]' may be used 
uninitialized in this function
...
See details by the URL: 
http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=patched.png

So i patch for it below.

Thanks.
Harry Wei.

From: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 fs/ncpfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 00a1d1c..15f0ebb 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -30,6 +30,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/namei.h>
+#include <linux/ncp.h>
 
 #include <net/sock.h>
 
@@ -461,6 +462,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 #endif
 	struct ncp_entry_info finfo;
 
+	data.mounted_vol[NCP_VOLNAME_LEN + 1] = {0};
 	data.wdog_pid = NULL;
 	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
 	if (!server)
-- 
1.7.0.4

