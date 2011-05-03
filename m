Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1ECT7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:59:05 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7702 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab1ECT7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:59:02 -0400
Subject: [PATCH 03/16] hpsa: remove unused parameter from
	hpsa_complete_scsi_command()
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:00 -0500
Message-ID: <20110503195900.5478.91691.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 415ad4f..8266850 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1006,8 +1006,7 @@ static void hpsa_unmap_sg_chain_block(struct ctlr_info *h,
 	pci_unmap_single(h->pdev, temp64.val, chain_sg->Len, PCI_DMA_TODEVICE);
 }
 
-static void complete_scsi_command(struct CommandList *cp,
-	int timeout, u32 tag)
+static void complete_scsi_command(struct CommandList *cp)
 {
 	struct scsi_cmnd *cmd;
 	struct ctlr_info *h;
@@ -2936,7 +2935,7 @@ static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 {
 	removeQ(c);
 	if (likely(c->cmd_type == CMD_SCSI))
-		complete_scsi_command(c, 0, raw_tag);
+		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
 		complete(c->waiting);
 }

