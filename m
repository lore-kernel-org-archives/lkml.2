Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab2BNOi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:38:58 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52394 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab2BNOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:38:51 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: LSI Corporation <DL-MPTFusionLinux@lsi.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mpt2sas: fix -Wunused-variable warning
Date: Tue, 14 Feb 2012 15:38:46 +0100
Message-Id: <1329230326-26868-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230331;3d7cf095;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function
  ‘_scsih_sas_broadcast_primative_event’:
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5766:40: warning: unused
  variable ‘event_data’ [-Wunused-variable]

remove Mpi2EventDataSasBroadcastPrimitive_t *event_data,
use fw_event->event_data directly instead.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 193e33e..067d359 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5763,7 +5763,6 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5772,8 +5771,8 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
+	    "width(%d)\n", ioc->name, __func__, fw_event->event_data->PhyNum,
+	     fw_event->event_data->PortWidth));
 
 	_scsih_block_io_all_device(ioc);
 
-- 
1.7.7.3

