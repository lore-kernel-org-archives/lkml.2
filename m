Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2BJFpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab2BJFpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:45:00 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 26/60] vhost: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:47 +0800
Message-Id: <1328852421-19678-27-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/vhost/vhost.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c14c42b..bdb2d64 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -937,9 +937,9 @@ static int set_bit_to_user(int nr, void __user *addr)
 	if (r < 0)
 		return r;
 	BUG_ON(r != 1);
-	base = kmap_atomic(page, KM_USER0);
+	base = kmap_atomic(page);
 	set_bit(bit, base);
-	kunmap_atomic(base, KM_USER0);
+	kunmap_atomic(base);
 	set_page_dirty_lock(page);
 	put_page(page);
 	return 0;
-- 
1.7.7.6

