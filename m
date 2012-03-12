Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2CLN1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab2CLN1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:27:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i7300: Fix the memory alloc initialization
Date: Mon, 12 Mar 2012 10:27:03 -0300
Message-Id: <1331558823-9221-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of initializing with the total number of channels, it
should use the number of channels per branch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index f9faf96..0ff0b26 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1049,7 +1049,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	layers[0].size = MAX_BRANCHES;
 	layers[0].is_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = MAX_CHANNELS;
+	layers[1].size = MAX_CH_PER_BRANCH;
 	layers[1].is_csrow = true;
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = MAX_SLOTS;
-- 
1.7.8

