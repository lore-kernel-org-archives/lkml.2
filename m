Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab2C2RHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759558Ab2C2RHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:07:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/14] i7300_edac: Get rid of some wrongly-solved rebase conflict
Date: Thu, 29 Mar 2012 14:07:00 -0300
Message-Id: <1333040821-6253-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should not increment tot_dimms manually. This code were
there for an older approach that got removed. After one of the
several rebases that this code suffered until the final version,
the conflict was wrongly merged, and this code returned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 57f264d..f9a4fa4 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -803,9 +803,6 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, dimm);
 
-				mci->tot_dimms++;
-				dimm++;
-
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
-- 
1.7.8

