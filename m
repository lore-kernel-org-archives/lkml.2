Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2CLMsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab2CLMsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:48:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] i3200_edac: Fix a regression introduced by 3b6909b
Date: Mon, 12 Mar 2012 09:48:32 -0300
Message-Id: <1331556515-7902-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
References: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the private data structure is not zero. Fix it.

This is a cut-and-paste error introduced when copying the alloc init
code from some other driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i3200_edac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 1233435..9171823 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -358,7 +358,8 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
 	layers[1].is_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(struct i3200_priv));
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8

