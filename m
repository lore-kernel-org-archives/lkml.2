Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1DGRdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:33:14 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:55292 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1DGRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:33:12 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] fsldma: fix build warning caused by of_platform_device changes
Date: Thu,  7 Apr 2011 10:33:03 -0700
Message-Id: <1302197583-31771-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 07 Apr 2011 10:33:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 000061245a6797d542854106463b6b20fbdcb12e forgot to convert the
type of structure passed into platform_device_register() when it was
converted from of_platform_device_register. Fix it.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6b39675..8a78154 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1448,7 +1448,7 @@ static const struct of_device_id fsldma_of_ids[] = {
 	{}
 };
 
-static struct of_platform_driver fsldma_of_driver = {
+static struct platform_driver fsldma_of_driver = {
 	.driver = {
 		.name = "fsl-elo-dma",
 		.owner = THIS_MODULE,
-- 
1.7.3.4

