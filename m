Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2ISQcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:32:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26026 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab2ISQcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:32:17 -0400
Subject: [PATCH 06/11] fuse: rework fuse_do_ioctl()
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Wed, 19 Sep 2012 20:32:37 +0400
Message-ID: <20120919163230.29482.61000.stgit@maximpc.sw.ru>
In-Reply-To: <20120919161559.29482.55120.stgit@maximpc.sw.ru>
References: <20120919161559.29482.55120.stgit@maximpc.sw.ru>
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

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d72d638..08899a6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1893,7 +1893,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		num_pages++;
 	}
 
-	req = fuse_get_req(fc, FUSE_MAX_PAGES_PER_REQ);
+	req = fuse_get_req(fc, num_pages);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		req = NULL;

