Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2LQVCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:02:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2LQVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:02:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,304,1355126400"; 
   d="scan'208";a="14773297"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] Introduce of_init_clk_data() for DT clock parsing
Date: Mon, 17 Dec 2012 13:02:11 -0800
Message-Id: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.1.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see the same pattern repeated a few times to parse the common clock
bindings for a particular clock. Instead of wrting this code another
time, let's consolidate the logic in one place and standardize how
clocks will be named from their bindings.

After this series there are no more users of of_clk_get_parent_name()
so we may want to delete it.

Stephen Boyd (4):
  clk: Add of_init_clk_data() to parse common clock bindings
  clk: highbank: Use of_init_clk_data()
  clk: vt8500: Use of_init_clk_data()
  clk: zynq: Use of_init_clk_data()

 drivers/clk/clk-highbank.c   | 21 ++++++----------
 drivers/clk/clk-vt8500.c     | 39 ++++++++++++-----------------
 drivers/clk/clk-zynq.c       | 28 +++++++--------------
 drivers/clk/clk.c            | 58 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/clk-provider.h |  2 ++
 5 files changed, 91 insertions(+), 57 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

