Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1KAXdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:33:00 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44898 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755986Ab1KAXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:32:57 -0400
Message-ID: <4EB08189.2@xenotime.net>
Date: Tue, 01 Nov 2011 16:32:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] ext4: fix printk format warning in page-io
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
In-Reply-To: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:

fs/ext4/page-io.c:108:5: warning: format '%d' expects type 'int', but argument 6 has type 'ssize_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	"Theodore Ts'o" <tytso@mit.edu>
Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
Cc:	linux-ext4@vger.kernel.org
---
 fs/ext4/page-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-1101.orig/fs/ext4/page-io.c
+++ next-2011-1101/fs/ext4/page-io.c
@@ -104,7 +104,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 		ext4_msg(inode->i_sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
-			 "(inode %lu, offset %llu, size %d, error %d)",
+			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
 
