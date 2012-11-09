Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2KITTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:19:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab2KITSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:18:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: [patch,v3 06/10] ata: use scsi_host_alloc_node
Date: Fri,  9 Nov 2012 14:18:03 -0500
Message-Id: <1352488687-19935-7-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
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

