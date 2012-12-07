Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2LGG2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:28:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41301 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2LGG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:28:18 -0500
Date: Fri, 7 Dec 2012 09:28:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
Message-ID: <20121207062801.GD18220@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioc->diag_trigger_mpi is an SL_WH_MPI_TRIGGERS_T struct.

There is a cut and paste error here and SL_WH_EVENT_TRIGGERS_T is used
instead of SL_WH_MPI_TRIGGERS_T.  Since the SL_WH_EVENT_TRIGGERS_T is
smaller than SL_WH_MPI_TRIGGERS_T, it means we only clear part of the
buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

This is a static analysis patch.  Even though I'm pretty sure it's
correct, I'm not able to test it.

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8af944d..3e35e64 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3136,7 +3136,7 @@ _ctl_diag_trigger_mpi_store(struct device *cdev,
 	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	sz = min(sizeof(struct SL_WH_MPI_TRIGGERS_T), count);
 	memset(&ioc->diag_trigger_mpi, 0,
-	    sizeof(struct SL_WH_EVENT_TRIGGERS_T));
+	    sizeof(struct SL_WH_MPI_TRIGGERS_T));
 	memcpy(&ioc->diag_trigger_mpi, buf, sz);
 	if (ioc->diag_trigger_mpi.ValidEntries > NUM_VALID_ENTRIES)
 		ioc->diag_trigger_mpi.ValidEntries = NUM_VALID_ENTRIES;
