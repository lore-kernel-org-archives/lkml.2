Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2JBP0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:26:13 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47435 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JBP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:26:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com,
        "Richard W.M. Jones" <rjones@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] virtio-scsi: initialize scatterlist structure
Date: Tue,  2 Oct 2012 17:25:46 +0200
Message-Id: <1349191548-7120-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
References: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard W.M. Jones <rjones@redhat.com>

The sg struct is used without being initialized, which breaks
when CONFIG_DEBUG_SG is enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3e79a2f..7554d78 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
-	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-- 
1.7.1


