Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0ICUH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:07:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55160 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0ICUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:07:25 -0400
Date: Fri, 3 Sep 2010 13:04:43 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
        joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com
Subject: [PATCH V5 7/8] Cleancache: ext4 hook for cleancache
Message-ID: <20100903200443.GA4728@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V5 7/8] Cleancache: ext4 hook for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  For ext4,
all other cleancache hooks are in the VFS layer including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Andreas Dilger <adilger@sun.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.36-rc3/fs/ext4/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/ext4/super.c	2010-08-31 10:27:04.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -1849,6 +1850,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
+	cleancache_init_fs(sb);
 	return res;
 }
 
