Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2BITLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:11:21 -0500
Received: from mail.df.lth.se ([194.47.250.12]:38265 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2BITLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:11:19 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 14:11:19 EST
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/3] pinctrl: move the core per-device handlers to core
Date: Thu,  9 Feb 2012 20:00:50 +0100
Message-Id: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussing with some people involved with pin control, we agreed
that it will just cause trouble to have separate handles for pin muxing
and pin configuration in callers - they will definately want to set all
pin aspects regarding muxing and other configuration with one single
call.

These three patches take the first step in this transformation by moving
the per-device handles over to core code, and renaming all related
functions with the pinctrl_* prefix.

Linus Walleij (3):
  pinctrl: break out a pinctrl consumer header
  pinctrl: move generic functions to the pinctrl_ namespace
  pinctrl: factor pin control handles over to the core

 Documentation/pinctrl.txt        |  124 ++++---
 arch/arm/mach-u300/core.c        |   24 +-
 drivers/pinctrl/core.c           |  602 +++++++++++++++++++++++++++++++-
 drivers/pinctrl/core.h           |   34 ++-
 drivers/pinctrl/pinctrl-coh901.c |    6 +-
 drivers/pinctrl/pinmux.c         |  732 ++++++--------------------------------
 drivers/pinctrl/pinmux.h         |   67 ++++-
 include/linux/pinctrl/consumer.h |  118 ++++++
 include/linux/pinctrl/machine.h  |    8 +-
 include/linux/pinctrl/pinconf.h  |   39 --
 include/linux/pinctrl/pinmux.h   |   52 ---
 11 files changed, 991 insertions(+), 815 deletions(-)
 create mode 100644 include/linux/pinctrl/consumer.h

-- 
1.7.7.6

