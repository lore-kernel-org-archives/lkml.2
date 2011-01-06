Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1AFQjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:39:17 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:11070 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1AFQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:39:16 -0500
Subject: [PATCH] cciss: make cciss_revalidate not loop through CISS_MAX_LUNS
	volumes unnecessarily.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Thu, 06 Jan 2011 10:39:14 -0600
Message-ID: <20110106163914.10177.81092.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <StephenM.Cameron>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8e0f925..8febc20 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2833,7 +2833,7 @@ static int cciss_revalidate(struct gendisk *disk)
 	sector_t total_size;
 	InquiryData_struct *inq_buff = NULL;
 
-	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
+	for (logvol = 0; logvol <= h->highest_lun; logvol++) {
 		if (!h->drv[logvol])
 			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,

