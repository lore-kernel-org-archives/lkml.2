Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2DFFVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:21:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab2DFFVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:21:40 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Venkatraman S <svenkatr@ti.com>, Santosh Y <santoshsy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] scsi/ufs: Fix evaluation of task_failed status
Date: Fri, 6 Apr 2012 10:57:09 +0530
Message-ID: <1333690029-4991-2-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
References: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Else FAILED would be set even if task_result was
originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
CC: Santosh Y <santoshsy@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aa97200..cd59f6f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
 		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
 
-		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
+		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
 	} else {
-- 
1.7.5.4

