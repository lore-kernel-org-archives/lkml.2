Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428Ab1C3Vpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:45:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:58322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964846Ab1C3VHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277839"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hooanon05@yahoo.co.jp, Trond.Myklebust@netapp.com,
        tim.gardner@canonical.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [122/275] NFS: fix the return value of nfs_file_fsync()
Message-Id: <20110330210602.2875A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/nfs/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/file.c	2011-03-29 22:51:19.419226280 -0700
+++ linux-2.6.35.y/fs/nfs/file.c	2011-03-29 23:03:00.750280971 -0700
@@ -222,7 +222,7 @@
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }
