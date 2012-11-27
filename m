Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2K0Qq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:46:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab2K0Qqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:46:54 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: [patch,v3,repost 06/10] ata: use scsi_host_alloc_node
Date: Tue, 27 Nov 2012 11:46:34 -0500
Message-Id: <1354034799-8460-7-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/ata/libata-scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..9d5dd09 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3586,7 +3586,8 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		struct Scsi_Host *shost;
 
 		rc = -ENOMEM;
-		shost = scsi_host_alloc(sht, sizeof(struct ata_port *));
+		shost = scsi_host_alloc_node(sht, sizeof(struct ata_port *),
+					     dev_to_node(host->dev));
 		if (!shost)
 			goto err_alloc;
 
-- 
1.7.1

