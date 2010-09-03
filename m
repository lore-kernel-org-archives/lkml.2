Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0ICUHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:07:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55172 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab0ICUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:07:30 -0400
Date: Fri, 3 Sep 2010 13:05:14 -0700
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
Subject: [PATCH V5 8/8] Cleancache: ocfs2 hook for cleancache
Message-ID: <20100903200514.GA4750@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V5 8/8] Cleancache: ocfs2 hook for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  Ocfs2 is
currently the only user of the clustered filesystem
interface but nevertheless, the cleancache hooks in the
VFS layer are sufficient for ocfs2 including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.36-rc3/fs/ocfs2/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/ocfs2/super.c	2010-08-31 10:29:14.000000000 -0600
@@ -42,6 +42,7 @@
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
 #include <linux/smp_lock.h>
+#include <linux/cleancache.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -2284,6 +2285,7 @@ static int ocfs2_initialize_super(struct
 		mlog_errno(status);
 		goto bail;
 	}
+	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
 
 bail:
 	mlog_exit(status);
