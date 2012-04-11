Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663Ab2DKQ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:28:17 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:44138 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab2DKQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:28:16 -0400
Message-Id: <201204111628.q3BGSEm2005145@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 11 Apr 2012 12:23:11 -0400
Subject: [PATCH] mvsas: get rid of a dead variable that causes a warning
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Xiangliang Yu <yuxiangl@marvell.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 11 Apr 2012 16:28:14.0703 (UTC) FILETIME=[1819E7F0:01CD1800]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "dev" variable in mvs_task_exec() is no longer used and
generates a warning when building the kernel.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..3006ec9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = NULL;
 	u32 rc = 0;
 	u32 pass = 0;
-- 
1.6.5.2

