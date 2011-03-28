Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1C1Xwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:52:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48863 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1C1Xwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:52:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82587656"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH v2 0/2] regulator: Fix regulator_enable deadlock and add uA_load propagation
Date: Mon, 28 Mar 2011 16:52:35 -0700
Message-Id: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the uA_load propagation change takes out a lock on a regulator and
then the regulators that it supplies, it will cause deadlock with the current
regulator_enable implementation.  regulator_disable can also deadlock with
regulator_enable, but it requires two threads and precise timing to observe.
Therefore, regulator_enable must be fixed before current propagation can be
used.

Changes from v1:
	- Renamed _regulator_enable to regulator_dev_enable.
	- Made change logs more verbose.

David Collins (2):
  regulator: Remove possible deadlock from regulator_enable
  regulator: Propagate uA_load requirements up supply chain

 drivers/regulator/core.c         |  151 ++++++++++++++++++++++++++++++-------
 include/linux/regulator/driver.h |    5 +
 2 files changed, 127 insertions(+), 29 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

