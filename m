Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1GVNw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:52:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36367 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754309Ab1GVNw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:52:57 -0400
Date: Fri, 22 Jul 2011 14:52:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant@secretlab.ca>,
        Liam Girdwood <lrg@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [GIT PULL] regmap: Generic I2C and SPI register map library
Message-ID: <20110722135247.GA27855@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pull request adds regmap, a library which abstracts out some widely
reimplemented code for accessing the register maps of devices on slow
buses like I2C and SPI.  As well as factoring out code this makes
it much easier to factor out higher level code for this class of
devices.  We've been using equivalent code in ASoC to great effect, the
idea here is to move that functionality so that it's usable in other
subsystems.

I'm not 100% happy with the implementation at present (to a large extent
due to keeping it simple for initial review, though there's some stuff
I'm just not happy with) so I expect a bit of internal churn but the
external interface should be solid and allow other code to start making
use of the code.

Only one driver is converted to the API in this pull request (the
tps65023), some other drivers have been converted including the generic
cache code in ASoC but various cross tree dependencies mean they can't
be applied until everything settles down in the merge window.

The code is in a separate directory because it is expected that the
addition of register cache support and diagnostic features like trace
and debugfs access to the register maps will mean that the code will
get larger.

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

Mark Brown (4):
      regmap: Add generic non-memory mapped register access API
      regmap: Add I2C bus support
      regmap: Add SPI bus support
      regulator: Convert tps65023 to use regmap API

 MAINTAINERS                            |    7 +
 drivers/base/Kconfig                   |    2 +
 drivers/base/Makefile                  |    1 +
 drivers/base/regmap/Kconfig            |   14 +
 drivers/base/regmap/Makefile           |    3 +
 drivers/base/regmap/regmap-i2c.c       |  115 ++++++++
 drivers/base/regmap/regmap-spi.c       |   72 +++++
 drivers/base/regmap/regmap.c           |  455 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   97 ++-----
 include/linux/regmap.h                 |   82 ++++++
 11 files changed, 779 insertions(+), 70 deletions(-)
 create mode 100644 drivers/base/regmap/Kconfig
 create mode 100644 drivers/base/regmap/Makefile
 create mode 100644 drivers/base/regmap/regmap-i2c.c
 create mode 100644 drivers/base/regmap/regmap-spi.c
 create mode 100644 drivers/base/regmap/regmap.c
 create mode 100644 include/linux/regmap.h
