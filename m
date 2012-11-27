Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2K0Qqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:46:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab2K0Qqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:46:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [patch,v3,repost 03/10] scsi: make scsi_alloc_sdev numa-aware
Date: Tue, 27 Nov 2012 11:46:31 -0500
Message-Id: <1354034799-8460-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the numa node id set in the Scsi_Host to allocate the sdev structure
on the device-local numa node.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi_scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..d91749d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -232,8 +232,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	extern void scsi_evt_thread(struct work_struct *work);
 	extern void scsi_requeue_run_queue(struct work_struct *work);
 
-	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
+			    GFP_ATOMIC, scsi_host_get_numa_node(shost));
 	if (!sdev)
 		goto out;
 
-- 
1.7.1

