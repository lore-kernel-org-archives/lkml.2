Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2J3USy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:18:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2J3UPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:15:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [patch 06/10] ata: use scsi_host_alloc_node
Date: Tue, 30 Oct 2012 16:14:40 -0400
Message-Id: <1351628084-29358-9-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

