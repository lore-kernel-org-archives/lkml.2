Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2FIOEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:04:15 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:42379 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab2FIOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:04:14 -0400
From: Josh Hunt <johunt@akamai.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/2] scsi: propery initialize atomic_t ioerr_cnt
Date: Sat,  9 Jun 2012 07:03:38 -0700
Message-Id: <1339250619-1561-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize atomic_t ioerr_cnt as per the guidelines defined in Documentation/atomic_ops.txt

Reported-by: Debabrata Banerjee <dbanerje@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/scsi/sd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..8b85703 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2702,6 +2702,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	atomic_set(&sdkp->openers, 0);
+	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
-- 
1.7.0.4

