Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1CRNYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:24:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57869 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1CRNYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:24:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80528581"
From: Subhash Jadavani <subhashj@codeaurora.org>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
Date: Fri, 18 Mar 2011 18:54:03 +0530
Message-Id: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent MSMs, ADM (Data Mover) HW is not present
which means existing SDCC driver can perform data
transfer in PIO (peripheral IO) mode only.
But PIO mode requires lot of CPU attention which
would mean consuming extra CPU MIPS.

As a replacement on these recent MSMs, there is
a new DMA HW engine named SPS-BAM (as part of
Smart Peripheral System of MSM) is added for
data movement between SDCC core and system memory.

This patch has done changes in existing MSM SDCC
driver for using SPS-BAM as DMA engine.

This patch is just for early review.

This patch is dependent on following 2 patches:
https://patchwork.kernel.org/patch/586271/
http://www.spinics.net/lists/arm-kernel/msg118467.html

Subhash Jadavani (1):
  mmc: msm_sdcc: Use SPS BAM as DMA engine

 drivers/mmc/host/Kconfig        |   10 +
 drivers/mmc/host/Makefile       |    1 +
 drivers/mmc/host/msm_sdcc.c     |  929 +++++++++++++++++++++++++++++++++++++--
 drivers/mmc/host/msm_sdcc.h     |   47 ++
 drivers/mmc/host/msm_sdcc_dml.c |  303 +++++++++++++
 drivers/mmc/host/msm_sdcc_dml.h |  120 +++++
 6 files changed, 1374 insertions(+), 36 deletions(-)
 create mode 100644 drivers/mmc/host/msm_sdcc_dml.c
 create mode 100644 drivers/mmc/host/msm_sdcc_dml.h

--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
