Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1HRMXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:23:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:9537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab1HRMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:23:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="39641781"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/3] mmc: fixes for aggressive clock gating framework
Date: Thu, 18 Aug 2011 15:23:46 +0300
Message-Id: <cover.1313664897.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an updated series which should fix few races seen when aggressive
clock gating is active. The first patch actually just renames the gating
functions to make their use-cases a bit more clear.

Second and third patches fix the races itself.

Previous version of the series can be seen here
	http://article.gmane.org/gmane.linux.kernel.mmc/9611

Changes to previous version:
	* rename clock gating functions
	* use mmc_host_clk_hold() and mmc_host_clk_release() to protect the
	  ios updates
	* use non-reentrant workqueue instead of the default

Please review, thanks.

Mika Westerberg (3):
  mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
  mmc: prevent aggressive clock gating to race with ios updates
  mmc: use non-reentrant workqueue for clock gating

 drivers/mmc/core/core.c |   35 +++++++++++++++++++++++++++++++----
 drivers/mmc/core/host.c |   12 ++++++------
 drivers/mmc/core/host.h |    8 ++++----
 3 files changed, 41 insertions(+), 14 deletions(-)

-- 
1.7.5.4

