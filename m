Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2AZJFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:05:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18825 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2AZJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:05:02 -0500
X-AuditID: cbfee61a-b7cd2ae000004fa5-a8-4f2117382111
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] mmc: core: Support packed command feature of eMMC4.5
Date: Thu, 26 Jan 2012 18:04:56 +0900
Message-id: <000901ccdc09$92daf020$b890d060$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczcCZLCbTHoLWdPRhCEPYQOLGKvHw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support of packed command feature
for eMMC4.5 devices.

Changes in v4:
	- Add Data-tag as CMD23 argument for packed header.
	- Separate the capability of MMC_CAP2_PACKED_CMD into read and write.
	- remove unnecessary initial value.

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

 drivers/mmc/card/block.c   |  475 +++++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/card/queue.c   |   48 ++++-
 drivers/mmc/card/queue.h   |   13 ++
 drivers/mmc/core/host.c    |    2 +
 drivers/mmc/core/mmc.c     |   24 +++
 drivers/mmc/core/mmc_ops.c |    1 +
 include/linux/mmc/card.h   |    3 +
 include/linux/mmc/core.h   |    4 +
 include/linux/mmc/host.h   |    4 +
 include/linux/mmc/mmc.h    |   15 ++
 10 files changed, 562 insertions(+), 27 deletions(-)

Best regards,
Seungwon Jeon.
--
1.7.2.3


