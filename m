Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1LVNIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:08:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38637 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1LVNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:08:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6567"; a="146880823"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Ravi Kumar V <kumarrav@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/1] Add Qualcomm MSM ADM DMAEngine driver 
Date: Thu, 22 Dec 2011 18:38:31 +0530
Message-Id: <1324559312-23684-1-git-send-email-kumarrav@codeaurora.org>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qualcomm Application Datamover(ADM) supports simple, scatter gather
and box mode dma transfers.

This driver implements the scatter gather and box mode transfer.

Our ADM hardware needs these following fields for a transfer.
-------------------
Scatter gather mode
-------------------
32-bit command configuration.
32-bit source address
32 bit destination address
16-bit length

---------
Box Mode
---------
32-bit command configuration
32-bit source address
32-bit destination address
16-bit source row length
16-bit destination row length
16-bit source row numbers
16-bit destination row numbers
16-bit source row offset
16-bit destination row offset

As of now there is no support to pass private data like "command"
configuration in standard DMAEngine API.

We are using "device_prep_dma_sg" API to do the SG and box mode transfer,
but since the current APIs doesn't support a way to pass the "command configuration",
"source and destination row numbers" we are using "length"  and "offset" field of the
existing scatterlist to achieve it. Let us know if there is a better way
to do it or new API needs to be created. 

Here we are using same length field as above for command configuration,
16 MSB bits offset field of scatterlist for passing row numbers
and remaining of 16 LSB bits for offset.

Ravi Kumar V (1):
  msm: DMAEngine: Add DMAEngine driver based on old MSM DMA APIs

 arch/arm/mach-msm/include/mach/dma.h |   53 +++
 drivers/dma/Kconfig                  |   12 +
 drivers/dma/Makefile                 |    1 +
 drivers/dma/msm-dma.c                |  719 ++++++++++++++++++++++++++++++++++
 4 files changed, 785 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/msm-dma.c

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

