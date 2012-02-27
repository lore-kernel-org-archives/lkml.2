Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2B0KUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:20:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41444 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2B0KUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:20:35 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-91-4f4b58e96ad8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        "'Maya Erez'" <merez@codeaurora.org>
Subject: [PATCH v5 0/2] mmc: core: Support packed command feature of eMMC4.5
Date: Mon, 27 Feb 2012 19:20:25 +0900
Message-id: <004101ccf539$6b83ea10$428bbe30$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz1OWqHTC4nG/BQSlq5RGSSy7dtpw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support of packed command feature
for eMMC4.5 devices.

Changes in v5:
	- Revert "Add a variable member in mmc_host for minimum number of packed entries".
	- Fix the partial packed command from failure index.
	- Clean an unnecessary parameter of mmc_blk_packed_hdr_wrq_prep 
	- Clean warnings of checkpatch.

Changes in v4:
	- Add Data-tag as CMD23 argument for packed header.
	- Separate the capability of MMC_CAP2_PACKED_CMD into read and write.
	- Remove unnecessary initial value.

Changes in v3:
	- Add a variable member in mmc_host for minimum number of packed entries.
	  This value can be overridden by host.
	- Fix a handling of error sequence.

Changes in v2:
	- Fix the packed read sequence and error handling.
	- Apply checking the exception status for all cases with
	  the comments from Maya Erez and Sahitya Tummala.
	- Fix preparing the packed list with the comment from Maya Erez and Venkatraman.


Seungwon Jeon (2):
      mmc: core: Add packed command feature of eMMC4.5
      mmc: core: Support packed command for eMMC4.5 device

 drivers/mmc/card/block.c   |  496 +++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.c   |   48 ++++-
 drivers/mmc/card/queue.h   |   13 ++
 drivers/mmc/core/mmc.c     |   24 ++
 drivers/mmc/core/mmc_ops.c |    1 +
 include/linux/mmc/card.h   |    3 +
 include/linux/mmc/core.h   |    4 +
 include/linux/mmc/host.h   |    4 +
 include/linux/mmc/mmc.h    |   15 ++
 9 files changed, 581 insertions(+), 27 deletions(-)

Best regards,
Seungwon Jeon.
--
1.7.2.3


