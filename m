Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2AaCLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:11:22 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:59892 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752575Ab2AaCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:11:21 -0500
Message-ID: <4F275B64.8060904@xenotime.net>
Date: Mon, 30 Jan 2012 19:09:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] ext4: fix balloc.c printk format warning
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
In-Reply-To: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for a sector_t value:

fs/ext4/balloc.c:405:3: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'sector_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	"Theodore Ts'o" <tytso@mit.edu>
Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
Cc:	linux-ext4@vger.kernel.org
---
 fs/ext4/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120130.orig/fs/ext4/balloc.c
+++ linux-next-20120130/fs/ext4/balloc.c
@@ -404,7 +404,7 @@ int ext4_wait_block_bitmap(struct super_
 	if (!buffer_uptodate(bh)) {
 		ext4_error(sb, "Cannot read block bitmap - "
 			   "block_group = %u, block_bitmap = %llu",
-			   block_group, bh->b_blocknr);
+			   block_group, (unsigned long long)bh->b_blocknr);
 		return 1;
 	}
 	/* Panic or remount fs read-only if block bitmap is invalid */
