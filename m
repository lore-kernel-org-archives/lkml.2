Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab1DNSKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:10:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:42103 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699Ab1DNR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 168/209] amd64_edac: Fix interleaving check
Date: Thu, 14 Apr 2011 13:55:26 -0400
Message-Id: <1302803767-9715-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e726f3c368e7c1919a7166ec09c5705759f1a69d upstream.

When matching error address to the range contained by one memory node,
we're in valid range when node interleaving

1. is disabled, or
2. enabled and when the address bits we interleave on match the
interleave selector on this node (see the "Node Interleaving" section in
the BKDG for an enlightening example).

Thus, when we early-exit, we need to reverse the compound logic
statement properly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c20a6c9..0e03506 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1567,7 +1567,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
 	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
 
-	if (intlv_en ||
+	if (intlv_en &&
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
 
-- 
1.7.4.4

