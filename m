Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1BJSAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:00:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1BJSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=jlNwadhDCRdgZ4VdYzuUyRFf7yK+oQF2+8YD4jxQ1UQq9uh9A0ir5/ri+6zfD59CB9
         jFHNSrm31HE52lh/a9IxdNLYuM+DNYnX973nWbjGbrfPeK1OKQhKl0cEKhXKJXZfbiTb
         ERfVbXymFxnvk6Q265Ch9PaHagplN14NBX5M8=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: zcache: fix memory leak
Date: Thu, 10 Feb 2011 21:00:39 +0300
Message-Id: <1297360839-21602-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

obj is not freed if __get_free_page() failed.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/staging/zcache/zcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
index 61be849..b8a2b30 100644
--- a/drivers/staging/zcache/zcache.c
+++ b/drivers/staging/zcache/zcache.c
@@ -790,6 +790,7 @@ static int zcache_do_preload(struct tmem_pool *pool)
 	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
 	if (unlikely(page == NULL)) {
 		zcache_failed_get_free_pages++;
+		kmem_cache_free(zcache_obj_cache, obj);
 		goto unlock_out;
 	}
 	preempt_disable();
-- 
1.7.0.4

