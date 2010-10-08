Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab0JHT7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:59:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2004 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab0JHT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:59:51 -0400
Subject: [PATCH 08/13] cciss: limit commands allocated on reset_devices
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Oct 2010 15:06:42 -0500
Message-ID: <20101008200642.24279.43191.stgit@beardog.cce.hp.com>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to conserve memory in a memory-limited kdump scenario

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7741e3b..08cbee8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4059,6 +4059,11 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 static void __devinit cciss_get_max_perf_mode_cmds(struct ctlr_info *h)
 {
 	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+
+	/* Limit commands in memory limited kdump scenario. */
+	if (reset_devices && h->max_commands > 32)
+		h->max_commands = 32;
+
 	if (h->max_commands < 16) {
 		dev_warn(&h->pdev->dev, "Controller reports "
 			"max supported commands of %d, an obvious lie. "

