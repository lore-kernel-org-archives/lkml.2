Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2IRG44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:56:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17343 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2IRG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:56:54 -0400
Date: Tue, 18 Sep 2012 09:56:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] lpfc: fix an '&&' vs '&' typo
Message-ID: <20120918065647.GA31914@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent here was clearly to do a bitwise AND similar to the others in
this file.  The current condition is never true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 7ffabb7..65f9fb6 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -634,7 +634,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
-			    (irsp->un.ulpWord[4] && IOERR_PARAM_MASK) !=
+			    (irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
 			    IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 
