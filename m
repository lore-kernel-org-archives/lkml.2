Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2HFScR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:32:17 -0400
Received: from www17.your-server.de ([213.133.104.17]:47794 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab2HFScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:32:13 -0400
Subject: [PATCH] [SCSI] libsas: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:17 +0200
Message-ID: <1344275477.14513.112.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1093,9 +1093,7 @@ int sas_init_queue(struct sas_ha_struct
 
 	core->queue_thread = kthread_run(sas_queue_thread, sas_ha,
 					 "sas_queue_%d", core->shost->host_no);
-	if (IS_ERR(core->queue_thread))
-		return PTR_ERR(core->queue_thread);
-	return 0;
+	return PTR_RET(core->queue_thread);
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
