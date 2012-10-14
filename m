Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2JNO5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:57:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46518 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab2JNOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:27 -0400
Message-Id: <20121014143545.285790962@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 085/147] IB/srp: Avoid having aborted requests hang
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit d8536670916a685df116b5c2cb256573fd25e4e3 upstream.

We need to call scsi_done() for commands after we abort them.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ac66e6b..922d845 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1687,6 +1687,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 			  SRP_TSK_ABORT_TASK);
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
+	scmnd->scsi_done(scmnd);
 
 	return SUCCESS;
 }


