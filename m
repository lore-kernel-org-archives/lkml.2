Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2ERQtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532Ab2ERQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 53/66] i7300_edac: Get rid of some wrongly-solved rebase conflict
Date: Fri, 18 May 2012 13:32:40 -0300
Message-Id: <1337358773-6919-54-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should not increment tot_dimms manually. This code were
there for an older approach that got removed. After one of the
several rebases that this code suffered until the final version,
the conflict was wrongly merged, and this code returned.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 381f7cd..db84456 100644
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

