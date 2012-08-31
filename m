Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2HaUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:01:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65089 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2HaUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:01:11 -0400
From: dongsu.park@profitbricks.com
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, JBottomley@parallels.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH 5/5] ib_srp: fix an error accessing invalid memory in rport_dev_loss_timedout
Date: Fri, 31 Aug 2012 22:00:41 +0200
Message-Id: <1346443241-24844-6-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

In rport_dev_loss_timedout(), rport must be obtained by accessing
the member entry dev_loss_work, not fast_io_fail_work.

Signed-off-By: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 915b355..d796413 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -242,7 +242,7 @@ static void rport_fast_io_fail_timedout(struct work_struct *work)
 {
 	struct srp_rport *rport =
 		container_of(to_delayed_work(work), struct srp_rport,
-			     fast_io_fail_work);
+			     dev_loss_work);
 	struct Scsi_Host *shost;
 	struct srp_internal *i;
 
-- 
1.7.11.1

