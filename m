Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab2CNHnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:43:49 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:48418 "EHLO
	smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2CNHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:43:45 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 03:43:45 EDT
Date: Wed, 14 Mar 2012 14:56:10 +1100
From: Chris Dunlop <chris@onthe.net.au>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mpt2sas: Fix hex/decimal typo in _base_sas_log_info()
Message-ID: <20120314035610.GA21520@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The log_info constant is supposed to be IOP_LOGINFO_CODE_TASK_TERMINATED
(see drivers/message/fusion/lsi/mpi_log_sas.h) rather than the
non-sensical 0x1CA86D0.

Signed-off-by: Chris Dunlop <chris@onthe.net.au>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a78036f..224ed29 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -657,7 +657,7 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
 		return;
 
 	/* eat the loginfos associated with task aborts */
-	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
+	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
 		return;
 
-- 
1.7.0.4

