Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2BJFzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2BJFmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:42:23 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH 10/60] ata: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:31 +0800
Message-Id: <1328852421-19678-11-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/ata/libata-sff.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 9691dd0..d8af325 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -720,13 +720,13 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 		/* FIXME: use a bounce buffer */
 		local_irq_save(flags);
-		buf = kmap_atomic(page, KM_IRQ0);
+		buf = kmap_atomic(page);
 
 		/* do the actual data transfer */
 		ap->ops->sff_data_xfer(qc->dev, buf + offset, qc->sect_size,
 				       do_write);
 
-		kunmap_atomic(buf, KM_IRQ0);
+		kunmap_atomic(buf);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
@@ -865,13 +865,13 @@ next_sg:
 
 		/* FIXME: use bounce buffer */
 		local_irq_save(flags);
-		buf = kmap_atomic(page, KM_IRQ0);
+		buf = kmap_atomic(page);
 
 		/* do the actual data transfer */
 		consumed = ap->ops->sff_data_xfer(dev,  buf + offset,
 								count, rw);
 
-		kunmap_atomic(buf, KM_IRQ0);
+		kunmap_atomic(buf);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
-- 
1.7.7.6

