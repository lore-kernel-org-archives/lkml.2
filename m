Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab0FKVj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:39:28 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29454 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0FKVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:39:27 -0400
Subject: [PATCH] cciss: set SCSI max cmd len to 16, as default is wrong.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
       linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Fri, 11 Jun 2010 16:44:19 -0500
Message-ID: <20100611214419.14054.91928.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: set SCSI max cmd len to 16, as default is wrong.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e1d0e2c..e082a26 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -861,6 +861,7 @@ cciss_scsi_detect(int ctlr)
 	sh->n_io_port = 0;	// I don't think we use these two...
 	sh->this_id = SELF_SCSI_ID;  
 	sh->sg_tablesize = hba[ctlr]->maxsgentries;
+	sh->max_cmd_len = MAX_COMMAND_SIZE;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		hba[ctlr]->scsi_ctlr)->scsi_host = sh;

