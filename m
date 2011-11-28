Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1K1WkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:40:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38603 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767Ab1K1WkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:40:21 -0500
Date: Mon, 28 Nov 2011 22:40:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/8] WM8994 MFD updates for 3.3
Message-ID: <20111128224017.GA13163@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You have taken yourself too seriously.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series (and pull request) contains a bunch of
updates I've previously posted for wm8994 but which haven't been merged
plus a big update adding register cache support for the wm8994 driver
which hasn't previously been posted.  As there's a matching update for
the ASoC driver for WM8994 removing the copy of the register cache there
it'd be great if it were possible to merge this via the ASoC tree.

I've also got one more patch which depends on this lot converting the
IRQ controller over to use the generic regmap IRQ controller which I'll
post as well - that also depends on this series as the regmap interrupt
controller relies on the register cache - so I'd also like to either
pull the same branch into the regmap tree or merge both this and the
regmap IRQ stuff via ASoC.

This seems like the easiest route from the point of view of bisection
and cross tree issues - does that all sound OK to you?

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git mfd/wm8994

Mark Brown (8):
      mfd: Remove some unused functions in wm8894-irq
      mfd: Add basic device tree binding for wm8994
      mfd: Convert wm8994 to devm_kzalloc()
      mfd: Disable more pulls on WM8994
      mfd: Don't hard code the reset value for WM8994 devices
      mfd: Define some additional wm8994 registers
      mfd: Add wm8994 register access and default information
      mfd: Enable register cache for wm8994 devices

 Documentation/devicetree/bindings/sound/wm8994.txt |   18 +
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/wm8994-core.c                          |  121 +--
 drivers/mfd/wm8994-irq.c                           |   10 -
 drivers/mfd/wm8994-regmap.c                        | 1218 ++++++++++++++++++++
 drivers/mfd/wm8994.h                               |   24 +
 include/linux/mfd/wm8994/core.h                    |    2 -
 include/linux/mfd/wm8994/pdata.h                   |    6 +
 include/linux/mfd/wm8994/registers.h               |   96 ++
 sound/soc/codecs/wm8994-tables.c                   |   12 +-
 10 files changed, 1423 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/wm8994.txt
 create mode 100644 drivers/mfd/wm8994-regmap.c
 create mode 100644 drivers/mfd/wm8994.h
