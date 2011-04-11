Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1DKADN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 20:03:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:9893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1DKADL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 20:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,335,1299484800"; 
   d="scan'208";a="677386514"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: [PATCH 1/1] staging: sep: resolve issue with false zero length of page
Date: Sun, 10 Apr 2011 17:03:28 -0700
Message-Id: <1302480208-20247-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 890eede..52342c1 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1095,13 +1095,16 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	if (num_pages > 1) {
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
+		if (lli_array[num_pages - 1].block_size == 0)
+			lli_array[num_pages - 1].block_size = PAGE_SIZE;
 
 		dev_warn(&sep->pdev->dev,
-			"lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
+			"lli_array[%x].bus_address is "
+			"%08lx, lli_array[%x].block_size is %x\n",
 			num_pages - 1,
-			(unsigned long)lli_array[count].bus_address,
+			(unsigned long)lli_array[num_pages -1].bus_address,
 			num_pages - 1,
-			lli_array[count].block_size);
+			lli_array[num_pages -1].block_size);
 	}
 
 	/* Set output params according to the in_out flag */
-- 
1.7.0.4

