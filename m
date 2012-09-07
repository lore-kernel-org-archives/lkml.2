Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2IGGox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:44:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2IGGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:44:50 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        boojin.kim@samsung.com, jassisinghbrar@gmail.com,
        Inderpal Singh <inderpal.singh@linaro.org>
Subject: [PATCH 0/2] DMA: PL330: Clock and runtime cleanup
Date: Fri,  7 Sep 2012 12:14:46 +0530
Message-Id: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The controller clock is being managed at AMBA bus level probe/remove and
pm_runtime/suspend functions. The existing driver does the clock enable/disable
again in the same code paths, which unneccessarily increments the usage count of
the clock for the same device. 

The following patches remove the redundant clock enable/disable from the driver.

Inderpal Singh (2):
  DMA: PL330: Remove controller clock enable/disable
  DMA: PL330: Remove redundant runtime_suspend/resume functions

 drivers/dma/pl330.c |   73 ++++-----------------------------------------------
 1 file changed, 5 insertions(+), 68 deletions(-)

-- 
1.7.9.5

