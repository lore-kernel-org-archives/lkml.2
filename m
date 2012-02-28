Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503Ab2B1U1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:27:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17344 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2B1U1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:27:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Feb 2012 12:27:35 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 0/6] pinctrl: API rework, pinconfig in mapping table, ...
Date: Tue, 28 Feb 2012 13:27:26 -0700
Message-ID: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the current set of patches I have outstanding for pinctrl.

The locking rework change is still under discussion; I haven't seen a
nak/ack since I was asked to move it later in the series and I explained
the difficulties in doing so while maintaining correctness.

The other changes have fixes based on review feedback.

The last patch is a fix for the Tegra30 pinctrl driver that showed up
once I was able to test on real HW. You should be able to apply this
out-of-order if you want. I'd even be happy if you squashed it into the
original commit that added the driver, if you branch doesn't need to be
git-stable.

Stephen Warren (6):
  pinctrl: Fix and simplify locking
  pinctrl: Refactor struct pinctrl handling in core.c vs pinmux.c
  pinctrl: Add usecount to pins for muxing
  pinctrl: API changes to support multiple states per device
  pinctrl: Enhance mapping table to support pin config operations
  pinctrl: fix case of Tegra30's foo_groups[] arrays

 Documentation/pinctrl.txt         |  196 +++-
 arch/arm/mach-u300/core.c         |   28 +-
 drivers/pinctrl/core.c            |  630 ++++++++----
 drivers/pinctrl/core.h            |   92 ++-
 drivers/pinctrl/pinconf.c         |  272 +++++-
 drivers/pinctrl/pinconf.h         |   40 +
 drivers/pinctrl/pinctrl-tegra30.c | 1992 ++++++++++++++++++------------------
 drivers/pinctrl/pinmux.c          |  464 +++------
 drivers/pinctrl/pinmux.h          |   59 +-
 drivers/tty/serial/sirfsoc_uart.c |   12 +-
 include/linux/pinctrl/consumer.h  |   55 +-
 include/linux/pinctrl/machine.h   |  148 +++-
 include/linux/pinctrl/pinctrl.h   |    1 -
 13 files changed, 2282 insertions(+), 1707 deletions(-)

