Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2KITTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab2KITSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:18:35 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [patch,v3 09/10] lpfc: use scsi_host_alloc_node
Date: Fri,  9 Nov 2012 14:18:06 -0500
Message-Id: <1352488687-19935-10-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: James Smart  <james.smart@emulex.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7dc4218..65956d3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3051,11 +3051,13 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	int error = 0;
 
 	if (dev != &phba->pcidev->dev)
-		shost = scsi_host_alloc(&lpfc_vport_template,
-					sizeof(struct lpfc_vport));
+		shost = scsi_host_alloc_node(&lpfc_vport_template,
+					     sizeof(struct lpfc_vport),
+					     dev_to_node(&phba->pcidev->dev));
 	else
-		shost = scsi_host_alloc(&lpfc_template,
-					sizeof(struct lpfc_vport));
+		shost = scsi_host_alloc_node(&lpfc_template,
+					     sizeof(struct lpfc_vport),
+					     dev_to_node(&phba->pcidev->dev));
 	if (!shost)
 		goto out;
 
-- 
1.7.1

