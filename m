Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1EaSOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:14:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab1EaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:14:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94658398"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH 1/4] [SCSI] lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
Date: Tue, 31 May 2011 11:14:30 -0700
Message-Id: <1306865673-20560-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
In-Reply-To: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/blkdev.h:12,
                 from drivers/scsi/lpfc/lpfc_debugfs.c:21:
In function 'copy_from_user':
arch/x86/include/asm/uaccess_64.h:65:
warning: call to 'copy_from_user_overflow' declared with
attribute warning: copy_from_user() buffer size is not provably
correct

presumably due to buf_size being signed causing GCC to fail to
see that buf_size can't become negative.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ffe82d1..30b25c5 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1147,7 +1147,8 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
 {
 	char mybuf[64];
 	char *pbuf, *step_str;
-	int bsize, i;
+	int i;
+	size_t bsize;
 
 	/* Protect copy from user */
 	if (!access_ok(VERIFY_READ, buf, nbytes))
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

