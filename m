Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2BTGqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:46:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19229 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2BTGqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 19 Feb 2012 22:46:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 00/20] pinctrl: API change, config in mapping table
Date: Sun, 19 Feb 2012 23:45:40 -0700
Message-Id: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes:
* Rework the pinctrl API as we discussed at Linaro Connect.
* Allow specifying pin config settings in the mapping table in addition
  to mux options, as we agreed upon at Linaro Connect.
* Various cleanups and refactorings aimed at supporting the changes above.

TODO in this patch set:
* Test build of non-Tegra platforms.
* Test build with pinmux/pinconf disabled.
... but I figure it was a good idea to send out for comments ASAP.

TODO in future patch sets:
* Implement device tree support in pinctrl core and a pinctrl driver.
* Remove pin config APIs from pinctrl now that the mapping table supports
  pin config?

I've tested this all on a couple Tegra boards, including hacking in a single
pin config and dummy state mapping table entry. I've got patches for Tegra
boards that use the explicit pin config APIs, and need to convert them to
using the pin config mapping table entries for more complete testing.

(In the diffstat below, I /think/ the first 19 patches are a net negative in
line-count, and only the last patch, which implements a new feature, adds a
significant number of lines)

Stephen Warren (20):
  pinctrl: pinctrl_register_mappings() shouldn't be __init
  pinctrl: use list_add_tail instead of list_add
  pinctrl: Store mapping table as a list of chunks
  pinctrl: Record a pin owner, not mux function, when requesting pins
  pinctrl: Re-order pinmux.[ch] to match each-other
  pinctrl: Re-order pinconf.[ch] to match each-other
  pinctrl: core.c/h cleanups
  pinctrl: Assume map table entries can't have a NULL name field
  pinctrl: Disallow map table entries with NULL dev_name field
  pinctrl: Assume map table entries can't have a NULL ctrl_dev_name
    field
  pinctrl: Downgrade pinctrl_get warning when no maps are found
  pinctrl: Use dev_*() instead of pr_*(), add some msgs, minor cleanups
  pinctrl: Error if mapping table's control dev can't be found
  pinctrl: Allocate sizeof(*p) instead of sizeof(struct foo)
  pinctrl: Fix and simplify locking
  pinctrl: Refactor struct pinctrl handling in core.c vs pinmux.c
  pinctrl: Add usecount to pins for muxing
  pinctrl: Fix pinconf_groups_show() to emit newline
  pinctrl: API changes to support multiple states per device
  pinctrl: Enhance mapping table to support pin config operations

 Documentation/pinctrl.txt         |  244 +++++++----
 arch/arm/mach-u300/core.c         |   28 +-
 drivers/pinctrl/core.c            |  936 +++++++++++++++++++++----------------
 drivers/pinctrl/core.h            |  100 +++--
 drivers/pinctrl/pinconf.c         |  288 ++++++++++--
 drivers/pinctrl/pinconf.h         |   45 ++-
 drivers/pinctrl/pinmux.c          |  578 ++++++++---------------
 drivers/pinctrl/pinmux.h          |   61 ++--
 drivers/tty/serial/sirfsoc_uart.c |   12 +-
 include/linux/pinctrl/consumer.h  |   55 ++-
 include/linux/pinctrl/machine.h   |  131 ++++--
 include/linux/pinctrl/pinctrl.h   |    1 -
 12 files changed, 1438 insertions(+), 1041 deletions(-)

-- 
1.7.5.4

