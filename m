Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2LKJCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:02:47 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34245 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2LKJCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:02:43 -0500
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
CC: Support <support@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 11 Dec 2012 14:32:32 +0530
Subject: RE: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
Thread-Topic: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
Thread-Index: Ac3URAoByM/sXjJETsyk9UkaipSSfgDOiuIQ
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E75BB255@inbmail02.lsi.com>
References: <20121207062801.GD18220@elgon.mountain>
In-Reply-To: <20121207062801.GD18220@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Friday, December 07, 2012 11:58 AM
To: Nandigama, Nagalakshmi
Cc: Reddy, Sreekanth; Support; James E.J. Bottomley; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi

ioc->diag_trigger_mpi is an SL_WH_MPI_TRIGGERS_T struct.

There is a cut and paste error here and SL_WH_EVENT_TRIGGERS_T is used instead of SL_WH_MPI_TRIGGERS_T.  Since the SL_WH_EVENT_TRIGGERS_T is smaller than SL_WH_MPI_TRIGGERS_T, it means we only clear part of the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

This is a static analysis patch.  Even though I'm pretty sure it's correct, I'm not able to test it.

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
