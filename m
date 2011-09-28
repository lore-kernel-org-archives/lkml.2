Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1I1FtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:49:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62332 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1I1FtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:49:04 -0400
X-AuditID: cbfee61b-b7b7fae000005864-57-4e82b54ee85c
From: Alim Akhtar <alim.akhtar@samsung.com>
To: linus.walleij@linaro.org, vinod.koul@intel.com, dan.j.williams@intel.com,
        viresh.kumar@st.com
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
Date: Wed, 28 Sep 2011 11:20:06 +0530
Message-id: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
X-Mailer: git-send-email 1.7.2.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the amba-pl08x driver for s3c64xx.
The DMA controller of S3C64XX is a variant of PrimeCell pl080 DMAC.
S3C64xx contents extra register to hold the TransferSize.

Below diagram explains the s3c64xx LLI structure and offsets.
	-----------------------------------------------------------------
	|       Offset          |       Contents                        |
	-----------------------------------------------------------------
	| Next LLI Address      | Source Address for Next xfer          |
	----------------------------------------------------------------- 
	| Next LLI Address+0x04 | Destination Address for Next xfer     |
	-----------------------------------------------------------------
	| Next LLI Address+0x08 | Next LLI address for Next xfer        |
	-----------------------------------------------------------------
	| Next LLI Address+0x0c | DMACCxControl0 data for Next xfer     |
	-----------------------------------------------------------------
	| Next LLI Address+0x10 | DMACCxControl1 xfer size for Next xfer|
	----------------------------------------------------------------- 

Changes since v1:
	- Rebased with "samsung_dma" branch of 
	http://git.infradead.org/users/vkoul/slave-dma.git

	- Addressed review comments from linus.walleij 
	http://www.spinics.net/lists/arm-kernel/msg135411.html

Alim Akhtar (1):
  dmaengine/amba-pl08x: Add support for s3c64xx DMAC

 drivers/dma/amba-pl08x.c |  135 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 112 insertions(+), 23 deletions(-)

-- 
1.7.2.3

