Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946226Ab2JDVZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:25:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946197Ab2JDVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:25:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 48/52] IB/srp: Avoid having aborted requests hang
Date: Thu,  4 Oct 2012 14:21:39 -0700
Message-Id: <20121004210641.427138736@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit d8536670916a685df116b5c2cb256573fd25e4e3 upstream.

We need to call scsi_done() for commands after we abort them.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1687,6 +1687,7 @@ static int srp_abort(struct scsi_cmnd *s
 			  SRP_TSK_ABORT_TASK);
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
+	scmnd->scsi_done(scmnd);
 
 	return SUCCESS;
 }


