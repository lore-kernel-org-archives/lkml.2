Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861Ab2KBVsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758960Ab2KBVq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:46:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [patch,v2 03/10] scsi: make scsi_alloc_sdev numa-aware
Date: Fri,  2 Nov 2012 17:45:56 -0400
Message-Id: <1351892763-21325-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the numa node id set in the Scsi_Host to allocate the sdev structure
on the device-local numa node.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi_scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..f10a308 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -232,8 +232,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	extern void scsi_evt_thread(struct work_struct *work);
 	extern void scsi_requeue_run_queue(struct work_struct *work);
 
-	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
+			    GFP_ATOMIC, shost->numa_node);
 	if (!sdev)
 		goto out;
 
-- 
1.7.1

