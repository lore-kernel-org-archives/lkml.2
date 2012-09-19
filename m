Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2ISGGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:06:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2ISGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:06:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="236137347"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 0/3] Introduce devm_clk_register()
Date: Tue, 18 Sep 2012 23:05:27 -0700
Message-Id: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this series fixes error checking in the wm831x clock
driver and is here to prevent context conflicts in the third patch.
I split it out in case it needed to merge sooner rather than later.

The goal of this series is to add devm_clk_register() so I can use it in
some MSM clock code I'm sending out in the near future. The second 
patch adds the API and the third patch moves over an existing user of
clk_unregister() to the devm API.

Stephen Boyd (3):
  clk: wm831x: Fix clk_register() error code checking
  clk: Add devm_clk_{register,unregister}()
  clk: wm831x: Use devm_clk_register() to simplify code

 drivers/clk/clk-wm831x.c     |  34 ++++---------
 drivers/clk/clk.c            | 111 +++++++++++++++++++++++++++++++++++--------
 include/linux/clk-provider.h |   2 +
 3 files changed, 101 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

