Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1IGVjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:39:45 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:3669 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab1IGVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:39:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1315425280!15802307!616
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: dt3155v4l: remove irq_handler from struct dt3155_priv
Date: Wed, 7 Sep 2011 14:37:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <mchehab@redhat.com>,
        <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109071438.00719.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to cache the irq_handler in struct dt3155_priv.  Just pass
the function directly in request_irq.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>

---

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 4059ea6..693b3d3 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -428,8 +428,7 @@ dt3155_open(struct file *filp)
 		/* disable all irqs, clear all irq flags */
 		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
 						pd->regs + INT_CSR);
-		pd->irq_handler = dt3155_irq_handler_even;
-		ret = request_irq(pd->pdev->irq, pd->irq_handler,
+		ret = request_irq(pd->pdev->irq, dt3155_irq_handler_even,
 						IRQF_SHARED, DT3155_NAME, pd);
 		if (ret) {
 			printk(KERN_ERR "dt3155: error: request_irq\n");
diff --git a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/dt3155v4l/dt3155v4l.h
index b0792b3..fea333c 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h
@@ -183,7 +183,6 @@ struct dt3155_stats {
  * @q			pointer to vb2_queue structure
  * @curr_buf:		pointer to curren buffer
  * @mux:		mutex to protect the instance
- * @irq_handler:	irq handler for the driver
  * @dmaq		queue for dma buffers
  * @lock		spinlock for dma queue
  * @field_count		fields counter
@@ -199,7 +198,6 @@ struct dt3155_priv {
 	struct vb2_queue *q;
 	struct vb2_buffer *curr_buf;
 	struct mutex mux;
-	irq_handler_t irq_handler;
 	struct list_head dmaq;
 	spinlock_t lock;
 	unsigned int field_count;
