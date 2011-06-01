Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161685Ab1FAIMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:12:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161647Ab1FAIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:12:29 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:33 2011
Message-Id: <20110601080332.543733149@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:06 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eddie Wai <eddie.wai@broadcom.com>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [070/146] [SCSI] bnx2i: Updated the connection shutdown/cleanup
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 timeout

From: Eddie Wai <eddie.wai@broadcom.com>

commit d5307a078bb0288945c900c6f4a2fd77ba6d0817 upstream.

Modified the 10s wait time for inflight offload connections to
advance to the next state to 2s based on test result.
Modified the 20s shutdown timeout to 30s based on test result.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/bnx2i/bnx2i_init.c  |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -227,7 +227,7 @@ void bnx2i_stop(void *handle)
 	wait_event_interruptible_timeout(hba->eh_wait,
 					 (list_empty(&hba->ep_ofld_list) &&
 					 list_empty(&hba->ep_destroy_list)),
-					 10 * HZ);
+					 2 * HZ);
 	/* Wait for all endpoints to be torn down, Chip will be reset once
 	 *  control returns to network driver. So it is required to cleanup and
 	 * release all connection resources before returning from this routine.
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -858,7 +858,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct
 	mutex_init(&hba->net_dev_lock);
 	init_waitqueue_head(&hba->eh_wait);
 	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
-		hba->hba_shutdown_tmo = 20 * HZ;
+		hba->hba_shutdown_tmo = 30 * HZ;
 		hba->conn_teardown_tmo = 20 * HZ;
 		hba->conn_ctx_destroy_tmo = 6 * HZ;
 	} else {	/* 5706/5708/5709 */


