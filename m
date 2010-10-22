Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab0JVTVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:21:22 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4801 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0JVTVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:21:18 -0400
Subject: [PATCH 4/5] cciss: limit commands allocated on reset_devices
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:21:17 -0500
Message-ID: <20101022192117.25567.17893.stgit@beardog.cce.hp.com>
In-Reply-To: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
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
index 03afef8..55fed21 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4039,6 +4039,11 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
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

