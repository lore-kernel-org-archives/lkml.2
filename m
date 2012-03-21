Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2CUVcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:32:09 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:5512 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222Ab2CUVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:32:05 -0400
Subject: [PATCH] cciss: Initialize scsi host max_sectors for tape drive support
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Wed, 21 Mar 2012 16:32:03 -0500
Message-ID: <20120321213203.9277.11716.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The default is too small (1024 blocks), use h->cciss_max_sectors (8192 blocks)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e820b68..f510a9c 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -866,6 +866,7 @@ cciss_scsi_detect(ctlr_info_t *h)
 	sh->can_queue = cciss_tape_cmds;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
+	sh->max_sectors = h->cciss_max_sectors;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		h->scsi_ctlr)->scsi_host = sh;

