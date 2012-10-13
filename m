Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2JMJIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2JMJIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:08:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] UAPI: Unexport linux/blk_types.h
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 13 Oct 2012 10:08:17 +0100
Message-ID: <20121013090817.28574.26477.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121013090809.28574.46706.stgit@warthog.procyon.org.uk>
References: <20121013090809.28574.46706.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that was linux/blk_types.h incorrectly exported to fix up some missing
bits required by the exported parts of linux/fs.h (READ, WRITE, READA, etc.).

So unexport linux/blk_types.h and unexport the relevant bits of linux/fs.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jens Axboe <jaxboe@fusionio.com>
cc: Tejun Heo <tj@kernel.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>
---

 include/linux/Kbuild |    1 -
 include/linux/fs.h   |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index d114db9..e2a1346 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -69,7 +69,6 @@ header-y += b1lli.h
 header-y += baycom.h
 header-y += bfs_fs.h
 header-y += binfmts.h
-header-y += blk_types.h
 header-y += blkpg.h
 header-y += blktrace_api.h
 header-y += bpqether.h
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65fbf57..c83f45c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -117,6 +117,7 @@ struct inodes_stat_t {
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
+#ifdef __KERNEL__
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
@@ -175,6 +176,7 @@ struct inodes_stat_t {
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
+#endif /* __KERNEL__ */
 
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector

