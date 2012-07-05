Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2GEKp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:45:57 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:49869 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2GEKpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:45:55 -0400
X-AuditID: b753bd60-928c4ba0000047ca-70-4ff56fde3ff8
X-AuditID: b753bd60-928c4ba0000047ca-70-4ff56fde3ff8
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 2/5] fuse: do not create cache for fuse request allocation
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2012 19:50:50 +0900
Message-ID: <20120705105050.17812.56780.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fuse_req_cachep was used for request allocation in fuse.
This patch does not create it since it is not used anymore
due to the tunable read/write request size in fuse.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 fs/fuse/dev.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 511560b..4087ff4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -23,8 +23,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-static struct kmem_cache *fuse_req_cachep;
-
 static struct fuse_conn *fuse_get_conn(struct file *file)
 {
 	/*
@@ -2075,27 +2073,10 @@ static struct miscdevice fuse_miscdevice = {
 
 int __init fuse_dev_init(void)
 {
-	int err = -ENOMEM;
-	fuse_req_cachep = kmem_cache_create("fuse_request",
-					    sizeof(struct fuse_req),
-					    0, 0, NULL);
-	if (!fuse_req_cachep)
-		goto out;
-
-	err = misc_register(&fuse_miscdevice);
-	if (err)
-		goto out_cache_clean;
-
-	return 0;
-
- out_cache_clean:
-	kmem_cache_destroy(fuse_req_cachep);
- out:
-	return err;
+	return misc_register(&fuse_miscdevice);
 }
 
 void fuse_dev_cleanup(void)
 {
 	misc_deregister(&fuse_miscdevice);
-	kmem_cache_destroy(fuse_req_cachep);
 }

