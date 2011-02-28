Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1B1Qul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:50:41 -0500
Received: from kroah.org ([198.145.64.141]:47962 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab1B1QhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:07 2011
Message-Id: <20110228162407.580482916@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [19/68] NFS: fix the return value of nfs_file_fsync()
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: J. R. Okajima <hooanon05@yahoo.co.jp>

commit 0702099bd86c33c2dcdbd3963433a61f3f503901 upstream.

By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
close(2) became returning the non-zero value even if it went well.
nfs_file_fsync() should return 0 when "status" is positive.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -220,7 +220,7 @@ static int nfs_do_fsync(struct nfs_open_
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }


