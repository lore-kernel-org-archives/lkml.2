Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2IGRmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:42:01 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7313 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab2IGRl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:41:59 -0400
Subject: [PATCH 6/6] fuse: rework fuse_do_ioctl()
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 07 Sep 2012 21:41:59 +0400
Message-ID: <20120907174154.1343.22158.stgit@maximpc.sw.ru>
In-Reply-To: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_do_ioctl() already calculates the number of pages it's going to use. It is
stored in 'num_pages' variable. So the patch simply uses it for allocating
fuse_req.
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 84cc83c..abb070b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1885,7 +1885,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		num_pages++;
 	}
 
-	req = fuse_get_req_multipage(fc, FUSE_MAX_PAGES_PER_REQ);
+	req = fuse_get_req_multipage(fc, num_pages);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		req = NULL;

