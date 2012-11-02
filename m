Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab2KBVrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835Ab2KBVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:46:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [patch,v2 08/10] mpt2sas: use scsi_host_alloc_node
Date: Fri,  2 Nov 2012 17:46:01 -0400
Message-Id: <1351892763-21325-9-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index af4e6c4..a4d6b36 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8011,8 +8011,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
 
-	shost = scsi_host_alloc(&scsih_driver_template,
-	    sizeof(struct MPT2SAS_ADAPTER));
+	shost = scsi_host_alloc_node(&scsih_driver_template,
+	    sizeof(struct MPT2SAS_ADAPTER), dev_to_node(&pdev->dev));
 	if (!shost)
 		return -ENODEV;
 
-- 
1.7.1

