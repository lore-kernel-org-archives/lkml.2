Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2JEKSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:18:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62685 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2JEKR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:17:59 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, boojin.kim@samsung.com, vinod.koul@intel.com,
        patches@linaro.org, kgene.kim@samsung.com
Subject: [PATCH v2 0/4] DMA: PL330: Fix mem leaks and balance probe/remove 
Date: Fri,  5 Oct 2012 15:47:52 +0530
Message-Id: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 2 patches of this series fix memory leaks because the memory
allocated for peripheral channels and DMA descriptors were not getting
freed.

The last 2 patches balance the module's remove function.

This series depends on "61c6e7531d3b66b3 ........DMA: PL330: Check the
pointer returned by kzalloc" which is on slave-dma's "fixes" branch. 
Hence slave-dma tree's "next" branch was merged with "fixes" and 
applied patch at [1] to fix the build error.

[1] http://permalink.gmane.org/gmane.linux.kernel.next/24274

Changes since v1:
 - Protect only list_add_tail with spin_locks
 - Return EBUSY from remove if channel is in use
 - unregister dma_device in remove
 
Inderpal Singh (4):
  DMA: PL330: Free memory allocated for peripheral channels
  DMA: PL330: Change allocation method to properly free  DMA
    descriptors
  DMA: PL330: Balance module remove function with probe
  DMA: PL330: unregister dma_device in module's remove function

 drivers/dma/pl330.c |   53 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 15 deletions(-)

-- 
1.7.9.5

