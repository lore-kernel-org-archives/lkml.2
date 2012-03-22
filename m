Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2CVSJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:09:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39234 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2CVSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:08:59 -0400
Subject: [PATCH 2/2] cciss: Initialize scsi host max_sectors for tape drive
	support
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Thu, 22 Mar 2012 13:08:58 -0500
Message-ID: <20120322180858.14453.67533.stgit@beardog.cce.hp.com>
In-Reply-To: <20120322180852.14453.3206.stgit@beardog.cce.hp.com>
References: <20120322180852.14453.3206.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The default is too small (1024 blocks), use h->cciss_max_sectors (8192 blocks)
Without this change, if you try to set the block size of a tape drive above
512*1024, via "mt -f /dev/st0 setblk nnn" where nnn is greater than 524288,
it won't work right.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/block/cciss_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 1162f7b..acda773 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -866,6 +866,7 @@ cciss_scsi_detect(ctlr_info_t *h)
 	sh->can_queue = cciss_tape_cmds;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
+	sh->max_sectors = h->cciss_max_sectors;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		h->scsi_ctlr)->scsi_host = sh;

