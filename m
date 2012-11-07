Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2KGKsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:48:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2KGKsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:48:50 -0500
X-IronPort-AV: E=Sophos;i="4.80,729,1344182400"; 
   d="scan'208";a="6154926"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 2/5] virtio-scsi: remove the needless variable gfp_mask
Date: Wed, 7 Nov 2012 18:18:11 +0800
Message-Id: <1352283494-31200-3-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:58,
	Serialize complete at 2012/11/07 18:17:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use the macro instead of define a variable.


Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8746c37..5390229 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -587,11 +587,10 @@ static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
 	struct virtio_device *vdev, int sg_elems)
 {
 	struct virtio_scsi_target_state *tgt;
-	gfp_t gfp_mask = GFP_KERNEL;
 
 	/* We need extra sg elements at head and tail.  */
 	tgt = kmalloc(sizeof(*tgt) + sizeof(tgt->sg[0]) * (sg_elems + 2),
-		      gfp_mask);
+		      GFP_KERNEL);
 
 	if (!tgt)
 		return NULL;
-- 
1.8.0

