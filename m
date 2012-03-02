Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2CBUF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:05:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6331 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2CBUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:05:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 02 Mar 2012 12:05:53 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 0/7] pinctrl: API rework, pinconfig in mapping table, ...
Date: Fri, 2 Mar 2012 13:05:43 -0700
Message-ID: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the current set of patches I have outstanding for pinctrl.

NOTE: This series assumes that commit 7d23de2 "pinctrl: resurrect verbose
pinmux-pins" is dropped, since "Show selected function and group in
pinmux-pins debugfs" re-implements it in a way that's compatible with
all the API rework and restructing in this series.

The locking rework change is still under discussion; I haven't seen a
nak/ack since I was asked to move it later in the series and I explained
the difficulties in doing so while maintaining correctness.

The other changes have fixes based on review feedback.

The Tegra30 pinctrl driver fix should be OK to apply out-of-order if you
want. I'd even be happy if you squashed it into the original commit that
added the driver, if you branch doesn't need to be git-stable.

v3:
* Added patch "Show selected function and group in pinmux-pins debugfs".
* Fixed review feedback in "Enhance mapping table to support pin config
  operations".

Stephen Warren (7):
  pinctrl: Fix and simplify locking
  pinctrl: Refactor struct pinctrl handling in core.c vs pinmux.c
  pinctrl: Add usecount to pins for muxing
  pinctrl: API changes to support multiple states per device
  pinctrl: Enhance mapping table to support pin config operations
  pinctrl: Show selected function and group in pinmux-pins debugfs
  pinctrl: fix case of Tegra30's foo_groups[] arrays

 Documentation/pinctrl.txt         |  196 +++-
 arch/arm/mach-u300/core.c         |   28 +-
 drivers/pinctrl/core.c            |  630 ++++++++----
 drivers/pinctrl/core.h            |   89 ++-
 drivers/pinctrl/pinconf.c         |  272 +++++-
 drivers/pinctrl/pinconf.h         |   40 +
 drivers/pinctrl/pinctrl-tegra30.c | 1992 ++++++++++++++++++------------------
 drivers/pinctrl/pinmux.c          |  507 ++++------
 drivers/pinctrl/pinmux.h          |   58 +-
 drivers/tty/serial/sirfsoc_uart.c |   12 +-
 include/linux/pinctrl/consumer.h  |   55 +-
 include/linux/pinctrl/machine.h   |  148 +++-
 include/linux/pinctrl/pinctrl.h   |    1 -
 13 files changed, 2343 insertions(+), 1685 deletions(-)

