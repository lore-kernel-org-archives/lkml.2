Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2CLKbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:31:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50222 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2CLKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:31:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="169288158"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Ravi Kumar V <kumarrav@codeaurora.org>
Subject: [PATCH v3 0/2] Add Qualcomm MSM ADM DMAEngine driver
Date: Mon, 12 Mar 2012 16:00:59 +0530
Message-Id: <1331548259-26865-1-git-send-email-kumarrav@codeaurora.org>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are the changes we have done from the previous
v1 posted here: https://lkml.org/lkml/2011/12/22/148 

As our ADM Scatter-gather hardware needs
-32-bit command configuration parameter
 apart from 
-32-bit source address
-32-bit destination address
-16-bit length

So,we have added new parameter in struct scatterlist to support xfer descriptor
specific private data, and for supporting ADM Box mode DMA we added new
API and data structure.

Changes done from v2:

As per our previous discussion you had suggested us to follow the below patch
https://lkml.org/lkml/2012/1/26/405
Please check the below link of our discussion
https://lkml.org/lkml/2012/1/30/48
 
So we have added the new context parameter in device_prep_dma_sg and 
device_prep_interleave_dma API's to support for passing client channel specific
private data associated with every transfer descriptor. 

We are using 
Interleaved API for BOX type transfer.
SG API for SG type transfer.
 
Ravi Kumar V (2):
  dmaengine: Add support for per xfer specific privatedata
  DMAEngine: Add DMAEngine driver based on old MSM DMA APIs

 arch/arm/mach-msm/include/mach/dma.h |   30 ++
 drivers/dma/Kconfig                  |   12 +
 drivers/dma/Makefile                 |    1 +
 drivers/dma/msm-dma.c                |  724 ++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h            |    4 +-
 5 files changed, 769 insertions(+), 2 deletions(-)
 create mode 100644 drivers/dma/msm-dma.c

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

