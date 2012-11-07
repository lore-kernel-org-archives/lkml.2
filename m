Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2KGKth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:49:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab2KGKsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:48:52 -0500
X-IronPort-AV: E=Sophos;i="4.80,729,1344182400"; 
   d="scan'208";a="6154928"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 3/5] virtio-scsi: use pr_err instead of printk
Date: Wed, 7 Nov 2012 18:18:12 +0800
Message-Id: <1352283494-31200-4-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:57,
	Serialize complete at 2012/11/07 18:17:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_err() instead of printk() for code cleanups.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5390229..765138a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -790,8 +790,7 @@ static int __init init(void)
 
 	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
 	if (!virtscsi_cmd_cache) {
-		printk(KERN_ERR "kmem_cache_create() for "
-				"virtscsi_cmd_cache failed\n");
+		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
 		goto error;
 	}
 
@@ -800,8 +799,7 @@ static int __init init(void)
 		mempool_create_slab_pool(VIRTIO_SCSI_MEMPOOL_SZ,
 					 virtscsi_cmd_cache);
 	if (!virtscsi_cmd_pool) {
-		printk(KERN_ERR "mempool_create() for"
-				"virtscsi_cmd_pool failed\n");
+		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
 		goto error;
 	}
 	ret = register_virtio_driver(&virtio_scsi_driver);
-- 
1.8.0

