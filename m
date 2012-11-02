Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2KBVsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050Ab2KBVq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:46:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [patch,v2 05/10] sd: use alloc_disk_node
Date: Fri,  2 Nov 2012 17:45:58 -0400
Message-Id: <1351892763-21325-6-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..8deb915 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk(SD_MINORS);
+	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
 	if (!gd)
 		goto out_free;
 
-- 
1.7.1

