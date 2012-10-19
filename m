Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161036Ab2JSDEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:04:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:52065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab2JSCso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Richard W.M. Jones" <rjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 24/76] SCSI: virtio-scsi: initialize scatterlist structure
Date: Thu, 18 Oct 2012 19:46:48 -0700
Message-Id: <20121019024353.991387879@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Richard W.M. Jones" <rjones@redhat.com>

commit 2e9c9dfde00a6466441e93033cf2c37f720bdacf upstream.

The sg struct is used without being initialized, which breaks
when CONFIG_DEBUG_SG is enabled.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct vi
 	struct scatterlist sg;
 	unsigned long flags;
 
-	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 


