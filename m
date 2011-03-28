Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1C1Pes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:34:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27620 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1C1Peq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:34:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6298"; a="82280573"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH 0/2] regulator: Fix regulator_enable deadlock and add uA_load propagation
Date: Mon, 28 Mar 2011 08:34:40 -0700
Message-Id: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the uA_load propagation change takes out a lock on a regulator and
then the regulators that it supplies, it will cause deadlock with the current
regulator_enable implementation.  regulator_disable can also deadlock with
regulator_enable, but it requires two threads and precise timing to observe.
Therefore, regulator_enable must be fixed before current propagation can be
used.

David Collins (2):
  regulator: Remove possible deadlock from regulator_enable
  regulator: Propagate uA_load requirements up supply chain

 drivers/regulator/core.c         |  147 +++++++++++++++++++++++++++++++-------
 include/linux/regulator/driver.h |    5 ++
 2 files changed, 125 insertions(+), 27 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

