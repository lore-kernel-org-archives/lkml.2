Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2GSMmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42954 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2GSMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:04 -0400
X-AuditID: b753bd60-9f483ba000000655-6c-5008009982ae
X-AuditID: b753bd60-9f483ba000000655-6c-5008009982ae
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 1/6] pipe: make the maximum pipe size referable from
 kernel module
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Jul 2012 21:49:07 +0900
Message-ID: <20120719124907.6250.16564.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the maximum pipe size referable from a kernel module.

The /proc/sys/fs/pipe-max-size defines an upper limit for the
capacity of a pipe. It is also used as an upper limit of a
fuse read/write request size in this patch series. So, it
is necessary to make it referable from a kernel module.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Muthukumar R <muthur@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 fs/pipe.c                 |    7 +++++++
 include/linux/pipe_fs_i.h |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 49c1065..f0f3768 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -36,6 +36,13 @@ unsigned int pipe_max_size = 1048576;
  */
 unsigned int pipe_min_size = PAGE_SIZE;
 
+/* get pipe_max_size */
+unsigned int pipe_get_max_size(void)
+{
+	return pipe_max_size;
+}
+EXPORT_SYMBOL(pipe_get_max_size);
+
 /*
  * We use a start+len construction, which provides full use of the 
  * allocated memory.
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index e1ac1ce..50a16dd 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -134,6 +134,9 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
+/* get pipe_max_size */
+unsigned int pipe_get_max_size(void);
+
 /* Pipe lock and unlock operations */
 void pipe_lock(struct pipe_inode_info *);
 void pipe_unlock(struct pipe_inode_info *);

