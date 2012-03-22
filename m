Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2CVOWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:22:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34412 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2CVOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:22:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6656"; a="174778052"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.or,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tsoni@codeaurora.org, Ravi Kumar V <kumarrav@codeaurora.org>
Subject: [PATCH v5 0/2] Add Qualcomm MSM ADM DMAEngine driver
Date: Thu, 22 Mar 2012 19:52:02 +0530
Message-Id: <1332426122-25174-1-git-send-email-kumarrav@codeaurora.org>
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

Changes done from v3:

Implemented the wrappers as suggested by Russell King in following patch
https://lkml.org/lkml/2012/2/3/269
Fixed the dmaengine & client drivers to follow above changes

Changes done from v4:

Changed return value of prep_dma_sg & prep_interleaved_dma to NULL
when some thing fails inside the API
 
Ravi Kumar V (2):
  dmaengine: Add context parameter to prep_dma_sg and
    prep_interleaved_dma
  DMAEngine: Add DMAEngine driver based on old MSM ADM DMA APIs

 arch/arm/mach-msm/include/mach/dma.h    |   35 ++
 drivers/dma/Kconfig                     |   12 +
 drivers/dma/Makefile                    |    1 +
 drivers/dma/fsldma.c                    |    2 +-
 drivers/dma/msm_adm_dma.c               |  728 +++++++++++++++++++++++++++++++
 drivers/dma/sirf-dma.c                  |    2 +-
 drivers/dma/ste_dma40.c                 |    2 +-
 drivers/misc/carma/carma-fpga-program.c |    2 +-
 drivers/misc/carma/carma-fpga.c         |    7 +-
 include/linux/dmaengine.h               |   22 +-
 10 files changed, 803 insertions(+), 10 deletions(-)
 create mode 100644 drivers/dma/msm_adm_dma.c

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

