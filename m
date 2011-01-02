Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1ABIJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:09:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:34404 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1ABHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 041/260] staging: hv: Fixed lockup problem with bounce_buffer scatter list
Date: Sun,  2 Jan 2011 02:15:37 -0500
Message-Id: <1293952756-15010-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:51.0366 (UTC) FILETIME=[95DCA460:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

commit 77c5ceaff31645ea049c6706b99e699eae81fb88 upstream.

Fixed lockup problem with bounce_buffer scatter list which caused
crashes in heavy loads. And minor code indentation cleanup in effected
area.

Removed whitespace and noted minor indentation changes in description as
pointed out by Joe Perches. (Thanks for reviewing Joe)

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/storvsc_drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 060da9e..5504e19 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -644,6 +644,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	unsigned int request_size = 0;
 	int i;
 	struct scatterlist *sgl;
+	unsigned int sg_count = 0;
 
 	DPRINT_ENTER(STORVSC_DRV);
 
@@ -728,6 +729,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	request->DataBuffer.Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
+		sg_count = scsi_sg_count(scmnd);
 
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
@@ -762,11 +764,12 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 					      scsi_sg_count(scmnd));
 
 			sgl = cmd_request->bounce_sgl;
+			sg_count = cmd_request->bounce_sgl_count;
 		}
 
 		request->DataBuffer.Offset = sgl[0].offset;
 
-		for (i = 0; i < scsi_sg_count(scmnd); i++) {
+		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d \n",
 				   i, sgl[i].length, sgl[i].offset);
 			request->DataBuffer.PfnArray[i] =
-- 
1.7.3.3

