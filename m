Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2BFHLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:11:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:52083 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2BFHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:10:47 -0500
From: Hui Wang <jason77.wang@gmail.com>
To: <mchehab@redhat.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony.luck@intel.com>
Subject: [PATCH 2/3] edac: sb_edac: Fix a INTERLEAVE_MODE() misuse
Date: Mon, 6 Feb 2012 15:11:00 +0800
Message-ID: <1328512261-19896-3-git-send-email-jason77.wang@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1328512261-19896-2-git-send-email-jason77.wang@gmail.com>
References: <1328512261-19896-1-git-send-email-jason77.wang@gmail.com>
 <1328512261-19896-2-git-send-email-jason77.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can identify dram interleave mode from the Dram Rule register
rather than Dram Interleave list register.

In this context, the reg of INTERLEAVE_MODE(reg) contains the Dram
Interleave list register, we can't get interleave mode from the reg,
while the variable interleave_mode saves the the mode got from the
Dram Rule register, so we use the variable to replace
INTERLEAVE_MDDE(reg) here.

Signed-off-by: Hui Wang <jason77.wang@gmail.com>
---
 drivers/edac/sb_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 1dc118d..f84a515 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -913,7 +913,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		addr,
 		limit,
 		sad_way + 7,
-		INTERLEAVE_MODE(reg) ? "" : "XOR[18:16]");
+		interleave_mode ? "" : "XOR[18:16]");
 	if (interleave_mode)
 		idx = ((addr >> 6) ^ (addr >> 16)) & 7;
 	else
-- 
1.7.6

