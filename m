Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2DRHc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:32:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54053 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab2DRHc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:32:56 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <santoshsy@gmail.com>,
        <linkinjeon@gmail.com>, Venkatraman S <svenkatr@ti.com>
Subject: [PATCH RESEND 2/2] scsi/ufs: Fix evaluation of task_failed status
Date: Wed, 18 Apr 2012 13:08:53 +0530
Message-ID: <1334734733-13640-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Else FAILED would be set even if task_result was
originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
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

